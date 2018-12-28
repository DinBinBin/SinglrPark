//
//  UITabBar+SPTabBar.m
//  SinglePark
//
//  Created by chensw on 2018/12/28.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "UITabBar+SPTabBar.h"
#define TabbarItemNums 4.0

@implementation UITabBar (SPTabBar)
//显示红点
- (void)showBadgeOnItemIndex:(int)index count:(int)count{
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UILabel *bview = [[UILabel alloc]init];
    bview.tag = 888+index;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    
    bview.text = [NSString stringWithFormat:@"%d",count];
    bview.textColor = [UIColor whiteColor];
    bview.font = FONT(10);
    bview.textAlignment = NSTextAlignmentCenter;
    CGRect tabFram = self.frame;
    
    float percentX = (index+0.6)/TabbarItemNums;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    
    
    if (count>99) {
        bview.text = @"99+";
        bview.frame = CGRectMake(x, y, 22, 12);
        bview.layer.cornerRadius = 5;
    }else if (count == 0){
        [self removeBadgeOnItemIndex:index];

    }else{
        bview.text = [NSString stringWithFormat:@"%d",count];
        bview.frame = CGRectMake(x, y, 15, 15);
        bview.layer.cornerRadius = 7.5;
    }

    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}
//隐藏红点
-(void)hideBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}
//移除控件
- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
