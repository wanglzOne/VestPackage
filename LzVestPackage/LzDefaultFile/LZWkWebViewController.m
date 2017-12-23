//
//  LZWkWebViewController.m
//  httpdns
//
//  Created by lz on 2017/11/24.
//  Copyright © 2017年 iOS. All rights reserved.
//

#import "LZWkWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "GuideView.h"
// 1是横屏 其余数字是竖屏
#define VHScreen 1
// 返回YES表示隐藏，返回NO表示显示 状态栏
#define HiddenStatusBar YES
#define webUrl @"http://sda.4399.com/4399swf/upload_swf/ftp14/wangc/20141011/2/game.htm"
#define ADDestimatedProgress  2

@interface LZWkWebViewController ()<WKUIDelegate>
@property (nonatomic, strong) WKWebView *wkWeb;
@property (nonatomic, strong) GuideView *guide;
@end

@implementation LZWkWebViewController
-(GuideView *)guide{
    if (!_guide) {
        _guide = [[GuideView alloc] initWithFrame:self.view.bounds];
    }
    return _guide;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.wkWeb];
    [_wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (ADDestimatedProgress == 1) {
        [self.wkWeb addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.wkWeb setAlpha:0];
        [self.guide showGuideView];
//        [SVProgressHUD show];
    }
    
    [_wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
}
-(BOOL)prefersStatusBarHidden

{
    
    return HiddenStatusBar;// 返回YES表示隐藏，返回NO表示显示
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (self.wkWeb.estimatedProgress == 1) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
                [self.guide hideGuideView];
                [self.wkWeb setAlpha:1];
            });
            
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.wkWeb removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationPortrait  ;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (VHScreen == 1) {
        return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
    }
    else
    {
        return (UIInterfaceOrientationMaskPortrait);
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return nil;
    
}

//必须有
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (VHScreen == 1) {
        return UIInterfaceOrientationLandscapeRight;
        
    }else{
        return UIInterfaceOrientationPortrait ;
        
    }
}
- (void)webViewDidClose:(WKWebView *)webView {
    
}

- (WKWebView *)wkWeb {
    if (!_wkWeb) {
        _wkWeb = [[WKWebView alloc] init];
        _wkWeb.scrollView.scrollEnabled = NO;
    }
    return _wkWeb;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
