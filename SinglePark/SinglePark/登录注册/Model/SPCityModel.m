//
//  SPCityModel.m
//  SinglePark
//
//  Created by chensw on 2018/12/7.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPCityModel.h"

@implementation SPCityModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"value": @"id",
             @"parent": @"pid"
             };
}

@end
