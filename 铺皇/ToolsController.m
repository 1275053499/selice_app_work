//
//  ToolsController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ToolsController.h"
@interface ToolsController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property(nonatomic,strong)UIScrollView *PHToolsscrollview;
@property(nonatomic,strong)UIImageView  *PHToolsimgView;
@property(nonatomic,strong)UIButton     *PHToolsaskbtn;

@end

@implementation ToolsController

#pragma -mark 懒加载
- (UIWebView *)webView
{
    if(!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTCColor(255, 255, 255);
 
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickTools)];
    self.navigationItem.leftBarButtonItem = backItm;
    self.title = @"工具中心";
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
     [self creatPHTools];
    
}

-(void)creatPHTools{

    _PHToolsscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    self.view.backgroundColor = [UIColor whiteColor];
    _PHToolsscrollview.userInteractionEnabled = YES;
    _PHToolsscrollview.showsVerticalScrollIndicator = YES;
    _PHToolsscrollview.showsHorizontalScrollIndicator = YES;
    _PHToolsscrollview.delegate = self;
    _PHToolsscrollview.contentSize = CGSizeMake(KMainScreenWidth, 800);
    [self.view addSubview:_PHToolsscrollview];
    
    _PHToolsimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 800)];
    _PHToolsimgView.image = [UIImage imageNamed:@"工具市场"];
    [_PHToolsscrollview  addSubview:_PHToolsimgView];
    
    _PHToolsaskbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _PHToolsaskbtn.frame = CGRectMake(KMainScreenWidth/4, 740, KMainScreenWidth/2, 40);
    [_PHToolsaskbtn setTitle:@"马上咨询" forState:UIControlStateNormal];
    [_PHToolsaskbtn setBackgroundImage:[UIImage imageNamed:@"Tools_xizu"] forState:UIControlStateNormal];
    [_PHToolsaskbtn setTitleColor:[UIColor colorWithRed:62/255.0 green:24/255.0 blue:135/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_PHToolsaskbtn addTarget:self action:@selector(askToolsbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_PHToolsscrollview addSubview:_PHToolsaskbtn];
}

#pragma -mark 马上咨询咨询
-(void)askToolsbtn:(UIButton *)btn{
    //初始版本
    //    NSLog(@"电话咨询");
    //    NSString * str1 =@"15302626641";
    //    NSLog(@"str1======%@",str1);
    //    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",str1];
    //    UIWebView * callWebview = [[UIWebView alloc] init];
    //    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    //    [self.view addSubview:callWebview];
    //加强版本
    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                cancelTitle:@"取消"
                                                           destructiveTitle:nil
                                                                otherTitles:@[@"微信咨询", @"QQ咨询", @"电话咨询"]
                                                                otherImages:nil
                                                          selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                              NSLog(@"%zd", index);
                                                              
                                                              switch (index) {
                                                                  case 0://微信咨询
                                                                  {
                                                                      
                                                                      // 跳到微信
                                                                      //                                                                      NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
                                                                      //                                                                      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                                                                      
                                                                      
                                                                      SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                                                                                  cancelTitle:@"取消"
                                                                                                                             destructiveTitle:nil
                                                                                                                                  otherTitles:@[@"搜索关注微信订阅号：铺王网订阅号", @"搜索关注微信公众号：铺王网"]
                                                                                                                                  otherImages:nil
                                                                                                                            selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                                                                                NSLog(@"%zd", index);
                                                                                                                                switch (index) {
                                                                                                                                    case 0:
                                                                                                                                    {
                                                                                                                                        // 跳到微信
                                                                                                                                        NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
                                                                                                                                        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                                                                                                                                        
                                                                                                                                    }
                                                                                                                                        break;
                                                                                                                                        
                                                                                                                                    default:{
                                                                                                                                        // 跳到微信
                                                                                                                                        NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
                                                                                                                                        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                                                                                                                                    }
                                                                                                                                        break;
                                                                                                                                }
                                                                                                                                
                                                                                                                            }];
                                                                      actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
                                                                      
                                                                      [actionSheet show];
                                                                      
                                                                  }
                                                                      break;
                                                                  case 1://QQ咨询
                                                                  {
                                                                      //是否安装QQ
                                                                      if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
                                                                      {
                                                                          //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
                                                                          NSString *QQ = @"3433796671";
                                                                          //调用QQ客户端,发起QQ临时会话
                                                                          NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
                                                                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                                                      }
                                                                  }
                                                                      break;
                                                                      
                                                                  case 2://TEL咨询
                                                                  {
                                                                      [LEEAlert alert].config
                                                                      
                                                                      .LeeAddTitle(^(UILabel *label) {
                                                                          
                                                                          label.text = @"联系客服";
                                                                          
                                                                          label.textColor = [UIColor blackColor];
                                                                      })
                                                                      .LeeAddContent(^(UILabel *label) {
                                                                          
                                                                          label.text = @"TEL:0755-23212184";
                                                                          label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
                                                                      })
                                                                      
                                                                      .LeeAddAction(^(LEEAction *action) {
                                                                          
                                                                          action.type = LEEActionTypeCancel;
                                                                          
                                                                          action.title = @"取消";
                                                                          
                                                                          action.titleColor = kTCColor(255, 255, 255);
                                                                          
                                                                          action.backgroundColor = kTCColor(174, 174, 174);
                                                                          
                                                                          action.clickBlock = ^{
                                                                              
                                                                              // 取消点击事件Block
                                                                          };
                                                                      })
                                                                      
                                                                      .LeeAddAction(^(LEEAction *action) {
                                                                          
                                                                          action.type = LEEActionTypeDefault;
                                                                          
                                                                          action.title = @"呼叫";
                                                                          
                                                                          action.titleColor = kTCColor(255, 255, 255);
                                                                          
                                                                          action.backgroundColor = kTCColor(77, 166, 214);
                                                                          
                                                                          action.clickBlock = ^{
                                                                              
                                                                              [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://0755-23212184"]];
                                                                              
                                                                          };
                                                                      })
                                                                      .LeeHeaderColor(kTCColor(255, 255, 255))
                                                                      .LeeShow();

                                                                  }
                                                                      break;
                                                                      
                                                                  default://TEL咨询
                                                                  {
                                                                      
                                                                  }
                                                                      break;
                                                              }
                                                          }];
    actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
    [actionSheet show];
}


#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
    
}

#pragma  -mark - 按钮返回
- (void)BackButtonClickTools{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
}

@end
