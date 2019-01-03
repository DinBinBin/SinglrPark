//
//  SPConmentHeadView.h
//  SinglePark
//
//  Created by 斌斌戴 on 2019/1/3.
//  Copyright © 2019年 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPConmentHeadView : UITableViewHeaderFooterView
@property (nonatomic,strong)SPMessageModel *model;

@end

NS_ASSUME_NONNULL_END
