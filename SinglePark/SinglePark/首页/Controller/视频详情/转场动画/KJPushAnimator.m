//
//  KJPushAnimator.m
//  自定义转场解决navigationBar颜色转换问题
//
//  Created by coder on 2017/6/29.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "KJPushAnimator.h"
#import "UIView+KJFrame.h"


static CGFloat kTransitionDuration = 0.25;


@implementation KJPushAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.kj_x = [UIScreen mainScreen].bounds.size.width;
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    

    [UIView animateWithDuration:kTransitionDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        fromView.kj_x = -100;
        toView.kj_x = 0;
        
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

    }];
    
}


@end
