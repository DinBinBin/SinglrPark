//
//  SPBlacklistController.m
//  SinglePark
//
//  Created by DBB on 2018/10/20.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPBlacklistController.h"
#import "SPPursuitHeadTabCell.h"

@interface SPBlacklistController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,assign)NSInteger selItem;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,copy)NSString *balckStr;
@end

@implementation SPBlacklistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getdata];
}

- (void)getdata{
    self.dataArr = [NSMutableArray array];
    NSDictionary *dic1 = @{@"head":@"4",
                           @"occupation":@"距离----",
                           @"nickName":@"昵称----",
                           @"sex":@"1",
                           @"singer":@"伴着我的歌声是你心碎的幻想，你用你的眼泪抚摸我的寂寞",
                           @"didian":@"广东深圳",
                           @"number":@[@"4",@"4",@"4"]
                           };
    SPPersonModel *model = [[SPPersonModel alloc] initWithDataDic:dic1];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    [self.listTabView reloadData];
    
}
#pragma mark ----UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return    self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPPursuitHeadTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.balckStr forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}



- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        _listTabView.tableFooterView = [[UIView alloc] init];
        self.balckStr = @"balckStr";
        [_listTabView registerClass:[SPPursuitHeadTabCell class] forCellReuseIdentifier:self.balckStr];

        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}

@end
