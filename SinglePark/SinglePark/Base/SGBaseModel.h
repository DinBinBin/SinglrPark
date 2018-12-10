//
//  SGBaseModel.h
//  StillGold
//
//  Created by DBB on 2017/6/5.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>


@interface SGBaseModel : NSObject <YYModel,NSCopying,NSCoding>


/// YYModel - API
/// 将 Json (NSData，NSString，NSDictionary) 转换为 Model
+ (instancetype)modelWithJSON:(id)json;
/// 字典转模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
/// json-array 转换为 模型数组
+ (NSArray *)modelArrayWithJSON:(id)json;


/// 将 Model 转换为 JSON 对象
- (id)toJSONObject;
/// 将 Model 转换为 NSData
- (NSData *)toJSONData;
/// 将 Model 转换为 JSONString
- (NSString *)toJSONString;



/*
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
*/
@end
