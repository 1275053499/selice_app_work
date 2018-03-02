//
//  TransferSetmealController.m
//  铺皇
//
//  Created by selice on 2017/10/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "TransferSetmealController.h"
#import "Password.h"
#import "ZYKeyboardUtil.h"
#define MARGIN_KEYBOARD 10
#import "SafenumberController.h"
@interface TransferSetmealController ()<UIScrollViewDelegate,UITextFieldDelegate>{
  
      int  i ;
    NSInteger           _count;               //倒计时
    UIScrollView *  MainScroll;

    UIView  * viewone;
         UILabel * labone;
         UIView  * white11; //白块1
                 UILabel * white11_1;
                 UILabel * white11_2;
                 UILabel * white11_3;
         UIView  *white12;  //白块2
                 UILabel * white12_1;
                 UILabel * white12_2;
                 UILabel * white12_3;
    
         UIView  *white13;  //白块3
                 UILabel * white13_1;
                 UILabel * white13_2;
                 UILabel * white13_3;
    
    UIView *viewtwo;
        UILabel * labtwo;
        UIView  * white21; //白块1
                UILabel * white21_1;
                UILabel * white21_2;
                UILabel * white21_3;
        UIView  *white22;  //白块2
                UILabel * white22_1;
                UILabel * white22_2;
                UILabel * white22_3;
    
        UIView  *white23;  //白块3
                UILabel * white23_1;
                UILabel * white23_2;
                UILabel * white23_3;
    
    UIView *viewthr;
        UILabel * labthr;
        UIView  * white31; //白块1
                UILabel * white31_1;
                UILabel * white31_2;
                UILabel * white31_3;
        UIView  *white32;  //白块2
                UILabel * white32_1;
                UILabel * white32_2;
                UILabel * white32_3;
    
        UIView  *white33;  //白块3
                UILabel * white33_1;
                UILabel * white33_2;
    
    UILabel  *alertlab;     //提示内容
    UIButton *paybtn;       //支付按钮
    
   
    NSString * paystate1;        //服务状态
    NSString * paytype1;         //套餐类型
    NSString * paynum1;          //套餐积分
    NSString * paytime1;         //套餐时间
    
    
    
     NSString * paystate2;       //服务状态
    NSString * paytype2;         //套餐类型
    NSString * paynum2;          //套餐积分
    NSString * paytime2;         //套餐时间
    
    

     NSString * paystate3;       //服务状态
    NSString * paytype3;         //套餐类型
    NSString * paynum3;          //套餐积分
    NSString * paytime3;         //套餐时间
    
    NSString * totalpay;        //总积分
    NSString *paysetmeal;        //订单信息
    

  
}

@property (strong, nonatomic) UITextField    * white33_3;
@property (strong, nonatomic) ZYKeyboardUtil * keyboardUtil;

@end

@implementation TransferSetmealController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    i = 1;  //计数输入密码错误
    
    paystate1 = [NSString new];
    paystate1 = @"0";
    paystate2 = [NSString new];
    paystate2 = @"0";
    paystate3 = [NSString new];
    paystate3 = @"0";
    
    paytype1 = [NSString new];
    paytype1 = @"0";
    paytype2 = [NSString new];
    paytype2 = @"0";
    paytype3 = [NSString new];
    paytype3 = @"0";
    
    totalpay = [NSString new];
    paysetmeal = [NSString new];

    if (self.isContract.length>0) {
        
        self.navigationItem.title = @"续约服务";
    }
    else{
        self.navigationItem.title = @"开通转让服务";
    }
    
    UIBarButtonItem *backItm  = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(Back:)];
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor whiteColor];
 
    MainScroll                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+64)];
    MainScroll.userInteractionEnabled         = YES;
    MainScroll.showsVerticalScrollIndicator   = YES;
    MainScroll.showsHorizontalScrollIndicator = YES;
    MainScroll.delegate                       = self;
    MainScroll.backgroundColor                = kTCColor(255, 255, 255);
    MainScroll.contentSize                    = CGSizeMake(KMainScreenWidth, 720);
    [self.view addSubview:MainScroll];

    [self buildtopview];
    [self buildbottomview];
    
    //    添加手势点击可以让键盘下去
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [MainScroll addGestureRecognizer:tap];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
}

#pragma -mark 点击scrollowview键盘下去
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.white33_3 resignFirstResponder];
}

-(void)buildtopview{
    
#pragma -mark     服务 1 首页展示
    viewone = [[UIView alloc]init];
    viewone.backgroundColor =kTCColor(229, 229, 229);
    [MainScroll addSubview:viewone];
    [viewone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, (KMainScreenWidth-60)/3+54));
        make.left.equalTo(MainScroll).with.offset(0);
        make.top.equalTo (MainScroll).with.offset(0);
    }];
    
#pragma -mark     服务 1 首页展示 标题
    labone               = [[UILabel alloc]init];
    labone.textAlignment = NSTextAlignmentLeft;
    labone.text          = @"首页展示";
    labone.font          = [UIFont systemFontOfSize:18.0f];
    [viewone addSubview:labone];
    [labone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.equalTo(viewone).with.offset(16);
        make.left.equalTo(viewone).with.offset(20);
    }];
    
