//
//  ADViewController.m
//  Created by 铺皇网 on 2017/5/20.
//  Copyright © 2017年 中国铺皇. All rights reserved.


#import "ADViewController.h"

@interface ADViewController ()

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"广告页面";
    NSLog(@"%@",self.adUrl);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+49)];
    webView.backgroundColor = [UIColor whiteColor];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
    
}
@end
