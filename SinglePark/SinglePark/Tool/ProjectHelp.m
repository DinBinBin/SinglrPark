//
//  ProjectHelp.m
//  General
//
//  Created by DBB on 2017/3/8.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import "ProjectHelp.h"
#import <ImageIO/ImageIO.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AVFoundation/AVFoundation.h>

@implementation ProjectHelp

+(void)creatGif:(UIImageView *)imgView strpath:(NSString *)strpath{
    //1.找到gif文件路径
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:strpath ofType:@"gif"];
    //2.获取gif文件数据
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:dataPath], NULL);
    //3.获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //4.定义一个变量记录gif播放一轮的时间
    float allTime = 0;
    //5.定义一个可变数组存放所有图片
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    //6.定义一个可变数组存放每一帧播放的时间
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    //7.每张图片的宽度
    NSMutableArray *widthArray = [[NSMutableArray alloc] init];
    //8.每张图片的高度
    NSMutableArray *heightArray = [[NSMutableArray alloc] init];
    
    //遍历gif
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        
        //获取图片信息
        NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        //获取宽度
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        //获取高度
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        
        //
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        
        //统计时间
        NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
        allTime +=time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    //添加帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    NSMutableArray *times = [[NSMutableArray alloc] init];
    float currentTime = 0;
    //设置每一帧的时间占比
    for (int i=0; i<imageArray.count; i++) {
        [times addObject:[NSNumber numberWithFloat:currentTime/allTime]];
        currentTime +=[timeArray[i] floatValue];
    }
    [animation setKeyTimes:times];
    [animation setValues:imageArray];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    //设置循环
    animation.repeatCount = 2;
    //设置播放总时长
    animation.duration = allTime;
    //Layer层添加
    [[imgView layer] addAnimation:animation forKey:@"gifAnimation"];
    
}


//计算高度
+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font
{
    CGSize rtSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    rtSize = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(rtSize.width) + 5;
    
}

+ (CGFloat)heightWithString:(NSString *)string font:(UIFont *)font{
    CGSize rtSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    rtSize = [string boundingRectWithSize:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(rtSize.height) + 5;
    
}

+(UIButton *)btnImg:(NSString *)imgStr hightImg:(NSString *)hightStr title:(NSString *)title withframe:(CGRect )frame{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, button.width, button.height*2/3)];
    [imgview setImage:[UIImage imageNamed:imgStr]];
    
    //    UILabel
    
    
    return button;
}

//线条
+(UIView *)point:(CGPoint )point width:(CGFloat )width height:(CGFloat )heigth{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, width, heigth)];
    lineView.backgroundColor = MyBackLine;
    return lineView;
}

// 特意字体
+ (NSMutableAttributedString *)getstrrange:(NSRange )range attribu:(NSString *)str font:(UIFont *)font color:(UIColor *)color{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:font
     
                          range:range];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:color
     
                          range:range];
    return AttributedStr;
}

+ (NSMutableAttributedString *)getAttributstrrange:(NSRange )range attribu:(NSMutableAttributedString *)str font:(UIFont *)font color:(UIColor *)color{
    
    [str addAttribute:NSFontAttributeName
     
                value:font
     
                range:range];
    
    [str addAttribute:NSForegroundColorAttributeName
     
                value:color
     
                range:range];
    return str;
}
+ (CGSize )getAttributstr:(NSMutableAttributedString *)attributStr getsize:(CGSize )size{
    return  [attributStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
}
//获取当前IP
+ ( NSString*)getCurrentLocalIP
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (CGFloat )equalmoneyInterest:(CGFloat )money rate:(CGFloat )rate time:(CGFloat )time{ //计算等额本息
    return  ( money*rate/12*pow((1+rate/12), time))/(pow((1+rate/12), time)-1)*time-money;
}
+ (CGFloat )expireInterestmonth:(CGFloat )money rate:(CGFloat )rate time:(CGFloat )time{//到期还本付息 月
    return money*rate/12*time;
}

+ (CGFloat )expireInterestDay:(CGFloat )money rate:(CGFloat )rate time:(CGFloat )time{ //到期还本付息 天
    return money*rate/360*time;
}


+ (NSArray *)cdi_imagesWithGif:(NSString *)gifNameInBoundle {
    //    NSString *dataPath = [[NSBundle mainBundle]pathForResource:gifNameInBoundle ofType:@"gif"];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:gifNameInBoundle withExtension:@"gif"];
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [frames addObject:image];
        CGImageRelease(imageRef);
    }
    return frames;
}

@end


