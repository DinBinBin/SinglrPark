//
//  SPCommentTabView.m
//  SinglePark
//
//  Created by 斌斌戴 on 2018/11/16.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCommentTabView.h"
#import "SPVideoCommentTabCell.h"
#import "SPConmentHeadView.h"

@interface SPCommentTabView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *commentTab;
@property (nonatomic,copy)NSString *commentStr;

@end

@implementation SPCommentTabView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.commentTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UITableView *)commentTab{
    if (_commentTab == nil ) {
        _commentTab = [[UITableView alloc] init];
        _commentTab.dataSource = self;
        _commentTab.delegate = self;
        self.commentStr = @"commentStr";
        _commentTab.backgroundColor = PTBackColor;
        _commentTab.backgroundColor = [UIColor clearColor];

        [_commentTab registerClass:[SPVideoCommentTabCell class] forCellReuseIdentifier:self.commentStr];
        [_commentTab registerClass:[SPConmentHeadView class] forHeaderFooterViewReuseIdentifier:@"head"];
        _commentTab.tableFooterView = [[UIView alloc] init];
        [self addSubview:_commentTab];
    }
    return _commentTab;
}

#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArr.count == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count == 0) {
        return 0;
    }
    SPMessageModel *model = self.dataArr[section];
    if (model.replies.count) {

        return  model.replies.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    SPVideoCommentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.commentStr forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SPMessageModel *model = self.dataArr[indexPath.section];
    if (self.AnswerComment) {
        self.AnswerComment(model.replies[indexPath.row]);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        if (self.dataArr.count == 0) {
            if (self.dataArr.count == 0) {
                UIView *cellview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                cellview.backgroundColor = [UIColor clearColor];
                UILabel *lab = [[UILabel alloc] init];
                [cellview addSubview:lab];
                lab.text = @"暂无评论";
                lab.textColor = [UIColor whiteColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                lab.font = FONT(16);
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(cellview);
                }];
                return cellview;
            }
    
        }

    SPConmentHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    UIControl *control = [[UIControl alloc ] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [control addSubview:head];
    head.model = self.dataArr[section];
//    control.backgroundColor = [UIColor whiteColor];
    WEAKSELF
    STRONGSELF
    [control addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (strongSelf.AnswerComment) {
            strongSelf.AnswerComment(strongSelf.dataArr[section]);
        }
    }];
    return control;
    
}



- (void)setDataArr:(NSMutableArray *)dataArr{
    if (_dataArr != dataArr) {
        _dataArr = dataArr;
        [self.commentTab reloadData];
    }
}
@end
