//
//  WebViewVC.m
//  QZBaseWebVCDemo
//
//  Created by MrYu on 16/8/23.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import "WebViewVC.h"
@interface WebViewVC ()

@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"铺皇管理系统";
    self.view.backgroundColor = kTCColor(255, 255, 255);
    //    返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    [self setStartLoadBlock:^(id webView) {
        NSLog(@"block success");
    }];
    [self setFinishLoadBlock:^(id webView) {
        NSLog(@"block finish");
    }];
    
     [self loadUrl];
    
    
//    未知方法
//    [self addBridge];
//    [self makeSubview];
   
}

#pragma  -mark - 返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma -mark 回到顶部
- (void)makeSubview
{
    UIButton *btn1 = [[UIButton alloc] init];
    btn1.frame = CGRectMake(self.view.bounds.size.width - 80, self.view.bounds.size.height - 80, 50, 50);
    [btn1 setTitle:@"top" forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 25;
    btn1.clipsToBounds = YES;
    [self.view addSubview:btn1];
    [self.view bringSubviewToFront:btn1];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(gotop) forControlEvents:UIControlEventTouchUpInside];
}

- (void)gotop{
    
    [self scrollToTop];
}

@end
