//
//  SGTabBarController.m
//  StillGold
//
//  Created by DBB on 2017/6/5.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import "SGTabBarController.h"
#import "SGNavigationController.h"
#import "SPMainVC.h"
#import "SPMessageVC.h"
#import "SPFoundVC.h"
#import "SPMineVC.h"

@interface SGTabBarController ()<UITabBarControllerDelegate>

@end

@implementation SGTabBarController

#pragma mark - Getter


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *normalAttrs              = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName]              = [UIFont systemFontOfSize:11];
    normalAttrs[NSForegroundColorAttributeName]   = FirstWordColor;
    
    NSMutableDictionary *selectedAttrs            = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName]            = normalAttrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = ThemeColor;
    
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [self setupChildViewController:[[SPMainVC alloc] init]
                             title:@"首页"
                             image:@"icon5_def"
                     selectedImage:@"icon5_sel"];

    
    [self setupChildViewController:[[SPMessageVC alloc] init]
                             title:@"消息"
                             image:@"icon6_def"
                     selectedImage:@"icon6_sel"];
    
    [self setupChildViewController:[[SPFoundVC alloc] init]
                                 title:@"发现"
                                 image:@"icon7_def"
                         selectedImage:@"icon7_sel"];
    
    [self setupChildViewController:[[SPMineVC alloc] init]
                             title:@"我的"
                             image:@"icon8_def"
                     selectedImage:@"icon8_sel"];
    
}

- (void)setupChildViewController:(UIViewController *)childController
                           title:(NSString *)title
                           image:(NSString *)image
                   selectedImage:(NSString *)selectedImage {
    
    childController.title          = title;
    [childController.tabBarItem setImage:[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childController.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    SGNavigationController *navCon = [[SGNavigationController alloc] initWithRootViewController:childController];
    navCon.title                   = title;
    
    [self addChildViewController:navCon];
}



@end
