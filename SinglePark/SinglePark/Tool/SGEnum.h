
//
//  SGEnum.h
//  StillGold
//
//  Created by DBB on 2017/7/26.
//  Copyright © 2017年 DBB. All rights reserved.
//

#ifndef SGEnum_h
#define SGEnum_h

typedef NS_ENUM(NSInteger,ChooseType) {
    
    BoyChoose = 1,      // 男
    FemaleChoose = 2,     //女
    AllSexChoose = 3     // 全部
};

typedef NS_ENUM(NSInteger,FriendType) {
    
    FriendGift = 1,     //邀请奖励
    FriendName = 2,     // 邀请人
    
};

typedef NS_ENUM(NSInteger, SPPursuitType) {
    SPPursuitTypeNone,                  // 没有要追的人
    SPPursuitTypeNotStated,             // 未表态
    PursuitTypeDetailAccept,            // 接受
    SPPursuitTypeRefuse,                // 拒绝
    SPPursuitTypeOutTime,               // 未表态而且超时了
    
    
};

typedef NS_ENUM(NSInteger, SPPursuitViewType) {
    SPPursuitMeViewType,                // 追我的人
    SPMePursuitViewType                 // 我追的人
};


#endif /* SGEnum_h */
