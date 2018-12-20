//
//  SPEditNickNameViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/10.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPEditNickNameViewController.h"

@interface SPEditNickNameViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UILabel *residueLabel;
@end

@implementation SPEditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    self.str = @"请输入您要修改的昵称";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"完成" target:self action:@selector(finishClick) Itemcolor:[UIColor whiteColor]];
    
    [self.view addSubview:self.textView];
    [self.textView addSubview:self.placeHolderLabel];
    [self.view addSubview:self.residueLabel];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(10);
    }];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.textView).offset(10);
        make.width.equalTo(self.textView.mas_width).offset(-14);
    }];
    [self.residueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.mas_equalTo(300);
        //        make.right.mas_equalTo(200);
        
        make.bottom.equalTo(self.textView.mas_bottom).offset(-10);
        make.right.equalTo(self.textView.mas_right).offset(-5);
        
    }];
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = Font16;
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeHolderLabel{
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = FONT(16);
        _placeHolderLabel.textColor = SecondWordColor;
        _placeHolderLabel.text = self.str;
        _placeHolderLabel.backgroundColor =[UIColor clearColor];
        
    }
    return _placeHolderLabel;
}

- (UILabel *)residueLabel{
    if (_residueLabel == nil) {
        _residueLabel = [[UILabel alloc] init];
        _residueLabel.backgroundColor = [UIColor clearColor];
        _residueLabel.font = FONT(12);
        _residueLabel.text = @"8/8";
        _residueLabel.textColor = SecondWordColor;
    }
    return _residueLabel;
}

-(void)finishClick{
    if (self.SPCallBackStringBlock) {
        self.SPCallBackStringBlock(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text length] == 0){
        
        self.placeHolderLabel.text = self.str;
        
    }else{
        self.placeHolderLabel.text = @"";//这里给空
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    
    
    if([textView.text length] == 0){
        
        self.placeHolderLabel.text = self.str;
        
    }else{
        
        self.placeHolderLabel.text = @"";//这里给空
        
    }
    
    
    //最大长度
    NSInteger kMaxLength = 8;
    
    
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
                [textView resignFirstResponder];
            }
        }
        
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLength) {
            
            textView.text = [toBeString substringToIndex:kMaxLength];
            
        }
        
    }
    
    self.residueLabel.text = [NSString stringWithFormat:@"%lu/8",(unsigned long)textView.text.length];

    
}

//设置超出最大字数（200字）即不可输入 也是textview的代理方法

//-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//{

//    if ([text isEqualToString:@"\n"]) {     //这里"\n"对应的是键盘的 return 回收键盘之用
//
//        [textView resignFirstResponder];
//        return YES;
//    }
//    if (range.location >= 8)
//    {
//        return NO;
//    }else
//    {
//        return YES;
//    }
//}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
