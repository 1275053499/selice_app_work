//
//  RenttaocanController.m
//  铺皇
//
//  Created by selice on 2017/10/13.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RenttaocanController.h"
#import "ZYKeyboardUtil.h"
#define MARGIN_KEYBOARD 10
#import "Password.h"
#import "SafenumberController.h"
@interface RenttaocanController ()<UIScrollViewDelegate,UITextFieldDelegate>{
     int  i ;
    
    UIScrollView *  MainScrollrent;
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
    
    UILabel  *alertlab;     //提示内容
    UIButton *paybtn;       //支付按钮
    
    
    
    NSString * payservicetype1;  //服务类型
    NSString * paystate1;       //服务状态
    NSString * paytype1;         //套餐类型
    NSString * paynum1;          //套餐积分
    NSString * paytime1;         //套餐时间
    
    NSString * payservicetype2;  //服务类型
    NSString * paystate2;        //服务状态
    NSString * paytype2;         //套餐类型
    NSString * paynum2;          //套餐积分
    NSString * paytime2;         //套餐时间
    
    NSString * totalpay;        //总积分
    
}

@property (strong, nonatomic) UITextField    * white23_3;
@property (strong, nonatomic) ZYKeyboardUtil * keyboardUtil;

@end

@implementation RenttaocanController

- (void)viewDidLoad {
    [super viewDidLoad];

    paystate2 = [NSString new];
    paystate2 = @"0";
    paystate1 = [NSString new];
    paystate1 = @"0";
    
    paytype1 = [NSString new];
    paytype1 = @"0";
    paytype2 = [NSString new];
    paytype2 = @"0";
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(Back:)];
    self.navigationItem.leftBarButtonItem = backItm;
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isContract.length>0) {
        
        self.navigationItem.title = @"续约服务";
    }
    else{
        self.navigationItem.title = @"开通出租服务";
    }
    
    MainScrollrent                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+64)];
    MainScrollrent.userInteractionEnabled         = YES;
    MainScrollrent.showsVerticalScrollIndicator   = YES;
    MainScrollrent.showsHorizontalScrollIndicator = YES;
    MainScrollrent.delegate                       = self;
    MainScrollrent.backgroundColor                = kTCColor(255, 255, 255);
    MainScrollrent.contentSize                    = CGSizeMake(KMainScreenWidth,720);
    [self.view addSubview:MainScrollrent];
    
    [self buildtopview];
    [self buildbottomview];
    
    //    添加手势点击可以让键盘下去
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [MainScrollrent addGestureRecognizer:tap];
    
}

#pragma -mark 点击scrollowview键盘下去
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.white23_3 resignFirstResponder];
}

-(void)buildtopview{
    
#pragma -mark     服务1  信息展示+地图推荐
    viewone = [[UIView alloc]init];
    viewone.backgroundColor =kTCColor(229, 229, 229);
    [MainScrollrent addSubview:viewone];
    [viewone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, (KMainScreenWidth-60)/3+54));
        make.left.equalTo(MainScrollrent).with.offset(0);
        make.top.equalTo (MainScrollrent).with.offset(0);
    }];
#pragma -mark     服务1 信息展示+地图推荐 标题
    labone               = [[UILabel alloc]init];
    labone.textAlignment = NSTextAlignmentLeft;
    labone.text          = @"信息展示+地图推荐";
    labone.font          = [UIFont systemFontOfSize:18.0f];
    [viewone addSubview:labone];
    [labone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.top.equalTo(viewone).with.offset(16);
        make.left.equalTo(viewone).with.offset(20);
    }];
    
#pragma -mark 信息展示+地图推荐 服务7天 start
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
    NSString *string11_3  = @"500";
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
#pragma -mark 信息展示+地图推荐 服务7天 end
    
#pragma -mark 信息展示+地图推荐 服务30天 start
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
    NSString *string12_3  = @"1800";
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
#pragma -mark  信息展示+地图推荐 服务30天 end
    