#pragma -mark 首页展示 服务7天 start
    white11 = [[UIView alloc]init];
    white11.backgroundColor         = [UIColor whiteColor];
    white11.layer.cornerRadius      = 10;
    white11.layer.borderWidth       = 2.0f;
    white11.layer.masksToBounds     = YES;
    white11.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [viewone addSubview:white11];
    [white11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(viewone).with.offset(20);
        make.top.equalTo(labone.mas_bottom).with.offset(16);
    }];
    white11.userInteractionEnabled     = YES;
    UITapGestureRecognizer *white11GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white11Gesclick:)];
    [white11 addGestureRecognizer:white11GES];
    
    white11_1            = [[UILabel alloc]init];
    white11_1.text       =  @"效率快，范围广";
    white11_1.font       = [UIFont systemFontOfSize:12.0f];
    white11_1.textColor  =kTCColor(101, 101, 101);
    [white11 addSubview:white11_1];
    [white11_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white11).with.offset(10);
        make.top.equalTo(white11).with.offset(12);
    }];
    
    white11_2            = [[UILabel alloc]init];
    white11_2.text       = @"服务7天";
    white11_2.font       = [UIFont systemFontOfSize:15.0f];
    white11_2.textColor  = kTCColor(0, 0, 0);
    [white11 addSubview:white11_2];
    [white11_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white11).with.offset(10);
        make.top.equalTo(white11_1.mas_bottom).with.offset(12);
    }];
     white11_3            = [[UILabel alloc]init];
    NSString *string11_3  = @"2800";
    NSString *string211_3 = [NSString stringWithFormat:@"%@积分",string11_3];
    NSMutableAttributedString *stra11_3  = [[NSMutableAttributedString alloc]initWithString:string211_3];//可随意拼接字符串
    [stra11_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string11_3.length)];
    white11_3.attributedText             = stra11_3;
    white11_3.font                       = [UIFont systemFontOfSize:18.0f];
    [white11 addSubview:white11_3];
    [white11_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white11).with.offset(10);
        make.top.equalTo(white11_2.mas_bottom).with.offset(12);
    }];
#pragma -mark 首页展示 服务7天 end
#pragma -mark 首页展示 服务30天 start
    white12                         = [[UIView alloc]init];
    white12.backgroundColor         = [UIColor whiteColor];
    white12.layer.cornerRadius      = 10;
    white12.layer.borderWidth       = 2.0f;
    white12.layer.masksToBounds     = YES;
    white12.layer.borderColor      = [[UIColor whiteColor] CGColor];//框白颜色
    [viewone addSubview:white12];
    [white12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(white11.mas_right).with.offset(10);
        make.top.equalTo(labone.mas_bottom).with.offset(16);
    }];
    white12.userInteractionEnabled      = YES;
    UITapGestureRecognizer *white12GES  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white12Gesclick:)];
    [white12 addGestureRecognizer:white12GES];
    
    white12_1            = [[UILabel alloc]init];
    white12_1.text       =  @"效率快，范围广";
    white12_1.font       = [UIFont systemFontOfSize:12.0f];
    white12_1.textColor  = kTCColor(101, 101, 101);
    [white12 addSubview:white12_1];
    [white12_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white12).with.offset(10);
        make.top.equalTo(white12).with.offset(12);
    }];
    
    white12_2            = [[UILabel alloc]init];
    white12_2.text       =  @"服务30天";
    white12_2.font       = [UIFont systemFontOfSize:15.0f];
    white12_2.textColor  = kTCColor(0, 0, 0);
    [white12 addSubview:white12_2];
    [white12_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white12).with.offset(10);
        make.top.equalTo(white12_1.mas_bottom).with.offset(12);
    }];
    
    white12_3             = [[UILabel alloc]init];
    NSString *string12_3  = @"6000";
    NSString *string212_3 = [NSString stringWithFormat:@"%@积分",string12_3];
    NSMutableAttributedString *stra12_3 = [[NSMutableAttributedString alloc]initWithString:string212_3];//可随意拼接字符串
    [stra12_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string12_3.length)];
    white12_3.attributedText=stra12_3;
    white12_3.font        = [UIFont systemFontOfSize:18.0f];
    [white12 addSubview:white12_3];
    [white12_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white12).with.offset(10);
        make.top.equalTo(white12_2.mas_bottom).with.offset(12);
    }];
#pragma -mark  首页展示 服务30天 end
    
#pragma -mark  首页展示 服务90天 start
    white13 = [[UIView alloc]init];
    white13.backgroundColor         = [UIColor whiteColor];
    white13.layer.cornerRadius      = 10;
    white13.layer.borderWidth       = 2.0f;
    white13.layer.masksToBounds     = YES;
    white13.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [viewone addSubview:white13];
    [white13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(white12.mas_right).with.offset(10);
        make.top.equalTo(labone.mas_bottom).with.offset(16);
    }];
    white13.userInteractionEnabled = YES;
    UITapGestureRecognizer *white13GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white13Gesclick:)];
    [white13 addGestureRecognizer:white13GES];
    
    white13_1            = [[UILabel alloc]init];
    white13_1.text       =  @"效率快，范围广";
    white13_1.font       = [UIFont systemFontOfSize:12.0f];
    white13_1.textColor  = kTCColor(101, 101, 101);
    [white13 addSubview:white13_1];
    [white13_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white13).with.offset(10);
        make.top.equalTo(white13).with.offset(12);
    }];
    white13_2            = [[UILabel alloc]init];
    white13_2.text       =  @"服务90天";
    white13_2.font       = [UIFont systemFontOfSize:15.0f];
    white13_2.textColor  = kTCColor(0, 0, 0);
    [white13 addSubview:white13_2];
    [white13_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white13).with.offset(10);
        make.top.equalTo(white13_1.mas_bottom).with.offset(12);
    }];
    
    white13_3             = [[UILabel alloc]init];
    NSString *string13_3  = @"15000";
    NSString *string213_3 = [NSString stringWithFormat:@"%@积分",string13_3];
    NSMutableAttributedString *stra13_3 = [[NSMutableAttributedString alloc]initWithString:string213_3];//可随意拼接字符串
    [stra13_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string13_3.length)];
    white13_3.attributedText=stra13_3;
    white13_3.font       = [UIFont systemFontOfSize:18.0f];
    [white13 addSubview:white13_3];
    [white13_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white13).with.offset(10);
        make.top.equalTo(white13_2.mas_bottom).with.offset(12);
    }];

    
