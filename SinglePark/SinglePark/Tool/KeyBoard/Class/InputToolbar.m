//
//  InputToolbar.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define customKeyboardHeight 200
#define InputToolbarHeight 49
#define NavigationHeight 64

#import "InputToolbar.h"
#import "UIView+Extension.h"
#import "EmotionImages.h"

@interface InputToolbar ()<UITextViewDelegate,EmojiButtonViewDelegate>
@property (nonatomic, assign)CGFloat textInputHeight;
@property (nonatomic, assign)NSInteger TextInputMaxHeight;
@property (nonatomic, assign)NSInteger keyboardHeight;
@property (nonatomic,assign)BOOL showKeyboardButton; //YES: 显示键盘图标
@property (nonatomic,assign)BOOL showMoreViewButton; //YES: 显示显示非键盘
@property (nonatomic,assign)BOOL showVoiceViewButton; //YES: 显示显示非键盘

@property (nonatomic,strong)UIButton *sendBtn;



@end

@implementation InputToolbar

static InputToolbar* _instance = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[InputToolbar alloc] init] ;
    });
    return _instance ;
}

+ (instancetype)alloc
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] init] ;
    });
    return _instance ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        [self layoutUI];
    }
    self.backgroundColor = PTBackColor;
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardFrame.size.height;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:7];
    self.y = keyboardFrame.origin.y - self.height;
    [UIView commitAnimations];
    _inputToolbarFrameChange(self.height,_keyboardHeight);
    NSLog(@"1111111111111111%f---%f",keyboardFrame.size.height,SCREEN_HEIGHT);
    self.textInput.text = @"";
    self.keyboardIsVisiable = YES;
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.y = keyboardFrame.origin.y - self.height;
    }];
    _inputToolbarFrameChange(self.height,0);
    self.keyboardIsVisiable = NO;
    [self setShowKeyboardButton:NO];
}

- (void)layoutUI
{
    
    self.textInput = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 100, 36)];
    self.textInput.font = [UIFont systemFontOfSize:18];
    self.textInput.layer.cornerRadius = 3;
    self.textInput.layer.masksToBounds = YES;
    self.textInput.returnKeyType = UIReturnKeySend;
//    self.textInput setTextco
    self.textInput.enablesReturnKeyAutomatically = YES;
    self.textInput.delegate = self;
    [self addSubview:self.textInput];
    self.textUpload = [[UITextView alloc] init];
    self.textUpload.delegate = self;

    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textInput.frame) + 15, 9, 45, 30)];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = ThemeColor;
    self.sendBtn.titleLabel.font = FONT(15);
    [self.sendBtn setCornerRadius:5];
    [self.sendBtn addTarget:self action:@selector(sendmessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendBtn];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    _textInputHeight = ceilf([self.textInput sizeThatFits:CGSizeMake(self.textInput.bounds.size.width, MAXFLOAT)].height);
    self.textInput.scrollEnabled = _textInputHeight > _TextInputMaxHeight && _TextInputMaxHeight > 0;
    if (self.textInput.scrollEnabled) {
        self.textInput.height = 5 + _TextInputMaxHeight;
//        self.y = SCREEN_HEIGHT - _keyboardHeight - _TextInputMaxHeight - 5 - 8;
        self.height = _TextInputMaxHeight + 15;
    } else {
        self.textInput.height = _textInputHeight;
//        self.y = SCREEN_HEIGHT - _keyboardHeight - _textInputHeight - 5 - 8;
        self.height = _textInputHeight + 15;
    }
    _inputToolbarFrameChange(self.height,_keyboardHeight);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textInput.inputView = nil;
    self.textUpload.inputView = nil;
}

