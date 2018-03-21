//
//  YJLshowpayController.m
//  铺皇
//
//  Created by selice on 2017/10/17.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "YJLshowpayController.h"

#import "WXApiObject.h"
#import "WXApi.h"
#import "getIPhoneIP.h"
#import "DataMD5.h"
#import "XMLDictionary.h"
#import <AlipaySDK/AlipaySDK.h>

//微信支付商户号
#define MCH_ID  @"1490419572"
//开户邮件中的（公众账号APPID或者应用APPID）
#define WX_AppID @"wx9f7d4b17e069bbd4"
//安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
#define WX_PartnerKey @"1s2e3l4i5c6e7y8a9n9j8i7n6l5i4nPH"
//获取用户openid，可使用APPID对应的公众平台登录http://mp.weixin.qq.com 的开发者中心获取AppSecret。
#define WX_AppSecret @"af61dda1692cf78e47e0065d5d55e4e4"


@interface YJLshowpayController ()<UIScrollViewDelegate>{
    UIScrollView    *  MainScroll;  //背景视图
    UIView          *  Topview;     //顶部视图
    UIView          *  TopBJview;     //顶部视图
    UIImageView *  Personimgview;
    UILabel     *  Personname;
    
    UIView          *  Midview;     //中部视图
    UIView          *  Bottomviewwechat;  //低部视图1
    UIView          *  Bottomviewapily;   //低部视图2
    UIView          *  Bottomviewbutton;   //低部视图3
    
    UIButton * btn_1;
    UIButton * btn_2;
    UIButton * btn_3;
    UIButton * btn_4;
    UIButton * btn_5;
    UIButton * btn_6;
    
    NSString * paystr_1;
    NSString * paystr_2;
    NSString * paystr_3;
    NSString * paystr_4;
    NSString * paystr_5;
    NSString * paystr_6;
    
    NSString * paysavestr_1;//节约多少钱
    NSString * paysavestr_2;
    NSString * paysavestr_3;
    NSString * paysavestr_4;
    NSString * paysavestr_5;
    NSString * paysavestr_6;
    
    NSString *total;//总费用
    
    NSString *totalintegral;//总积分
    
    UILabel * displaynum;
    UILabel * dislpaysavenum;
    
    UIButton        * wechatbtn_1;//微信前面按钮
    UIImageView     * wechatimg;
    UILabel         * wechatlab;
    
    UIButton        * apilybtn_1;   //支付宝前面按钮
    UIImageView     * apilyimg;
    UILabel         * apilylab;
    
    NSString *useWorA;          //使用哪种方式字符串判断
    UIButton *WApaybtn;         //支付按钮
    
}
@property (nonatomic,strong)NSMutableArray *DataArr;
@end

@implementation YJLshowpayController
-(NSMutableArray*)DataArr{
    if (_DataArr == nil) {
        _DataArr =[[NSMutableArray alloc]init];
    }
    return  _DataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    paystr_1 = [NSString new];
    paystr_2 = [NSString new];
    paystr_3 = [NSString new];
    paystr_4 = [NSString new];
    paystr_5 = [NSString new];
    paystr_6 = [NSString new];
    paysavestr_6 = [NSString new];
    paysavestr_5 = [NSString new];
    paysavestr_4 = [NSString new];
    paysavestr_3 = [NSString new];
    paysavestr_2 = [NSString new];
    paysavestr_1 = [NSString new];
    useWorA      = [NSString new];
    total         = [NSString new];
    totalintegral = [NSString new];
    
    UIBarButtonItem *backItm  = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(Back:)];
    self.navigationItem.title = @"充 值";
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor whiteColor];
    
    MainScroll                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+64)];
    MainScroll.userInteractionEnabled         = YES;
    MainScroll.showsVerticalScrollIndicator   = YES;
    MainScroll.showsHorizontalScrollIndicator = YES;
    MainScroll.delegate                       = self;
    MainScroll.backgroundColor                = kTCColor(223, 223, 223);
    MainScroll.contentSize                    = CGSizeMake(KMainScreenWidth, KMainScreenHeight+64);
    [self.view addSubview:MainScroll];
    
    [self Topview   ];
    [self Midview   ];
    [self Bottomview];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WX_PaySuccess) name:@"WX_PaySuccess" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WX_PayCancel)  name:@"WX_PayCancel" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WX_Paysupport) name:@"WX_Paysupport" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WX_PayFail)    name:@"WX_PayFail" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Ali_PaySuccess)   name:@"Ali_PaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Ali_PayFail)      name:@"Ali_PayFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Ali_PayCancel)    name:@"Ali_PayCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Ali_Payother)      name:@"Ali_Payother" object:nil];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma -mark 充值成功
