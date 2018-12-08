//
//  SPSupplementController.h
//  SinglePark
//
//  Created by DBB on 2018/9/13.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SGBaseController.h"

@protocol SPJobDelegate <NSObject>

- (void)selectJobName:(NSString *)name;

@end

@interface SPSupplementController : SGBaseController

@end