#pragma -mark  信息展示+地图推荐 服务90天 start
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
    NSString *string13_3  = @"4200";
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
    
#pragma -mark  服务 3 资源匹配
    //   资源匹配 灰色view
    viewtwo = [[UIView alloc]init];
    viewtwo.backgroundColor =kTCColor(229, 229, 229);
    [MainScrollrent addSubview:viewtwo];
    [viewtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, (KMainScreenWidth-60)/3+64));
        make.left.equalTo(MainScrollrent).with.offset(0);
        make.top.equalTo (viewone.mas_bottom).with.offset(0);
    }];

#pragma -mark     服务 3 资源匹配 标题
    labtwo = [[UILabel alloc]init];
    labtwo.textAlignment = NSTextAlignmentLeft;
    labtwo.text = @"资源匹配";
    labtwo.font  = [UIFont systemFontOfSize:18.0f];
    [viewtwo addSubview:labtwo];
    [labtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewtwo).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.equalTo(viewtwo).with.offset(20);
    }];

#pragma -mark 资源匹配 20个 start
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
    white21_2.text       =  @"20个资源";
    white21_2.font       = [UIFont systemFontOfSize:15.0f];
    white21_2.textColor  =kTCColor(0, 0, 0);
    [white21 addSubview:white21_2];
    [white21_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white21).with.offset(10);
        make.top.equalTo(white21_1.mas_bottom).with.offset(12);
    }];

    white21_3            = [[UILabel alloc]init];
    NSString *string21_3 = @"900";
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
#pragma -mark 资源匹配 20个  end
#pragma -mark 资源匹配 40个  start
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
    white22_1.text       = @"效率快，范围广";
    white22_1.font       = [UIFont systemFontOfSize:12.0f];
    white22_1.textColor  = kTCColor(101, 101, 101);
    [white22 addSubview:white22_1];
    [white22_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22).with.offset(12);
    }];

    white22_2            = [[UILabel alloc]init];
    white22_2.text       =  @"40个资源";
    white22_2.font       = [UIFont systemFontOfSize:15.0f];
    white22_2.textColor  = kTCColor(0, 0, 0);
    [white22 addSubview:white22_2];
    [white22_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22_1.mas_bottom).with.offset(12);
    }];
    
    
    white22_3                 = [[UILabel alloc]init];
    NSString *string22_3      = @"1920";
    NSString *string222_3     = [NSString stringWithFormat:@"%@积分",string22_3];
    NSMutableAttributedString *stra22_3   = [[NSMutableAttributedString alloc]initWithString:string222_3];//可随意拼接字符串
    [stra22_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string22_3.length)];
    white22_3.attributedText  = stra22_3;
    white22_3.font            = [UIFont systemFontOfSize:18.0f];
    [white22 addSubview:white22_3];
    [white22_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22_2.mas_bottom).with.offset(12);
    }];

#pragma -mark 资源匹配 40个  end
#pragma -mark 资源匹配 自定义购买量 start
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

    white23_1            = [[UILabel alloc]init];
    white23_1.text       =  @"效率快，范围广";
    white23_1.font       = [UIFont systemFontOfSize:12.0f];
    white23_1.textColor  = kTCColor(101, 101, 101);
    [white23 addSubview:white23_1];
    [white23_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23).with.offset(12);
    }];
    
    white23_2            = [[UILabel alloc]init];
    white23_2.text       =  @"20个起售";
    white23_2.font       = [UIFont systemFontOfSize:15.0f];
    white23_2.textColor  = kTCColor(0, 0, 0);
    [white23 addSubview:white23_2];
    [white23_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23_1.mas_bottom).with.offset(12);
    }];

    self.white23_3                    = [[UITextField alloc]init];
    self.white23_3.textColor          = [UIColor redColor];
    self.white23_3.placeholder        = @"填写购买量";
    self.white23_3.delegate           = self;
    self.white23_3.returnKeyType      = UIReturnKeyDone;
    self.white23_3.font               = [UIFont systemFontOfSize:14.0f];
    self.white23_3.textAlignment      = NSTextAlignmentCenter;
    self.white23_3.keyboardType       = UIKeyboardTypeNumberPad;
    self.white23_3.clearButtonMode    = UITextFieldViewModeWhileEditing;
    self.white23_3.borderStyle        = UITextBorderStyleRoundedRect;
    [self.white23_3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [white23 addSubview:self.white23_3];
    [self.white23_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-20, 20));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23_2.mas_bottom).with.offset(12);
    }];

    //键盘处理 抬起
    [self configKeyBoardRespond];
