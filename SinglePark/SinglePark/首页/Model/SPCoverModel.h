//
//  SPCoverModel.h
//  SinglePark
//
//  Created by DBB on 2018/10/4.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SGBaseModel.h"
#import "SPPersonModel.h"

@interface SPCoverModel : SGBaseModel
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *distance;
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,copy)NSString *sex;


//数据 视频model
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *videoId;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *updated_at;
@property (nonatomic,copy)NSString *up_nums;
@property (nonatomic,copy)NSString *video;
@property (nonatomic,copy)NSString *thumb_id; //截图ID
@property (nonatomic,copy)NSString *thumb; //截图


@end
