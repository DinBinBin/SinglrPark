//
//  SPVideoModel.h
//  SinglePark
//
//  Created by 斌斌戴 on 2018/11/15.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPVideoModel : SGBaseModel

@property (nonatomic,copy)NSString *commentStr;
@property (nonatomic,copy)NSString *headUrl;
@property (nonatomic,copy)NSString *goodnumber;



@property (nonatomic,copy)NSString *up_nums;
@property (nonatomic,copy)NSString *video;
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *updated_at;
@property (nonatomic,copy)NSString *comments;
@property (nonatomic,assign)BOOL up;
@property (nonatomic,assign)NSString *videoId;


@end


NS_ASSUME_NONNULL_END