#pragma -mark  资源匹配  end
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak RenttaocanController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.white23_3,nil];
    }];
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    NSLog(@"开始编辑");
    white21.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white22.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white23.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.white23_3 resignFirstResponder];
    payservicetype2     = @"3";// 资源匹配
    paytype2          = @"3";       //第三个
    paynum2             = [NSString stringWithFormat:@"%ld积分",[self.white23_3.text integerValue]*48];//总积分
    if ([self.white23_3.text integerValue] < 20) {
        self.white23_3.text = @"20";
    }
    paytime2           = [NSString stringWithFormat:@"%@个资源",self.white23_3.text];                 //购买个数
    paystate2           = @"1";     //服务开通状态
}

#pragma 当点击键盘的返回键键盘下去
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.white23_3 resignFirstResponder];
    payservicetype2     = @"3";// 资源匹配
    paytype2            = @"3";       //第三个
    paynum2             = [NSString stringWithFormat:@"%ld积分",[self.white23_3.text integerValue]*48];//总积分
   
    if ([self.white23_3.text integerValue] < 20) {
        self.white23_3.text = @"20";
    }
    paytime2            = [NSString stringWithFormat:@"%@个资源",self.white23_3.text];                 //购买个数
    paystate2           = @"1";     //服务开通状态
    return YES;
}

#pragma mark - self.white33_3 限制购买量字数
-(void)textFieldDidChange:(UITextField *)textField{
    
    if (textField == self.white23_3) {
        if (textField.text.length >3) {
            textField.text = [textField.text substringToIndex:3];
        }
    }
}

-(void)white11Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"信息展示+地图推荐 500积分 服务7天");
    white11.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white12.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white13.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [self.white23_3 resignFirstResponder];
    
    
    payservicetype1 = @"1";       // 首页展示
    paytype1        = @"1";       // 第1个
    paynum1         =[NSString stringWithFormat:@"500"];                      //总积分
    paytime1        =[NSString stringWithFormat:@"服务7天"];                  //服务时间
    paystate1       = @"1";     //服务开通状态
}


-(void)white12Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"信息展示+地图推荐 1800积分 服务30天");
    white12.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white13.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white11.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
  
    [self.white23_3 resignFirstResponder];
    payservicetype1 = @"1";       // 首页展示
    paytype1        = @"2";       // 第1个
    paynum1         =[NSString stringWithFormat:@"1800"];                      //总积分
    paytime1        =[NSString stringWithFormat:@"服务30天"];                  //服务时间
    paystate1       = @"1";     //服务开通状态
}

-(void)white13Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"信息展示+地图推荐 4200积分 服务90天");
    white13.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white11.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white12.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    
    [self.white23_3 resignFirstResponder];
    payservicetype1 = @"1";       // 首页展示
    paytype1        = @"3";       // 第1个
    paynum1         =[NSString stringWithFormat:@"4200"];                      //总积分
    paytime1        =[NSString stringWithFormat:@"服务90天"];                  //服务时间
    paystate1       = @"1";     //服务开通状态
}

-(void)white21Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"信息展示+地图推荐 500积分 服务7天");
    white21.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white22.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white23.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    
    [self.white23_3 resignFirstResponder];
    payservicetype2 = @"2";       // 信息展示+地图推荐
    paytype2        = @"1";       // 第1个
    paynum2         =[NSString stringWithFormat:@"960"];                      //总积分
    paytime2        =[NSString stringWithFormat:@"20个资源"];                  //服务时间
    paystate2       = @"1";     //服务开通状态
}

