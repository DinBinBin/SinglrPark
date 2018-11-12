//
//  SPMessageTabCell.h
//  SinglePark
//
//  Created by DBB on 2018/10/5.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPMessageTabCell : UITableViewCell

@property (nonatomic,strong)SPMessageModel *model;
@end

NS_ASSUME_NONNULL_END