#pragma -mark     服务2  信息展示+地图推荐
    //    信息展示+地图推荐 灰色view
    viewtwo = [[UIView alloc]init];
    viewtwo.backgroundColor =kTCColor(229, 229, 229);
    [MainScroll addSubview:viewtwo];
    [viewtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, (KMainScreenWidth-60)/3+54));
        make.left.equalTo(MainScroll).with.offset(0);
        make.top.equalTo (viewone.mas_bottom).with.offset(0);
    }];
    
#pragma -mark     服务2 信息展示+地图推荐 标题
    labtwo = [[UILabel alloc]init];
    labtwo.textAlignment = NSTextAlignmentLeft;
    labtwo.text = @"信息展示+地图推荐";
    labtwo.font  = [UIFont systemFontOfSize:18.0f];
    [viewtwo addSubview:labtwo];
    [labtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewtwo).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.left.equalTo(viewtwo).with.offset(20);
    }];

#pragma -mark 信息展示+地图推荐 服务7天 start
    white21 = [[UIView alloc]init];
    white21.backgroundColor         = [UIColor whiteColor];
    white21.layer.cornerRadius      = 10;
    white21.layer.borderWidth       = 2.0f;
    white21.layer.masksToBounds     = YES;
    white21.layer.borderColor      = [[UIColor whiteColor] CGColor];//框白颜色
    [viewtwo addSubview:white21];
    [white21 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(viewtwo).with.offset(20);
        make.top.equalTo(labtwo.mas_bottom).with.offset(16);
    }];
    white21.userInteractionEnabled = YES;
    UITapGestureRecognizer *white21GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white21Gesclick:)];
    [white21 addGestureRecognizer:white21GES];

    white21_1            = [[UILabel alloc]init];
    white21_1.text       =  @"效率快，范围广";
    white21_1.font       = [UIFont systemFontOfSize:12.0f];
    white21_1.textColor  =kTCColor(101, 101, 101);
    [white21 addSubview:white21_1];
    [white21_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white21).with.offset(10);
        make.top.equalTo(white21).with.offset(12);
    }];

    white21_2            = [[UILabel alloc]init];
    white21_2.text       =  @"服务7天";
    white21_2.font       = [UIFont systemFontOfSize:15.0f];
    white21_2.textColor  =kTCColor(0, 0, 0);
    [white21 addSubview:white21_2];
    [white21_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white21).with.offset(10);
        make.top.equalTo(white21_1.mas_bottom).with.offset(12);
    }];

    white21_3            = [[UILabel alloc]init];
    NSString *string21_3 = @"500";
    NSString *string221_3 = [NSString stringWithFormat:@"%@积分",string21_3];
    NSMutableAttributedString *stra21_3 = [[NSMutableAttributedString alloc]initWithString:string221_3];//可随意拼接字符串
    [stra21_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string21_3.length)];
    white21_3.attributedText=stra21_3;
    white21_3.font       = [UIFont systemFontOfSize:18.0f];
    [white21 addSubview:white21_3];
    [white21_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white21).with.offset(10);
        make.top.equalTo(white21_2.mas_bottom).with.offset(12);
    }];
#pragma -mark 信息展示+地图推荐 服务7天 end

#pragma -mark 信息展示+地图推荐 服务30天 start
    white22 = [[UIView alloc]init];
    white22.backgroundColor         = [UIColor whiteColor];
    white22.layer.cornerRadius      = 10;
    white22.layer.borderWidth       = 2.0f;
    white22.layer.masksToBounds     = YES;
    white22.layer.borderColor      = [[UIColor whiteColor] CGColor];//框白颜色
    [viewtwo addSubview:white22];
    [white22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(white21.mas_right).with.offset(10);
        make.top.equalTo(labtwo.mas_bottom).with.offset(16);
    }];
    white22.userInteractionEnabled = YES;
    UITapGestureRecognizer *white22GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white22Gesclick:)];
    [white22 addGestureRecognizer:white22GES];

    white22_1            = [[UILabel alloc]init];
    white22_1.text       =  @"效率快，范围广";
    white22_1.font       = [UIFont systemFontOfSize:12.0f];
    white22_1.textColor  =kTCColor(101, 101, 101);
    [white22 addSubview:white22_1];
    [white22_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22).with.offset(12);
    }];
    
    white22_2            = [[UILabel alloc]init];
    white22_2.text       =  @"服务30天";
    white22_2.font       = [UIFont systemFontOfSize:15.0f];
    white22_2.textColor  =kTCColor(0, 0, 0);
    [white22 addSubview:white22_2];
    [white22_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22_1.mas_bottom).with.offset(12);
    }];

    white22_3            = [[UILabel alloc]init];
    NSString *string22_3 = @"1800";
    NSString *string222_3 = [NSString stringWithFormat:@"%@积分",string22_3];
    NSMutableAttributedString *stra22_3 = [[NSMutableAttributedString alloc]initWithString:string222_3];//可随意拼接字符串
    [stra22_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string22_3.length)];
    white22_3.attributedText=stra22_3;
    white22_3.font       = [UIFont systemFontOfSize:18.0f];
    [white22 addSubview:white22_3];
    [white22_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22_2.mas_bottom).with.offset(12);
    }];
#pragma -mark  信息展示+地图推荐 服务30天 end

