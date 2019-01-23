//
//  SPMessageModel.m
//  SinglePark
//
//  Created by DBB on 2018/10/9.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPMessageModel.h"

@implementation SPMessageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"messageId": @"id",
             };
}

@end
