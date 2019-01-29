//
//  MFDatePick.m
//  YGather
//
//  Created by lyu on 16/9/13.
//  Copyright © 2016年 GXCloud. All rights reserved.
//

#import "MFDatePickView.h"
#import "NSDateFormatter+Category.h"
@interface MFDatePickView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *provinceName;  // 省
    NSString *cityName;      // 市
    NSString *areaName;      // 区
}
///顶部tabbar
@property (nonatomic, strong) UIView *tabBarView;
///取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
///确定按钮
@property (nonatomic, strong) UIButton *doneBtn;

///标题
@property (nonatomic, strong) UILabel *titleLabel;
/** 性别 */
@property (nonatomic, copy) NSString *sexStr;
/** 年龄 */
@property (nonatomic, copy) NSString *ageStr;
/** 地区 */
@property (nonatomic, copy) NSString *areaStr;
/** 职业*/
@property (nonatomic, copy) NSString *jobStr;
/** 学历*/
@property (nonatomic, copy) NSString *eduStr;
/** 隐藏年龄视图按钮 */
@property (nonatomic, strong) UILabel *ageLabel;
/** 活动报名截止时间标题 */
@property (nonatomic, strong) UILabel *lastLabel;
/** 活动报名截止时间说明小标题 */
@property (nonatomic, strong) UILabel *specLb;


/** 性别选择器 */
@property (nonatomic, strong) UIPickerView *sexPickView;
/** 学历选择器 */
@property (nonatomic, strong) UIPickerView *eduPickView;
/** 职业选择器 */
@property (nonatomic, strong) UIPickerView *jobPickView;
/** 地区选择器 */
@property (nonatomic, strong) UIPickerView *areaPickView;

/** 性别数组 */
@property (nonatomic, strong) NSArray *sexArray;
/** 学历数组 */
@property (nonatomic, strong) NSArray *eduArray;
/** 职业数组 */
@property (nonatomic, strong) NSArray *jobArray;
/** 地区数组 */
@property (nonatomic, strong) NSArray *plistArray;

/** 所有省数组 */
@property (nonatomic, strong) NSMutableArray *provinceArr;
/** 所有市数组 */
@property (nonatomic, strong) NSMutableArray *cityArr;
/** 所有地区数组 */
@property (nonatomic, strong) NSMutableArray *areaArr;

@end



@implementation MFDatePickView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"areaArray" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistStr];
        self.plistArray = [NSMutableArray arrayWithArray:array];
        self.cityArr = [NSMutableArray arrayWithCapacity:0];
        self.areaArr = [NSMutableArray arrayWithCapacity:0];
        
        provinceName = @"";
        cityName = @"";
        areaName = @"";
        [self setupUP];
    }
    return self;

}


#pragma mark - 初始化UI
-(void)setupUP{

    //添加tabbar
    [self addSubview:self.tabBarView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.doneBtn];
    [self addSubview:self.datePick];
    [self addSubview:self.lastLabel];
    [self addSubview:self.specLb];
    
    
    //添加约束
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.coverBtn.mas_bottom);
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@(44));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(self.tabBarView).offset(11);
        make.centerY.equalTo(self.tabBarView);
        make.left.equalTo(self.tabBarView).offset(15);
        make.width.equalTo(@(40));

    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.tabBarView);
    }];
    
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tabBarView).offset(11);
        make.centerY.equalTo(self.tabBarView);
        make.right.equalTo(self.tabBarView).offset(-15);
        make.width.equalTo(@(40));
    }];
    
    [self.datePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBarView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(216));
    }];
    

    [_lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.centerX.mas_equalTo(0);
    }];
    
    [_specLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.centerX.mas_equalTo(0);
    }];

}

#pragma mark - 事件点击
-(void)doneBtnClick{
    
    //默认选择当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (self.datePick.datePickerMode == UIDatePickerModeDateAndTime) {
        formatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd H:mm"];
    }else{
        formatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
    }
    NSString *newDateStr = [formatter stringFromDate:date];
    
    switch (self.pickType) {
        case MFSexPick:
            if (self.doneBtnDidClickBlock) {
                self.doneBtnDidClickBlock(self.sexStr ? self.sexStr : self.sexArray[0]);
            }
            break;
        case MFDatePick:
            if (self.doneBtnDidClickBlock) {
                self.doneBtnDidClickBlock(self.ageStr ? self.ageStr : newDateStr);
            }
            break;
        case MFAreaPick:
            if (self.doneBtnDidClickBlock) {
                self.doneBtnDidClickBlock(self.areaStr ? self.areaStr : @"北京市 市辖区 东城区");
            }
            break;
        case MFJobPick:
            if (self.doneBtnDidClickBlock) {
                self.doneBtnDidClickBlock(self.jobStr ? self.jobStr : self.jobArray[0]);
            }
            break;
        case MFEduPick:
            if (self.doneBtnDidClickBlock) {
                self.doneBtnDidClickBlock(self.eduStr ? self.eduStr : self.eduArray[0]);
            }
            break;
   
        default:
            break;
    }
    
