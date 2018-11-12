//
//  SGNavigationController.m
//  StillGold
//
//  Created by DBB on 2017/6/5.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import "SGNavigationController.h"
#import "SGBaseController.h"

@interface SGNavigationController ()

@end

@implementation SGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barStyle = UIBarStyleBlack;
    UIView *line = [ProjectHelp point:CGPointMake(0, self.navigationBar.height-0.5) width:kScreenWidth height:0.5];
    line.backgroundColor = HexCOLOR(0xdddddd);
    [self.navigationBar addSubview:line];
    
}

#pragma mark - Life cycle
+ (void)initialize {
    [super initialize];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor  whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor  blackColor]];
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//    if (self.viewControllers.count > 0) {
//
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backBarButtonWithTarget:self action:@selector(popViewControllerAnimated:)];
//
//        // 全局滑动手势
//        self.interactivePopGestureRecognizer.enabled = YES;
//        self.interactivePopGestureRecognizer.delegate = nil;
//
//        //隐藏导航栏
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//
//    [super pushViewController:viewController animated:animated];
//
//}


/** 推控制器 */
- (void)pushViewController:(SGBaseController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed      = YES;
    }
    [super pushViewController:viewController animated:animated  ];

}

/** 返回 */
- (void)back {
    [self popViewControllerAnimated:YES];
}


@end
