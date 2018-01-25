//
//  WebsetController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/1.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "WebsetController.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
@interface WebsetController ()<UIWebViewDelegate>

@end

@implementation WebsetController
{
    UIWebView *_webView;
    
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kTCColor(255, 255, 255);
     [self setupUI];
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(backweb)];
    self.navigationItem.leftBarButtonItem = backItm;
    
}

- (void)setupUI {
    if (iOS11) {
         _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    }else{
         _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+49)];
    }
   
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    _webView.backgroundColor = [UIColor whiteColor];
    
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    [self.view addSubview:_webView];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [_progressLayer finishedLoad];
}

- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    NSLog(@"i am dealloc");
}

#pragma  -mark - 返回
-(void)backweb{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
}

@end
