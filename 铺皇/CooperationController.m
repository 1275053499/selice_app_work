//
//  CooperationController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/2.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "CooperationController.h"
@interface CooperationController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property(nonatomic,strong)UIScrollView *PHCooperationscrollview;
@property(nonatomic,strong)UIImageView  *PHCooperationimgView;
@property(nonatomic,strong)UIButton     *PHCooperationaskbtn;

@end


@implementation CooperationController

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

    self.view.backgroundColor                           = [UIColor whiteColor];
    self.title = @"合作中心";
 
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickcooperation)];
  
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
     [self creatPHCooperation];
}

-(void)creatPHCooperation{
    
 
    _PHCooperationscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    _PHCooperationscrollview.userInteractionEnabled = YES;
    _PHCooperationscrollview.showsVerticalScrollIndicator = YES;
    _PHCooperationscrollview.showsHorizontalScrollIndicator = YES;
    _PHCooperationscrollview.delegate = self;
    _PHCooperationscrollview.contentSize = CGSizeMake(KMainScreenWidth, 860);

    [self.view addSubview:_PHCooperationscrollview];
    
    
    _PHCooperationimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 860)];
    _PHCooperationimgView.image = [UIImage imageNamed:@"商家合作"];
    [_PHCooperationscrollview  addSubview:_PHCooperationimgView];
    
    
    _PHCooperationaskbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _PHCooperationaskbtn.frame = CGRectMake(KMainScreenWidth/4, 800, KMainScreenWidth/2, 40);
    [_PHCooperationaskbtn setTitle:@"马上咨询" forState:UIControlStateNormal];
    [_PHCooperationaskbtn setBackgroundImage:[UIImage imageNamed:@"cooperation_zixu"] forState:UIControlStateNormal];
    [_PHCooperationaskbtn setTitleColor:[UIColor colorWithRed:61/255.0 green:94/255.0 blue:106/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_PHCooperationaskbtn addTarget:self action:@selector(askRenovationbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_PHCooperationscrollview addSubview:_PHCooperationaskbtn];
}

#pragma -mark 马上咨询咨询
-(void)askRenovationbtn:(UIButton *)btn{

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
- (void)BackButtonClickcooperation{
    
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
