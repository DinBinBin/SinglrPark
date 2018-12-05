//
//  SPConversationViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/5.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPConversationViewController.h"

@interface SPConversationViewController ()

@end

@implementation SPConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 替换back按钮
    UIBarButtonItem *backBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"back"
                                                                     imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)
                                                                              target:self
                                                                              action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
