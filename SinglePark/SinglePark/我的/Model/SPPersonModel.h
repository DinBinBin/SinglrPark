//
//  SPPersonModel.h
//  SinglePark
// 个人资料
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPersonModel : SGBaseModel
@property (nonatomic,assign)int userId;
@property (nonatomic,copy)NSString *avatar;//用户头像
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *birthday;
@property (nonatomic,copy)NSString *occupation; //职业
@property (nonatomic,copy)NSArray *job; //职业数组

@property (nonatomic,copy)NSString *unit; //所在单位
@property (nonatomic,copy)NSString *university; //毕业学校
@property (nonatomic,copy)NSString *education; //学历
@property (nonatomic,copy)NSString *province_id; //省
@property (nonatomic,copy)NSString *city_id; //市
@property (nonatomic,copy)NSString *district_id; //区
@property (nonatomic,copy)NSString *height; //身高
@property (nonatomic,copy)NSString *weight; //体重
@property (nonatomic,copy)NSString *income; //年收入
@property (nonatomic,copy)NSString *signature; //三观签名
@property (nonatomic,copy)NSString *referrer; //引荐人
@property (nonatomic,copy)NSString *invitationCode;//邀请码
@property (nonatomic,copy)NSString *phone;//手机号
@property (nonatomic,copy)NSString *recommend;//推荐指数
@property (nonatomic,copy)NSString *latitude;//纬度
@property (nonatomic,copy)NSString *longitude;//经度
@property (nonatomic,assign)int config_notice;//新消息通知 1:开启；2:关闭
@property (nonatomic,assign)int config_notice_detail;//新消息详情通知 1:开启；2:关闭
@property (nonatomic,assign)int config_privacy;//隐私设置 1:完全公开；2:仅有视频的用户可见；3;我追的人可见；4:追我的人可见；5:仅自己可见



@property (nonatomic,copy)NSString *singer;
@property (nonatomic,copy)NSString *didian;
@property (nonatomic,strong)NSArray *number;




@property (nonatomic,copy)NSString *token;
@end

NS_ASSUME_NONNULL_END
