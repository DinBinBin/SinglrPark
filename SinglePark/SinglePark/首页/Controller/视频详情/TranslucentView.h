//
//  TranslucentView.h
//  testPlayer
//
//  Created by 斌斌戴 on 2018/9/12.
//  Copyright © 2018年 驿路梨花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPVideoModel.h"

@interface TranslucentView : UIView

@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UIButton *goodBtn;
@property (nonatomic,strong)UIButton *commentBtn;
@property (nonatomic,strong)UIButton *titleBtn;

@property (nonatomic,strong)SPVideoModel *model;
@property (nonatomic,copy)void (^TranslucentBlock)(NSInteger row);
@end