- (void)emojiButtonView:(EmojiButtonView *)emojiButtonView emojiText:(NSObject *)text
{
    if ([text isEqual: deleteButtonId]) {
        NSInteger location = self.textUpload.selectedRange.location;
        NSString *string = [self.textUpload.text substringToIndex:location];
        if ([string hasSuffix:@"]"]) {
            for (NSInteger i = string.length - 1; i >= 0; i --) {
                char c = [string characterAtIndex:i];
                [self.textUpload deleteBackward];
                if (c == '[') {
                    break;
                }
            }
            [self.textInput deleteBackward];
        } else {
            [self.textUpload deleteBackward];
            [self.textInput deleteBackward];
        }
        return;
    }
    if (![text isKindOfClass:[UIImage class]]) {
        [self.textInput replaceRange:self.textInput.selectedTextRange withText:(NSString *)text];
        [self.textUpload replaceRange:self.textUpload.selectedTextRange withText:(NSString *)text];
    } else {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        textAttachment.image = (UIImage *)text;
        textAttachment.bounds = CGRectMake(0, - 5, self.textInput.font.lineHeight + 2, self.textInput.font.lineHeight + 2);
        NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithAttributedString:self.textInput.attributedText];
        [strM replaceCharactersInRange:self.textInput.selectedRange withAttributedString:imageText];
        [strM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(self.textInput.selectedRange.location, 1)];
        self.textInput.attributedText = strM;
        self.textInput.selectedRange = NSMakeRange(self.textInput.selectedRange.location + 1,0);
        [self.textInput.delegate textViewDidChange:self.textInput];
        
        NSString *stringImage = [EmotionImages shareEmotinImages].emotions[[[EmotionImages shareEmotinImages].images indexOfObject:(UIImage *)text]];
        NSMutableString *mString = [NSMutableString stringWithString:self.textUpload.text];
        [mString replaceCharactersInRange:self.textUpload.selectedRange withString:stringImage];
        self.textUpload.text = mString;
        self.textUpload.selectedRange = NSMakeRange(self.textUpload.selectedRange.location + 1,0);
        [self.textInput.delegate textViewDidChange:self.textUpload];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //默认键盘删除键
    if ([text isEqualToString:@""]) {
        //确定光标位置并且删除
        NSInteger location = self.textUpload.selectedRange.location;
        NSString *string = [self.textUpload.text substringToIndex:location];
        if ([string hasSuffix:@"]"]) {
            for (NSInteger i = string.length - 1; i >= 0; i --) {
                char c = [string characterAtIndex:i];
                [self.textUpload deleteBackward];
                if (c == '[') {
                    break;
                }
            }
        } else {
            [self.textUpload deleteBackward];
        }
    }
    //键盘默认发送键
    if ([text isEqualToString:@"\n"]) {
        if (_sendContent) {
            _sendContent(self.textInput.text);
            self.y = SCREEN_HEIGHT - _keyboardHeight - InputToolbarHeight;
            _inputToolbarFrameChange(self.height,_keyboardHeight);
        }
        textView.text = nil;
        self.textUpload.text = nil;
        self.textInput.height = 36;
        self.height = InputToolbarHeight;
        [self endEditing:YES];
        return NO;
    }
    NSMutableString *mString = [NSMutableString stringWithString:self.textUpload.text];
    [mString replaceCharactersInRange:self.textUpload.selectedRange withString:text];
    self.textUpload.text = mString;

    return YES;
}





- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    
    // 默认的图片名
    NSString *image = @"liaotian_ic_biaoqing_nor";
    NSString *highImage = @"liaotian_ic_biaoqing_press";
    
    // 显示键盘图标
    if (showKeyboardButton) {
        image = @"liaotian_ic_jianpan_nor";
        highImage = @"liaotian_ic_jianpan_press";
    }
    
}

- (void)setIsBecomeFirstResponder:(BOOL)isBecomeFirstResponder
{
    if (isBecomeFirstResponder) {
        [self.textInput becomeFirstResponder];
        [self.textUpload becomeFirstResponder];
    } else {
        [self.textInput resignFirstResponder];
        [self.textUpload resignFirstResponder];
    }
}

- (void)setMorebuttonViewDelegate:(id)delegate
{
}

- (void)setTextViewMaxVisibleLine:(NSInteger)textViewMaxVisibleLine
{
    _textViewMaxVisibleLine = textViewMaxVisibleLine;
    _TextInputMaxHeight = ceil(self.textInput.font.lineHeight * (textViewMaxVisibleLine - 1) + self.textInput.textContainerInset.top + self.textInput.textContainerInset.bottom);
}

- (void)clearInputToolbarContent
{
    self.textInput.text = nil;
    self.textUpload.text = nil;
}

- (void)resetInputToolbar
{
    self.textInput.text = nil;
    self.textUpload.text = nil;
    self.textInput.height = 36;
    self.height = InputToolbarHeight;
}

//发送
- (void)sendmessage{
    if (self.textInput.text) {  //是否输入语言
        _sendContent(self.textInput.text);
        self.textInput.text = nil;
        self.textUpload.text = nil;
        self.textInput.height = 36;
        self.height = InputToolbarHeight;
        [self endEditing:YES];
    }else{
        [MBProgressHUD showMessage:@"输入不能为空"];
    }
}


@end
