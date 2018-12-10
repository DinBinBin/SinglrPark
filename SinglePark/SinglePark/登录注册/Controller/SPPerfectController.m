//
//  SPPerfectController.m
//  SinglePark
//
//  Created by DBB on 2018/9/13.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPerfectController.h"
#import "SPSupplementController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface SPPerfectController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *perfectTabView;
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UITextField *userNameField;
@property (nonatomic,strong)UIButton *maleBtn;
@property (nonatomic,strong)UIButton *femaleBtn;

@property (nonatomic,strong)UIButton *nextStepBtn;
@property (nonatomic,strong)UILabel *promptLab;
@property (nonatomic,strong)UIImage *img;
@property (nonatomic,assign)NSInteger sex;


@end

@implementation SPPerfectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善基本信息";
    self.sex = 0;
    [self.view addSubview:self.perfectTabView];
    [self.perfectTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (UITableView *)perfectTabView{
    if (_perfectTabView == nil) {
        _perfectTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64)];
        _perfectTabView.delegate  = self;
        _perfectTabView.dataSource = self;
        _perfectTabView.backgroundColor = PTBackColor;
        _perfectTabView.tableFooterView = [[UIView alloc] init];
    }
    return _perfectTabView;
}

- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.frame = CGRectMake(self.view.right-120,5, 100, 40);
        [_headBtn addTarget:self action:@selector(selectCover) forControlEvents:UIControlEventTouchUpInside];
        [_headBtn setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
        
    }
    return _headBtn;
}

- (UILabel *)promptLab{
    if (_promptLab == nil) {
        _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
        _promptLab.textColor = FirstWordColor;
        //        _mobileLab.textAlignment = NSTextAlignmentCenter;
        _promptLab.font = FONT(14);
        _promptLab.text = @"注意：性别选择后不能更改！";
    }
    return _promptLab;
}

- (UITextField *)userNameField{
    if (_userNameField == nil) {
        _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth-220, 50)];
        _userNameField.font = FONT(14);
        _userNameField.placeholder = @"请输入您的昵称";
        _userNameField.delegate = self;
        [_userNameField setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_userNameField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _userNameField;
}

