//
//  SPMessageModel.h
//  SinglePark
//
//  Created by DBB on 2018/10/9.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPMessageModel : SGBaseModel
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,copy)NSString *messsage;
@property (nonatomic,copy)NSString *time;

@property (nonatomic,copy)NSString *coverimg;
@property (nonatomic,copy)NSString *answer;


@property (nonatomic,copy)NSString *gooder;




// 视频回答
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *messageId;
@property (nonatomic,copy)NSString *video_id;
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,strong)NSArray *replies;
@end

NS_ASSUME_NONNULL_END
