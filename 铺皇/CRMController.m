//
//  CRMController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "CRMController.h"
#import "UIBarButtonItem+Create.h"
@interface CRMController ()

@end

@implementation CRMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickcooperation)];
    self.navigationItem.leftBarButtonItem = backItm;
    self.title = @"CRM";
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
}
#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5;    //  时间
    animation.type = kCATransitionMoveIn;//覆盖
    animation.subtype = kCATransitionFromLeft;//左边开始
    [self.view.window.layer addAnimation:animation forKey:nil];                   //  添加动作
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}



- (void)BackButtonClickcooperation
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5;    //  时间
    animation.type = kCATransitionMoveIn;//覆盖
    animation.subtype = kCATransitionFromLeft;//左边开始
    [self.view.window.layer addAnimation:animation forKey:nil];                   //  添加动作
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    tabbar不显示出来
    self.tabBarController.tabBar.hidden=YES;
    //    让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
