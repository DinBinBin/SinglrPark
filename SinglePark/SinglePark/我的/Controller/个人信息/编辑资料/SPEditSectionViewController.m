//
//  SPEditSectionViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/10.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPEditSectionViewController.h"

@interface SPEditSectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITextField *field;
@end

@implementation SPEditSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _field = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, kScreenW-20, 45)];
    _field.font = Font14;
    _field.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setupUI {
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.tableView];
    switch (self.type) {
        case SPSexEditType:
            self.title = @"性别";
            [self.dataSource removeAllObjects];
            self.dataSource = [NSMutableArray arrayWithArray:@[@"男",@"女"]];
            break;
        case SPAgeEditType:
            self.title = @"年龄";
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:@"保密"];
            for (int a = 18; a < 41; a++) {
                NSString *age = [NSString stringWithFormat:@"%d岁",a];
                [self.dataSource addObject:age];
            }
            [self.dataSource addObject:@"40以上"];
            break;
        case SPJobEditType:
        {
            self.title = @"职业";
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"完成" target:self action:@selector(finishClick) Itemcolor:[UIColor whiteColor]];
            [self requestDataWithURL:SPURL_API_Job];
            break;
        }
        case SPUnitEditType:
            self.title = @"单位";
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"完成" target:self action:@selector(finishClick) Itemcolor:[UIColor whiteColor]];
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:@"保密"];
            break;
        case SPUniversityEditType:
            self.title = @"毕业学校";
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"完成" target:self action:@selector(finishClick) Itemcolor:[UIColor whiteColor]];
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:@"保密"];
            break;
        case SPEducationEditType:
            self.title = @"学历";
            [self.dataSource removeAllObjects];
            self.dataSource = [NSMutableArray arrayWithArray:@[@"小学",@"初中",@"高中",@"专科",@"大学",@"硕士",@"博士",@"博士后"]];
            [self.tableView reloadData];
            break;
        case SPAreaEditType:
            self.title = @"地区";
            break;
        case SPHeightEditType:
            self.title = @"身高";
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:@"保密"];
            for (int a = 140; a < 191; a++) {
                NSString *age = [NSString stringWithFormat:@"%dcm",a];
                [self.dataSource addObject:age];
            }
            [self.dataSource addObject:@"190cm以上"];
            break;
        case SPWeightEditType:
            self.title = @"体重";
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:@"保密"];
            [self.dataSource addObject:@"40kg以下"];
            for (int a = 40; a < 101; a++) {
                NSString *age = [NSString stringWithFormat:@"%dkg",a];
                [self.dataSource addObject:age];
            }
            [self.dataSource addObject:@"100kg以上"];
            break;
        case SPIncomeEditType:
            self.title = @"年收入";
            [self.dataSource removeAllObjects];
            self.dataSource = [NSMutableArray arrayWithArray:@[@"5万-",@"5万+",@"10万+",@"20万+",@"50万+",@"100万+",@"保密"]];
            break;
            
        default:
            break;
    }
}

- (void)requestDataWithURL:(NSString *)url {
    WEAKSELF
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:url parameters:nil success:^(id responseObject) {
        STRONGSELF
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [self.dataSource removeAllObjects];
            NSArray *arr = responseDic[@"data"];
            for (int a = 0; a < arr.count; a++) {
                NSDictionary *dic = arr[a];
                if (self.type == SPJobEditType) {//职业列表
                    [self.dataSource addObject:dic[@"name"]];
                }
                
            }
            
            [strongSelf.tableView reloadData];
        }else {
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];

        }
        [MBProgressHUD hideHUDForView:self.view];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showMessage:Networkerror];
        JDWLog(@"%@",error.localizedDescription);
    }];
    
    
}

- (void)finishClick {
    if (self.SPCallBackStringBlock) {
        self.SPCallBackStringBlock(_field.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == SPJobEditType || self.type == SPUnitEditType || self.type == SPUniversityEditType) {
        return 2;
    }
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == SPJobEditType || self.type == SPUnitEditType || self.type == SPUniversityEditType) {
        if (section == 0) {
            return 1;
        }else{
            return self.dataSource.count;
        }
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.font = Font14;
        cell.textLabel.textColor = SecondWordColor;
    }
    
    if (self.type == SPJobEditType || self.type == SPUnitEditType || self.type == SPUniversityEditType) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                NSString *holderText;

                if (self.type == SPJobEditType) {
                    holderText = @"手动填写我的职业名称";
                }else if (self.type == SPUnitEditType) {
                    holderText = @"手动填写所在单位名称";
                   
                }else if (self.type == SPUniversityEditType) {
                    holderText = @"手动填写毕业学校名称";
                    
                }
                NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
                
                [placeholder addAttribute:NSFontAttributeName
                                    value:Font14
                                    range:NSMakeRange(0, holderText.length)];
                _field.attributedPlaceholder = placeholder;
                [cell.contentView addSubview:_field];
            }
            
        }else{
            cell.textLabel.text = self.dataSource[indexPath.row];
        }
        
        return cell;

    }
    
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.SPCallBackStringBlock) {
        self.SPCallBackStringBlock(self.dataSource[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = PTBackColor;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