#pragma -mark  首信息展示+地图推荐 服务90天 start
    white23 = [[UIView alloc]init];
    white23.backgroundColor         = [UIColor whiteColor];
    white23.layer.cornerRadius      = 10;
    white23.layer.borderWidth       = 2.0f;
    white23.layer.masksToBounds     = YES;
    white23.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [viewtwo addSubview:white23];
    [white23 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(white22.mas_right).with.offset(10);
        make.top.equalTo(labtwo.mas_bottom).with.offset(16);
    }];
    white23.userInteractionEnabled = YES;
    UITapGestureRecognizer *white23GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white23Gesclick:)];
    [white23 addGestureRecognizer:white23GES];

    white23_1            = [[UILabel alloc]init];
    white23_1.text       =  @"效率快，范围广";
    white23_1.font       = [UIFont systemFontOfSize:12.0f];
    white23_1.textColor  =kTCColor(101, 101, 101);
    [white23 addSubview:white23_1];
    [white23_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23).with.offset(12);
    }];
    white23_2            = [[UILabel alloc]init];
    white23_2.text       =  @"服务90天";
    white23_2.font       = [UIFont systemFontOfSize:15.0f];
    white23_2.textColor  =kTCColor(0, 0, 0);
    [white23 addSubview:white23_2];
    [white23_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23_1.mas_bottom).with.offset(12);
    }];

    white23_3            = [[UILabel alloc]init];
    NSString *string23_3 = @"4200";
    NSString *string223_3 = [NSString stringWithFormat:@"%@积分",string23_3];
    NSMutableAttributedString *stra23_3 = [[NSMutableAttributedString alloc]initWithString:string223_3];//可随意拼接字符串
    [stra23_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string23_3.length)];
    white23_3.attributedText=stra23_3;
    white23_3.font       = [UIFont systemFontOfSize:18.0f];
    [white23 addSubview:white23_3];
    [white23_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23_2.mas_bottom).with.offset(12);
    }];
#pragma -mark  信息展示+地图推荐 服务90天 end
    
#pragma -mark  服务 3 资源匹配
    //   资源匹配 灰色view
    viewthr = [[UIView alloc]init];
    viewthr.backgroundColor =kTCColor(229, 229, 229);
    [MainScroll addSubview:viewthr];
    [viewthr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, (KMainScreenWidth-60)/3+64));
        make.left.equalTo(MainScroll).with.offset(0);
        make.top.equalTo (viewtwo.mas_bottom).with.offset(0);
    }];
    
#pragma -mark     服务 3 资源匹配 标题
    labthr = [[UILabel alloc]init];
    labthr.textAlignment = NSTextAlignmentLeft;
    labthr.text = @"资源匹配";
    labthr.font  = [UIFont systemFontOfSize:18.0f];
    [viewthr addSubview:labthr];
    [labthr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewthr).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.left.equalTo(viewthr).with.offset(20);
    }];
    
#pragma -mark 资源匹配 20个 start
    white31 = [[UIView alloc]init];
    white31.backgroundColor         = [UIColor whiteColor];
    white31.layer.cornerRadius      = 10;
    white31.layer.borderWidth       = 2.0f;
    white31.layer.masksToBounds     = YES;
    white31.layer.borderColor      = [[UIColor whiteColor] CGColor];//框白颜色
    [viewthr addSubview:white31];
    [white31 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(viewthr).with.offset(20);
        make.top.equalTo(labthr.mas_bottom).with.offset(16);
    }];
    white31.userInteractionEnabled = YES;
    UITapGestureRecognizer *white31GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white31Gesclick:)];
    [white31 addGestureRecognizer:white31GES];

    white31_1            = [[UILabel alloc]init];
    white31_1.text       =  @"效率快，范围广";
    white31_1.font       = [UIFont systemFontOfSize:12.0f];
    white31_1.textColor  =kTCColor(101, 101, 101);
    [white31 addSubview:white31_1];
    [white31_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white31).with.offset(10);
        make.top.equalTo(white31).with.offset(12);
    }];

    white31_2            = [[UILabel alloc]init];
    white31_2.text       =  @"20个资源";
    white31_2.font       = [UIFont systemFontOfSize:15.0f];
    white31_2.textColor  =kTCColor(0, 0, 0);
    [white31 addSubview:white31_2];
    [white31_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white31).with.offset(10);
        make.top.equalTo(white31_1.mas_bottom).with.offset(12);
    }];

    white31_3            = [[UILabel alloc]init];
    NSString *string31_3 = @"960";
    NSString *string231_3 = [NSString stringWithFormat:@"%@积分",string31_3];
    NSMutableAttributedString *stra31_3 = [[NSMutableAttributedString alloc]initWithString:string231_3];//可随意拼接字符串
    [stra31_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string31_3.length)];
    white31_3.attributedText=stra31_3;
    white31_3.font       = [UIFont systemFontOfSize:18.0f];
    [white31 addSubview:white31_3];
    [white31_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white31).with.offset(10);
        make.top.equalTo(white31_2.mas_bottom).with.offset(12);
    }];
