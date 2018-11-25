//
//  SPFoundVC.m
//  SinglePark
//
//  Created by DBB on 2018/8/12.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPFoundVC.h"
#import "JDWFillEditController.h"

@interface SPFoundVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *foundTabView;

@end

@implementation SPFoundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.foundTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.imageView.image = [UIImage imageNamed:@""];
    cell.textLabel.text = @"向CEO吐槽";
    cell.textLabel.font = FONT(16);
    cell.textLabel.textColor = FirstWordColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JDWFillEditController *edit = [[JDWFillEditController alloc] init];
    [self.navigationController pushViewController:edit animated:YES];
}


- (UITableView *)foundTabView{
    if (_foundTabView == nil) {
        _foundTabView = [[UITableView alloc] init];
        _foundTabView.dataSource = self;
        _foundTabView.delegate = self;
        _foundTabView.backgroundColor = PTBackColor;
        _foundTabView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_foundTabView];
    }
    return _foundTabView;
}

@end
