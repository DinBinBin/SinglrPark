//
//  JDWForceRefreshView.h
//  JDWin_B
//
//  Created by 斌斌戴 on 2018/9/30.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDWForceRefreshView : UIView
@property (nonatomic,copy)void (^ClicKSure)(void);

@property (nonatomic,strong)SPCoverModel *infoModel;

@end

NS_ASSUME_NONNULL_END
