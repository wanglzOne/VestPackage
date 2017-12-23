//
//  RootController.m
//  LzVestPackage
//
//  Created by lz on 2017/12/23.
//  Copyright © 2017年 wanglz. All rights reserved.
//

#import "RootController.h"
#define imgName @"loginImg"

@interface RootController ()
@property (nonatomic ,retain)UIImageView *imgView;
@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView.image = [UIImage imageNamed:imgName];
    [self.view addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView=[[UIImageView alloc]init];
        
    }
    return _imgView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