-(void)white22Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"资源购买 1920积分 40");
    
    white21.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white23.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white22.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    [self.white23_3 resignFirstResponder];
    payservicetype2 = @"2";       // 信息展示+地图推荐
    paytype2        = @"2";       // 第1个
    paynum2         =[NSString stringWithFormat:@"1920"];                      //总积分
    paytime2        =[NSString stringWithFormat:@"40个资源"];                  //服务时间
    paystate2       = @"1";     //服务开通状态
}

-(void)buildbottomview{
    alertlab= [[UILabel alloc]init];
    alertlab.text = @"温馨提示\n\n1.积分业务一经开通支付后不支持退款；\n\n2.充值后若还是无法正常使用，请尝试联系客服；";
    alertlab.textColor        = [UIColor blackColor];
    alertlab.textAlignment    = NSTextAlignmentLeft;
    alertlab.numberOfLines    = 0;
    alertlab.font             = [UIFont systemFontOfSize:12.0f];
    [MainScrollrent addSubview:alertlab];
    [alertlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 100));
        make.top.equalTo(viewtwo.mas_bottom).with.offset(50);
        make.left.equalTo(MainScrollrent).with.offset(20);
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
    [MainScrollrent addSubview:paybtn];
    [paybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 32));
        make.left.equalTo(MainScrollrent).with.offset(20);
        make.top.equalTo(alertlab.mas_bottom).with.offset(20);
    }];
}


