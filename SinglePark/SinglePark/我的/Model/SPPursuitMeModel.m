//
//  SPPursuitMeModel.m
//  SinglePark
//
//  Created by chensw on 2019/1/21.
//  Copyright © 2019 DBB. All rights reserved.
//

#import "SPPursuitMeModel.h"

@implementation SPPursuitMeModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"itemId": @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"fromUser" : SPPersonModel.class,
             @"toUser" : SPPersonModel.class
             };
}
@end