#pragma -mark 资源匹配 20个  end
#pragma -mark 资源匹配 40个  start
    white32 = [[UIView alloc]init];
    white32.backgroundColor         = [UIColor whiteColor];
    white32.layer.cornerRadius      = 10;
    white32.layer.borderWidth       = 2.0f;
    white32.layer.masksToBounds     = YES;
    white32.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [viewthr addSubview:white32];
    [white32 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(white31.mas_right).with.offset(10);
        make.top.equalTo(labthr.mas_bottom).with.offset(16);
    }];
    white32.userInteractionEnabled = YES;
    UITapGestureRecognizer *white32GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white32Gesclick:)];
    [white32 addGestureRecognizer:white32GES];

    white32_1            = [[UILabel alloc]init];
    white32_1.text       =  @"效率快，范围广";
    white32_1.font       = [UIFont systemFontOfSize:12.0f];
    white32_1.textColor  =kTCColor(101, 101, 101);
    [white32 addSubview:white32_1];
    [white32_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white32).with.offset(10);
        make.top.equalTo(white32).with.offset(12);
    }];
    
    white32_2            = [[UILabel alloc]init];
    white32_2.text       =  @"40个资源";
    white32_2.font       = [UIFont systemFontOfSize:15.0f];
    white32_2.textColor  =kTCColor(0, 0, 0);
    [white32 addSubview:white32_2];
    [white32_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white32).with.offset(10);
        make.top.equalTo(white32_1.mas_bottom).with.offset(12);
    }];

    white32_3                 = [[UILabel alloc]init];
    NSString *string32_3      = @"1920";
    NSString *string232_3     = [NSString stringWithFormat:@"%@积分",string32_3];
    NSMutableAttributedString *stra32_3   = [[NSMutableAttributedString alloc]initWithString:string232_3];//可随意拼接字符串
    [stra32_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string32_3.length)];
    white32_3.attributedText  = stra32_3;
    white32_3.font            = [UIFont systemFontOfSize:18.0f];
    [white32 addSubview:white32_3];
    [white32_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white32).with.offset(10);
        make.top.equalTo(white32_2.mas_bottom).with.offset(12);
    }];
    
#pragma -mark 资源匹配 40个  end
    
#pragma -mark 资源匹配 自定义购买量 start
    white33 = [[UIView alloc]init];
    white33.backgroundColor         = [UIColor whiteColor];
    white33.layer.cornerRadius      = 10;
    white33.layer.borderWidth       = 2.0f;
    white33.layer.masksToBounds     = YES;
    white33.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [viewthr addSubview:white33];
    [white33 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(white32.mas_right).with.offset(10);
        make.top.equalTo(labthr.mas_bottom).with.offset(16);
    }];

    white33_1            = [[UILabel alloc]init];
    white33_1.text       =  @"效率快，范围广";
    white33_1.font       = [UIFont systemFontOfSize:12.0f];
    white33_1.textColor  = kTCColor(101, 101, 101);
    [white33 addSubview:white33_1];
    [white33_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white33).with.offset(10);
        make.top.equalTo(white33).with.offset(12);
    }];
    white33_2            = [[UILabel alloc]init];
    white33_2.text       =  @"20个起售";
    white33_2.font       = [UIFont systemFontOfSize:15.0f];
    white33_2.textColor  = kTCColor(0, 0, 0);
    [white33 addSubview:white33_2];
    [white33_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white33).with.offset(10);
        make.top.equalTo(white33_1.mas_bottom).with.offset(12);
    }];

    self.white33_3                    = [[UITextField alloc]init];
    self.white33_3.textColor          = [UIColor redColor];
    self.white33_3.placeholder        = @"填写购买量";
    self.white33_3.delegate           = self;
    self.white33_3.returnKeyType      = UIReturnKeyDone;
    self.white33_3.font               = [UIFont systemFontOfSize:14.0f];
    self.white33_3.textAlignment      = NSTextAlignmentCenter;
    self.white33_3.keyboardType       = UIKeyboardTypeNumberPad;
    self.white33_3.clearButtonMode    = UITextFieldViewModeWhileEditing;
    self.white33_3.borderStyle=UITextBorderStyleRoundedRect;
    [self.white33_3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [white33 addSubview:self.white33_3];
    [self.white33_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-20, 20));
        make.left.equalTo(white33).with.offset(10);
        make.top.equalTo(white33_2.mas_bottom).with.offset(12);
    }];
    
    //键盘处理 抬起
    [self configKeyBoardRespond];
#pragma -mark  资源匹配  end
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak TransferSetmealController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.white33_3,nil];
    }];
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

#pragma mark - UITextFieldDelegate开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    NSLog(@"开始编辑");
    white31.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white32.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white33.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
}


+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(string.length > 0)
        
    {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.white33_3 resignFirstResponder];
   
    paytype3            = @"3";        //第三个
    paynum3             = [NSString stringWithFormat:@"%ld积分",[self.white33_3.text integerValue]*48];//总积分
    if ([self.white33_3.text integerValue] < 20) {
        self.white33_3.text = @"20";
    }
    paytime3            = [NSString stringWithFormat:@"%@个资源",self.white33_3.text];                 //购买个数
    paystate3           = @"1";       //服务开通状态
}

#pragma 当点击键盘的返回键键盘下去
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.white33_3 resignFirstResponder];
  
    paytype3            = @"3";       //第三个
    paynum3             = [NSString stringWithFormat:@"%ld积分",[self.white33_3.text integerValue]*48];//总积分
    if ([self.white33_3.text integerValue] < 20) {
        self.white33_3.text = @"20";
    
    }
    paytime3            = [NSString stringWithFormat:@"%@个资源",self.white33_3.text];                 //购买个数
    paystate3           = @"1";      //服务开通状态
    return YES;
}

#pragma mark - self.white33_3 限制购买量字数
-(void)textFieldDidChange:(UITextField *)textField{
    
    if (textField == self.white33_3) {
        if (textField.text.length >3) {
             textField.text = [textField.text substringToIndex:3];
        }
    }
}

