//
//  AppDelegate.m
//  LzVestPackage
//
//  Created by lz on 2017/12/23.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import "AppDelegate.h"
#import "LZWkWebViewController.h"
#import "RootController.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define kJpushAppKey @"01dd5f4ad813d5a87c43a47f"

#define LzAndZkURL @"www.baidu.com"
#define LzAndZkPARAM @{@"app_id":@"12"}

#define AppStoreID @"1322778123"

@interface AppDelegate ()<JPUSHRegisterDelegate>{
    ScottAlertViewController *_alertCon;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Bmob registerWithAppKey:BmobApplicationID];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [RootController new];
    
    //判断网络
    [self reachability];
    [self setJpush];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark 开启网络状况的监听
- (void)reachability {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                [self noNetWork];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                [self noNetWork];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"3g网络");
                if (![[self getCurrentVC] isKindOfClass:[webViewTabBarController class]]) {
                    [self compareSwitchStatus];
                }else{
                    [_alertCon dismissViewControllerAnimated:YES completion:^{
                    }];
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                if (![[self getCurrentVC] isKindOfClass:[webViewTabBarController class]]) {
                    [self compareSwitchStatus];
                }else{
                    [_alertCon dismissViewControllerAnimated:YES completion:^{
                    }];
                    NSLog(@"WIFI已连接");
                }
            }
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)compareSwitchStatus {
    [ZWBmobManager compareSwitchStatus:^(NSInteger switch_, NSString *link, NSString * appId) {
        if (switch_) {
            //open
            [self loadWebViewWith:link];
        }else {
            //close
            [self loadVestView];
        }
    }];
}

- (void)loadWebViewWith:(NSString *)url {
    //将得到的URL存储下来
    [ZWVestManager saveObj:url WithKey:linkURLKey];
    
    webViewTabBarController *web=[[webViewTabBarController alloc] init];
    self.window.rootViewController=web;
}

- (void)loadVestView {
    //运行自己的程序
    NSLog(@"------运行自己的程序--------");
    LZWkWebViewController* web = [[LZWkWebViewController alloc] init];
    self.window.rootViewController = web;
}

#pragma mark -没有网
- (void)noNetWork{
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"网络断开连接" message:@"请检查网络或者蜂窝网络使用权限"];
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        
    }]];
    [alertView addAction:[ScottAlertAction actionWithTitle:@"点击退出" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        [self exitApp];
    }]];
    
    _alertCon = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
    _alertCon.tapBackgroundDismissEnable = YES;
    [self.window.rootViewController presentViewController:_alertCon animated:YES completion:nil];
}

#pragma mark -退出应用
//退出
-(void)exitApp{
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

#pragma mark -获取当前显示的界面
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

-(void)setJpush{
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    NSString * channel = @"App Store"; //这个只是用于统计下载渠道所用
    [JPUSHService setupWithOption:nil appKey:kJpushAppKey
                          channel:channel
                 apsForProduction:kapsForProduction
            advertisingIdentifier:nil];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"deviceToken==%@",deviceToken);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