-(void)Ali_PaySuccess{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"尊敬的用户" message:@"恭喜您已经充值成功！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了确认");
        
        //        微信
        NSLog(@"微信支付了哦 ");
#pragma -mark        微信支付成功返回方法调用
        
        [self UpdataAlipy];
        
    }];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 充值失败
-(void)Ali_PayFail{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"尊敬的用户" message:@"您当前充值失败！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了确认");
        
    }];
    
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 充值取消
-(void)Ali_PayCancel{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"尊敬的用户" message:@"您已经取消了本次充值！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了确认");
    }];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 不支持
-(void)Ali_Payother{
    
    NSLog(@"支付宝未知错误");
}


#pragma -mark 充值成功
-(void)WX_PaySuccess{
    
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"尊敬的用户" message:@"恭喜您已经充值成功！" preferredStyle:UIAlertControllerStyleAlert];
    
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSLog(@"点击了确认");
                
                    //        微信
                    NSLog(@"微信支付了哦 ");
#pragma -mark        微信支付成功返回方法调用
                   
                    [self UpdataWechat];
             
                
            }];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 充值失败
-(void)WX_PayFail{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"尊敬的用户" message:@"您当前充值失败！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了确认");
        
    }];
    
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 充值取消
-(void)WX_PayCancel{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"尊敬的用户" message:@"您已经取消了本次充值！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了确认");
    }];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 不支持
-(void)WX_Paysupport{

    NSLog(@"微信版本不支持");
}

#pragma -mark        支付宝支付成功返回方法
-(void)UpdataAlipy{
    NSLog(@"支付宝充值获取积分:%@分",total);
    
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSLog(@"支付金额:%@",total);
    NSDictionary *params =    @{
                                
                                    @"user_id": [[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                                    @"money":totalintegral,
                                    @"type":@"支付宝",
                                };
    
    [manager POST:payrecharge parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"返回数据%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"服务器渣渣   ");
    }];
}

#pragma -mark        微信支付成功返回方法
-(void)UpdataWechat{
    
    NSLog(@"微信充值获取积分  :%@分",total);
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSLog(@"支付金额:%@",total);
    NSDictionary *params =    @{
                                    @"user_id": [[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                                    @"money":totalintegral,
                                    @"type":@"微信",
                                };
    NSLog(@"%@",params);
    
    [manager POST:payrecharge parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"返回数据%@",responseObject);
        NSLog(@"成功上传数据");
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"服务器渣渣   ");
    }];
}

#pragma -mark 顶部视图
-(void)Topview{
    
    TopBJview = [[UIView alloc]init];
    TopBJview.backgroundColor= [UIColor whiteColor];
    [MainScroll addSubview:TopBJview];
    [TopBJview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 150));
        make.left.equalTo(MainScroll).with.offset(0);
        make.top.equalTo (MainScroll).with.offset(0);
    }];
    
//    person_bg@2x
    Topview = [[UIView alloc]init];
    Topview.backgroundColor= kTCColor(191, 223, 255);
    [TopBJview addSubview:Topview];
    Topview.layer.cornerRadius = 10.0f;
//    Topview.layer.borderWidth  = 1.0f;
    [Topview mas_makeConstraints:^(MASConstraintMaker *make) {
       make.size.mas_equalTo(CGSizeMake(300, 130));
       make.left.equalTo(TopBJview).with.offset((KMainScreenWidth-300)/2);
       make.top.equalTo (TopBJview).with.offset(10);
    }];
    
    //    个人头像
    Personimgview                    =[[UIImageView alloc]init];
    Personimgview.layer.cornerRadius = 30.0f;
    Personimgview.layer.borderWidth  = 1.0f;
    Personimgview.layer.borderColor  = [UIColor whiteColor].CGColor;
    Personimgview.layer.rasterizationScale = [UIScreen mainScreen].scale;
    Personimgview.layer.shouldRasterize    = YES;
    Personimgview.clipsToBounds            = YES;
    [MainScroll addSubview:Personimgview];
    [Personimgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.equalTo(Topview).with.offset(15);
        make.centerX.equalTo(Topview);
    }];
    
