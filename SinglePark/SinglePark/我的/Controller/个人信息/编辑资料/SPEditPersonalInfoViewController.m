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

@interface SPEditPersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SPSelectDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *detailArr;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SPPersonModel *model;
@end

@implementation SPEditPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";

    self.titleArr = @[
                      @[@"头像",@"昵称"],
                      @[@"性别",@"年龄"],
                      @[@"职业",@"所在单位"],
                      @[@"毕业学校",@"学历"],
                      @[@"地区"],
                      @[@"身高",@"体重"],
                      @[@"年收入"],
                      @[@"三观签名"],
                      @[@"引荐人",@"我的邀请码"]
                      ];
    self.detailArr = [NSMutableArray arrayWithArray:@[
                                                      @[@"logo",@"宇宙超无敌美少女"],
                                                      @[@"女",@"18"],
                                                      @[@"工程师",@"平安中心"],
                                                      @[@"深圳大学",@"大学"],
                                                      @[@"广东 深圳"],
                                                      @[@"180CM",@"65KG"],
                                                      @[@"15w"],
                                                      @[@"存在即合理"],
                                                      @[@"logo",@"23KJHF2"]
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
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:PTURL_API_UserGet parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [strongSelf.detailArr removeAllObjects];
            SPPersonModel *model = [SPPersonModel modelWithJSON:responseDic[@"data"]];
            strongSelf.model = model;
            [strongSelf reloadDataSource];
            //保存用户信息
            [[DBAccountInfo sharedInstance].model yy_modelSetWithJSON:responseDic[@"data"]];
            [JDWUserInfoDB saveUserInfo:[DBAccountInfo sharedInstance].model];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];

        }
        [MBProgressHUD hideHUDForView:strongSelf.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:strongSelf.view];
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
    
    
}

- (void)reloadDataSource {
    NSString *sex;
    if ([_model.sex isEqualToString:@"0"]) {
        sex = @"未填写";
    }else if ([_model.sex isEqualToString:@"1"]){
        sex = @"男";
    }else{
        sex = @"女";
    }
    self.detailArr = [NSMutableArray arrayWithArray:@[
                                                      @[self.model.avatar ?: @"logo",self.model.nickName ?: @"未填写"],
                                                        @[sex,self.model.birthday ?: @"未填写"],
                                                        @[self.model.occupation?:@"未填写",self.model.unit ?: @"未填写"],
                                                        @[self.model.university ?:@"未填写",self.model.education ?:@"未填写"],
                                                        @[self.model.province_id ?:@"未填写"],
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
            headCell.headImageView.image = self.img ?: [UIImage imageNamed:@"logo"];

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
    
    cell.textLabel.font = Font14;
    cell.textLabel.textColor = SecondWordColor;
    cell.detailTextLabel.textColor = FirstWordColor;
    cell.detailTextLabel.font = Font14;
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
                    strongSelf.model.sex = str;
                    [strongSelf reloadDataSource];
                };
            }else{//修改年龄
                vc.type = SPAgeEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.birthday = str;
                    [strongSelf reloadDataSource];
                };
            }
            
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {//修改职业
                vc.type = SPJobEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.occupation = str;
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
        }else if (indexPath.section == 4) {
            SPAreaViewController *area = [[SPAreaViewController alloc] init];
            area.delegate = self;
            [self.navigationController pushViewController:area animated:YES];
            return;
        }else if (indexPath.section == 5) {
            if (indexPath.row == 0) {
                vc.type = SPHeightEditType;
                vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
                    strongSelf.model.height = str;
                    [strongSelf reloadDataSource];
                };
            }else{
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
    self.model.province_id = areaName;
    [self reloadDataSource];
}

#pragma mark - click
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
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.section == 0) {
        [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - Lazy
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = PTBackColor;
        _tableView.tableFooterView = [[UIView alloc] init];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}


@end