-(void)white11Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"首页展示 2800积分 服务7天");
    white11.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white12.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white13.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [self.white33_3 resignFirstResponder];
  
    paytype1        = @"1";       // 第1个
    paynum1         =[NSString stringWithFormat:@"2800"];                      //总积分
    paytime1        =[NSString stringWithFormat:@"服务7天"];                  //服务时间
    paystate1       = @"1";     //服务开通状态
}

-(void)white12Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"首页展示 6000积分 服务30天");
    white12.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white13.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white11.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
   [self.white33_3 resignFirstResponder];

    paytype1        = @"2";       // 第2个
    paynum1         =[NSString stringWithFormat:@"6000"];                      //总积分
    paytime1        =[NSString stringWithFormat:@"服务30天"];                  //服务时间
    paystate1       = @"1";     //服务开通状态
}

-(void)white13Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"首页展示 15000积分 服务90天");
    white13.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white11.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white12.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [self.white33_3 resignFirstResponder];
   
    paytype1        = @"3";       // 第3个
    paynum1         =[NSString stringWithFormat:@"15000"];                      //总积分
    paytime1        =[NSString stringWithFormat:@"服务90天"];                  //服务时间
    paystate1       = @"1";     //服务开通状态
}

-(void)white21Gesclick:(UIGestureRecognizer*)GES{
     NSLog(@"信息展示+地图推荐 500积分 服务7天");
    white21.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white22.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white23.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
   [self.white33_3 resignFirstResponder];
   
    paytype2        = @"1";       // 第1个
    paynum2         =[NSString stringWithFormat:@"500"];                      //总积分
    paytime2        =[NSString stringWithFormat:@"服务7天"];                  //服务时间
    paystate2       = @"1";     //服务开通状态
}

-(void)white22Gesclick:(UIGestureRecognizer*)GES{
     NSLog(@"信息展示+地图推荐 1800积分 服务30天");
    white21.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white22.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white23.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
   [self.white33_3 resignFirstResponder];
    
    paytype2        = @"2";       // 第2个
    paynum2         =[NSString stringWithFormat:@"1800"];                      //总积分
    paytime2        =[NSString stringWithFormat:@"服务30天"];                  //服务时间
    paystate2       = @"1";     //服务开通状态
}

-(void)white23Gesclick:(UIGestureRecognizer*)GES{
     NSLog(@"信息展示+地图推荐 4200积分 服务90天");
    white21.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white22.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white23.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
   [self.white33_3 resignFirstResponder];

    paytype2        = @"3";       // 第3个
    paynum2         =[NSString stringWithFormat:@"4200"];                      //总积分
    paytime2        =[NSString stringWithFormat:@"服务90天"];                  //服务时间
    paystate2       = @"1";     //服务开通状态
    
}

-(void)white31Gesclick:(UIGestureRecognizer*)GES{
    
    NSLog(@"资源购买 960积分 20");
    white31.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white32.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white33.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    self.white33_3.text = @"";
    [self.white33_3 resignFirstResponder];
 
    paytype3        = @"1";       // 第1个
    paynum3         =[NSString stringWithFormat:@"960"];                      //总积分
    paytime3        =[NSString stringWithFormat:@"20个资源"];                  //购买个数
    paystate3       = @"1";     //服务开通状态
}

-(void)white32Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"资源购买 1920积分 40");
    white32.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white31.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white33.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色w
    self.white33_3.text = @"";
   [self.white33_3 resignFirstResponder];

    paytype3        = @"2";       // 第1个
    paynum3         =   [NSString stringWithFormat:@"1920"];                      //总积分
    paytime3        =   [NSString stringWithFormat:@"40个资源"];                  //购买个数
    paystate3       = @"1";     //服务开通状态
}

#pragma -mark 底部
-(void)buildbottomview{
    alertlab= [[UILabel alloc]init];
    alertlab.text = @"温馨提示\n\n1.积分业务一经开通支付后不支持退款；\n\n2.充值后若还是无法正常使用，请尝试联系客服；";
    alertlab.textColor        = [UIColor blackColor];
    alertlab.textAlignment    = NSTextAlignmentLeft;
    alertlab.numberOfLines    = 0;
    alertlab.font             = [UIFont systemFontOfSize:12.0f];
    [MainScroll addSubview:alertlab];
    [alertlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 100));
        make.top.equalTo(viewthr.mas_bottom).with.offset(10);
        make.left.equalTo(MainScroll).with.offset(20);
    }];
    
    //    按钮
    paybtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isContract.length>0) {
        
         [paybtn setTitle:@"续约套餐" forState:UIControlStateNormal];
    }
    
    else{
         [paybtn setTitle:@"购买套餐" forState:UIControlStateNormal];
    }
   
    [paybtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    paybtn.titleLabel.font  = [UIFont systemFontOfSize:20.0f];
    [paybtn setTintColor:[UIColor whiteColor]];
    [paybtn addTarget:self action:@selector(payclick:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:paybtn];
    [paybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 32));
        make.left.equalTo(MainScroll).with.offset(20);
        make.top.equalTo(alertlab.mas_bottom).with.offset(20);
    }];
}

