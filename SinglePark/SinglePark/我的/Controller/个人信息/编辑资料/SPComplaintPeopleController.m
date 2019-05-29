//
//  SPComplaintPeopleController.m
//  SinglePark
//
//  Created by 斌斌戴 on 2019/5/28.
//  Copyright © 2019年 DBB. All rights reserved.
//

#import "SPComplaintPeopleController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QiniuSDK.h"

@interface SPComplaintPeopleController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)UILabel *residueLabel;
@property (nonatomic,strong)UIButton *subitBtn;
@property (nonatomic,strong)UIButton *reduceBtn;
@property (nonatomic,strong)UIImage *img;
@property (nonatomic,copy) NSString *coverPath;
@property (nonatomic,copy) NSString *avatar;

@end

@implementation SPComplaintPeopleController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉";
    self.str = @"请填写您对该用户的投诉内容，我们会尽快处理！";
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
        //        [_reduceBtn setTitle:@"X" forState:UIControlStateNormal];
        [_reduceBtn setImage:[UIImage imageNamed:@"deleteSP"] forState:UIControlStateNormal];
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
    
    
    //最大长度
    NSInteger kMaxLength = 400;
    
    
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
//
//-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//{
//
//    if ([text isEqualToString:@"\n"]) {     //这里"\n"对应的是键盘的 return 回收键盘之用
//
//        [textView resignFirstResponder];
//        return YES;
//    }
//    if (range.location >= 400)
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


// 提交
-(void)finishClick{
    if (!self.textView.text) {
        [MBProgressHUD showMessage:@"请输入您投诉的理由"];
        return;
    }
    
    
    
    NSDictionary *parameters = @{@"content" : self.textView.text,
                                 @"pics" : self.avatar ?:@"",
                                 @"t_uid":[NSString stringWithFormat:@"%d",self.model.userId]
                                 };
    
    WEAKSELF
    [JDWNetworkHelper POST:SPURL_API_Complaint parameters:parameters success:^(id responseObject) {
        STRONGSELF
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [MBProgressHUD showMessage:@"您已投诉成功，我们正在加紧处理！"];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        JDWLog(@"%@",error.localizedDescription);
    }];
    
    
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
    
    [self commitHeadimg:self.img];
}


- (void)commitHeadimg:(UIImage *)img{
    NSString *filePath = [kDocumentDirectoryPath stringByAppendingPathComponent:@"VideoImg"];
    
    self.coverPath = [filePath stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%5.2f.png",[[NSDate date] timeIntervalSince1970]]];  // 保存文件的名称
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
    };
    BOOL result =[UIImagePNGRepresentation(img)writeToFile:self.coverPath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
        [self gettoken:self.coverPath];
    }else{
        [MBProgressHUD showAutoMessage:@"选取失败"];
    }
}
- (void)gettoken:(NSString *)filePath{
    
    [JDWNetworkHelper POST:SPQiniuToken parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSString *qiniutoken = responseDic[@"data"][@"qiniu"];
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                NSLog(@"percent == %.2f", percent);
            }
                                                                         params:nil
                                                                       checkCrc:NO
                                                             cancellationSignal:nil];
            [upManager putFile:filePath key:nil token:qiniutoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info ===== %@", info);
                NSLog(@"resp ===== %@", resp);
                self.avatar = resp[@"key"];
                
            }
                        option:uploadOption];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
    }];
}


- (void)addreducebtn{
    [self.view addSubview:self.reduceBtn];
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.subitBtn);
        make.width.height.mas_equalTo(10);
    }];
    
}


@end