//    个人账号
    Personname           = [[UILabel alloc]init];
    Personname.textColor = [UIColor blackColor];
    Personname.font      = [UIFont systemFontOfSize:15.0f];
    Personname.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:Personname];
    [Personname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(Personimgview);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-130,30));
        make.top.equalTo(Personimgview.mas_bottom).with.offset(10);
    }];

    
#pragma mark  网络赋值
    _DataArr                = [[pershowData shareshowperData]getAllDatas];
    personshowmodel *model  = [_DataArr objectAtIndex:0];
    [Personimgview sd_setImageWithURL:[NSURL URLWithString:model.personimage] placeholderImage:nil];                     //图片
     Personname.text        =   model.personphone;           //电话
}
#pragma -mark 中部部视图
-(void)Midview{
    
    Midview = [[UIView alloc]init];
    Midview.backgroundColor= [UIColor whiteColor];
    [MainScroll addSubview:Midview];
    [Midview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 220));
        make.left.equalTo(MainScroll).with.offset(0);
        make.top.equalTo (TopBJview.mas_bottom).with.offset(1);
    }];
    
    btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_1 addTarget:self action:@selector(choose_1:) forControlEvents:UIControlEventTouchUpInside];
    [btn_1 setImage:[UIImage imageNamed:@"group1"] forState:UIControlStateNormal];
    [Midview addSubview:btn_1];
    [btn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, 76));
        make.top.equalTo(Midview).with.offset(25);
        make.left.equalTo(Midview).with.offset(25);
    }];
    
    btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_2 addTarget:self action:@selector(choose_2:) forControlEvents:UIControlEventTouchUpInside];
    [btn_2 setImage:[UIImage imageNamed:@"group2"]       forState:UIControlStateNormal];
    [Midview addSubview:btn_2];
    [btn_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, 76));
        make.top.equalTo(Midview).with.offset(25);
        make.left.equalTo(btn_1.mas_right).with.offset(10);
    }];
    
    btn_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_3 addTarget:self action:@selector(choose_3:) forControlEvents:UIControlEventTouchUpInside];
    [btn_3 setImage:[UIImage imageNamed:@"group3"]       forState:UIControlStateNormal];
    [Midview addSubview:btn_3];
    [btn_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, 76));
        make.top.equalTo(Midview).with.offset(25);
        make.left.equalTo(btn_2.mas_right).with.offset(10);
    }];
    
    btn_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_4 addTarget:self action:@selector(choose_4:) forControlEvents:UIControlEventTouchUpInside];
    [btn_4 setImage:[UIImage imageNamed:@"group4"]       forState:UIControlStateNormal];
    [Midview addSubview:btn_4];
    [btn_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, 76));
        make.top.equalTo(btn_1.mas_bottom).with.offset(25);
        make.left.equalTo(Midview).with.offset(25);
    }];
    
    btn_5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_5 addTarget:self action:@selector(choose_5:) forControlEvents:UIControlEventTouchUpInside];
    [btn_5 setImage:[UIImage imageNamed:@"group5"]       forState:UIControlStateNormal];
    [Midview addSubview:btn_5];
    [btn_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, 76));
        make.top.equalTo(btn_2.mas_bottom).with.offset(25);
        make.left.equalTo(btn_4.mas_right).with.offset(10);
    }];
    
    btn_6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_6 addTarget:self action:@selector(choose_6:) forControlEvents:UIControlEventTouchUpInside];
    [btn_6 setImage:[UIImage imageNamed:@"group6"]       forState:UIControlStateNormal];
    [Midview addSubview:btn_6];
    [btn_6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, 76));
        make.top.equalTo(btn_3.mas_bottom).with.offset(25);
        make.left.equalTo(btn_5.mas_right).with.offset(10);
    }];
    
//    支付XX元
    displaynum               = [[UILabel alloc]init];
    displaynum.text          = @"支付:0000.00元";
