//
//  ShopsController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsController.h"

@interface ShopsController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property(nonatomic,strong)UIScrollView *PHShopsscrollview;
@property(nonatomic,strong)UIImageView  *PHShopsimgView;
@property(nonatomic,strong)UIButton     *PHShopsaskbtn;
@end

@implementation ShopsController
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
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickshops)];
    self.navigationItem.leftBarButtonItem = backItm;
    self.title = @"商铺大学";
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    [self creatPHDaily];
    
}




-(void)creatPHDaily{
 
    _PHShopsscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    self.view.backgroundColor = [UIColor whiteColor];
    _PHShopsscrollview.userInteractionEnabled = YES;
    _PHShopsscrollview.showsVerticalScrollIndicator = YES;
    _PHShopsscrollview.showsHorizontalScrollIndicator = YES;
    _PHShopsscrollview.delegate = self;
    _PHShopsscrollview.contentSize = CGSizeMake(KMainScreenWidth, 860);
    
    [self.view addSubview:_PHShopsscrollview];
    
    _PHShopsimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 860)];
    _PHShopsimgView.image = [UIImage imageNamed:@"商铺大学"];
    [_PHShopsscrollview  addSubview:_PHShopsimgView];
    
    _PHShopsaskbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _PHShopsaskbtn.frame = CGRectMake(KMainScreenWidth/4, 800, KMainScreenWidth/2, 40);
    [_PHShopsaskbtn setTitle:@"马上咨询" forState:UIControlStateNormal];
    [_PHShopsaskbtn setBackgroundImage:[UIImage imageNamed:@"Shops_zixu"] forState:UIControlStateNormal];
    [_PHShopsaskbtn setTitleColor:[UIColor colorWithRed:138/255.0 green:134/255.0 blue:35/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_PHShopsaskbtn addTarget:self action:@selector(askShopsbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_PHShopsscrollview addSubview:_PHShopsaskbtn];
}

#pragma -mark 马上咨询咨询
-(void)askShopsbtn:(UIButton *)btn{
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
- (void)BackButtonClickshops{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
@end
