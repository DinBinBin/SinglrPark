//
//  SPJobModel.m
//  SinglePark
//
//  Created by chensw on 2018/12/6.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPJobModel.h"

@implementation SPJobModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"userID": @"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    //    if ([dic[@"infoList"] isKindOfClass:[NSNull class]]) return YES;
    //
    //    NSArray<JDWHotInfoModel *> *arr = dic[@"infoList"];
    //
    //    if (arr.count > 0) {
    //        for (int i = 0; i < arr.count; i++) {
    //            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dic[@"infoList"][i][@"publishTime"] doubleValue] / 1000.0];
    //            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //            //设定时间格式,这里可以设置成自己需要的格式
    //            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //            self.infoList[i].publishTime = [dateFormatter stringFromDate:date];
    //        }
    //    }
    
    return YES;
}
@end
