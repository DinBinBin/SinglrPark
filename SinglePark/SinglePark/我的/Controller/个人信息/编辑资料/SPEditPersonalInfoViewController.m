//
//  SPEditPersonalInfoViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/7.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPEditPersonalInfoViewController.h"
#import "SPMineHeadCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SPEditNickNameViewController.h"
#import "SPEditSectionViewController.h"
#import "SPAreaViewController.h"
#import "MFDatePickView.h"
#import "SPCityModel.h"
#import "QiniuSDK.h"


@interface SPEditPersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SPSelectDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *detailArr;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SPPersonModel *model;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *qiniuToken;
/** 添加遮罩 */
@property (nonatomic, strong) UIView *alertBackgroundView;
@property (nonatomic, strong) UITextField *fakeTextField;
@end

@implementation SPEditPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";

    self.titleArr = @[
                      @[@"头像",@"昵称"],
                      @[@"性别",@"生日"],
                      @[@"职业",@"所在单位"],
                      @[@"毕业学校",@"学历"],
                      @[@"地区"],
                      @[@"身高",@"体重"],
                      @[@"年收入"],
                      @[@"三观签名"],
                      @[@"引荐人",@"我的邀请码"]
                      ];
    self.detailArr = [NSMutableArray arrayWithArray:@[
                                                      @[@"",@""],
                                                      @[@"",@""],
                                                      @[@"",@""],
                                                      @[@"",@""],
                                                      @[@""],
                                                      @[@"",@""],
                                                      @[@""],
                                                      @[@""],
                                                      @[@"",@""]
                                                      ]];
    
    [self setupUI];
    
    [self requestData];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
}

