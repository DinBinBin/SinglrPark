//
//  JDWFillEditController.m
//  JDWin_B
//
//  Created by DBB1 on 2018/6/20.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import "JDWFillEditController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JDWFillEditController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UILabel *residueLabel;
@property (nonatomic,strong)UIButton *subitBtn;
@property (nonatomic,strong)UIButton *reduceBtn;
@property (nonatomic,strong)UIImage *img;

@end

@implementation JDWFillEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.str = @"这个软件很不错，我还要使用~这里是意见反馈输入框，可以输入400个文字，可以添加1个图片";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"提交" target:self action:@selector(finishClick) Itemcolor:[UIColor whiteColor]];
    
    [self.view addSubview:self.textView];
    [self.textView addSubview:self.placeHolderLabel];
    [self.view addSubview:self.residueLabel];
    [self.view addSubview:self.subitBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(300);
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
    
    [self.subitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.width.height.mas_equalTo(60);
    }];
   
}
- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeHolderLabel{
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = FONT(14);
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
        _residueLabel.text = @"400/400";
        _residueLabel.textColor = SecondWordColor;
    }
    return _residueLabel;
}

- (UIButton *)subitBtn{
    if (_subitBtn == nil) {
        _subitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_subitBtn setBackgroundImage:[UIImage imageNamed:@"button_tijiao"] forState:UIControlStateNormal];
        [_subitBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [_subitBtn addTarget:self action:@selector(suppot) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subitBtn;
}
- (UIButton *)reduceBtn{
    if (_reduceBtn == nil) {
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceBtn setTitle:@"X" forState:UIControlStateNormal];
//        [_reduceBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}


// 拍照
- (void)reduce{
    self.subitBtn.enabled = YES;
    [self.subitBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    self.img = nil;
    [self.reduceBtn removeFromSuperview];
}

- (void)suppot{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openPhotoWithType:1];
    }];
    
    [photo setValue:TextMianColor forKey:@"_titleTextColor"];
    
    UIAlertAction * choice = [UIAlertAction actionWithTitle:@"从相册中选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openPhotoWithType:0];
    }];
    [choice setValue:TextMianColor forKey:@"_titleTextColor"];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:photo];
    [alertController addAction:choice];
    [alertController addAction:cancel];
    [self showDetailViewController:alertController sender:nil];

}

// 键盘放下
- (void)downKeyboard{
    
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
    
    //计算剩余字数   不需要的也可不写
    
    NSString *nsTextCotent = textView.text;
    
    NSInteger existTextNum = [nsTextCotent length];
    
    NSInteger remainTextNum = 400 - existTextNum;
    
    self.residueLabel.text = [NSString stringWithFormat:@"%ld/400",remainTextNum];
    
}

//设置超出最大字数（200字）即不可输入 也是textview的代理方法

-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
    if ([text isEqualToString:@"\n"]) {     //这里"\n"对应的是键盘的 return 回收键盘之用
        
        [textView resignFirstResponder];
        return YES;
    }
    if (range.location >= 400)
    {
        return NO;
    }else
    {
        return YES;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


// 提交
-(void)finishClick{
    if (!self.textView.text) {
        [MBProgressHUD showMessage:@"请输入您要反馈的意见"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)openPhotoWithType:(int)type
{
    if ([self getMediaTypeVideo]) {  //获取相机权限
        UIImagePickerControllerSourceType sourceType = type;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = TextMianColor;
        [picker.navigationBar setTitleTextAttributes:attrs];
        picker.navigationBar.tintColor = TextMianColor;
        [self  presentViewController:picker animated:YES completion:^{
            //            UIViewController *vc = picker.viewControllers.lastObject;
            //            UIBarButtonItem *cancelBtn = [vc valueForKey:@"imagePickerCancelButton"];
            //            UIButton *btn = [cancelBtn valueForKey:@"view"];
            //            [btn setTitleColor:TextMianColor forState:UIControlStateNormal];
        }];//进入照相界面
    }else{
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"请设置使用照片。\n请启用照片-设置/隐私/照片"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        NSLog(@"相机受限");
    }
}

-(bool)getMediaTypeVideo
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusRestricted){// 受限制 家长权限之类的
        return NO;
    } else if(author == ALAuthorizationStatusDenied){// 已经拒绝的
        
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"请设置使用照片。\n请启用照片-设置/隐私/照片"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        return NO;
    } else if(author == ALAuthorizationStatusAuthorized){// 已允许的
        
        return YES;
        
    } else if(author == ALAuthorizationStatusNotDetermined){// 还没决定的
        return YES;
        
    } else {
        return NO;
    }}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - imagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    //    NSLog(@"%@",info );
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage  *img = [self scaleToSize:[info objectForKey:@"UIImagePickerControllerEditedImage"] size:CGSizeMake(300, 300)];
    self.img = img;
    [self.subitBtn setImage:img forState:UIControlStateNormal];
    
    [self addreducebtn ];
    
}

- (void)commitHeadimg{
    
    
}

- (void)addreducebtn{
    [self.view addSubview:self.reduceBtn];
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.subitBtn);
        make.width.height.mas_equalTo(10);
    }];
    
}


@end