//    if (self.doneBtnDidClickBlock) {
//        self.doneBtnDidClickBlock(self.birthdayStr ? self.birthdayStr : newDateStr);
//    }
    

}
-(void)canelBtnDidClick{

    if (self.cancelBtnDidClickBlock) {
        self.cancelBtnDidClickBlock();
    }

}
- (void)dateChange:(UIDatePicker *)datePick{
    
    //把当前的日期给文本框赋值
    //获取当前选中的日期
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    if (datePick.datePickerMode == UIDatePickerModeDateAndTime) {
        fmt.dateFormat = @"yyyy-MM-dd H:mm";

    }else{
    fmt.dateFormat = @"yyyy-MM-dd";
    }
    //把当前日期转成字符串
    self.birthdayStr = [fmt stringFromDate:datePick.date];
    self.ageStr = [fmt stringFromDate:datePick.date];
    
    if (self.selectDateBlock) {
        self.selectDateBlock(datePick.date);
    }
    
}

- (void)hiddenAgeclick:(UIButton *)button
{
    button.selected = !button.selected;
    if (self.hiddenAgeBlock) {
        self.hiddenAgeBlock(button.selected);
    }
}

#pragma mark - 懒加载
-(UIView *)tabBarView{
    if (_tabBarView == nil) {
        _tabBarView = [[UIView alloc] init];
        _tabBarView.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    return _tabBarView;
}

-(UIButton *)cancelBtn{

    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:FirstWordColor forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:FONT(16)];
        [_cancelBtn addTarget:self action:@selector(canelBtnDidClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _cancelBtn;
}
-(UILabel *)titleLabel{

    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请选择时间";
        _titleLabel.textColor = TextMianColor;
        _titleLabel.font = FONT(16);
        [_titleLabel sizeToFit];

    }
    return _titleLabel;
}
-(UIButton *)doneBtn{
    
    if (_doneBtn == nil) {
        _doneBtn = [[UIButton alloc] init];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:FirstWordColor forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_doneBtn.titleLabel setFont:FONT(16)];

    }
    return _doneBtn;
    
}

-(UIDatePicker *)datePick{

    if (_datePick == nil) {
        _datePick = [[UIDatePicker alloc] init];
        _datePick.backgroundColor = [UIColor whiteColor];
        _datePick.datePickerMode = UIDatePickerModeDate;
        //设置中国时间格式
        _datePick.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        [_datePick addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];

    }
    return _datePick;
}


