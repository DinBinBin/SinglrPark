//
//  SPPersonModel.h
//  SinglePark
// 个人资料
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SGBaseModel.h"
#import "SPCoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPersonModel : SGBaseModel
@property (nonatomic,assign)int userId;
@property (nonatomic,copy)NSString *avatar;//用户头像
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,assign)int sex;//0:未设置；1:男；2:女
@property (nonatomic,copy)NSString *birthday; //生日日期
@property (nonatomic,copy)NSString *age; //年龄
@property (nonatomic,copy)NSString *occupation; //职业
@property (nonatomic,copy)NSArray *job; //职业数组

@property (nonatomic,copy)NSString *unit; //所在单位
@property (nonatomic,copy)NSString *university; //毕业学校
@property (nonatomic,copy)NSString *education; //学历
@property (nonatomic,assign)NSInteger province_id; //省
@property (nonatomic,assign)NSInteger city_id; //市
@property (nonatomic,assign)NSInteger district_id; //区
@property (nonatomic,copy)NSString *areaName;
@property (nonatomic,copy)NSString *height; //身高
@property (nonatomic,copy)NSString *weight; //体重
@property (nonatomic,copy)NSString *income; //年收入
@property (nonatomic,copy)NSString *signature; //三观签名
@property (nonatomic,copy)NSString *referrer; //引荐人
@property (nonatomic,copy)NSString *invitationCode;//邀请码
@property (nonatomic,copy)NSString *phone;//手机号
@property (nonatomic,copy)NSString *recommend;//推荐指数
@property (nonatomic,assign)double latitude;//纬度
@property (nonatomic,assign)double longitude;//经度
@property (nonatomic,assign)NSInteger config_notice;//新消息通知 1:开启；2:关闭
@property (nonatomic,assign)NSInteger config_notice_detail;//新消息详情通知 1:开启；2:关闭
@property (nonatomic,assign)NSInteger config_privacy;//隐私设置 1:完全公开；2:仅有视频的用户可见；3;我追的人可见；4:追我的人可见；5:仅自己可见


@property (nonatomic,copy)NSString *singer;
@property (nonatomic,copy)NSString *didian;
@property (nonatomic,strong)NSArray *number;








//首页用到的mmodel
@property (nonatomic,strong)SPCoverModel *videoModel;
@property (nonatomic,strong)NSArray *first_video;

@end

NS_ASSUME_NONNULL_END
