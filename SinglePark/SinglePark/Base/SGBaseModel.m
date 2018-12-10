//
//  SGBaseModel.m
//  StillGold
//
//  Created by DBB on 2017/6/5.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import "SGBaseModel.h"

@implementation SGBaseModel

/// 将 JSON (NSData,NSString,NSDictionary) 转换为 Model
+ (instancetype)modelWithJSON:(id)json { return [self yy_modelWithJSON:json]; }

/// json-array 转 模型-数组
+ (NSArray *)modelArrayWithJSON:(id)json {
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

/// 字典转模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    return [self yy_modelWithDictionary:dictionary];
}

- (id)toJSONObject { return [self yy_modelToJSONObject]; }
- (NSData *)toJSONData { return [self yy_modelToJSONData]; }
- (NSString *)toJSONString { return [self yy_modelToJSONString]; }



/// Coding/Copying/hash/equal
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

/// Properties optional
- (void)setValue:(id)value forUndefinedKey:(NSString *)key { }

/// desc
- (NSString *)description { return [self yy_modelDescription]; }



/*
-(id)initWithDataDic:(NSDictionary*)data{
    if (self = [super init]) {
        [self setAttributes:data];
    }
    return self;
}

-(SEL )getSetterSelWithAttibuteName:(NSString*)attributeName{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}
- (NSString *)customDescription{
    return nil;
}

- (NSString *)description{
    NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject *valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            //            ITTDINFO(@"attributeName %@ value %@", attributeName, valueObj);
            if (valueObj) {
                [attrsDesc appendFormat:@" [%@=%@] ",attributeName, valueObj];
                //[valueObj release];
            }else {
                [attrsDesc appendFormat:@" [%@=nil] ",attributeName];
            }
            
        }
    }
    
    NSString *customDesc = [self customDescription];
    NSString *desc;
    
    if (customDesc && [customDesc length] > 0 ) {
        desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
    }else {
        desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
    }
    
    return desc;
}
-(void)setAttributes:(NSDictionary*)dataDic{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[dataDic count]];
        for (NSString *key in dataDic) {
            [dic setValue:key forKey:key];
            attrMapDic = dic;
        }
    }
    
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
            id attributeValue = [dataDic objectForKey:dataDicKey];
            if (attributeValue == nil) {
                if ([attributeName isEqualToString:@"null"]) {
                    continue;
                }
                attributeValue = @"";
            }
            [self performSelectorOnMainThread:sel
                                   withObject:attributeValue
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}

- (id)initWithCoder:(NSCoder *)decoder{
    if( self = [super init] ){
        NSDictionary *attrMapDic = [self attributeMapDictionary];
        if (attrMapDic == nil) {
            return self;
        }
        NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
        id attributeName;
        while ((attributeName = [keyEnum nextObject])) {
            SEL sel = [self getSetterSelWithAttibuteName:attributeName];
            if ([self respondsToSelector:sel]) {
                id obj = [decoder decodeObjectForKey:attributeName];
                [self performSelectorOnMainThread:sel
                                       withObject:obj
                                    waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject *valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            
            if (valueObj) {
                [encoder encodeObject:valueObj forKey:attributeName];
            }
        }
    }
}
- (NSData*)getArchivedData{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)cleanString:(NSString *)str {
    if (str == nil) {
        return @"";
    }
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\n" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@"\r" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    return cleanString;
}

// 映射 关系
-(NSDictionary*)attributeMapDictionary{
    return nil;
}



#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    //    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
*/
@end
