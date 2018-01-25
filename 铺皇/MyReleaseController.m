//
//  MyReleaseController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "MyReleaseController.h"
@interface MyReleaseController ()

@end

@implementation MyReleaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kTCColor(255, 255, 255);
    
    self.title = @"我的发布";
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    //    添加segview
    [self.view addSubview:[self build]];
}

- (YJLSegpageview *)build {
    
    YJLSegpageview *pageView = [[YJLSegpageview alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) withTitles:@[@"转让",@"出租",@"选址",@"招聘"] withViewControllers:@[@"InformaZRController",@"InformaZZController",@"InformaXZController",@"InformaZPController"] withParameters:nil];
    pageView.selectedColor = kTCColor(77, 166, 214);
    pageView.unselectedColor = [UIColor blackColor];
    pageView.defaultSubscript = 0;
    return pageView;
}



#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{

    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}
#pragma  -mark - 返回
-(void)back{
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
}
@end
