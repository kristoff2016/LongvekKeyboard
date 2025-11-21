#import "KBPredictionEngine.h"
#import <sqlite3.h>

@interface KBPredictionEngine ()
@property (nonatomic, strong) NSArray *englishWords;
@property (nonatomic, strong) NSDictionary *englishBigrams;
@property (nonatomic, assign) sqlite3 *db;
@property (nonatomic, strong) NSString *dbPath;

@property (nonatomic, assign, readwrite) BOOL isDictionaryReady;
@end

@implementation KBPredictionEngine

+ (instancetype)sharedEngine {
    static KBPredictionEngine *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBPredictionEngine alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isDictionaryReady = [[NSUserDefaults standardUserDefaults] boolForKey:@"KBDictionaryDownloaded"];
        [self setupDatabasePath];
    }
    return self;
}

- (void)setupDatabasePath {
    // Ideally use App Group container
    // NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.yourcompany.LongvekKeyboard"];
    // NSString *docsPath = [containerURL path];
    
    // Fallback to local Documents for now
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    self.dbPath = [docsPath stringByAppendingPathComponent:@"khmer_dict.sqlite"];
}

- (void)loadData {
    if (!self.isDictionaryReady) return;
    
    [self openDatabase];
    
    // Load lightweight English data (keep in memory as it's small for now, or move to DB later)
    self.englishWords = [self loadJSON:@"english_words"];
    self.englishBigrams = [self loadJSON:@"english_bigrams"];
}

- (BOOL)openDatabase {
    if (sqlite3_open([self.dbPath UTF8String], &_db) == SQLITE_OK) {
        return YES;
    } else {
        NSLog(@"Failed to open database");
        return NO;
    }
}

- (void)createDatabaseFromJSON {
    if (![self openDatabase]) return;
    
    char *errMsg;
    const char *sql_stmt = "CREATE TABLE IF NOT EXISTS words (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, frequency INTEGER, predictions TEXT)";
    
    if (sqlite3_exec(self.db, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"Failed to create table: %s", errMsg);
        return;
    }
    
    // Load JSON
    NSDictionary *khmerData = [self loadJSON:@"khmer_words"];
    if (khmerData && khmerData[@"words"]) {
        NSArray *wordsArray = khmerData[@"words"];
        
        sqlite3_exec(self.db, "BEGIN TRANSACTION", NULL, NULL, NULL);
        
        const char *insert_stmt = "INSERT INTO words (word, frequency, predictions) VALUES (?, ?, ?)";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(self.db, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
            for (NSDictionary *item in wordsArray) {
                NSString *word = item[@"word"];
                NSNumber *freq = item[@"frequency"];
                NSArray *preds = item[@"predictions"];
                
                // Serialize predictions to string
                NSString *predsJson = @"";
                if (preds) {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:preds options:0 error:nil];
                    if (jsonData) {
                        predsJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    }
                }
                
                sqlite3_bind_text(statement, 1, [word UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 2, [freq intValue]);
                sqlite3_bind_text(statement, 3, [predsJson UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_step(statement);
                sqlite3_reset(statement);
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_exec(self.db, "COMMIT", NULL, NULL, NULL);
        
        // Create Index for fast prefix search
        sqlite3_exec(self.db, "CREATE INDEX IF NOT EXISTS idx_word ON words(word)", NULL, NULL, NULL);
    }
}

- (void)downloadDictionaryWithCompletion:(void(^)(BOOL success))completion {
    // Simulate download and processing
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // In a real app, this would download a file.
        // Here we simulate "processing" by building the DB from the JSON file.
        [self createDatabaseFromJSON];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isDictionaryReady = YES;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KBDictionaryDownloaded"];
            
            // Load English data
            self.englishWords = [self loadJSON:@"english_words"];
            self.englishBigrams = [self loadJSON:@"english_bigrams"];
            
            if (completion) {
                completion(YES);
            }
        });
    });
}

- (id)loadJSON:(NSString *)filename {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (!path) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) return nil;
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (NSArray<NSString *> *)predictForWord:(NSString *)word {
    if (word.length == 0) return @[];
    
    NSMutableArray *results = [NSMutableArray array];
    
    // 1. Khmer Predictions from SQLite
    if (self.db) {
        const char *query_stmt = "SELECT word FROM words WHERE word LIKE ? ORDER BY frequency DESC LIMIT 3";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(self.db, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            NSString *param = [NSString stringWithFormat:@"%@%%", word];
            sqlite3_bind_text(statement, 1, [param UTF8String], -1, SQLITE_TRANSIENT);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                const char *resultWord = (const char *)sqlite3_column_text(statement, 0);
                if (resultWord) {
                    [results addObject:[NSString stringWithUTF8String:resultWord]];
                }
            }
            sqlite3_finalize(statement);
        }
    }
    
    // 2. English Predictions (Fallback if needed)
    if (results.count < 3 && self.englishWords) {
        for (NSString *candidate in self.englishWords) {
            if ([candidate hasPrefix:word.lowercaseString]) {
                [results addObject:candidate];
                if (results.count >= 3) break;
            }
        }
    }
    
    return results;
}

- (NSArray<NSString *> *)predictionsForNextWord:(NSString *)word {
    if (!word) return @[];
    
    // 1. Check SQLite for specific next-word predictions
    if (self.db) {
        const char *query_stmt = "SELECT predictions FROM words WHERE word = ? LIMIT 1";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(self.db, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [word UTF8String], -1, SQLITE_TRANSIENT);
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                const char *predsJson = (const char *)sqlite3_column_text(statement, 0);
                if (predsJson) {
                    NSString *jsonString = [NSString stringWithUTF8String:predsJson];
                    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    NSArray *preds = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                    sqlite3_finalize(statement);
                    if (preds && preds.count > 0) {
                        return [preds subarrayWithRange:NSMakeRange(0, MIN(3, preds.count))];
                    }
                    return @[]; // Found word but no preds, stop here? Or fallback?
                }
            }
            sqlite3_finalize(statement);
        }
    }
    
    // 2. Fallback to English Bigrams
    NSArray *nextWords = self.englishBigrams[word.lowercaseString];
    return nextWords ? [nextWords subarrayWithRange:NSMakeRange(0, MIN(3, nextWords.count))] : @[];
}

- (void)dealloc {
    if (_db) {
        sqlite3_close(_db);
    }
}

@end
