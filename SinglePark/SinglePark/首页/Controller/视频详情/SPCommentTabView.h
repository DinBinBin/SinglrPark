//
//  SPCommentTabView.h
//  SinglePark
//
//  Created by 斌斌戴 on 2018/11/16.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPCommentTabView : UIView

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,copy)void (^AnswerComment)(SPMessageModel *model);
@end


NS_ASSUME_NONNULL_END
