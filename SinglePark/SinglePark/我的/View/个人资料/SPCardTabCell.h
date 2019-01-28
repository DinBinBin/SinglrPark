//
//  SPCardTabCell.h
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPCardTabCell : UITableViewCell
@property (nonatomic,strong)SPPersonModel *model;
@property (nonatomic,assign)BOOL isMine;
@end

NS_ASSUME_NONNULL_END