- (void)requestData {
    WEAKSELF
    STRONGSELF
    [JDWNetworkHelper POST:PTURL_API_UserGet parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [strongSelf.detailArr removeAllObjects];
            SPPersonModel *model = [SPPersonModel modelWithJSON:responseDic[@"data"]];
            strongSelf.model = model;
            
            [strongSelf requestProvinceName];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
}

- (void)requestProvinceName {
    WEAKSELF
    STRONGSELF
    NSString *strId = [NSString stringWithFormat:@"%ld",[DBAccountInfo sharedInstance].model.province_id];
    NSString *url = [SPURL_API_CityName stringByAppendingPathComponent:strId];
    [MBProgressHUD showLoadToView:self.view];

    [JDWNetworkHelper POST:url parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            
            [strongSelf.detailArr removeAllObjects];
            SPCityModel *model = [SPCityModel modelWithJSON:responseDic[@"data"]];
            NSString *name = [NSString stringWithFormat:@"%@ %@",strongSelf.model.areaName ?:@"",model.name];
            strongSelf.model.areaName = name;
            
            [strongSelf requestCityName];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
}

- (void)requestCityName {
    NSString *strId = [NSString stringWithFormat:@"%ld",[DBAccountInfo sharedInstance].model.city_id];
    NSString *url = [SPURL_API_CityName stringByAppendingPathComponent:strId];
    
    WEAKSELF
    STRONGSELF
    [JDWNetworkHelper POST:url parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            
            [strongSelf.detailArr removeAllObjects];
            SPCityModel *model = [SPCityModel modelWithJSON:responseDic[@"data"]];
            NSString *name = [NSString stringWithFormat:@"%@ %@",strongSelf.model.areaName ?:@"",model.name];
            strongSelf.model.areaName = name;
            
            [strongSelf requestDistrictName];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
    
}
- (void)requestDistrictName {
    NSString *strId = [NSString stringWithFormat:@"%ld",[DBAccountInfo sharedInstance].model.district_id];
    NSString *url = [SPURL_API_CityName stringByAppendingPathComponent:strId];
    WEAKSELF
    STRONGSELF
    
    [JDWNetworkHelper POST:url parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [strongSelf.detailArr removeAllObjects];
            SPCityModel *model = [SPCityModel modelWithJSON:responseDic[@"data"]];
            NSString *name = [NSString stringWithFormat:@"%@ %@",strongSelf.model.areaName ?: @"",model.name];
            strongSelf.model.areaName = name;
            [strongSelf reloadDataSource];
            
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        [MBProgressHUD hideHUDForView:strongSelf.view];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
        [MBProgressHUD hideHUDForView:strongSelf.view];
        
    }];
    
}




- (void)reloadDataSource {
    
    
    NSString *sex;
    if (_model.sex == 0) {
        sex = @"未填写";
    }else if (_model.sex == 1){
        sex = @"男";
    }else{
        sex = @"女";
    }
    
    self.detailArr = [NSMutableArray arrayWithArray:@[
                                                      @[self.model.avatar ?: @"logo",self.model.nickName ?: @"未填写"],
                                                        @[sex,self.model.birthday ?: @"未填写"],
                                                        @[self.model.job.firstObject?:@"未填写",self.model.unit ?: @"未填写"],
                                                        @[self.model.university ?:@"未填写",self.model.education ?:@"未填写"],
                                                        @[self.model.areaName ?:@"未填写"],
                                                        @[self.model.height ?:@"未填写",self.model.weight ?:@"未填写"],
                                                        @[self.model.income ?:@"未填写"],
                                                        @[self.model.signature ?:@"未填写"],
                                                        @[self.model.referrer ?:@"logo",self.model.invitationCode ?:@"未填写"]
                                                    ]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titleArr[section];
    return arr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SPMineHeadCell *headCell = [[[NSBundle mainBundle] loadNibNamed:@"SPMineHeadCell" owner:nil options:nil] firstObject];
            if (self.img) {
                headCell.headImageView.image = self.img;
            }else{
                [headCell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.detailArr[0][0]] placeholderImage:ImageNamed(@"logo")];
            }
            return headCell;
        }
    }else if (indexPath.section == 8) {
        if (indexPath.row == 0) {
            SPMineHeadCell *headCell = [[[NSBundle mainBundle] loadNibNamed:@"SPMineHeadCell" owner:nil options:nil] firstObject];
            headCell.headTitleLB.text = @"引荐人";
            return headCell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.font = Font16;
    cell.textLabel.textColor = SecondWordColor;
    cell.detailTextLabel.textColor = FirstWordColor;
    cell.detailTextLabel.font = Font16;
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.detailArr[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WEAKSELF
    STRONGSELF
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self selectCover];
        }else{//修改昵称
            SPEditNickNameViewController *vc = [[SPEditNickNameViewController alloc] init];            
            vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                strongSelf.model.nickName = str;
                [strongSelf reloadDataSource];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        SPEditSectionViewController *vc = [[SPEditSectionViewController alloc] init];
        
        if(indexPath.section == 1){
            
            if (indexPath.row == 0) {//修改性别
                vc.type = SPSexEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    if ([str isEqualToString:@"男"]) {
                        strongSelf.model.sex = 1;

                    }else{
                        strongSelf.model.sex = 2;
                    }
                    [strongSelf reloadDataSource];
                };
            }else{//修改生日日期
                
                [self.view addSubview:self.fakeTextField];
                [self.fakeTextField becomeFirstResponder];
                return;
            }
            
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {//修改职业
                vc.type = SPJobEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.job = @[str];
                    [strongSelf reloadDataSource];
                };
            }else{//修改所在单位
                vc.type = SPUnitEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.unit = str;
                    [strongSelf reloadDataSource];
                };
            }
        }else if (indexPath.section == 3) {
            if (indexPath.row == 0) {//毕业学校
                vc.type = SPUniversityEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.university = str;
                    [strongSelf reloadDataSource];
                };
            }else{//学历
                vc.type = SPEducationEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.education = str;
                    [strongSelf reloadDataSource];
                };
            }
        }else if (indexPath.section == 4) {//地区
            SPAreaViewController *area = [[SPAreaViewController alloc] init];
            area.delegate = self;
            [self.navigationController pushViewController:area animated:YES];
            return;
        }else if (indexPath.section == 5) {
            if (indexPath.row == 0) {//身高
                vc.type = SPHeightEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.height = str;
                    [strongSelf reloadDataSource];
                };
            }else{//体重
                vc.type = SPWeightEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.weight = str;
                    [strongSelf reloadDataSource];
                };
            }
        }else if (indexPath.section == 6) {
            vc.type = SPIncomeEditType;
            vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                strongSelf.model.income = str;
                [strongSelf reloadDataSource];
            };
        }
        
        [self.navigationController pushViewController:vc animated:YES];

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 8) {
        if (indexPath.row == 0) {
            return 70;
        }
    }

    return 45;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

#pragma mark - SPJobDelegate

- (void)selectAreaName:(NSString *)areaName {
    self.model.areaName = areaName;
    self.model.province_id = [DBAccountInfo sharedInstance].model.province_id;
    self.model.city_id = [DBAccountInfo sharedInstance].model.city_id;
    self.model.district_id = [DBAccountInfo sharedInstance].model.district_id;

    [self reloadDataSource];
}

#pragma mark - click
- (void)back {
    
    if (self.img) {
        [self commitHeadimg:self.img];
    }else{
        [self uploadUserInfo];
    }
    
}

