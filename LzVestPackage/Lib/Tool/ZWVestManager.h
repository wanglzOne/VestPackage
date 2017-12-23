//
//  ZWVestManager.h
//  LzVestPackage
//
//  Created by Tom on 2017/12/23.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const linkURLKey = @"savelinkKey"; 
#define userDefaults [NSUserDefaults standardUserDefaults]

@interface ZWVestManager : NSObject
+ (void)saveObj:(NSString *)object WithKey:(NSString *)key;
+ (NSString *)getObjectWithKey:(NSString *)key;
@end
