//
//  SPPursuitHomeView.h
//  SinglePark
//
//  Created by chensw on 2018/12/13.
//  Copyright © 2018 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SPPursuitHomeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *headButtonView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLB;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgVIew;
@property (weak, nonatomic) IBOutlet UIImageView *mainBgImgView;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;
@property (weak, nonatomic) IBOutlet UIButton *suitButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;

@property (nonatomic,copy) void (^gobackBlcok)(void);

@end

NS_ASSUME_NONNULL_END
