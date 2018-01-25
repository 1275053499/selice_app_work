//
//  WeboneViewController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "WeboneViewController.h"

@interface WeboneViewController ()

@end

@implementation WeboneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =  @"网络信息";
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


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    tabbar不显示出来
    self.tabBarController.tabBar.hidden=YES;
    

}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //    tabbar显示出来
    self.tabBarController.tabBar.hidden=NO;
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
