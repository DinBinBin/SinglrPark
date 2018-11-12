//
//  UIButton+ZExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/5/24.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "UIButton+ZExtension.h"
#import <objc/runtime.h>

#define kVerifyMsgTake @"获取验证码"
#define kVerifyMsgDidToke @"验证码已发送"
#define kVerifyMsgLoad @"s"

static const char *verifyStartBlockKey    = "verifyStartBlockKey";     // 开始回调
static const char *verifyCompleteBlockKey = "verifyCompleteBlockKey";  // 完成回调
static const char *verifyTimerKey         = "verifyTimerKey";          // 计时器
static const char *verifyStatusKey        = "verifyStatusKey";         // 状态（移除时候判断用
static const char *verifyIntervalKey      = "verifyIntervalKey";       // 总时间
static const char *verifyStartIntervalKey = "verifyStartIntervalKey";  // 开始时间戳

@implementation UIButton (ZExtension)

#pragma mark -
- (void)addTimerForVerifyWithInterval:(NSUInteger)interval start:(StartBlock)startBlock complete:(CompleteBlock)completeBlock {
    
    [self setTitle:kVerifyMsgTake forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(verifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (startBlock) {
        objc_setAssociatedObject(self, verifyStartBlockKey, startBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    if (completeBlock) {
        objc_setAssociatedObject(self, verifyCompleteBlockKey, completeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    objc_setAssociatedObject(self, verifyIntervalKey, @(interval), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, verifyStatusKey, @(YES), OBJC_ASSOCIATION_ASSIGN);
}

- (void)verifyButtonClick:(UIButton *)button {
    if (!button.enabled) return;
    button.enabled = NO;

    long long startTime = [[NSDate date] timeIntervalSince1970];
    objc_setAssociatedObject(self, verifyStartIntervalKey, @(startTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    void(^startBlock)(void) = objc_getAssociatedObject(self, verifyStartBlockKey);
    if (startBlock) {
        startBlock();
    }
    
    [button setTitle:kVerifyMsgDidToke forState:UIControlStateDisabled];
    
    [self startTimer];
}

- (void)startTimer {
    NSTimer *timer = objc_getAssociatedObject(self, verifyTimerKey);
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadTimeStatus) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        objc_setAssociatedObject(self, verifyTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)stopTimer {
    NSTimer *timer = objc_getAssociatedObject(self, verifyTimerKey);
    if (timer) {
        [timer invalidate];
        timer = nil;
        objc_setAssociatedObject(self, verifyTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)reloadTimeStatus {
    if (self.enabled == YES) {
        [self stopTimer];
    }
    
    long long nowTime = [[NSDate date] timeIntervalSince1970];
    long long startTime = [objc_getAssociatedObject(self, verifyStartIntervalKey) longLongValue];
    int totalTime = [objc_getAssociatedObject(self, verifyIntervalKey) intValue];
    if (nowTime - startTime >= totalTime) {
        [self stopTimer];
        
        void(^completeBlock)(void) = objc_getAssociatedObject(self, verifyCompleteBlockKey);
        
        if (completeBlock) {
            completeBlock();
        }
        return;
    }
    [self setTitle:[NSString stringWithFormat:@"%lld%@", totalTime - (nowTime - startTime), kVerifyMsgLoad] forState:UIControlStateDisabled];
}

- (void)removeFromSuperview {
    if ([objc_getAssociatedObject(self, verifyStatusKey) boolValue]) {
        objc_removeAssociatedObjects(self);
    }
    [super removeFromSuperview];
}

@end