//需要消耗积分
#pragma -mark 支付按钮点击事件
-(void)payclick:(id)sender{
    
    if ([paystate1 isEqualToString:@"0"] & [paystate2 isEqualToString:@"0"] & [paystate3 isEqualToString:@"0"]) {
        NSLog(@"没有选择套餐");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️提示" message:@"您还未选择一款套餐，不支持执行支付" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                           NSLog(@"点击了确认");
            
       }];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    else{

    NSLog(@"支付点击.....");
    NSString *paysetmeal1 = [NSString new];
    if (paytime1.length >0) {
        paysetmeal1 = [NSString stringWithFormat:@"%@:%@ %@积分",labone.text,paytime1,paynum1];
    }
    else{
        paysetmeal1 = @"";
    }
    NSString *paysetmeal2 = [NSString new];
    if (paytime2.length >0) {
        paysetmeal2 = [NSString stringWithFormat:@"%@:%@ %@积分",labtwo.text,paytime2,paynum2];
    }
    else{
        paysetmeal2 = @"";
    }
    NSString *paysetmeal3 = [NSString new];
    if (paytime3.length >0) {
        paysetmeal3 = [NSString stringWithFormat:@"%@:%@ %@积分",labthr.text,paytime3,paynum3];
    }
    else{
        paysetmeal3 = @"";
    }
    
//        处理订单信息展示
    totalpay = [NSString stringWithFormat:@"%ld",[paynum1 integerValue]+[paynum2 integerValue]+[paynum3 integerValue]];//积分累计
        if (paysetmeal1.length>1) {
            if (paysetmeal2.length>1&&paysetmeal3.length>1) {
                 paysetmeal  = [NSString stringWithFormat:@"%@\n%@\n%@\n需要消费积分:%@积分",paysetmeal1,paysetmeal2,paysetmeal3,totalpay];
            }else if (paysetmeal2.length>1&&paysetmeal3.length<1){
                 paysetmeal  = [NSString stringWithFormat:@"%@\n%@\n需要消费积分:%@积分",paysetmeal1,paysetmeal2,totalpay];
            }
            else if (paysetmeal2.length<1&&paysetmeal3.length>1){
                paysetmeal  = [NSString stringWithFormat:@"%@\n%@\n需要消费积分:%@积分",paysetmeal1,paysetmeal3,totalpay];
            }else{
                 paysetmeal  = [NSString stringWithFormat:@"%@\n需要消费积分:%@积分",paysetmeal1,totalpay];
            }
        }
        else{
            if (paysetmeal2.length>1&&paysetmeal3.length>1) {
                paysetmeal  = [NSString stringWithFormat:@"%@\n%@\n需要消费积分:%@积分",paysetmeal2,paysetmeal3,totalpay];
            }else if (paysetmeal2.length>1&&paysetmeal3.length<1){
                paysetmeal  = [NSString stringWithFormat:@"%@\n需要消费积分:%@积分",paysetmeal2,totalpay];
            }
            else{
                paysetmeal  = [NSString stringWithFormat:@"%@\n需要消费积分:%@积分",paysetmeal3,totalpay];
            }
        }
   
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = @"确认订单";
        label.textColor = [UIColor blackColor];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = paysetmeal;
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
        action.type            = LEEActionTypeDefault;
        action.title           = @"立即支付";
        action.titleColor      = kTCColor(255, 255, 255);
        action.backgroundColor = kTCColor(77, 166, 214);
        action.clickBlock      = ^{
            
            
            if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLTouchIDneed] isEqualToString:@"yes"]){
                
                LAContext *laContext = [[LAContext alloc] init];
                NSError *error = nil;
                
                if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
                    
                    [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                              localizedReason:@"需要授权Touch ID购买服务套餐"
                                        reply:^(BOOL success, NSError *error) {
                                            if (success) {
                                                NSLog(@"success to evaluate");
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    [self payintergal];
                                                });
                                                
                                            }
                                            
                                            if (error) {
                                                
                                                NSLog(@"---failed to evaluate---error: %@---", error.description);
                                            }
                                        }];
                }
                
                else {//指纹识别错误
                    
                    NSLog(@"==========Not support :%@", error.description);
                }
            }
            
            else{//么有开启指纹
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您尚未开启使用Touch ID进行支付，是否开启" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    
                    NSLog(@"开启");
                   
                    SafeController * NUMBER  = [[SafeController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:NUMBER animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }];
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"使用支付密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    
                    NSLog(@"使用支付密码");
                    
//                    NSString *HasPaycode = [[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpassword];
                    if ([[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpassword].length<1) {
                        //没有支付密码
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未设置支付密码，是否需要设置" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                            
                            NSLog(@"前往设置");
                            SafenumberController *ctl =[[SafenumberController alloc]init];
                            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                            [self.navigationController pushViewController:ctl animated:YES];
                            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                            
                        }];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                            
                            NSLog(@"取消");
                            
                        }];
                        
                        [alertController addAction:cancelAction];
                        [alertController addAction:commitAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                    else{
                        //有支付密码
                        if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpasswordopen] isEqualToString:@"openPay"]) {
                            //openPay 开启了支付验证的
                            //弹出式密码框
                            Password *passView = [[Password alloc]initSingleBtnView];
                            passView.passWordTextConfirm =^(NSString *text){
                                
                                NSLog(@"输入密码：%@",text);
                                NSLog(@"点击了确定按钮 验证密码是否正确");
                                //点击确定按钮输出密码
                                if ( [[[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpassword] isEqualToString:text]) {
                                    NSLog(@"输入密码正确");
#pragma     付钱方法
                                    [self payintergal];
                                    
                                }else{
                                    
                                    NSLog(@"输入密码错误");
                                   
                                     [YJLHUD showErrorWithmessage:@"支付密码输入错误"];
                                    [YJLHUD dismissWithDelay:2];
                                    
                                }
                            };
                            [passView show];//支付密码输入页面出现
                        }
                        
                        else{   //closePay 关闭了支付验证的
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未开启密码认证，是否需要开启" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"前往开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                
                                NSLog(@"前往开启支付验证开关");
                               
                                SafenumberController *ctl =[[SafenumberController alloc]init];//套餐页面
                                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                [self.navigationController pushViewController:ctl animated:YES];
                                self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                
                            }];
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                
                                NSLog(@"取消");
                                
                            }];
                            
                            [alertController addAction:cancelAction];
                            [alertController addAction:commitAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                        }
                    }
                    
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    NSLog(@"不用");
                }];
                
                [alertController addAction:commitAction];
                [alertController addAction:otherAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        };
    })
    .LeeHeaderColor(kTCColor(255, 255, 255))
    .LeeShow();
    }
}



