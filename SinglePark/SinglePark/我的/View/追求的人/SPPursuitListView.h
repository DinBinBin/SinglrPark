//
//  SPPursuitListView.h
//  SinglePark
//
//  Created by DBB on 2018/10/21.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//typedef NS_ENUM(NSInteger, PursuitType) {
//    PursuitTypeNone,
//    PursuitTypeDisclosureIndicator,
//    PursuitTypeDetailDisclosure,
//    PursuitTypeCheckmark,
//    PursuitTypeDetailButton
//};



@interface SPPursuitListView : UIView

@property (nonatomic,strong)NSArray *promptArr;

@property (nonatomic,assign)BOOL isme;
@property (nonatomic,assign)SPPursuitType typede;
@property (nonatomic,assign)SPPursuitViewType viewType;


@end


NS_ASSUME_NONNULL_END
