//
//  SPEditPersonalInfoViewController.h
//  SinglePark
//
//  Created by chensw on 2018/12/7.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPEditPersonalInfoViewController : SGBaseController
@property (nonatomic, copy) void (^backRequsetBlock)(void);
@end

NS_ASSUME_NONNULL_END