//    displaynum.backgroundColor          = [UIColor cyanColor];
    displaynum.textColor = [UIColor redColor];
    displaynum.textAlignment = NSTextAlignmentLeft;
    displaynum.font          =  [UIFont systemFontOfSize:15.0f];
    [Midview addSubview:displaynum];
    [displaynum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110,20));
        make.top.equalTo(btn_6.mas_bottom).with.offset(25);
        make.left.equalTo(Midview).with.offset(30);
    }];
    
//    （可省XX元）
    dislpaysavenum               = [[UILabel alloc]init];
    dislpaysavenum.text          = @"(可省00.0元)";
    dislpaysavenum.textColor = [UIColor redColor];
    dislpaysavenum.textAlignment = NSTextAlignmentLeft;
    dislpaysavenum.font          =  [UIFont systemFontOfSize:12.0f];
    [Midview addSubview:dislpaysavenum];
    [dislpaysavenum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80,20));
        make.top.equalTo(btn_6.mas_bottom).with.offset(25);
        make.left.equalTo(displaynum.mas_right).with.offset(0);
    }];
}

#pragma 实时判断金额 进行特效展现
-(void)uppaynum{
    
    NSLog(@"花费：%@-%@-%@-%@-%@-%@",paystr_1,paystr_2,paystr_3,paystr_4,paystr_5,paystr_6);
    NSLog(@"省钱：%@-%@-%@-%@-%@-%@",paysavestr_1,paysavestr_2,paysavestr_3,paysavestr_4,paysavestr_5,paysavestr_6);
     totalintegral = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue+paysavestr_1.floatValue+paysavestr_2.floatValue+paysavestr_3.floatValue+paysavestr_4.floatValue+paysavestr_5.floatValue+paysavestr_6.floatValue];
    NSLog(@"支付后可获得:%@积分",totalintegral);

    NSString *content = [NSString stringWithFormat:@"支付:%.2f元",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
    NSArray *number = @[@"支",@"付",@"元",@":"];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(i, 1)];
        }
    }
    
    displaynum.attributedText = attributeString;
    
    NSString *contentsave = [NSString stringWithFormat:@"(可省%.2lf元)",paysavestr_1.floatValue+paysavestr_2.floatValue+paysavestr_3.floatValue+paysavestr_4.floatValue+paysavestr_5.floatValue+paysavestr_6.floatValue];
    NSArray *numbersave = @[@"可",@"省",@"元",@"(",@")"];
    NSMutableAttributedString *attributeStringsave  = [[NSMutableAttributedString alloc]initWithString:contentsave];
    for (int i = 0; i < contentsave.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [contentsave substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([numbersave containsObject:a]) {
            [attributeStringsave setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(i, 1)];
        }
    }

    dislpaysavenum.attributedText = attributeStringsave;
    if (paystr_1.length < 1&&paystr_2.length<1&&paystr_3.length<1&&paystr_4.length<1&&paystr_5.length<1&&paystr_6.length<1) {
        NSLog(@"00000000YES");
        [Midview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@220);//不显示支付金额
        }];
//        [Bottomviewapily mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);//不显示支付支付宝方式
//        }];
//        [Bottomviewwechat mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);//不显示支付微信方式
//        }];
//        [Bottomviewbutton mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@350);
//        }];

    }else{
        NSLog(@"000000000NO");

        [Midview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@255);//显示支付金额
        }];
        
//        [Bottomviewapily mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@60);//显示支付支付宝方式
//        }];
//        [Bottomviewwechat mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@60);//显示支付微信方式
//        }];
//        [Bottomviewbutton mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@410);
//        }];
    }
}


