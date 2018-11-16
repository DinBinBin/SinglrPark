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
        [_commentTab registerClass:[SPVideoCommentTabCell class] forCellReuseIdentifier:self.commentStr];
        [self addSubview:_commentTab];
    }
    return _commentTab;
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPVideoCommentTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.commentStr forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
