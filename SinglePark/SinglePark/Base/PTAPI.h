//
//  PTAPI.h
//  PTLS
//
//  Created by mac on 2017/1/9.
//  Copyright © 2017年 DBB. All rights reserved.
//

#ifndef PTAPI_h
#define PTAPI_h


//http://jiu.wuchenge.com/api/doc/index.html



//刷新token
#define SPURL_API_Refresh [NSString stringWithFormat:@"%@/refresh",BASE_HttpURL]
//发送手机验证码接口
#define PTURL_API_SENDMSG [NSString stringWithFormat:@"%@/captcha",BASE_HttpURL]
//注册/邀请码
#define PTURLinvitation [NSString stringWithFormat:@"%@/code",BASE_HttpURL]
//注册接口
#define PTURL_API_LOGINREGIST [NSString stringWithFormat:@"%@/register",BASE_HttpURL]
//用户信息修改
#define PTURL_API_UserChage [NSString stringWithFormat:@"%@/user/modify",BASE_HttpURL]
//用户信息获取
#define PTURL_API_UserGet [NSString stringWithFormat:@"%@/user",BASE_HttpURL]
//职业列表
#define SPURL_API_Job [NSString stringWithFormat:@"%@/job/list",BASE_HttpURL]
//所有城市列表
#define SPURL_API_City [NSString stringWithFormat:@"%@/city/list",BASE_HttpURL]
//城市id换名称
#define SPURL_API_CityName [NSString stringWithFormat:@"%@/city",BASE_HttpURL]
//他人的用户信息
#define SPURL_API_info [NSString stringWithFormat:@"%@/user/info",BASE_HttpURL]
//追我的人
#define SPURL_API_Follow_tos [NSString stringWithFormat:@"%@/follows/tos",BASE_HttpURL]
//我追的人
#define SPURL_API_Follow_froms [NSString stringWithFormat:@"%@/follows/froms",BASE_HttpURL]

//意见反馈
#define SPURL_API_Feedback [NSString stringWithFormat:@"%@/feedback/create",BASE_HttpURL]
//协议文档
#define SPURL_API_Document [NSString stringWithFormat:@"%@/document/detail/",BASE_HttpURL]

//追她
#define SPURL_API_follows_create [NSString stringWithFormat:@"%@/follows/create",BASE_HttpURL]
//追讯
#define SPURL_API_Follows [NSString stringWithFormat:@"%@/follows/list",BASE_HttpURL]

// 获取七牛token
#define SPQiniuToken [NSString stringWithFormat:@"%@/qiniu",BASE_HttpURL]
// 图片地址
#define SPURL_API_Img(img) [@"http://images.wuchenge.com" stringByAppendingPathComponent:img]
//首页接口
#define PTURL_API_Index [NSString stringWithFormat:@"%@/home",BASE_HttpURL]
//发布视频接口
#define SPSendVideo [NSString stringWithFormat:@"%@/video/create",BASE_HttpURL]
//视频详情
#define SPInfoVideo [NSString stringWithFormat:@"%@/video/detail",BASE_HttpURL]
//视频点赞
#define SPUPVideo [NSString stringWithFormat:@"%@/video/up",BASE_HttpURL]
//视频举报
#define SPReports [NSString stringWithFormat:@"%@/reports/create",BASE_HttpURL]
//视频评论列表
#define SPComments [NSString stringWithFormat:@"%@/comments/list",BASE_HttpURL]
//视频评论
#define SPCommentscreate [NSString stringWithFormat:@"%@/comments/create",BASE_HttpURL]
//视频评论回复
#define SPAnswer [NSString stringWithFormat:@"%@/replies/create",BASE_HttpURL]
//我的评论列表
#define SPMineCommentList [NSString stringWithFormat:@"%@/comments/user_list",BASE_HttpURL]
//点赞列表
#define SPVideoUpList [NSString stringWithFormat:@"%@/video/up_list",BASE_HttpURL]
//我发布的视频
#define SPVideoList [NSString stringWithFormat:@"%@/video/list",BASE_HttpURL]
//查看处理结果
#define SPQiuniiuCat [NSString stringWithFormat:@"%@/qiniu_cat",BASE_HttpURL]

//版本更新
#define SPVersion [NSString stringWithFormat:@"%@/version",BASE_HttpURL]



//登录接口
#define SPURL_API_Login [NSString stringWithFormat:@"%@/login",BASE_HttpURL]



#endif /* PTAPI_h */

