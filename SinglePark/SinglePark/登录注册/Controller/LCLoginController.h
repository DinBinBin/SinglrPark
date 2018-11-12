//
//  LCLoginController.h
//  MRLC
//
//  Created by DBB on 2017/8/11.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import "SGBaseController.h"
//#import "SGUserModel.h"

@interface LCLoginController : SGBaseController

//@property (nonatomic,strong)SGUserModel *userModel;
@property (nonatomic,copy)NSString *passwordStr;
@property (nonatomic,assign)BOOL iswelecome;

@end