#pragma - mark 选择OR不选择
-(void)choose_1:(UIButton *)btn{
    if (btn.selected) {
        NSLog(@"不选中这个");
         [btn_1 setImage:[UIImage imageNamed:@"group1"]       forState:UIControlStateNormal];
        paystr_1 = @"";
        paysavestr_1 = @"";
    }
    else{
        NSLog(@"选中这个");
         [btn_1 setImage:[UIImage imageNamed:@"group_press1"] forState:UIControlStateNormal];
       
        paystr_1 = @"49.5";
        paysavestr_1 = @"0.5";
    }
     btn.selected = !btn.selected;
    
    [self uppaynum];
    [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    if (apilybtn_1.selected) {
        apilybtn_1.selected = !apilybtn_1.selected;
    }
    if (wechatbtn_1.selected) {
        wechatbtn_1.selected = !wechatbtn_1.selected;
    }
    useWorA = @"";
}

-(void)choose_2:(UIButton *)btn{
    if (btn.selected) {
        NSLog(@"不选中这个");
        [btn_2 setImage:[UIImage imageNamed:@"group2"]       forState:UIControlStateNormal];
        paystr_2 = @"";
        paysavestr_2 = @"";
    }
    else{
        NSLog(@"选中这个");
        [btn_2 setImage:[UIImage imageNamed:@"group_press2"] forState:UIControlStateNormal];
        paystr_2 = @"99";
        paysavestr_2 = @"1";
    }
    btn.selected = !btn.selected;
    
     [self uppaynum];
    [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    if (apilybtn_1.selected) {
        apilybtn_1.selected = !apilybtn_1.selected;
    }
    if (wechatbtn_1.selected) {
        wechatbtn_1.selected = !wechatbtn_1.selected;
    }
    useWorA = @"";
}

-(void)choose_3:(UIButton *)btn{
    if (btn.selected) {
        NSLog(@"不选中这个");
        paystr_3 = @"";
        paysavestr_3 = @"";
        [btn_3 setImage:[UIImage imageNamed:@"group3"]       forState:UIControlStateNormal];
    }
    else{
        NSLog(@"选中这个");
        paystr_3 = @"198";
        paysavestr_3 = @"2";
        [btn_3 setImage:[UIImage imageNamed:@"group_press3"] forState:UIControlStateNormal];
    }
    btn.selected = !btn.selected;
     [self uppaynum];
    [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    if (apilybtn_1.selected) {
        apilybtn_1.selected = !apilybtn_1.selected;
    }
    if (wechatbtn_1.selected) {
        wechatbtn_1.selected = !wechatbtn_1.selected;
    }
    useWorA = @"";
}
-(void)choose_4:(UIButton *)btn{
    if (btn.selected) {
        NSLog(@"不选中这个");
        paystr_4 = @"";
        paysavestr_4 = @"";
        [btn_4 setImage:[UIImage imageNamed:@"group4"]       forState:UIControlStateNormal];
    }
    else{
        NSLog(@"选中这个");
        paystr_4 = @"490";
        paysavestr_4 = @"10";
        [btn_4 setImage:[UIImage imageNamed:@"group_press4"] forState:UIControlStateNormal];
    }
    btn.selected = !btn.selected;
     [self uppaynum];
    [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    if (apilybtn_1.selected) {
        apilybtn_1.selected = !apilybtn_1.selected;
    }
    if (wechatbtn_1.selected) {
        wechatbtn_1.selected = !wechatbtn_1.selected;
    }
    useWorA = @"";
}


-(void)choose_5:(UIButton *)btn{
    if (btn.selected) {
        NSLog(@"不选中这个");
        paystr_5 = @"";
        paysavestr_5 = @"";
        [btn_5 setImage:[UIImage imageNamed:@"group5"]       forState:UIControlStateNormal];
    }
    else{
        NSLog(@"选中这个");
        paystr_5 = @"975";
        paysavestr_5 = @"25";
        [btn_5 setImage:[UIImage imageNamed:@"group_press5"] forState:UIControlStateNormal];
    }
    btn.selected = !btn.selected;
     [self uppaynum];
    [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    if (apilybtn_1.selected) {
        apilybtn_1.selected = !apilybtn_1.selected;
    }
    if (wechatbtn_1.selected) {
        wechatbtn_1.selected = !wechatbtn_1.selected;
    }
    useWorA = @"";
}

-(void)choose_6:(UIButton *)btn{
    if (btn.selected) {
        NSLog(@"不选中这个");
        paystr_6         = @"";
        paysavestr_6     = @"";
        [btn_6 setImage:[UIImage imageNamed:@"group6"]       forState:UIControlStateNormal];
    }
    else{
        NSLog(@"选中这个");
        paystr_6 = @"4950";
        paysavestr_6 = @"50";
        [btn_6 setImage:[UIImage imageNamed:@"group_press6"] forState:UIControlStateNormal];
    }
    
    btn.selected = !btn.selected;
     [self uppaynum];
    
     [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    if (apilybtn_1.selected) {
        apilybtn_1.selected = !apilybtn_1.selected;
    }
    if (wechatbtn_1.selected) {
        wechatbtn_1.selected = !wechatbtn_1.selected;
    }
    useWorA = @"";
}

#pragma -mark 低部视图
-(void)Bottomview{
//    微信的背景
    Bottomviewwechat = [[UIView alloc]init];
    Bottomviewwechat.backgroundColor= [UIColor whiteColor];
    [MainScroll addSubview:Bottomviewwechat];
    [Bottomviewwechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 60));
        make.left.equalTo(MainScroll).with.offset(0);
        make.top.equalTo (Midview.mas_bottom).with.offset(1);
    }];
    [Bottomviewwechat setUserInteractionEnabled:YES];
    UITapGestureRecognizer *wechatTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatClick:)];
    [wechatTap setNumberOfTapsRequired:1];
    [Bottomviewwechat addGestureRecognizer:wechatTap];

    wechatbtn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatbtn_1 addTarget:self action:@selector(wechat) forControlEvents:UIControlEventTouchUpInside];
    [wechatbtn_1 setImage:[UIImage imageNamed:@"choice_nosure"]       forState:UIControlStateNormal];
    [wechatbtn_1 setImage:[UIImage imageNamed:@"choice_sure"]         forState:UIControlStateSelected];
    [Bottomviewwechat addSubview:wechatbtn_1];
    [wechatbtn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(Bottomviewwechat).with.offset(20);
        make.left.equalTo(Bottomviewwechat).with.offset(25);
    }];
    
    wechatimg = [[UIImageView alloc]init];
    wechatimg.image = [UIImage imageNamed:@"WeChat"];
    [Bottomviewwechat addSubview:wechatimg];
    [wechatimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 20));
        make.top.equalTo(Bottomviewwechat).with.offset(20);
        make.left.equalTo(wechatbtn_1.mas_right).with.offset(100);
    }];
    
    wechatlab = [[UILabel alloc]init];
    wechatlab.font = [UIFont systemFontOfSize:14.0f];
    wechatlab.textAlignment = NSTextAlignmentLeft;
    wechatlab.text = @"微信支付";
    [Bottomviewwechat addSubview:wechatlab];
    [wechatlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 20));
        make.top.equalTo(Bottomviewwechat).with.offset(20);
        make.left.equalTo(wechatimg.mas_right).with.offset(20);
    }];
    