- (UIButton *)maleBtn{
    if (_maleBtn == nil) {
        _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
        [_maleBtn setTitleColor:FirstWordColor forState:UIControlStateNormal];
        [_maleBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
        _maleBtn.frame = CGRectMake(self.view.right-120,5, 100, 40);
        WEAKSELF
        STRONGSELF
        [_maleBtn addBlockForControlEvents:UIControlEventTouchUpInside
                                     block:^(id  _Nonnull sender) {
                                         strongSelf.femaleBtn.selected = NO;
                                         strongSelf.maleBtn.selected = YES;
                                         strongSelf.sex = 1;
                                     }];
    }
    return _maleBtn;
}
- (UIButton *)femaleBtn{
    if (_femaleBtn == nil) {
        _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _femaleBtn.frame = CGRectMake(self.view.right-120,5, 100, 40);
        [_femaleBtn setTitle:@"女" forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:FirstWordColor forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
        WEAKSELF
        STRONGSELF
        [_femaleBtn addBlockForControlEvents:UIControlEventTouchUpInside
                                     block:^(id  _Nonnull sender) {
                                         strongSelf.maleBtn.selected = NO;
                                         strongSelf.femaleBtn.selected = YES;
                                         strongSelf.sex = 2;
                                     }];
    }
    return _femaleBtn;
}
- (UIButton *)nextStepBtn{
    if (_nextStepBtn == nil) {
        _nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        WEAKSELF
        STRONGSELF
        [_nextStepBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            if (!strongSelf.img) {
//                [MBProgressHUD showMessage:@"请选择头像"];
//                return ;
//
//            }
//            if (strongSelf.userNameField.text.length==0) {
//                [MBProgressHUD showMessage:@"请输入昵称"];
//                return ;
//            }
//            if (strongSelf.userNameField.text.length>8) {
//                [MBProgressHUD showMessage:@"昵称不能超过8个字称"];
//                return ;
//            }
//            if (strongSelf.sex == 0) {
//                [MBProgressHUD showMessage:@"请选择性别"];
//                return ;
//            }
            SPSupplementController *supple = [[SPSupplementController alloc] init];
            supple.img = strongSelf.img;
            [strongSelf.navigationController pushViewController:supple animated:YES];

            
//            NSData *dataimg = UIImageJPEGRepresentation(strongSelf.img, 1.0f);
//            NSString *encodedImageStr = [dataimg base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//
//            NSDictionary *parsms = @{
////                                     @"nick_name":strongSelf.userNameField.text,
//                                     @"sex":[NSString stringWithFormat:@"%ld",strongSelf.sex]
////                                     @"avatar":encodedImageStr
//                                     };
//            [JDWNetworkHelper POST:PTURL_API_UserChage parameters:parsms success:^(id responseObject) {
//                        NSDictionary *responseDic = (NSDictionary *)responseObject;
//                if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
//                    SPSupplementController *supple = [[SPSupplementController alloc] init];
//                    [strongSelf.navigationController pushViewController:supple animated:YES];
//                }else{
//                    [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
//                }
//                SPSupplementController *supple = [[SPSupplementController alloc] init];
//                [strongSelf.navigationController pushViewController:supple animated:YES];
//
//            } failure:^(NSError *error) {
//                [MBProgressHUD showAutoMessage:Networkerror];
//            }];
        }];
        _nextStepBtn.layer.cornerRadius = 5;
        _nextStepBtn.clipsToBounds = YES;
        _nextStepBtn.backgroundColor = ThemeColor;

    }
    return _nextStepBtn;
}

#pragma mark ----Tab delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 50;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.headBtn];
        [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView).offset(10);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
            make.width.height.mas_equalTo(Width(80));
        }];
        self.headBtn.layer.cornerRadius = Width(80)/2;
        self.headBtn.layer.masksToBounds = YES;
        
    }else if (indexPath.section == 1){
        UILabel *promptcellLab = [[UILabel alloc] init];
        [cell.contentView addSubview:promptcellLab];
        promptcellLab.textColor = FirstWordColor;
        promptcellLab.font = FONT(14);
        [promptcellLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(10);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        if (indexPath.row == 0) {
            promptcellLab.text = @"昵称：";
            [cell.contentView addSubview:self.userNameField];
            [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(promptcellLab.mas_right).offset(10);
                make.top.equalTo(promptcellLab);
                make.bottom.equalTo(promptcellLab.mas_bottom);
            }];
            
        }else{
            promptcellLab.text = @"性别：";
            [cell.contentView addSubview:self.maleBtn];
            [self.maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(promptcellLab.mas_right).offset(10);
                make.centerY.equalTo(cell.contentView);
            }];
            
            [cell.contentView addSubview:self.femaleBtn];
            [self.femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.maleBtn.mas_right).offset(10);
                make.top.equalTo(self.maleBtn);
            }];
        }
        
    }else{
        [cell.contentView addSubview:self.promptLab];
        [self.promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(20);
            make.top.equalTo(cell.contentView.mas_top).offset(15);
            
        }];
        
        [cell.contentView addSubview:self.nextStepBtn];
        [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.promptLab);
            make.top.equalTo(self.promptLab.mas_bottom).offset(15);
            make.right.equalTo(cell.contentView.mas_right).offset(-20);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        }];

        
    }
    
    
    return cell;
}

//上传头像
- (void)selectCover{
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
    [self.headBtn setImage:img forState:UIControlStateNormal];
    
}

- (void)commitHeadimg:(UIImage *)img{
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 0) {
        if (textField.text.length >= 8) {
            [MBProgressHUD showAutoMessage:@"昵称不能超过8个字"];
            return NO;
        }
    }
    
    return YES;
}


@end
