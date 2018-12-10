//
//  SPPersonModel.m
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPersonModel.h"

@implementation SPPersonModel

//效率考虑
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.occupation forKey:@"occupation"];
    [aCoder encodeObject:self.singer forKey:@"singer"];
    [aCoder encodeObject:self.didian forKey:@"didian"];
    [aCoder encodeObject:self.number forKey:@"number"];

    [aCoder encodeBool:self.token forKey:@"token"];

    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.occupation = [aDecoder decodeObjectForKey:@"occupation"];
        self.singer = [aDecoder decodeObjectForKey:@"singer"];
        self.didian = [aDecoder decodeObjectForKey:@"didian"];
        self.number = [aDecoder decodeObjectForKey:@"number"];
        self.token = [aDecoder decodeObjectForKey:@"token"];

    }
    return self;
}




@end