//    支付宝的背景
    Bottomviewapily = [[UIView alloc]init];
    Bottomviewapily.backgroundColor= [UIColor whiteColor];
    [MainScroll addSubview:Bottomviewapily];
    [Bottomviewapily mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 60));
        make.left.equalTo(MainScroll).with.offset(0);
        make.top.equalTo (Bottomviewwechat.mas_bottom).with.offset(1);
    }];
    [Bottomviewapily setUserInteractionEnabled:YES];
    UITapGestureRecognizer *apilyTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(apilyClick:)];
    [apilyTap setNumberOfTapsRequired:1];
    [Bottomviewapily addGestureRecognizer:apilyTap];
    
    apilybtn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [apilybtn_1 addTarget:self action:@selector(alipy) forControlEvents:UIControlEventTouchUpInside];
    [apilybtn_1 setImage:[UIImage imageNamed:@"choice_nosure"]       forState:UIControlStateNormal];
    [apilybtn_1 setImage:[UIImage imageNamed:@"choice_sure"]         forState:UIControlStateSelected];
    [Bottomviewapily addSubview:apilybtn_1];
    [apilybtn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(Bottomviewapily).with.offset(20);
        make.left.equalTo(Bottomviewapily).with.offset(25);
    }];
    
    apilyimg = [[UIImageView alloc]init];
    apilyimg.image = [UIImage imageNamed:@"zhifubao"];
    [Bottomviewapily addSubview:apilyimg];
    [apilyimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 20));
        make.top.equalTo(Bottomviewapily).with.offset(20);
        make.left.equalTo(apilybtn_1.mas_right).with.offset(100);
    }];
    
    apilylab = [[UILabel alloc]init];
    apilylab.font = [UIFont systemFontOfSize:14.0f];
    apilylab.textAlignment = NSTextAlignmentLeft;
    apilylab.text = @"支付宝支付";
    [Bottomviewapily addSubview:apilylab];
    [apilylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 20));
        make.top.equalTo(Bottomviewapily).with.offset(20);
        make.left.equalTo(apilyimg.mas_right).with.offset(20);
    }];
    

