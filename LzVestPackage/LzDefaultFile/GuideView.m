//
//  GuideView.m
//  httpdns
//
//  Created by lz on 2017/11/28.
//  Copyright © 2017年 iOS. All rights reserved.
//

#import "GuideView.h"

@interface GuideView ()

@property (weak, nonatomic) IBOutlet UIImageView *guideImg;

@end

@implementation GuideView


- (void)showGuideView{
    GuideView *gview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    gview.frame = window.bounds;
    gview.tag = 10086;
    [window addSubview:gview];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.guideImg.image = [UIImage imageNamed:@"loginImg"];
}

- (void)hideGuideView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