- (UIButton *)hiddenAgeBtn
{
    if (!_hiddenAgeBtn) {
        _hiddenAgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hiddenAgeBtn setBackgroundImage:ImageNamed(@"icon_select_off") forState:UIControlStateNormal];
        [_hiddenAgeBtn setBackgroundImage:ImageNamed(@"icon_select_on") forState:UIControlStateSelected];
        [_hiddenAgeBtn addTarget:self action:@selector(hiddenAgeclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hiddenAgeBtn;
}

- (UILabel *)ageLabel
{
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.text = @"隐藏年龄";
        _ageLabel.textColor = ThemeColor;
        _ageLabel.font = FONT(16);
        [_ageLabel sizeToFit];
    }
    return _ageLabel;
}


- (UIPickerView *)sexPickView
{
    if (!_sexPickView) {
        _sexPickView = [[UIPickerView alloc] init];
        _sexPickView.backgroundColor = [UIColor whiteColor];
        _sexPickView.delegate = self;
        
    }
    return _sexPickView;
}

- (UIPickerView *)jobPickView
{
    if (!_jobPickView) {
        _jobPickView = [[UIPickerView alloc] init];
        _jobPickView.backgroundColor = [UIColor whiteColor];
        _jobPickView.delegate = self;
    }
    return _jobPickView;
}

- (UIPickerView *)eduPickView
{
    if (!_eduPickView) {
        _eduPickView = [[UIPickerView alloc] init];
        _eduPickView.backgroundColor = [UIColor whiteColor];
        _eduPickView.delegate = self;
    }
    return _eduPickView;
}

- (UIPickerView *)areaPickView
{
    if (!_areaPickView) {
        _areaPickView = [[UIPickerView alloc] init];
        _areaPickView.backgroundColor = [UIColor whiteColor];
        _areaPickView.delegate = self;
        //定义一个index，找出第一个滚动条里面的所有省对应的下标找出来，赋值给index
        NSInteger index=[_areaPickView selectedRowInComponent:0];
        
        [self.cityArr removeAllObjects];
        provinceName = self.plistArray[index][@"provinceName"];
        for (NSDictionary *city in self.plistArray[index][@"citylist"])
        {
            //将遍历出来市追加到存放市的集合里
            [self.cityArr addObject:city];
            
        }
        [self.areaPickView reloadComponent:1];
        //刷新县区
        [self.areaArr removeAllObjects];
        NSInteger index2=[_areaPickView selectedRowInComponent:1];
        cityName = self.cityArr[index2][@"cityName"];
        for (NSDictionary *area in self.cityArr[index2][@"arealist"])
        {
            //将遍历出来市追加到存放市的集合里
            [self.areaArr addObject:area];
            
        }
        [self.areaPickView reloadComponent:2];
    }
    return _areaPickView;
}

- (UILabel *)lastLabel
{
    if (!_lastLabel) {
        _lastLabel = [[UILabel alloc] init];
        _lastLabel.hidden = YES;
        [_lastLabel sizeToFit];
        _lastLabel.font = FONT(16);
        _lastLabel.textColor = TextMianColor;
        _lastLabel.text = @"截止时间";
    }
    return _lastLabel;
}

- (UILabel *)specLb
{
    if (!_specLb) {
        _specLb = [[UILabel alloc] init];
        _specLb.hidden = YES;
        [_specLb sizeToFit];
        _specLb.centerX = 0;
        _specLb.top = 23;
        _specLb.font = FONT(10);
        _specLb.textColor = TextSecondaryColor;
        _specLb.text = @"报名截止时间与活动开始时间需间隔至少3小时";
    }
    return _specLb;
}


#pragma mark -- 重写setter方法
- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        if ([title isEqualToString:@"截止时间"]) {
            self.titleLabel.hidden = YES;
            self.specLb.hidden = NO;
            self.lastLabel.hidden = NO;
        }else{
            
        self.titleLabel.text = title;
        }
    }
}

- (void)setHiddenAge:(BOOL)hiddenAge
{
    if (_hiddenAge!=hiddenAge) {
        _hiddenAge = hiddenAge;
        [self addSubview:self.hiddenAgeBtn];
        [self addSubview:self.ageLabel];
        self.titleLabel.text = @"请选择出生日期";
        [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];

        
        [_hiddenAgeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.datePick.mas_bottom).offset(8);
            make.right.mas_equalTo(-89);
            make.height.width.mas_equalTo(22);
        }];
        
        
        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.datePick.mas_bottom).offset(8);
            make.right.mas_equalTo(-15);
            make.height.equalTo(@(22));
        }];

    }

}

- (void)setPickType:(MFPickType)pickType
{
    if (_pickType != pickType) {
        _pickType = pickType;
        switch (pickType) {
            case MFDatePick:
                self.datePick.hidden = NO;
                break;
            case MFSexPick:
            {
                _datePick.hidden = YES;
                self.hiddenAge = NO;
                
                self.sexArray = @[@"女",@"男"];
                
                [self addSubview:self.sexPickView];
                self.titleLabel.text = @"选择性别";
                [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
                [self.sexPickView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tabBarView.mas_bottom);
                    make.left.right.equalTo(self);
                    make.height.equalTo(@(215));
                }];
            }
                break;
            case MFJobPick:
            {
                _datePick.hidden = YES;
                self.hiddenAge = NO;
                
                self.jobArray = @[@"学生",@"自由职业者",@"互联网/IT",@"房地产",@"公务员"];
                [self addSubview:self.jobPickView];
                self.titleLabel.text = @"选择职业";
                [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
                [self.jobPickView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tabBarView.mas_bottom);
                    make.left.right.equalTo(self);
                    make.height.equalTo(@(215));

                }];


            }
                break;
            case MFEduPick:
            {
                _datePick.hidden = YES;
                self.hiddenAge = NO;
                
                self.eduArray = @[@"大专",@"本科",@"硕士",@"博士",@"其他"];
                [self addSubview:self.eduPickView];
                self.titleLabel.text = @"选择学历";
                [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
                [self.eduPickView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tabBarView.mas_bottom);
                    make.left.right.equalTo(self);
                    make.height.equalTo(@(215));
                    
                }];

            }
                break;
            case MFAreaPick:
            {
                _datePick.hidden = YES;
                self.hiddenAge = NO;
                
                
                [self addSubview:self.areaPickView];
                self.titleLabel.text = @"选择地区";
                [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
                [self.areaPickView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tabBarView.mas_bottom);
                    make.left.right.equalTo(self);
                    make.height.equalTo(@(215));

                }];
            }
                break;
            default:
                break;
        }

    }
}