//    按钮的背景
    Bottomviewbutton = [[UIView alloc]init];
    Bottomviewbutton.backgroundColor= [UIColor whiteColor];
    [MainScroll addSubview:Bottomviewbutton];
    [Bottomviewbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-410));
        make.left.equalTo(MainScroll).with.offset(0);
        make.top.equalTo (Bottomviewapily.mas_bottom).with.offset(1);
    }];
    
    //    按钮
    WApaybtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [WApaybtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    WApaybtn.titleLabel.font  = [UIFont systemFontOfSize:18.0f];
    [WApaybtn setTintColor:[UIColor whiteColor]];
    [WApaybtn addTarget:self action:@selector(payWAclick:) forControlEvents:UIControlEventTouchUpInside];
    [Bottomviewbutton addSubview:WApaybtn];
    [WApaybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 32));
        make.left.equalTo(MainScroll).with.offset(20);
        make.top.equalTo(Bottomviewapily.mas_bottom).with.offset(30);
    }];
}

#pragma -mark 支付宝cell支付选择
-(void)apilyClick:(UITapGestureRecognizer *)TAG{
    apilybtn_1.selected = !apilybtn_1.selected;
    //    将微信制反
    if (wechatbtn_1.selected) {
        wechatbtn_1.selected = !wechatbtn_1.selected;
    }else{
        
    }
    NSLog(@"使用支付宝");
    if (apilybtn_1.selected) {
        useWorA = @"alipy";
        total = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
        [WApaybtn setTitle:[NSString stringWithFormat:@"支付宝支付:%.2f元",total.floatValue] forState:UIControlStateNormal];
    }
    else{
        
        useWorA = @"";
        [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    }
}

#pragma -mark 微信cell支付选择
-(void)wechatClick:(UITapGestureRecognizer *)TAG{
    wechatbtn_1.selected = !wechatbtn_1.selected;
    //    将支付宝制反
    if (apilybtn_1.selected) {
        apilybtn_1.selected = !apilybtn_1.selected;
    }
    NSLog(@"使用微信");
    
    if (wechatbtn_1.selected) {
        useWorA = @"wechat";
        
        total = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
        [WApaybtn setTitle:[NSString stringWithFormat:@"微信支付:%.2f元",total.floatValue] forState:UIControlStateNormal];
    }
    else{
        
        useWorA = @"";
        [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    }
}

#pragma  微信支付小按钮选择
-(void)wechat{
    
    wechatbtn_1.selected = !wechatbtn_1.selected;
    //    将支付宝制反
    if (apilybtn_1.selected) {
        apilybtn_1.selected = !apilybtn_1.selected;
    }

    NSLog(@"使用微信");
    
    if (wechatbtn_1.selected) {
        useWorA = @"wechat";
        total   = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
        [WApaybtn setTitle:[NSString stringWithFormat:@"微信支付:%.1f元",total.floatValue] forState:UIControlStateNormal];
    }
    else{
        
        useWorA = @"";
        [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    }
}

#pragma  支付宝支付小按钮选择
-(void)alipy{

    total = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
    
    
    apilybtn_1.selected = !apilybtn_1.selected;
//    将微信制反
    if (wechatbtn_1.selected) {
        wechatbtn_1.selected = !wechatbtn_1.selected;
    }else{
        
    }
    NSLog(@"使用支付宝");
    if (apilybtn_1.selected) {
        useWorA = @"alipy";
        [WApaybtn setTitle:[NSString stringWithFormat:@"支付宝支付:%.1f元",total.floatValue] forState:UIControlStateNormal];
    }
    else{
        useWorA = @"";
        [WApaybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    }
}

#pragma -mark 底部支付按钮点击
-(void)payWAclick:(id)sender{
    
    if ([useWorA isEqualToString:@"wechat"]){
        //        微信
        NSLog(@"微信支付了哦 ");
        #pragma -mark        微信支付方法调用
        total = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
        NSLog(@"%ld",total.integerValue);
        if (total.integerValue < 1) {
            
            NSLog(@"支付不支持.....");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️提示" message:@"没有选择套餐" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSLog(@"点击了确认");
            }];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            
             [self sendWX];
        }
    }
    else if([useWorA isEqualToString:@"alipy"]){

        //        支付宝
        NSLog(@"支付宝支付了哦");
        total = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
        NSLog(@"%ld",total.integerValue);
        if (total.integerValue < 1) {
            
            NSLog(@"支付不支持.....");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️提示" message:@"没有选择套餐" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSLog(@"点击了确认");
            }];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            
            [self sendAlipy];
        }
    }

    else{
        NSLog(@"没有选套餐或者充值方式");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️提示" message:@"请先选择充值套餐或者充值方式" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了确认");
            
        }];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma -mark 支付宝支付的接口
