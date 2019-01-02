//
//  SPPersonModel.m
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPersonModel.h"

@implementation SPPersonModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId": @"id",
             @"nickName" : @"nick_name",
             };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"first_video" : SPCoverModel.class,
             };
}


@end
