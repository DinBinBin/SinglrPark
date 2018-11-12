//
//  ProjectHelp.h
//  General
//
//  Created by DBB on 2017/3/8.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectHelp : NSObject


+(void)creatGif:(UIImageView *)imgView strpath:(NSString *)strpath;
+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font; //计算宽度
+(UIButton *)btnImg:(NSString *)imgStr hightImg:(NSString *)hightStr title:(NSString *)title withframe:(CGRect )frame;//未完成按钮
+ (CGFloat)heightWithString:(NSString *)string font:(UIFont *)font; //计算高度
+(UIView *)point:(CGPoint )point width:(CGFloat )width height:(CGFloat )heigth;//线条
+ (NSMutableAttributedString *)getstrrange:(NSRange )range attribu:(NSString *)str font:(UIFont *)font color:(UIColor *)color;

+ (NSMutableAttributedString *)getAttributstrrange:(NSRange )range attribu:(NSMutableAttributedString *)str font:(UIFont *)font color:(UIColor *)color;
+ (CGSize )getAttributstr:(NSMutableAttributedString *)attributStr getsize:(CGSize )size;
+ ( NSString*)getCurrentLocalIP; //获取当前IP
+ (CGFloat )equalmoneyInterest:(CGFloat )money rate:(CGFloat )rate time:(CGFloat )time; //计算等额本息
+ (CGFloat )expireInterestmonth:(CGFloat )money rate:(CGFloat )rate time:(CGFloat )time; //到期还本付息 月
+ (CGFloat )expireInterestDay:(CGFloat )money rate:(CGFloat )rate time:(CGFloat )time; //到期还本付息 天
+ (NSArray *)cdi_imagesWithGif:(NSString *)gifNameInBoundle;


@end
