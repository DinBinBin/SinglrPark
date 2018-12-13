//
//  SPPursuitHomeView.m
//  SinglePark
//
//  Created by chensw on 2018/12/13.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPPursuitHomeView.h"

@implementation SPPursuitHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SPPursuitHomeView" owner:nil options:nil] firstObject];
        self.frame = frame;
        
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
//        }];
        self.refuseButton.layer.borderWidth = 1;
        self.refuseButton.layer.borderColor = ThemeColor.CGColor;
        self.mainBgImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goVideo:)];
        [self.mainBgImgView addGestureRecognizer:tag];
    }
    
    return self;
}

- (IBAction)goVideo:(id)sender {

    if (self.gobackBlcok) {
        self.gobackBlcok();
    }
}


@end
