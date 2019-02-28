//
//  SPPrivacyController.m
//  SinglePark
//
//  Created by DBB on 2018/10/20.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPrivacyController.h"
#import "SPProtectionController.h"
#import "SPBlacklistController.h"
#import "MFMapManager.h"


@interface SPPrivacyController ()<UITableViewDelegate,UITableViewDataSource,MapManagerLocationDelegate>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,strong)NSArray *titleArr;

@end

@implementation SPPrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私";
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getdata];
    

    
}

- (void)getdata{
    self.titleArr = @[@"地理位置信息",@"您若要关闭或者开启地理位置，先找到iPhone的“设置”—“隐私”—“定位服务”功能，再找到应用程序“单身公园”更改。",@"资料隐私保护",@"黑名单"];
    
    [self.listTabView reloadData];
    
}
#pragma mark ----UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.font = Font16;
    cell.textLabel.textColor = FirstWordColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        UISwitch *mySwitch = [UISwitch new];
        mySwitch.onTintColor = ThemeColor;
        mySwitch.on = YES;
        [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

        cell.accessoryView = mySwitch;
        return cell;
    }else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = nil;
        UILabel *lab = [[UILabel alloc] init];
        [cell.contentView addSubview:lab];
        lab.font = Font16;
        lab.textColor = SecondWordColor;
        lab.numberOfLines = 0;
        lab.text = self.titleArr[indexPath.row];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(18);
            make.top.equalTo(cell.contentView).offset(5);
            make.right.equalTo(cell.contentView.mas_right).offset(-5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
        }];

        return cell;
    }else if (indexPath.row == 2) {
        return cell;
    }else {
        return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
         if (indexPath.row == 2){  //隐私
            SPProtectionController *controller = [[SPProtectionController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (indexPath.row == 3){  //黑名单
            SPBlacklistController *controller = [[SPBlacklistController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
   
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


-(void)switchAction:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;

    if (sw.on) {
        //判断用户定位服务是否开启
        if ([CLLocationManager locationServicesEnabled]) {
            [self getLocation];
            
        }else {
            //不能定位用户的位置
            //1.提醒用户检查当前的网络状况
            //2.提醒用户打开定位开关
            if (UIApplicationOpenSettingsURLString != NULL) {
                UIApplication *application = [UIApplication sharedApplication];
                NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    if (@available(iOS 10.0, *)) {
                        [application openURL:URL options:@{} completionHandler:nil];
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    [application openURL:URL];
                }
            }
        }
    }

    
}


- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        _listTabView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}




@end
