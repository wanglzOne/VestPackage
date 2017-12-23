//
//  webViewTabBarController.m
//  LzVestPackage
//
//  Created by lz on 2017/12/23.
//  Copyright © 2017年 wanglz. All rights reserved.
//


#import "webViewTabBarController.h"
#import "webViewController.h"

@interface webViewTabBarController ()<UITabBarControllerDelegate>


@end

@implementation webViewTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.backgroundColor = [UIColor whiteColor];
    webViewController *Company = [[webViewController alloc] init];
    self.webDelegate = Company;
    
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    NSArray *title = @[@"首页",@"后退",@"前进",@"刷新",@"退出"];
    NSArray *imgArr = @[@"homePic",@"backPic",@"gotoPic1",@"refreshPic",@"exit"];
    
    for (int i = 0; i < title.count; i++) {
        
        UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:title[i] image:[UIImage imageNamed:imgArr[i]] tag:i];
        if (i == 0) {
            Company.tabBarItem = tabbarItem;
            [vcArr addObject:Company];
        } else {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.tabBarItem = tabbarItem;
            [vcArr addObject:vc];
        }
    }
    self.delegate = self;
    [self setViewControllers:vcArr];
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSInteger tag = [tabBarController.viewControllers indexOfObject:viewController];
    [self controlWebView:tag];
    return NO;
}

- (void)controlWebView:(NSInteger)tag {
    NSLog(@"%ldd",(long)tag);
    switch (tag) {
        case 0:
            //首页
            [self.webDelegate homePage];
            break;
        case 1:
            //后退
            [self.webDelegate goback];
            break;
        case 2:
            //前进
            [self.webDelegate goforward];
            
            break;
        case 3:
            //刷新
            [self.webDelegate reload];
            break;
        case 4:
            //退出
            [self.webDelegate exitApp];
            break;
        default:
            break;
    }
}

@end

