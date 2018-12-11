//
//  MFDatePick.h
//  YGather
//
//  Created by lyu on 16/9/13.
//  Copyright © 2016年 GXCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,MFPickType) {
    MFSexPick = 1,  // 性别选择
    MFDatePick,     // 出生日期
    MFAreaPick,     // 地区
    MFJobPick,      // 职业
    MFEduPick       // 教育程度
};

@interface MFDatePickView : UIView
///点击取消按钮回调
@property (nonatomic, copy) void (^cancelBtnDidClickBlock)(void);
///点击确定按钮回调
@property (nonatomic, copy) void (^doneBtnDidClickBlock)(NSString * str);
///选择的日期
@property (nonatomic, copy) NSString *birthdayStr;
///其他选择器（非日期选择器）数据改变回
@property (nonatomic, copy) void (^dateChangeBlock)(NSString * str);
// 日期选择器日期（专用block）改变回调
@property (nonatomic, copy) void (^selectDateBlock)(NSDate * date);
//点击隐藏年龄按钮回调
@property (nonatomic, copy) void (^hiddenAgeBlock)(BOOL hidden);
//右下角是否显示隐藏年龄视图
@property (nonatomic, getter=isHiddenAge) BOOL hiddenAge;

/** 标题 */
@property (nonatomic, strong) NSString *title;
///日期选择器
@property (nonatomic, strong) UIDatePicker *datePick;

//选择器类型
@property (nonatomic, assign) MFPickType pickType;
// 隐藏年龄按钮
@property (nonatomic, strong) UIButton *hiddenAgeBtn;


@end
