//
//  SPPersonModel.h
//  SinglePark
// 个人资料
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPersonModel : SGBaseModel
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *occupation;
@property (nonatomic,copy)NSString *singer;
@property (nonatomic,copy)NSString *didian;
@property (nonatomic,strong)NSArray *number;





@property (nonatomic,copy)NSString *token;
@end

NS_ASSUME_NONNULL_END
