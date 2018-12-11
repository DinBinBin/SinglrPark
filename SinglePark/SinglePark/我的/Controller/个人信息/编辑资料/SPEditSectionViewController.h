//
//  SPEditSectionViewController.h
//  SinglePark
//
//  Created by chensw on 2018/12/10.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SGBaseController.h"

typedef NS_ENUM(NSInteger, SPEditType) {
    SPSexEditType,
    SPAgeEditType,
    SPJobEditType,
    SPUnitEditType,
    SPUniversityEditType,
    SPEducationEditType,
    SPAreaEditType,
    SPHeightEditType,
    SPWeightEditType,
    SPIncomeEditType
};

NS_ASSUME_NONNULL_BEGIN

@interface SPEditSectionViewController : SGBaseController
@property (nonatomic, assign) SPEditType type;
@property (nonatomic, copy) void (^SPCallBackStringBlock)(NSString *str);

@end

NS_ASSUME_NONNULL_END
