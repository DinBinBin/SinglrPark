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
#import "SPPursuitNoneTabCell.h"


@interface SPPursuitListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *pursuitStr;
@property (nonatomic,copy)NSString *pursuitNO;

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIButton *hunterBtn;

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
    SPPersonModel *model = [SPPersonModel modelWithJSON:dic1];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];

    [self.listTabView reloadData];
    
}
#pragma mark ----UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.typede == PursuitTypeNone) {
        return 2;
    }
    return self.promptArr.count + self.dataArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.typede == PursuitTypeNone) {
        if (indexPath.row == 0) {
            SPPursuitNoneTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pursuitNO forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.hunterBtn];
        return cell;
    }
    
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row - self.promptArr.count >= 0) {
//        SPBusinessCardController *business = [[SPBusinessCardController alloc] init];
//        business.model = self.dataArr[indexPath.row - self.promptArr.count];
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
        self.pursuitNO = @"pursuitNO";
        [_listTabView registerClass:[SPPursuitHeadTabCell class] forCellReuseIdentifier:self.pursuitStr];
        [_listTabView registerClass:[SPPursuitNoneTabCell class] forCellReuseIdentifier:self.pursuitNO];
        _listTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTabView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigbackground"]];

        [self addSubview:_listTabView];
    }
    return _listTabView;
}

- (void)setIsme:(BOOL)isme{
    _isme = isme;
    [self getdata];
}


////增加删除
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    //第二组可以左滑删除
//    if (indexPath.row >= self.promptArr.count) {
//        return YES;
//    }
//
//    return NO;
//}
//
//// 定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//        if (indexPath.row >= self.promptArr.count) { // 删除
//            [self.dataArr removeAllObjects];
//            [self.listTabView reloadData];
//        }
//    }
//}
//
//// 修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

- (void)setTypede:(PursuitType)typede{
    if (_typede !=typede) {
        _typede = typede;
    }
    [self.listTabView reloadData];
    return;
}

- (UIButton *)hunterBtn{
    if (_hunterBtn == nil) {
        _hunterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hunterBtn.frame = CGRectMake(10, 0, kScreenWidth-20, 44);
        [_hunterBtn setCornerRadius:5];
        _hunterBtn.backgroundColor = ThemeColor;
        [_hunterBtn setTitle:@"逛逛公园" forState:UIControlStateNormal];
    }
    return  _hunterBtn;
}

@end
