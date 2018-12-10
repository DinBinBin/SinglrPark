//
//  SGBaseController.m
//  StillGold
//
//  Created by DBB on 2017/6/5.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import "SGBaseController.h"
#import "LCLoginController.h"

@interface SGBaseController ()

@end

@implementation SGBaseController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {

    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
-(void)deallocSelf
{
    [self preDeallocSelf];
    //    [AFNetworkTool cancelAllRequestOpration];
}

-(void)preDeallocSelf
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)dealloc
{
    [self deallocSelf];
    [self removeKeyboardNotice];
}

#pragma mark - :键盘监听 show/hide 处理
// 移除键盘通知
-(void)removeKeyboardNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 加载键盘通知
-(void)initkeyboardNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self keyboardChange:KEYBOARD_SHOW height:keyboardRect.size.height];
    
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self keyboardChange:KEYBOARD_HIED height:0];
}

#pragma mark 键盘事件 用于子类重写
/**
 *  @brief 键盘变化触发函数
 *
 *  @param type   键盘变化的类型 (value:KEYBOARD_SHOW/KEYBOARD_HIED)
 *  @param height 键盘的高度
 *
 */
-(void)keyboardChange:(int)type height:(CGFloat)height
{
    
}

#pragma mark - view life
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    self.view.backgroundColor = PTBackColor;
//    [self navTitleColor:[UIColor whiteColor]];
    [self _creatBackBtn];


}

- (void)backNavigationViewController
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navTitleColor:(UIColor *)color
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:color}];
}

#pragma mark - Creat BackBtn
- (void)_creatBackBtn{
    if (self.navigationController.viewControllers.count > 1) {
        // 替换back按钮
        UIBarButtonItem *backBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"back"
                                                                         imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)
                                                                                  target:self
                                                                                  action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
        // 隐藏tabbar

    }
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - check login
- (BOOL)checkLoginImmediately {
    if ([DBAccountInfo sharedInstance].islogin) return YES;
    LCLoginController *login = [[LCLoginController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
    return NO;
}

//方法二.当设置navigationBar的背景图片或背景色时，使用该方法都可移除黑线，且不会使translucent属性失效
-(void)setHideNavigationLine:(BOOL)hideNavigationLine
{
    _hideNavigationLine = hideNavigationLine;
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //隐藏黑线（在viewWillAppear时隐藏，在viewWillDisappear时显示）
    blackLineImageView.hidden = _hideNavigationLine;
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end