- (void)uploadUserInfo {
    if (self.model == nil) {
        [self goback];

        return;
    }

    
    
    NSDictionary *parsms = @{
                             @"avatar":self.qiniuToken ?: @"",
                             @"nick_name":self.model.nickName ?: [DBAccountInfo sharedInstance].model.nickName ?: @"未填写",
                             @"sex":@(self.model.sex) ?: @([DBAccountInfo sharedInstance].model.sex) ?: @"未填写",
                             @"birthday":self.model.birthday ?: [DBAccountInfo sharedInstance].model.birthday ?: @"未填写",
                             @"job":self.model.job ?: [DBAccountInfo sharedInstance].model.job ?: @[@"未填写"],
                             @"province_id":@(self.model.province_id) ?: @([DBAccountInfo sharedInstance].model.province_id) ?: @"",
                             @"city_id":@(self.model.city_id) ?: @([DBAccountInfo sharedInstance].model.city_id) ?: @"",
                             @"district_id":@(self.model.district_id) ?: @([DBAccountInfo sharedInstance].model.district_id) ?: @"",
                             @"height":self.model.height ?:[DBAccountInfo sharedInstance].model.height ?: @"未填写",
                             @"weight":self.model.weight ?: [DBAccountInfo sharedInstance].model.weight ?: @"未填写"
                             };
    WEAKSELF
    STRONGSELF
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:PTURL_API_UserChage parameters:parsms success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:strongSelf.view];
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            //            [MBProgressHUD showMessage:@"修改成功"];
        }else{
            [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
        }
        
        [self goback];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:strongSelf.view];
        [MBProgressHUD showAutoMessage:Networkerror];
        
        [self goback];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
    
}

- (void)goback {
    
    //保存用户信息
    [DBAccountInfo sharedInstance].model=self.model;
    [JDWUserInfoDB saveUserInfo:[DBAccountInfo sharedInstance].model];
    
    if (self.backRequsetBlock) {
        self.backRequsetBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    }
    
}

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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage  *img = [self scaleToSize:[info objectForKey:@"UIImagePickerControllerEditedImage"] size:CGSizeMake(300, 300)];
    self.img = img;
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    SPMineHeadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView reloadData];
//    if (indexPath.section == 0) {
//        [self commitHeadimg:self.img];
//
//    }
    
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
        [self goback];

    }
}
- (void)gettoken:(NSString *)filePath{
    
    WEAKSELF
    STRONGSELF
    [MBProgressHUD showLoadToView:self.view];
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
                strongSelf.model.avatar = SPURL_API_Img(resp[@"key"]);
                strongSelf.qiniuToken = resp[@"key"];

                [strongSelf uploadUserInfo];

            }
                        option:uploadOption];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
        

    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self goback];

    }];
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField == self.fakeTextField) {
        WEAKSELF
        STRONGSELF
        UIView  *alertBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        self.alertBackgroundView = alertBackgroundView;
        alertBackgroundView.backgroundColor = UIColorFromHEX(0x000000, 0.5);
        [[UIApplication sharedApplication].keyWindow addSubview:alertBackgroundView];
        alertBackgroundView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            strongSelf.alertBackgroundView.alpha = 1;
        }];
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        
        tap.delegate = self;
        
        //2.添加手势
        [self.alertBackgroundView addGestureRecognizer:tap];
        
        
    }
}



#pragma mark - 时间选择器
-(void)setupDatePick{
    WEAKSELF
    STRONGSELF
    MFDatePickView *datePickView = [[MFDatePickView alloc]initWithFrame:CGRectMake(0, 408, kScreenW, 216 + 44)];
    datePickView.pickType = MFDatePick;
    datePickView.cancelBtnDidClickBlock = ^(){
        
        [strongSelf.fakeTextField resignFirstResponder];
        [strongSelf.alertBackgroundView removeFromSuperview];
        
    };
    datePickView.doneBtnDidClickBlock = ^(NSString *str){
        
        [strongSelf.fakeTextField resignFirstResponder];
        [strongSelf.alertBackgroundView removeFromSuperview];
        strongSelf.model.birthday = str;
        [strongSelf reloadDataSource];
        
    };
    datePickView.selectDateBlock = ^(NSDate *date){
        
        //把当前的日期给文本框赋值
        //获取当前选中的日期
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        
        self.model.birthday = [fmt stringFromDate:date];;
        [strongSelf reloadDataSource];

    };
    //日期键盘
    self.fakeTextField.inputView = datePickView;
    
}


//点击遮罩
-(void)tap{
    
    [self.fakeTextField resignFirstResponder];
    [self.alertBackgroundView removeFromSuperview];
}


#pragma mark - Lazy
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = PTBackColor;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UITextField *)fakeTextField {
    if (!_fakeTextField) {
        _fakeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, -100, 50, 50)];
        _fakeTextField.delegate = self;
        [self setupDatePick];
    }
    return _fakeTextField;
}


@end
