//
//  SPPlayVideoController.h
//  SinglePark
//
//  Created by DBB on 2018/10/4.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SGBaseController.h"

@interface SPPlayVideoController : SGBaseController

@property (nonatomic,strong)NSMutableArray *datasource;
@property (nonatomic,assign)ChooseType choosetype;
@property (nonatomic,assign)BOOL  islocal;
@property (nonatomic,assign)NSInteger  selectIndex;
@property (nonatomic,assign)NSInteger num;

@end
