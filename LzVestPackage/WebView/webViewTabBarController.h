//
//  webViewTabBarController.h
//  LzVestPackage
//
//  Created by lz on 2017/12/23.
//  Copyright © 2017年 wanglz. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol webViewProtocol <NSObject>

-(void)goforward;//前进
-(void)goback;//后退
-(void)reload;//刷新
-(void)exitApp;//退出
-(void)homePage;//首页

@end

@interface webViewTabBarController : UITabBarController

@property (nonatomic,retain)id<webViewProtocol>webDelegate;

@end

