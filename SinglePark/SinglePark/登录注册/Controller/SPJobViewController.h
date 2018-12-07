//
//  SPJobViewController.h
//  SinglePark
//
//  Created by chensw on 2018/12/6.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SGBaseController.h"
#import "SPSupplementController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPJobViewController : SGBaseController<SPJobDelegate>
@property (nonatomic, weak) id<SPJobDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
