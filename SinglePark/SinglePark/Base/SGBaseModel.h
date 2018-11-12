//
//  SGBaseModel.h
//  StillGold
//
//  Created by DBB on 2017/6/5.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGBaseModel : NSObject
/// 返回状态(Success  bool)
@property (nonatomic, assign) BOOL success;
/// 返回错误消息(ExceptionMessage string)
@property (nonatomic, copy) NSString *exceptionMessage;

- (id)initWithDataDic:(NSDictionary*)data;    // 传入字典 创建时
- (void)setAttributes:(NSDictionary*)dataDic; // 再次赋值
- (NSString *)customDescription;
- (NSString *)description;
- (NSData *)getArchivedData;

- (NSString *)cleanString:(NSString *)str; // 清除\n和\r的字符串
- (NSDictionary*)attributeMapDictionary;   // 映射 关系

@end
