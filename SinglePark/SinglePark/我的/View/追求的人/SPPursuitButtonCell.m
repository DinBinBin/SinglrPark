//
//  SPPursuitButtonCell.m
//  SinglePark
//
//  Created by chensw on 2019/1/4.
//  Copyright © 2019 DBB. All rights reserved.
//

#import "SPPursuitButtonCell.h"
#import "OYCountDownManager.h"

@implementation SPPursuitButtonCell

// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
    }
    return self;
}


#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    /// 计算倒计时
    OYModel *model = self.model;
    NSInteger timeInterval;
    if (model.countDownSource) {
        timeInterval = [kCountDownManager timeIntervalWithIdentifier:model.countDownSource];
    }else {
        timeInterval = kCountDownManager.timeInterval;
    }
    NSInteger countDown = model.count - timeInterval;
    /// 当倒计时到了进行回调
    if (countDown <= 0) {
        // 回调给控制器
        if (self.countDownZero) {
            self.countDownZero(model);
        }
        return;
    }
    /// 重新赋值
    [self.mybutton setTitle:[NSString stringWithFormat:@"%02ld小时%02ld分%02ld秒", countDown/3600, (countDown/60)%60, countDown%60] forState:UIControlStateDisabled];
}

///  重写setter方法
- (void)setModel:(OYModel *)model {
    _model = model;
    
    //    self.timeLB.text = model.title;
    // 手动刷新数据
    [self countDownNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