#pragma 付钱方法
-(void)payintergal{

    NSLog(@"%@",self.isContractshopid);
    
    if ([self.isContract isEqualToString:@"isContract"]){
         [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"续约中...."];
    }else{
        
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"购买中...."];
    }
    
#pragma     付钱开始
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];

     NSLog(@"总积分:%@-信息状态：%@-信息套餐：%@-资源状态:%@-资源套餐:%@-资源数量:%@",totalpay,paystate1,paytype1,paystate2,paytype2,self.white33_3.text);
    
    NSDictionary *params = [[NSDictionary alloc]init];
    if ([self.isContract isEqualToString:@"isContract"]) {
        params = @{
                                 @"id"            :[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                                 @"shopid"        :self.isContractshopid,
                                 @"vip_integral"  :totalpay ,
                                 @"home"          :paystate1,
                                 @"home_type"     :paytype1 ,
                                 @"display"       :paystate2,
                                 @"map_type"      :paytype2 ,
                                 @"resource"      :paystate3,
                                 @"resource_type" :paytype3,
                                 @"resources"  :self.white33_3.text
 
                                 };
    }
    
    else{
        params = @{
                             
                             @"id"            :[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                             @"vip_integral"  :totalpay ,
                             @"home"          :paystate1,
                             @"home_type"     :paytype1 ,
                             @"display"       :paystate2,
                             @"map_type"      :paytype2 ,
                             @"resource"      :paystate3,
                             @"resource_type" :paytype3,
                             @"resources"  :self.white33_3.text
                             
                             };
    }
    
    NSLog(@"用户ID:%@",params);

    [manager POST:MyserviceZRpath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
//        //   总积分
//        [formData appendPartWithFormData:[totalpay dataUsingEncoding:NSUTF8StringEncoding] name:@"vip_integral"];
//        NSLog(@" 总积分:%@",totalpay);
//
//        //    首页服务开通状态
//        [formData appendPartWithFormData:[paystate1 dataUsingEncoding:NSUTF8StringEncoding] name:@"home"];
//        NSLog(@" 首页服务开通状态:%@",paystate1);
//
//        //    首页服务 套餐 ？
//        [formData appendPartWithFormData:[paytype1 dataUsingEncoding:NSUTF8StringEncoding] name:@"home_type"];
//        NSLog(@" 首页服务 套餐 ？:%@",paytype1);
//
//        //    地图推荐服务开通状态
//        [formData appendPartWithFormData:[paystate2 dataUsingEncoding:NSUTF8StringEncoding] name:@"display"];
//        NSLog(@" 地图推荐服务开通状态:%@",paystate2);
//
//        //    地图推荐 套餐 ？
//        [formData appendPartWithFormData:[paytype2 dataUsingEncoding:NSUTF8StringEncoding] name:@"map_type"];
//        NSLog(@" 地图推荐  套餐 ？:%@",paytype2);
//
//        //    资源服务开通状态
//        [formData appendPartWithFormData:[paystate3 dataUsingEncoding:NSUTF8StringEncoding] name:@"resource"];
//        NSLog(@" 资源服务开通状态:%@",paystate3);
//
//        //    资源匹配 套餐 ？
//        [formData appendPartWithFormData:[paytype3 dataUsingEncoding:NSUTF8StringEncoding] name:@"resource_type"];
//        NSLog(@" 资源匹配 套餐 ？:%@",paytype3);
//
//        //    资源匹配套餐3 个数
//        [formData appendPartWithFormData:[self.white33_3.text dataUsingEncoding:NSUTF8StringEncoding] name:@"zr_resources"];
//        NSLog(@" 资源匹配套餐3个数:%@",self.white33_3.text);
    }

          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"请求成功code=%@",     responseObject[@"code"]);
              NSLog(@"请求成功massign=%@",  responseObject[@"massign"]);
              NSLog(@"请求成功data=%@",     responseObject[@"data"]);
              if ([self.isContract isEqualToString:@"isContract"]) {
                  
                  if ([[responseObject[@"code"] stringValue] isEqualToString:@"400"]){
                      
                       [YJLHUD showErrorWithmessage:@"续约失败"];
                      
                  }else{
                      
                       [YJLHUD showSuccessWithmessage:@"续约成功"];
                      _count = 1;
                      [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
                      
                      }
              }
              
              else{
              
                  if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                      [YJLHUD showWithmessage:@"购买成功，赶紧去消费吧"];
                     
                  } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"408"]){
                     [YJLHUD showWithmessage:@"积分不足，请先去充值"];
                     
                }else{
                  [YJLHUD showWithmessage:@"服务器繁忙～～"];
                }
            }
    
              // 1秒之后再消失
              [YJLHUD dismissWithDelay:1.0];
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
               [YJLHUD dismissWithDelay:1.0];
              NSLog(@"请求失败=%@",error);
              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️提示" message:@"已断开与互联网的连接" preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                  NSLog(@"点击了确认");
              }];
              
              [alertController addAction:commitAction];
              [self presentViewController:alertController animated:YES completion:nil];
              
          }];
    #pragma    付钱结束
}

//倒计时返回
-(void)timerFired:(NSTimer *)timer{
    if (_count !=0) {
        _count -=1;
        
    }
    else{
        
        [timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}
#pragma -mark 返回
-(void)Back:(id)sender{
    
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
