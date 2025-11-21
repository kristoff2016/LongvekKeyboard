#import "KBLayoutManager.h"

@implementation KBLayoutManager

+ (instancetype)sharedManager {
    static KBLayoutManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBLayoutManager alloc] init];
        sharedInstance.currentLayoutType = KBLayoutTypeKhmer; // Default to Khmer
    });
    return sharedInstance;
}

- (NSArray<NSArray<NSString *> *> *)keysForLayout:(KBLayoutType)type {
    // 10-10-7 grid layout based on latest request
    NSArray *khmerRows = @[
        @[@"ឆ", @"ឹ", @"េ", @"រ", @"ត", @"យ", @"ុ", @"ិ", @"ោ", @"ផ"],
        @[@"ា", @"ស", @"ដ", @"ថ", @"ង", @"ហ", @"្", @"ក", @"ល", @"់"], // Replaced 'ើ' with '់'
        @[@"ឋ", @"ខ", @"ច", @"វ", @"ប", @"ន", @"ម"]
    ];
    
    switch (type) {
        case KBLayoutTypeKhmer:
            return khmerRows;
            
        case KBLayoutTypeKhmer5Row: {
            NSMutableArray *rows = [NSMutableArray arrayWithObject:[self numberRow][0]];
            [rows addObjectsFromArray:khmerRows];
            return rows;
        }
            
        case KBLayoutTypeSymbol:
            // Top / Normal (Primary)
            return @[
                @[@"ើ", @"ុំ", @"េះ", @"៉", @"ៗ", @"៛", @"$", @"%", @"័", @"៚"], // Added Displaced Vowels + Bantoc
                @[@"ឥ", @"ឦ", @"ឧ", @"ឩ", @"ឪ", @"ឫ", @"ឬ", @"ឯ", @"#", @"\""],
                @[@"@", @"[", @"]", @"(", @")", @":", @"ះ", @"=", @"+", @"x"]
            ];
            
        case KBLayoutTypeEmoji:
            return @[
                @[@"😂", @"😍", @"😭", @"😊", @"🙏", @"🥰", @"🤣", @"👍", @"❤️", @"😁"],
                @[@"🔥", @"🥺", @"😅", @"🤝", @"🎉", @"😎", @"🤔", @"🤦‍♂️", @"🙄", @"👌"],
                @[@"🥱", @"🤨", @"🥴", @"👈", @"👉", @"🙌", @"💀", @"👻", @"💩", @"🤡"]
            ];
            
        default:
            return @[];
    }
}

- (NSArray<NSArray<NSString *> *> *)shiftedKeysForLayout:(KBLayoutType)type {
    NSArray *khmerShiftedRows = @[
        @[@"ឈ", @"ឺ", @"ែ", @"ឬ", @"ទ", @"ួ", @"ូ", @"ី", @"ៅ", @"ភ"],
        @[@"ាំ", @"ៃ", @"ឌ", @"ធ", @"អ", @"ះ", @"ញ", @"គ", @"ឡ", @"៉"], // Replaced '៖' with '៉'
        @[@"ឍ", @"ឃ", @"ជ", @"ព", @"ណ", @"ំ", @"ុះ"]
    ];
    
    switch (type) {
        case KBLayoutTypeKhmer:
            return khmerShiftedRows;
            
        case KBLayoutTypeKhmer5Row: {
             // Shifted number row usually symbols
             NSArray *shiftedNumbers = @[@[@"!", @"@", @"#", @"$", @"%", @"^", @"&", @"*", @"(", @")"]];
             NSMutableArray *rows = [NSMutableArray arrayWithObject:shiftedNumbers[0]];
             [rows addObjectsFromArray:khmerShiftedRows];
             return rows;
        }
            
        case KBLayoutTypeSymbol:
            // Bottom / Shifted (Secondary)
            return @[
                @[@"១", @"២", @"៣", @"៤", @"៥", @"៦", @"៧", @"៨", @"៩", @"០"],
                @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"],
                @[@"&", @"។", @"៕", @".", @",", @";", @"៖", @"?", @"-", @"/"]
            ];
            
        case KBLayoutTypeEmoji:
             return @[
                @[@"👿", @"😮", @"🤐", @"😯", @"😪", @"😫", @"😴", @"😌", @"😛", @"😜"],
                @[@"😝", @"🤤", @"😒", @"😓", @"😔", @"😕", @"🙃", @"🤑", @"😲", @"☹️"],
                @[@"🙁", @"😖", @"😞", @"😟", @"😤", @"😢", @"😦", @"😧", @"😨", @"😩"]
            ];
            
        default:
            return @[];
    }
}

- (NSArray<NSArray<NSString *> *> *)numberRow {
    return @[@[@"១", @"២", @"៣", @"៤", @"៥", @"៦", @"៧", @"៨", @"៩", @"០"]]; // Khmer Numerals
}

- (NSArray<NSArray<NSString *> *> *)secondaryKeysForLayout:(KBLayoutType)type {
     return nil;
}

@end