#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == self.areaPickView) {
        return 3;
    }else{
        return 1;
    }
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == self.eduPickView) {
        return self.eduArray.count;
    }else if (pickerView == self.sexPickView){
        return self.sexArray.count;
    }else if (pickerView == self.jobPickView){
        return self.jobArray.count;
    }else{
        NSInteger result = 0;
        switch (component) {
            case 0:
                result = self.plistArray.count;//根据数组的元素个数返回几行数据
                break;
            case 1:
                result = self.cityArr.count;
                break;
            case 2:
                result = self.areaArr.count;
                break;
                
            default:
                break;
        }
        return result;
    }
    
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == self.sexPickView) {
        
        return self.sexArray[row];
        
    }else if (pickerView == self.eduPickView){
        
        return self.eduArray[row];
        
    }else if (pickerView == self.jobPickView){
        
        return self.jobArray[row];
        
    }else{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.plistArray[row][@"provinceName"];
            break;
        case 1:
            title = self.cityArr[row][@"cityName"];
            break;
        case 2:
            title = self.areaArr[row][@"areaName"];
            break;
        default:
            break;
    }
    return title;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.sexPickView) {
        self.sexStr = self.sexArray[row];
        if (self.dateChangeBlock) {
            self.dateChangeBlock(self.sexStr);
        }
    }else if (pickerView == self.jobPickView){
        self.jobStr = self.jobArray[row];
        if (self.dateChangeBlock) {
            self.dateChangeBlock(self.jobStr);
        }
    }else if (pickerView == self.eduPickView){
        self.eduStr = self.eduArray[row];
        if (self.dateChangeBlock) {
            self.dateChangeBlock(self.eduStr);
        }
    }else if (pickerView == self.areaPickView){
        if (component == 0) {
            [self.cityArr removeAllObjects];
            
            //定义一个index，找出第一个滚动条里面的所有省对应的下标找出来，赋值给index
            NSInteger index=[pickerView selectedRowInComponent:0];
            provinceName = self.plistArray[index][@"provinceName"];
            for (NSDictionary *city in self.plistArray[index][@"citylist"])
            {
                //将遍历出来市追加到存放市的集合里
                [self.cityArr addObject:city];
                
            }
            cityName = self.cityArr[0][@"cityName"];
            [self.areaArr removeAllObjects];

            for (NSDictionary *area in self.cityArr[0][@"arealist"])
            {
                //将遍历出来市追加到存放市的集合里
                [self.areaArr addObject:area];
                
            }
            areaName = self.areaArr[0][@"areaName"];
            [self.areaPickView reloadComponent:1];
            [self.areaPickView reloadComponent:2];
            [self.areaPickView selectRow:0 inComponent:1 animated:NO];
            [self.areaPickView selectRow:0 inComponent:2 animated:NO];
        }else if (component == 1) {
            [self.areaArr removeAllObjects];
            NSInteger index=[pickerView selectedRowInComponent:1];
            cityName = self.cityArr[index][@"cityName"];
            for (NSDictionary *area in self.cityArr[index][@"arealist"])
            {
                //将遍历出来市追加到存放市的集合里
                [self.areaArr addObject:area];
                
            }
            areaName = self.areaArr[0][@"areaName"];
            [self.areaPickView reloadComponent:2];
            [self.areaPickView selectRow:0 inComponent:2 animated:NO];
        }else {
            NSInteger index=[pickerView selectedRowInComponent:2];
            areaName = self.areaArr[index][@"areaName"];

        }
        
        self.areaStr = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,areaName];
        if (self.dateChangeBlock) {
            self.dateChangeBlock(self.areaStr);
        }
    }
    

}


@end
