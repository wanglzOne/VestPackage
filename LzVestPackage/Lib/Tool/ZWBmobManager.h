//
//  ZWBmobManager.h
//  VestProgect
//
//  Created by Tom on 2017/12/23.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TabName @"VestTable1" //里面只有一条数据
#define BmobApplicationID @"fe7d4a795e5ee12fbd5927e9d7bf2924" //这个有用
#define SecretKey     @"f44c72a9e0ef35e9"
#define MasterKey     @"10ca2b8fbc672fad1f1c4983d7c20c8f"

#define objectId @"lFcaJJJU" //根据ID来获取数据,这个很重要记得改

static NSString * const urlKey    = @"url";     //链接的Key
static NSString * const switchKey = @"switch";  //开关的Key
static NSString * const appIdKey  = @"appId";   //App Store ID

typedef void(^completionHandler)(NSInteger switch_, NSString *url, NSString * appId);

@interface ZWBmobManager : NSObject
+ (void)compareSwitchStatus:(completionHandler)completionHandler; //开关状态
@end
