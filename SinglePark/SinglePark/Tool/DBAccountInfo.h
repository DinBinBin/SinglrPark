//
//  DBAccountInfo.h
//  KnowledgeGold
//
//  Created by DBB on 2017/4/22.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGBaseController.h"
#import "SPPersonModel.h"

@interface DBAccountInfo : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic,assign)BOOL islogin;
@property (nonatomic,strong)SGBaseController *backControl; //返回的控制器
@property (nonatomic,strong)SGBaseController *secondControl;  //第二控制器
//@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)SPPersonModel *model;

@end
