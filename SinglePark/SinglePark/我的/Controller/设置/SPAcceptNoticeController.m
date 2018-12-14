//
//  SPAcceptNoticeController.m
//  SinglePark
//
//  Created by DBB on 2018/10/20.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPAcceptNoticeController.h"

@interface SPAcceptNoticeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;

@end

@implementation SPAcceptNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新消息通知";

    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}


#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.textColor = FirstWordColor;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"接收新消息通知";
        UISwitch *mySwitch = [UISwitch new];
        mySwitch.onTintColor = ThemeColor;
        mySwitch.on = [self checkUserNotificationSetting];
        [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

        cell.accessoryView = mySwitch;
        return cell;
 
        
    }else {
        cell.textLabel.text = @"通知显示消息详情";
        UISwitch *mySwitch = [UISwitch new];
        mySwitch.onTintColor = ThemeColor;
        mySwitch.on = YES;
        cell.accessoryView = mySwitch;
        return cell;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *labview = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
   
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, kScreenWidth-36, 55)];
    
    lab.font = Font14;
    lab.textColor = SecondWordColor;
    lab.numberOfLines = 0;
    [labview addSubview:lab];
    if (section == 0) {
        lab.text = @"您若要关闭或者开启新消息通知，先找到iPhone的“设置”—“通知”功能，再找到应用程序“单身公园”更改。";

    }else{
        lab.text = @"如果您选择关闭，当收到消息时，通知提示将不显示发信人和内容摘要";

    }
    return labview;
}

- (BOOL)checkUserNotificationSetting {
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            NSLog(@"推送关闭");
            return NO;
        }else{
            NSLog(@"推送打开");
            return YES;
        }
    }
    return NO;
    
}

-(void)switchAction:(id)sender
{
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

- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        _listTabView.tableFooterView = [[UIView alloc] init];
        _listTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}

@end
