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



//登录接口
#define SPURL_API_Login [NSString stringWithFormat:@"%@/login",BASE_HttpURL]

//首页接口
#define PTURL_API_Index [NSString stringWithFormat:@"%@/app/index/index.do",BASE_HttpURL]

//登录接口
#define PTURL_API_LOGIN [NSString stringWithFormat:@"%@/app/login/login.do",BASE_HttpURL]
//忘记密码接口
#define PTURL_API_FINDPWD [NSString stringWithFormat:@"%@/app/customer/updatePWD.do",BASE_HttpURL]
// 刷新接口
#define PTURL_API_Mine [NSString stringWithFormat:@"%@/app/customer/index.do",BASE_HttpURL]
//我资产明显
#define PTURL_API_MineDetails  [NSString stringWithFormat:@"%@/app/customer/accountDetail.do",BASE_HttpURL]
//实名认证
#define PTURL_RealmName [NSString stringWithFormat:@"%@/app/validate/toVerifyIDEntity.do",BASE_HttpURL]
//银行卡 接口
#define PTURL_API_Back [NSString stringWithFormat:@"%@/app/validate/toBindBankCard.do",BASE_HttpURL]





// 修改登录 交易密码
#define PTURL_API_Revise [NSString stringWithFormat:@"%@/appUserInfo/update_pwd",BASE_HttpURL]
//平台公告 动态
#define PTURL_API_FINDNotice [NSString stringWithFormat:@"%@/appMore/queryArticles",BASE_HttpURL]


//我的投资
#define PTURL_API_MineInvestment [NSString stringWithFormat:@"%@/appMember/investRecords",BASE_HttpURL]
//充值纪录
#define PTURL_API_RechargeRecord [NSString stringWithFormat:@"%@/appRecharge/rechargeRecord",BASE_HttpURL]
//提现记录
#define PTURL_API_CashRecord [NSString stringWithFormat:@"%@/appWithdraw/withdrawRecord",BASE_HttpURL]
//提现
#define PTURL_API_Cash [NSString stringWithFormat:@"%@/appWithdraw/doWithdraw",BASE_HttpURL]
// 红包接口
#define PTURL_API_RedPacket [NSString stringWithFormat:@"%@/appMember/userConpons",BASE_HttpURL]
//理财产品接口
#define PTURL_API_Financial [NSString stringWithFormat:@"%@/appLoan/loans",BASE_HttpURL]
//理财产品详情
#define PTURL_API_Financialdetails [NSString stringWithFormat:@"%@/appLoan/loan",BASE_HttpURL]
//理财产品投资记录
#define PTURL_API_Financialinvests [NSString stringWithFormat:@"%@/appLoan/invests",BASE_HttpURL]
//二维码接口
#define PTURL_API_Code [NSString stringWithFormat:@"%@/appUserInfo/ycodeImg",BASE_HttpURL]
//获取订单 接口
#define PTURL_getOrdernumber [NSString stringWithFormat:@"%@/appRecharge/getMchntOrderId",BASE_HttpURL]
//设置交易密码
#define PTURL_getSetPay [NSString stringWithFormat:@"%@/appUserInfo/update_transPwd",BASE_HttpURL]
//投资页面
#define PTURL_BidToInvest [NSString stringWithFormat:@"%@/appInvest/toInvest",BASE_HttpURL]
//取消充值
#define PTURL_cancelRecharge [NSString stringWithFormat:@"%@/appRecharge/cancelRecharge",BASE_HttpURL]
//充值成功回调
#define PTURL_RechargeBack [NSString stringWithFormat:@"%@/appRecharge/rechargeBack",BASE_HttpURL]

//投资支付
#define PTURL_BiddoInvest [NSString stringWithFormat:@"%@/appInvest/doInvest",BASE_HttpURL]




#endif /* PTAPI_h */

