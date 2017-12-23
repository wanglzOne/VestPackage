//
//  ZWVestManager.m
//  LzVestPackage
//
//  Created by Tom on 2017/12/23.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import "ZWVestManager.h"

@implementation ZWVestManager
+ (void)saveObj:(NSString *)object WithKey:(NSString *)key {
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}

+ (NSString *)getObjectWithKey:(NSString *)key {
    NSString * object = [userDefaults objectForKey:key];
    return object;
}

@end
