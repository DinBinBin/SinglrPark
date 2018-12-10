//
//  SPAreaViewController.h
//  SinglePark
//
//  Created by chensw on 2018/12/7.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SGBaseController.h"
#import "SPSelectDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface SPAreaViewController : SGBaseController<SPSelectDelegate>
@property (nonatomic, weak) id<SPSelectDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
