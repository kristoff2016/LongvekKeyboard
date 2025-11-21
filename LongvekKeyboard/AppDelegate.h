//
//  AppDelegate.h
//  LongvekKeyboard
//
//  Created by CHHORLYHEANG-KONG on 21/11/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

