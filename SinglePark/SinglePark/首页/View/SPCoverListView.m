//
//  SPCoverListView.m
//  SinglePark
//
//  Created by DBB on 2018/10/4.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCoverListView.h"
#import "SPCoverModel.h"
#import "SPCoverTabCell.h"
#import "SPPlayVideoController.h"
#import "SPPlayVideoController.h"

@interface SPCoverListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation SPCoverListView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setListUI];
        [self getdata];
    }
    return self;
}

- (void)setListUI{
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}


// 加载数据
- (void)getdata{
    NSString *choose;
    switch (self.choosetype) {
        case 1:
            choose = @"1";
            break;
        case 2:
            choose = @"2";

            break;
        case 3:
            choose = @"3";

            break;
        default:
            break;
    }
    
//    NSDictionary *parms = @{@"":@""};
    NSDictionary *dic = @{@"head":@"logo",
                          @"distance":@"距离----",
                          @"nickName":@"昵称----",
                          @"sex":@"nv",
                          @"videoCover":@"5"};
    SPCoverModel *model = [SPCoverModel modelWithJSON:dic];
    self.dataArr = [NSMutableArray array];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    [self.listTabView reloadData];
    
//    获取视频列表
    NSDictionary *params = @{@"":@""};
    [JDWNetworkHelper POST:SPQiniuToken parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
           
            
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
    }];
    
    
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPCoverTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.coverStr forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SPPlayVideoController *play = [[SPPlayVideoController alloc] init];
    [[self viewController].navigationController pushViewController:play animated:YES];
}


- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        self.coverStr = @"coverId";
        _listTabView.backgroundColor = PTBackColor;
        [_listTabView registerClass:[SPCoverTabCell class] forCellReuseIdentifier:self.coverStr];
        [self addSubview:_listTabView];
    }
    return _listTabView;
}

- (void)setChoosetype:(ChooseType)choosetype{
    if (_choosetype != choosetype) {
        _choosetype = choosetype;
        [self getdata];
    }
    
}
@end
