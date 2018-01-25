//
//  HfiveController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "HfiveController.h"
@interface HfiveController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property(nonatomic,strong)UIScrollView *PHH5scrollview;
@property(nonatomic,strong)UIImageView  *PHH5imgView;
@property(nonatomic,strong)UIImageView  *PHH5anliimgView;
@property(nonatomic,strong)UIButton     *PHH5anlibtn;
@property(nonatomic,strong)UIView       *PHH5fugaiview;
@property(nonatomic,strong)UIButton     *PHH5askbtn;


@end

@implementation HfiveController
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

    self.title = @"H5制作";

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickHfive)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
      [self creatPHH5];
    
}

#pragma  -mark 创建控件
-(void)creatPHH5{
    
    _PHH5fugaiview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 920)];
    _PHH5fugaiview.backgroundColor = kTCColor(133, 77, 63);
    
    _PHH5scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    self.view.backgroundColor = [UIColor whiteColor];
    _PHH5scrollview.userInteractionEnabled = YES;
    _PHH5scrollview.showsVerticalScrollIndicator = YES;
    _PHH5scrollview.showsHorizontalScrollIndicator = YES;
    _PHH5scrollview.delegate = self;
    _PHH5scrollview.contentSize = CGSizeMake(KMainScreenWidth, 920);
    #pragma  -mark添加图
    
    [self.view addSubview:_PHH5scrollview];
    [_PHH5scrollview addSubview:_PHH5fugaiview];
    
    _PHH5imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 615)];
    _PHH5imgView.image = [UIImage imageNamed:@"Hfive"];
    [_PHH5fugaiview  addSubview:_PHH5imgView];
   

    for (NSInteger i = 0; i<3; i++)
    {
        _PHH5anliimgView = [[UIImageView alloc]initWithFrame:CGRectMake(15 + i*((KMainScreenWidth-210)/2+60), 625, 60, 123)];
        _PHH5anliimgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"H5_anli_%ld",i+1]];
        [_PHH5fugaiview addSubview:_PHH5anliimgView];
    }
    
    for (NSInteger i = 0; i<3; i++)
    {
        _PHH5anlibtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _PHH5anlibtn.frame=CGRectMake(15 + i*((KMainScreenWidth-210)/2+60), 754, 60, 30);
        _PHH5anlibtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_PHH5anlibtn addTarget:self action:@selector(H5click:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0 ) {
            [_PHH5anlibtn setTitle:@"点击预览" forState:UIControlStateNormal];
            _PHH5anlibtn.tag = 001;
        }
        if (i == 1 ) {
            [_PHH5anlibtn setTitle:@"点击预览" forState:UIControlStateNormal];
            _PHH5anlibtn.tag = 002;
        }
        if (i == 2 ) {
            [_PHH5anlibtn setTitle:@"点击预览" forState:UIControlStateNormal];
            _PHH5anlibtn.tag = 003;
        }
        
        [_PHH5fugaiview addSubview:_PHH5anlibtn];
    }
    
    _PHH5askbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _PHH5askbtn.frame = CGRectMake(KMainScreenWidth/4, 824, KMainScreenWidth/2, 40);
    [_PHH5askbtn setTitle:@"马上咨询" forState:UIControlStateNormal];
    [_PHH5askbtn setBackgroundImage:[UIImage imageNamed:@"H5_zixu"] forState:UIControlStateNormal];
    [_PHH5askbtn setTitleColor:[UIColor colorWithRed:133/255.0 green:77/255.0 blue:63/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_PHH5askbtn addTarget:self action:@selector(askH5btn:) forControlEvents:UIControlEventTouchUpInside];
    [_PHH5fugaiview addSubview:_PHH5askbtn];
}

-(void)askH5btn:(UIButton *)btn{
    NSLog(@"咨询信息");

    
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
                                                                      
                                                                      //                                                                      注：跳转到微信公众号，首先需要到微信开发平台，绑定对应的公众号
                                                                      //                                                                      if ([WXApi isWXAppInstalled]) {
                                                                      //                                                                          JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
                                                                      //                                                                          req.username = @"公众号原始ID";
                                                                      //                                                                          req.extMsg = @"";
                                                                      //                                                                          req.profileType =0;
                                                                      //                                                                          [WXApi sendReq:req];
                                                                      //                                                                      } else {
                                                                      //                                                                          UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                                      //                                                                          [pasteboard setString:self.weChatID];
                                                                      //                                                                          [QQMMessage showSuccessMessage:@"已复制公众号"];
                                                                      //                                                                      }
                                                                      
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
                                                                          NSString *QQ = @"1275053499";
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

-(void)H5click:(UIButton *)btn{
    switch (btn.tag) {
        case 001:{
            
            NSLog(@"案例001");
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            WapH5Controller *ctl = [[WapH5Controller alloc]init];
            ctl.url = @"https://m.eqxiu.com/s/Kj1LSJF2";
            ctl.titlestr = @"中国·铺皇--产品推广";
            [self.navigationController pushViewController:ctl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        }
            break;
        case 002:{
            NSLog(@"案例002");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            WapH5Controller *ctl= [[WapH5Controller alloc]init];
            ctl.url             = @"https://m.eqxiu.com/s/VJgTyKqJ";
            ctl.titlestr        = @"中国·铺皇--H5店铺宣传";
            [self.navigationController pushViewController:ctl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        }
            break;
    
        default:{
            NSLog(@"案例003");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            WapH5Controller *ctl    = [[WapH5Controller alloc]init];
            ctl.url                 = @"https://m.eqxiu.com/s/02np4ZwA";
            ctl.titlestr            = @"中国·铺皇-产品推广";
            [self.navigationController pushViewController:ctl animated:YES];
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        }
            break;
    }
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

- (void)BackButtonClickHfive{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    tabbar不显示出来
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