-(void)sendAlipy{
    
    NSLog(@"支付宝支付方法");
 
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"连接支付宝...."];
    total = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
    
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSLog(@"支付金额:%@",total);
    
    NSDictionary *params =    @{
                                    @"money":total
                                };
    
    [manager POST:payAlipay parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
       
        [YJLHUD dismiss];
//        NSLog(@"支付宝可以返回数据%@",responseObject);
        NSString *appScheme = @"chinapuhuang";

        NSString * Order = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
       
        NSLog(@"datad转string:\n %@",Order);
        
        [[AlipaySDK defaultService] payOrder:Order fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
            NSLog(@"reslut = %@",resultDic);
            
            switch ([resultDic[@"resultStatus"] integerValue]) {
                case 6001:
                {
                    [YJLHUD showErrorWithmessage:@"取消支付"];
                    [YJLHUD dismissWithDelay:2.0f];
                }
                    break;
                case 9000:
                {
                    [YJLHUD showErrorWithmessage:@"支付成功"];
                    [YJLHUD dismissWithDelay:2.0f];
                }
                    break;
                case 4000:
                {
                    [YJLHUD showErrorWithmessage:@"支付失败"];
                    [YJLHUD dismissWithDelay:2.0f];
                }
                    break;
               
                default:{
                    [YJLHUD showErrorWithmessage:@"支付出错"];
                    [YJLHUD dismissWithDelay:2.0f];
                }
                    break;
            }
            
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        NSLog(@"服务器渣渣   ");
        [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:2.0f];
    }];
}

#pragma mark - 微信支付方法
- (void)sendWX{
    if ([WXApi isWXAppInstalled]) {
        
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"连接微信...."];
        total = [NSString stringWithFormat:@"%.2f",paystr_1.floatValue+paystr_2.floatValue+paystr_3.floatValue+paystr_4.floatValue+paystr_5.floatValue+paystr_6.floatValue];
        AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
        manager.responseSerializer          = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
        NSLog(@"支付金额:%@",total);
        
        NSDictionary *params =    @{
                                        @"total_fee":total
                                    };
        [manager POST:payWechat parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [YJLHUD dismiss];
            NSLog(@"返回数据%@",responseObject);
            //判断返回的许可
            if ([responseObject[@"result_code"] isEqualToString:@"SUCCESS"] && [responseObject[@"return_code"] isEqualToString:@"SUCCESS"]) {
                //发起微信支付，设置参数
                PayReq *request     =                   [[PayReq alloc] init];
                request.openID      = responseObject    [@"appid"           ];
                request.partnerId   = responseObject    [@"mch_id"          ];
                request.prepayId    = responseObject    [@"prepay_id"       ];
                request.package     =                    @"Sign=WXPay"      ;
                request.nonceStr    = responseObject    [@"nonce_str"       ];
                
                NSDate   * datenow  = [NSDate date];
                NSString * timeSp   = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
                UInt32 timeStamp    = [timeSp intValue];
                request.timeStamp   = timeStamp;
                DataMD5 *md5 = [[DataMD5 alloc] init];
                request.sign = [md5 createMD5SingForPay:request.openID partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
                //        NSLog(@"%@\n%@\n%@\n%@\n%d\n%@",request.partnerId,request.prepayId,request.package,request.nonceStr,request.timeStamp,request.sign);
                // 调用微信
                [WXApi sendReq:request];
                
            }else{
                
                NSLog(@"参数不正确，请检查参数");
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"服务器渣渣   ");
            [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
            [YJLHUD dismissWithDelay:2.0f];
        }];
    }
    else{
        [YJLHUD showErrorWithmessage:@"请先安装微信客户端"];
        [YJLHUD dismissWithDelay:1.0f];
    }
}

#pragma -mark 返回
-(void)Back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
}

@end
