//
//  SGBaseController.h
//  StillGold
//
//  Created by DBB on 2017/6/5.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KEYBOARD_SHOW 0
#define KEYBOARD_HIED 1

@interface SGBaseController : UIViewController
/**
 *  当前视图 是否加载 键盘通知  yes 为加载  no为不加载 ／默认不加载
 */
@property(nonatomic,assign) BOOL keyBoardNotice;
@property (nonatomic, assign) BOOL canDragBack;
@property (nonatomic, assign) BOOL hideNavigationLine;;

- (BOOL)checkLoginImmediately;
- (void)back;

- (void)getLocation;
@end