#pragma -mark 支付按钮点击事件
-(void)payclick:(id)sender{
    
    if ([paystate1 isEqualToString:@"0"] & [paystate2 isEqualToString:@"0"]) {
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
        
        totalpay = [NSString stringWithFormat:@"%ld",[paynum2 integerValue]+[paynum1 integerValue]];//积分累计
        
        NSString *paysetmeal  = [NSString stringWithFormat:@"%@\n%@\n需要消费积分:%@积分",paysetmeal1,paysetmeal2,totalpay];
        

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
            NSLog(@"取消点击事件Block");
            // 取消点击事件Block
        };
    })
    
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = @"立即支付";
        
        action.titleColor = kTCColor(255, 255, 255);
        
        action.backgroundColor = kTCColor(77, 166, 214);
        
        action.clickBlock = ^{
            
            if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLTouchIDneed] isEqualToString:@"yes"]){
                
                LAContext *laContext = [[LAContext alloc] init];
                NSError *error = nil;
                
                if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
                    
                    [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                              localizedReason:@"需要授权Touch ID购买"
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
                
                else {
                    
                    NSLog(@"==========Not support :%@", error.description);
                }
            }
            
            else{
                
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
                    
                    if ([[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpassword].length<1) {//没有支付密码
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未设置支付密码，是否需要设置" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                            
                            NSLog(@"前往设置");
                           
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
                        
                    }else{//有支付密码
                        
                        if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpasswordopen] isEqualToString:@"openPay"]) {//openPay 开启了支付验证的
                            //弹出式密码框
                            Password *passView = [[Password alloc]initSingleBtnView];
                            passView.passWordTextConfirm =^(NSString *text)
                            {
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
                                     [YJLHUD dismissWithDelay:1];
                                    
                                }
                            };
                            [passView show];//支付密码输入页面出现
                        }
                        
                        else{//closePay 关闭了支付验证的
                            
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
    

    if ([self.isContract isEqualToString:@"isContract"]){
    
         [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"续约中..."];
        
    }else{
     
         [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"购买中...."];
    }
    #pragma     付钱开始
    
                AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                manager.requestSerializer.timeoutInterval = 10.0;
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
   
    NSLog(@"总积分:%@-信息状态：%@-信息套餐：%@-资源状态:%@-资源套餐:%@-资源数量:%@",totalpay,paystate1,paytype1,paystate2,paytype2,self.white23_3.text);
     NSDictionary *params = [[NSDictionary alloc]init];
    if ([self.isContract isEqualToString:@"isContract"]) {
                 params = @{
                                         @"id"          :[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                                          @"shopid"        :self.isContractshopid,
                                         @"vip_integral":totalpay ,
                                         @"display"     :paystate1,
                                         @"map_type"    :paytype1,
                                         @"resource"    :paystate2,
                                         @"resource_type":paytype2,
                                         @"resources":self.white23_3.text
                                         };
    }else{
        params = @{
                   
                   @"id"          :[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                   @"vip_integral":totalpay ,
                   @"display"     :paystate1,
                   @"map_type"    :paytype1,
                   @"resource"    :paystate2,
                   @"resource_type":paytype2,
                   @"resources":self.white23_3.text
                   };
    }
                NSLog(@"用户ID:%@",params);
                [manager POST:MyserviceCZpath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    
//                    //                    总积分
//                    [formData appendPartWithFormData:[totalpay dataUsingEncoding:NSUTF8StringEncoding] name:@"vip_integral"];
//                    NSLog(@" 总积分:%@",totalpay);
//
//                    //    地图推荐服务开通状态
//                    [formData appendPartWithFormData:[paystate1 dataUsingEncoding:NSUTF8StringEncoding] name:@"display"];
//                    NSLog(@" 地图推荐服务开通状态:%@",paystate1);
//
//                    //    地图推荐 套餐 ？
//                    [formData appendPartWithFormData:[paytype1 dataUsingEncoding:NSUTF8StringEncoding] name:@"map_type"];
//                    NSLog(@" 地图推荐  套餐 ？:%@",paytype1);
//
//                    //    资源服务开通状态
//                    [formData appendPartWithFormData:[paystate2 dataUsingEncoding:NSUTF8StringEncoding] name:@"resource"];
//                    NSLog(@" 资源服务开通状态:%@",paystate2);
//
//                    //    资源匹配 套餐 ？
//                    [formData appendPartWithFormData:[paytype2 dataUsingEncoding:NSUTF8StringEncoding] name:@"resource_type"];
//                    NSLog(@" 资源匹配 套餐 ？:%@",paytype2);
//
//                    //    资源匹配套餐3 个数
//                    [formData appendPartWithFormData:[self.white23_3.text dataUsingEncoding:NSUTF8StringEncoding] name:@"resources"];
//                    NSLog(@" 资源匹配套餐  3    个数:%@",self.white23_3.text);
                    
            }
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"请求成功code=%@",     responseObject[@"code"]);
                          NSLog(@"请求成功massign=%@",  responseObject[@"massign"]);
                          NSLog(@"请求成功data=%@",     responseObject[@"data"]);
    
           if ([self.isContract isEqualToString:@"isContract"]) {
               if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                   
                    [YJLHUD showSuccessWithmessage:@"店铺续约成功"];
                   
               }else{
                  
                    [YJLHUD showErrorWithmessage:@"服务器繁忙～"];
         
                   }
               }
                   
           else{
                   
                   if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                       
                       
                       [YJLHUD showSuccessWithmessage:@"购买成功，赶紧去消费吧"];
                   } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"408"]){
                       
                       
                        [YJLHUD showErrorWithmessage:@"积分不足，请先去充值"];
                   }
                   else if ([[responseObject[@"code"] stringValue] isEqualToString:@"409"]){
                       
                      
                        [YJLHUD showErrorWithmessage:@"积分不存在"];
                   }
                   
                   else{
                        [YJLHUD showErrorWithmessage:@"服务器繁忙～"];
                      
                   }
               }
                 
                   [YJLHUD dismissWithDelay:2.0];
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       [YJLHUD dismissWithDelay:0];
                          NSLog(@"请求失败=%@",error);
                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️提示" message:@"已断开与互联网的连接" preferredStyle:UIAlertControllerStyleAlert];
                          UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                              NSLog(@"点击了确认");
                          }];
                          [alertController addAction:commitAction];
                          [self presentViewController:alertController animated:YES completion:nil];
                      }];
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
