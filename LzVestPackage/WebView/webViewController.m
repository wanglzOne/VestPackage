//
//  webViewController.m
//  LzVestPackage
//
//  Created by lz on 2017/12/23.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import "webViewController.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "ScottAlertController.h"

@interface webViewController ()<UIWebViewDelegate>{
    UIWebView *_webView;
}
@property (nonatomic ,strong)NSString *url;
@end


@implementation webViewController


- (void)viewWillLayoutSubviews {
    [self shouldRotateToOrientation:(UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation];
    
}

-(void)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == UIDeviceOrientationPortrait ||orientation ==
        UIDeviceOrientationPortraitUpsideDown) { // 竖屏
        NSLog(@"现在是竖屏");
        self.tabBarController.tabBar.hidden = NO;
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(LL_StatusBarHeight);
            make.bottom.mas_equalTo(-LL_TabbarHeight);
        }];
        [self hideTabBar:NO];
        
    } else { // 横屏
        NSLog(@"现在是横屏");
        self.tabBarController.tabBar.hidden = YES;
        
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [self hideTabBar:YES];
    }
}

#pragma mark 隐藏tabbar
- (void) hideTabBar:(BOOL) hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {   //tabbar
            if (hidden) {
                //
            } else {
                [view setFrame:CGRectMake(0, kMainBoundsHeight-LL_TabbarHeight, kMainBoundsWidth, LL_TabbarHeight)];
            }
        }
        else
        {
            //view
            if (hidden) {
                [view setFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight+LL_TabbarHeight)];
            } else {
                [view setFrame:CGRectMake(0, LL_StatusBarHeight, kMainBoundsWidth, kMainBoundsHeight)];
            }
        }
    }
    
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    _webView = [[UIWebView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView.opaque = NO;//去掉加载webview出现的黑边
    _webView.backgroundColor = [UIColor whiteColor];
    //让网页适配屏幕的大小
    _webView.scalesPageToFit = YES;
    //    禁用拖拽时的反弹效果
    [(UIScrollView *)[[_webView  subviews]firstObject] setBounces:NO];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    
    NSString *userAgent = [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    userAgent = [userAgent stringByAppendingString:@" Version/7.0 Safari/9537.53"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": userAgent}];
    
    if ([[[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]allKeys]containsObject:@"cookie"]) {
        NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
    }
    
    //转义网址
    NSString *encodedString=[[ZWVestManager getObjectWithKey:linkURLKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    NSURLRequest *requst = [NSURLRequest requestWithURL:weburl];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [_webView loadRequest:requst];
}
#pragma mark -webView代理

//开始加载的时候调用
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"加载中"];
    
}

//加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    for (NSHTTPCookie * cookie in [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] copy]) {
        if ([cookie isKindOfClass:[NSHTTPCookie class]])
        {
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookie"];
                break;
            }
        }
    }
    
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    
    // 如果是被取消，什么也不干(如果不加这句会重复请求,报-999错误)
    if([error code] == NSURLErrorCancelled)  {
        return;
    } else {
        [SVProgressHUD showErrorWithStatus:@"服务器错误,请稍后重试"];
        NSLog(@"%@",error);
    }
}

#pragma mark -五个代理方法
//首页
-(void)homePage {
    
    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    
    //转义网址
    NSString *encodedString=[[de objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    NSURLRequest *requst = [NSURLRequest requestWithURL:weburl];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [_webView loadRequest:requst];
    
}

//前进
-(void)goforward {
    [_webView goForward];
}
//后退
-(void)goback {
    [_webView goBack];
}
//刷新
-(void)reload {
    [_webView reload];
}
//退出
-(void)exitApp{
    
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"退出应用" message:@""];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        
    }]];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"确认" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        [UIView beginAnimations:@"exitApplication" context:nil];
        
        [UIView setAnimationDuration:0.5];
        
        [UIView setAnimationDelegate:self];
        
        // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:NO];
        
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        window.bounds = CGRectMake(0, 0, 0, 0);
        
        [UIView commitAnimations];
    }]];
    
    ScottAlertViewController * alertCon = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
    alertCon.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertCon animated:YES completion:nil];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}


@end

