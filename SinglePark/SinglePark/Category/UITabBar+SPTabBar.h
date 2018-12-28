//
//  UITabBar+SPTabBar.h
//  SinglePark
//
//  Created by chensw on 2018/12/28.
//  Copyright © 2018 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (SPTabBar)
- (void)showBadgeOnItemIndex:(int)index count:(int)count;
- (void)hideBadgeOnItemIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
