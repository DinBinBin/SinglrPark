//
//  SPPursuitHomeView.h
//  SinglePark
//
//  Created by chensw on 2018/12/13.
//  Copyright © 2018 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPPursuitType) {
    SPPursuitTypeNone,                  // 没有要追的人
    SPPursuitTypeNotStated,             // 未表态
    SPPursuitTypeOutTime,               // 未表态而且超时了
    SPPursuitTypeRefuse,                // 拒绝
    PursuitTypeDetailAccept,            // 接受
};

typedef NS_ENUM(NSInteger, SPPursuitViewType) {
    SPPursuitMeViewType,                // 追我的人
    SPMePursuitViewType                 // 我追的人
};

NS_ASSUME_NONNULL_BEGIN

@interface SPPursuitHomeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *headButtonView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLB;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgVIew;
@property (weak, nonatomic) IBOutlet UIImageView *mainBgImgView;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;
@property (weak, nonatomic) IBOutlet UIButton *suitButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *voiceBgView;

@property (nonatomic,copy) void (^gobackBlcok)(void);

@end

NS_ASSUME_NONNULL_END
