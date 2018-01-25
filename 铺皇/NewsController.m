//
//  NewsController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "NewsController.h"
@interface NewsController ()

@end

@implementation NewsController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = kTCColor(255, 255, 255);
    [self buildUI];
    [self loaddata];
}

-(void)loaddata{
    
}

-(void)buildUI{
    
    self.title = @"系统消息";
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
}
#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 返回
-(void)back{
    
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

}


@end
