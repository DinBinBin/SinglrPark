//
//  SPCommentTabView.m
//  SinglePark
//
//  Created by 斌斌戴 on 2018/11/16.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCommentTabView.h"
#import "SPVideoCommentTabCell.h"

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
        _commentTab.tableFooterView = [[UIView alloc] init];
        [self addSubview:_commentTab];
    }
    return _commentTab;
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *lab = [[UILabel alloc] init];
        [cell.contentView addSubview:lab];
        lab.text = @"暂无评论";
        lab.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        lab.font = FONT(16);
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
        }];
        return cell;
    }
    
    SPVideoCommentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.commentStr forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
