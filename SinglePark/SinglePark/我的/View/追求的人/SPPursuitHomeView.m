//
//  SPPursuitHomeView.m
//  SinglePark
//
//  Created by chensw on 2018/12/13.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPPursuitHomeView.h"

@interface SPPursuitHomeView ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentInt; // 倒计时间

@end

@implementation SPPursuitHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SPPursuitHomeView" owner:nil options:nil] firstObject];
        self.frame = frame;

        self.refuseButton.layer.borderWidth = 1;
        self.refuseButton.layer.borderColor = ThemeColor.CGColor;
        self.mainBgImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goVideo:)];
        [self.mainBgImgView addGestureRecognizer:tag];
        
//        self.voiceBgView.hidden = YES;
//        self.topConstraint.constant = 30;
        
        self.suitButton.enabled = NO;
        
        self.currentInt = 12*60*60;
        
        [self updateTimer:self.timer];
        
    }
    
    return self;
}


#pragma mark - set/get

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)updateTimer:(NSTimer *)timer
{
    NSInteger time = self.currentInt --;
    
    if (time <= 0) {
        if (time == 0) {
            [self requestData];
        }
        [_timer invalidate];
        _timer = nil;
        return ;
    }
    
    NSInteger h = time/ 3600;
    //分
    NSInteger m = time % 3600 / 60;
    //秒
    NSInteger s = time % 60;
    [self.suitButton setTitle:[NSString stringWithFormat:@"%02ld小时%02ld分%02ld秒", (long)h, (long)m,(long)s] forState:UIControlStateDisabled];

}

- (void)requestData {
    
}


- (IBAction)goVideo:(id)sender {

    if (self.gobackBlcok) {
        self.gobackBlcok();
    }
}


@end
