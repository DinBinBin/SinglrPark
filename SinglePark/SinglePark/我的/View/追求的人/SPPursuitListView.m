//
//  SPPursuitListView.m
//  SinglePark
//
//  Created by DBB on 2018/10/21.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPursuitListView.h"
#import "SPPursuitHeadTabCell.h"
#import "SPBusinessCardController.h"


@interface SPPursuitListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *pursuitStr;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation SPPursuitListView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
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
    return self.promptArr.count + self.dataArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.font = FONT(14);
    cell.textLabel.textColor = FirstWordColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.promptArr.count) {
        cell.textLabel.text = self.promptArr[indexPath.row];
        cell.textLabel.numberOfLines = 0;
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArr.count];
        }else if (indexPath.row == 1){
//            NSInteger index = (self.promptArr.count == 3?0:1);

            
        }else if (indexPath.row == 2){
            
        }
        

        return cell;
    }else {
        SPPursuitHeadTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pursuitStr forIndexPath:indexPath];
        cell.model = self.dataArr[indexPath.row - self.promptArr.count];
        return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row - self.promptArr.count >= 0) {
        SPBusinessCardController *business = [[SPBusinessCardController alloc] init];
        business.model = self.dataArr[indexPath.row - self.promptArr.count];
    }
    
}




- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        _listTabView.tableFooterView = [[UIView alloc] init];
        self.pursuitStr = @"pursuitStr";
        [_listTabView registerClass:[SPPursuitHeadTabCell class] forCellReuseIdentifier:self.pursuitStr];
        [self addSubview:_listTabView];
    }
    return _listTabView;
}

- (void)setIsme:(BOOL)isme{
    _isme = isme;
    [self getdata];
}


@end
