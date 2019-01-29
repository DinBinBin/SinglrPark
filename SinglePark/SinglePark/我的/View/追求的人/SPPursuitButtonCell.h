//
//  SPPursuitButtonCell.h
//  SinglePark
//
//  Created by chensw on 2019/1/4.
//  Copyright © 2019 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPursuitButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *mybutton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;

@property (nonatomic, copy) void(^countDownZero)(OYModel *);
@property (nonatomic, strong) OYModel *model;
@end

NS_ASSUME_NONNULL_END
