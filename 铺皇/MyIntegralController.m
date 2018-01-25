//
//  MyIntegralController.m
//  铺皇
//
//  Created by selice on 2017/9/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "MyIntegralController.h"

#define midwidth  ([UIScreen mainScreen].bounds.size.width-3)/4

@interface MyIntegralController ()<UIScrollViewDelegate>{
    
    UIScrollView *  IntergralScroll;
    NSString *code;
}
@property (nonatomic , strong)UIView        *Navview;       //自定义导航栏
@property (nonatomic , strong)UIButton      *BackBtn;       //返回按钮
@property (nonatomic , strong)UILabel       *Titlelab;      //标题框
@property (nonatomic , strong)UIImageView   *BJimageView;   //背景view
@property (nonatomic , strong)UIView        *HerderView;    //虚幻背景
@property (nonatomic , strong)UIImageView   *UserimageView; //个人头像
@property (nonatomic , strong)UIImageView   *MoneyimageView;//金币图片
@property (nonatomic , strong)UILabel       *Moneylab;      //积分
@property (nonatomic , strong)UILabel       *Uservip;       //普通用户
@property (nonatomic , strong)UIImageView   *lineX;         //横线条
@property (nonatomic , strong)UIImageView   *lineY;         //竖线条
@property (nonatomic , strong)UILabel       *dayadd;        //今日增值
@property (nonatomic , strong)UILabel       *dayaddnum;      //今日增值数量
@property (nonatomic , strong)UILabel       *dayreduce;     //今日消费
@property (nonatomic , strong)UILabel       *dayreducenum;  //今日消费量
@property (nonatomic , strong)UIView        *midview;       //中间的按钮view
@property (nonatomic , strong)UIButton      *rechargebtn;   //充值按钮
@property (nonatomic , strong)UILabel           *aleat;         //提示
@property (nonatomic , strong)UIImageView       *changeimg;         //兑换积分活动
@property (nonatomic , strong)NSMutableArray    *DataArr;

@end

@implementation MyIntegralController

-(NSMutableArray*)DataArr{
    if (_DataArr == nil) {
        _DataArr =[[NSMutableArray alloc]init];
    }
    return  _DataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    code =[[NSString alloc]init];
//    创建自定义nav
    [self creatnav];
    [self creatmidview];
    [self creatrecharge];
    [self creataleat];

}

-(void)loaddata{
    
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSDictionary *params = @{
                                 @"user_id": [[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                        };
    NSLog(@"%@",params);
    [manager GET:Myintergalpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
      
        NSLog(@"请求数据成功----%@",responseObject);
         self.dayaddnum.text      = [NSString stringWithFormat:@"%@分",responseObject[@"data"][@"recharge"]];//每日充值
         self.dayreducenum.text   = [NSString stringWithFormat:@"%@分",responseObject[@"data"][@"consume" ]];//每日消费
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
    }];
}

#pragma -mark 创建自定义nav
-(void)creatnav{

    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    IntergralScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, KMainScreenWidth, KMainScreenHeight+64)];
    IntergralScroll.userInteractionEnabled         = YES;
    IntergralScroll.showsVerticalScrollIndicator   = YES;
    IntergralScroll.showsHorizontalScrollIndicator = YES;
    IntergralScroll.delegate                       = self;
    IntergralScroll.backgroundColor                =[UIColor whiteColor];
    IntergralScroll.contentSize                    = CGSizeMake(KMainScreenWidth, KMainScreenHeight+180);
    [self.view addSubview:IntergralScroll];
    
    self.Navview = [[UIView alloc]init];
    self.Navview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.Navview];
    [self.view bringSubviewToFront:self.Navview];
    
    [self.Navview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 64));
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
    }];
    
//        返回按钮
    _BackBtn        =[UIButton buttonWithType:UIButtonTypeCustom];
    [_BackBtn addTarget:self action:@selector(clickback:) forControlEvents:UIControlEventTouchUpInside];
    [self.Navview addSubview:_BackBtn];
    [self.BackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(self.Navview).with.offset(0);
        make.top.with.offset(20);
    }];
    
    //    nav标题
    _Titlelab                   = [[UILabel alloc]init];
    _Titlelab.text              = @"我的积分";
    _Titlelab.textAlignment     = NSTextAlignmentCenter;
    [self.Navview addSubview:_Titlelab];
    
    [self.Titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BackBtn.mas_right).with.offset(0);
        make.right.equalTo(self.Navview).with.offset(-44);
        make.top.equalTo(self.Navview).with.offset(20);
        make.height.mas_equalTo(@44);
    }];

//    头部背景
    self.BJimageView = [[UIImageView alloc]init];
    [self.BJimageView setImage:[UIImage imageNamed:@"bg_header"]];
    [IntergralScroll addSubview:self.BJimageView];
    
    [self.BJimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 250));
        make.left.equalTo(IntergralScroll).with.offset(0);
        make.top.equalTo (IntergralScroll).with.offset(0);
    }];
   
//    虚幻背景
    self.HerderView  =[[UIView alloc]init];
    self.HerderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"person_bg"]];
    self.HerderView.layer.cornerRadius = 5.0f;
    [IntergralScroll addSubview:self.HerderView];
    [self.HerderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(330, 160));
        make.left.equalTo(IntergralScroll).with.offset((KMainScreenWidth-330)/2);
        make.top.equalTo (IntergralScroll).with.offset(64+13);
    }];

//    个人头像
    self.UserimageView                    =[[UIImageView alloc]init];
    self.UserimageView.layer.cornerRadius = 32.0f;

    self.UserimageView.layer.borderWidth  = 2.0f;
    self.UserimageView.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.UserimageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.UserimageView.layer.shouldRasterize    = YES;
    self.UserimageView.clipsToBounds            = YES;
    [IntergralScroll addSubview:self.UserimageView];
    
    [self.UserimageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(IntergralScroll).with
        .offset(64);
        make.centerX.equalTo(IntergralScroll);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];

//    金币图片
    self.MoneyimageView         =[[UIImageView alloc]init];
    self.MoneyimageView.image   =[UIImage imageNamed:@"money"];
    [self.HerderView addSubview:self.MoneyimageView];
    [self.MoneyimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.left.equalTo(self.UserimageView).with.offset(-17);
        make.top.equalTo (self.UserimageView.mas_bottom).with.offset(14);
    }];

//    金币文本
    self.Moneylab           = [[UILabel alloc]init];
    self.Moneylab.textColor = [UIColor blackColor];
    self.Moneylab.font      = [UIFont systemFontOfSize:22.0f];
    self.Moneylab.adjustsFontSizeToFitWidth = YES;

    self.Moneylab.textAlignment = NSTextAlignmentLeft;
    [self.HerderView addSubview:self.Moneylab];
    [self.Moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.MoneyimageView.mas_right).with.offset(5);
        make.top.equalTo(self.UserimageView.mas_bottom).with.offset(14);
        make.size.mas_equalTo(CGSizeMake(120, 17));
    }];

//    普通用户
    self.Uservip                =[[UILabel alloc]init];
    self.Uservip.textColor      =[UIColor whiteColor];
    self.Uservip.text           =@"普通用户";
    self.Uservip.textAlignment  = NSTextAlignmentCenter;
    self.Uservip.font           = [UIFont systemFontOfSize:14.0f];
    [self.HerderView addSubview:self.Uservip];
    [self.Uservip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.HerderView);
        make.top.equalTo(self.Moneylab.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
//    横线
    self.lineX = [[UIImageView alloc]init];
    self.lineX.backgroundColor  =[UIColor whiteColor];
    [self.HerderView addSubview:self.lineX];
    [self.lineX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(330, 1));
        make.top.equalTo (self.Uservip.mas_bottom).with.offset(8);
        make.left.equalTo(self.HerderView        ).with.offset(0);
    }];
    
//    竖线
    self.lineY = [[UIImageView alloc]init];
    self.lineY.backgroundColor  =[UIColor whiteColor];
    [self.HerderView addSubview:self.lineY];
    [self.lineY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 40));
        make.top.equalTo(self.lineX.mas_bottom).with.offset(1);
        make.left.equalTo(self.HerderView).with.offset(330/2-0.5);
    }];

//    今日增值
    self.dayadd                 = [[UILabel alloc]init];
    self.dayadd.textAlignment   = NSTextAlignmentCenter;
    self.dayadd.textColor       = [UIColor whiteColor];
    self.dayadd.text            = @"今日增值";
    self.dayadd.font            = [UIFont systemFontOfSize:12.0f];
    [self.HerderView addSubview:self.dayadd];
    
    [self.dayadd mas_makeConstraints:^(MASConstraintMaker *make) {

        make.size.mas_equalTo(CGSizeMake(330/2-0.5, 15));
        make.top.equalTo (self.Uservip.mas_bottom).with.offset(15);
        make.left.equalTo(self.HerderView        ).with.offset(0);
    }];
    
//    增值手势
    self.dayadd.userInteractionEnabled = YES;
    UITapGestureRecognizer *AddGES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddGesclick:)];
    [self.dayadd addGestureRecognizer:AddGES];
    
//今日增值数量
    self.dayaddnum                 = [[UILabel alloc]init];
    self.dayaddnum.textAlignment   = NSTextAlignmentCenter;
    self.dayaddnum.textColor       = [UIColor whiteColor];
     self.dayaddnum.text = @"000分";
    self.dayaddnum.font            = [UIFont systemFontOfSize:12.0f];
    [self.HerderView addSubview:self.dayaddnum];
    
    [self.dayaddnum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(330/2-0.5, 15));
        make.top.equalTo (self.Uservip.mas_bottom).with.offset(30);
        make.left.equalTo(self.HerderView        ).with.offset(0);
        
    }];

    //    增值手势
    self.dayadd.userInteractionEnabled = YES;
    UITapGestureRecognizer *AddGES2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddGesclick:)];
    [self.dayaddnum addGestureRecognizer:AddGES2];
    
    
    //    今日消费
    self.dayreduce               = [[UILabel alloc]init];
    self.dayreduce.textAlignment   = NSTextAlignmentCenter;
    self.dayreduce.textColor       = [UIColor whiteColor];
    self.dayreduce.text            = @"今日消费";
    self.dayreduce.font            = [UIFont systemFontOfSize:12.0f];
    [self.HerderView addSubview:self.dayreduce];
    
    [self.dayreduce mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(330/2-0.5, 15));
        make.top.equalTo (self.Uservip.mas_bottom).with.offset(15);
        make.right.equalTo(self.HerderView        ).with.offset(0);
    }];
    
    //    手势
    self.dayreduce.userInteractionEnabled = YES;
    UITapGestureRecognizer *ReduceGES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ReduceGesclick:)];
    [self.dayreduce addGestureRecognizer:ReduceGES];
    
    //今日消费数量
    self.dayreducenum                 = [[UILabel alloc]init];
    self.dayreducenum.textAlignment   = NSTextAlignmentCenter;
    self.dayreducenum.textColor       = [UIColor whiteColor];
    self.dayreducenum.text = @"000分";
    self.dayreducenum.font            = [UIFont systemFontOfSize:12.0f];
    [self.HerderView addSubview:self.dayreducenum];
    
    [self.dayreducenum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(330/2-0.5, 15));
        make.top.equalTo (self.Uservip.mas_bottom).with.offset(30);
        make.right.equalTo (self.HerderView        ).with.offset(0);
    }];
    UITapGestureRecognizer *ReduceGES2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ReduceGesclick:)];
    [self.dayreducenum addGestureRecognizer:ReduceGES2];
    
    
#pragma -mark 从数据库拿数据进行赋值
    personshowmodel *model = [[[pershowData shareshowperData]getAllDatas] objectAtIndex:0];
    [self.UserimageView sd_setImageWithURL:[NSURL URLWithString:model.personimage] placeholderImage:nil];                         //图片
    self.Moneylab.text       = [NSString stringWithFormat:@"%@分",model.personintegral];//金币
    
}
#pragma -mark 消费点击
-(void)ReduceGesclick:(UITapGestureRecognizer *)GES{
    NSLog(@" 消费点击");
   
    IntegralReduceController *ctl =[[IntegralReduceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}

#pragma -mark 增值点击
-(void)AddGesclick:(UITapGestureRecognizer *)GES{
    NSLog(@"增值点击");
    
    IntegralAddController *ctl =[[IntegralAddController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}

#pragma -mark 四个按钮创建
-(void)creatmidview{
//    四核按钮背景
    self.midview                    = [[UIView alloc]init];
    self.midview.backgroundColor    = kTCColor(229, 229, 229);
    [IntergralScroll addSubview:self.midview];
    
    [self.midview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 80));
        make.top.equalTo(self.BJimageView.mas_bottom).with.offset(0);
        make.left.equalTo(IntergralScroll).with.offset(0);
    }];
    
//    第1个按钮
    UIView * midfourviewone  = [[UIView alloc]init];
    midfourviewone.backgroundColor = [UIColor whiteColor];
    [self.midview addSubview:midfourviewone];
    [midfourviewone mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.size.mas_equalTo(CGSizeMake(midwidth, 75));
        make.left.equalTo(self.midview).with.offset((midwidth+1)*0);
        make.top.equalTo(self.midview).with.offset(0);
    }];
    
    //    手势
    midfourviewone.userInteractionEnabled = YES;
    UITapGestureRecognizer *midoneGES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(midoneGesclick:)];
    [midfourviewone addGestureRecognizer:midoneGES];

//    按钮图片
    UIImageView *midfourimgone  = [[UIImageView alloc]init];
    midfourimgone.image         = [UIImage imageNamed:@"icon_assignor"];
    [midfourviewone addSubview:midfourimgone];
    [midfourimgone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midfourviewone).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(midfourviewone).with.offset((midwidth-35)/2);
    }];
//    按钮文字
    UILabel *midfourlabone        = [[UILabel alloc]init];
    midfourlabone.textAlignment   = NSTextAlignmentCenter;
    midfourlabone.textColor       = [UIColor blackColor];
    midfourlabone.text            = @"店铺转让";
    midfourlabone.font            = [UIFont systemFontOfSize:12.0f];
    [midfourviewone addSubview:midfourlabone];
    
    [midfourlabone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(midwidth, 15));
        make.top. equalTo (midfourimgone.mas_bottom).with.offset(5);
        make.left.equalTo (midfourviewone).with.offset(0);
        
    }];

    
//    第2个按钮
    UIView * midfourviewtwo  = [[UIView alloc]init];
    midfourviewtwo.backgroundColor = [UIColor whiteColor];
    [self.midview addSubview:midfourviewtwo];
    [midfourviewtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(midwidth, 75));
        make.left.equalTo(self.midview).with.offset((midwidth+1)*1);
        make.top.equalTo(self.midview).with.offset(0);
    }];
    //    手势2
    midfourviewtwo.userInteractionEnabled = YES;
    UITapGestureRecognizer *midtwoGES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(midtwoGesclick:)];
    [midfourviewtwo addGestureRecognizer:midtwoGES];

    //    按钮图片
    UIImageView *midfourimgtwo  = [[UIImageView alloc]init];
    midfourimgtwo.image         = [UIImage imageNamed:@"icon_rent"];
    [midfourviewtwo addSubview:midfourimgtwo];
    [midfourimgtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midfourviewtwo).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(midfourviewtwo).with.offset((midwidth-35)/2);
    }];
    //    按钮文字
    UILabel *midfourlabtwo        = [[UILabel alloc]init];
    midfourlabtwo.textAlignment   = NSTextAlignmentCenter;
    midfourlabtwo.textColor       = [UIColor blackColor];
    midfourlabtwo.text            = @"店铺出租";
    midfourlabtwo.font            = [UIFont systemFontOfSize:12.0f];
    [midfourviewtwo addSubview:midfourlabtwo];
    
    [midfourlabtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(midwidth, 15));
        make.top. equalTo (midfourimgtwo.mas_bottom).with.offset(5);
        make.left.equalTo (midfourviewtwo).with.offset(0);
        
    }];
    
    
    
//    第3个按钮
    UIView * midfourviewthr  = [[UIView alloc]init];
    midfourviewthr.backgroundColor = [UIColor whiteColor];
    [self.midview addSubview:midfourviewthr];
    [midfourviewthr mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(midwidth, 75));
        make.left.equalTo(self.midview).with.offset((midwidth+1)*2);
        make.top.equalTo(self.midview).with.offset(0);
    }];
//    手势3
    midfourviewthr.userInteractionEnabled = YES;
    UITapGestureRecognizer *midthrGES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(midthrGesclick:)];
    [midfourviewthr addGestureRecognizer:midthrGES];
    
    //    按钮图片
    UIImageView *midfourimgthr  = [[UIImageView alloc]init];
    midfourimgthr.image         = [UIImage imageNamed:@"icon_location"];
    [midfourviewthr addSubview:midfourimgthr];
    [midfourimgthr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midfourviewthr).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(midfourviewthr).with.offset((midwidth-35)/2);
    }];
    //    按钮文字
    UILabel *midfourlabthr        = [[UILabel alloc]init];
    midfourlabthr.textAlignment   = NSTextAlignmentCenter;
    midfourlabthr.textColor       = [UIColor blackColor];
    midfourlabthr.text            = @"店铺选址";
    midfourlabthr.font            = [UIFont systemFontOfSize:12.0f];
    [midfourviewthr addSubview:midfourlabthr];
    
    [midfourlabthr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(midwidth, 15));
        make.top. equalTo (midfourimgthr.mas_bottom).with.offset(5);
        make.left.equalTo (midfourviewthr).with.offset(0);
        
    }];
    
    
    
//    第4个按钮
    UIView * midfourviewfou  = [[UIView alloc]init];
    midfourviewfou.backgroundColor = [UIColor whiteColor];
    [self.midview addSubview:midfourviewfou];
    [midfourviewfou mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(midwidth, 75));
        make.left.equalTo(self.midview).with.offset((midwidth+1)*3);
        make.top.equalTo(self.midview).with.offset(0);
    }];
    
    //    手4
    midfourviewfou.userInteractionEnabled = YES;
    UITapGestureRecognizer *midfouGES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(midfouGesclick:)];
    [midfourviewfou addGestureRecognizer:midfouGES];

    //    按钮图片
    UIImageView *midfourimgfou  = [[UIImageView alloc]init];
    midfourimgfou.image         = [UIImage imageNamed:@"icon_invite"];
    [midfourviewfou addSubview:midfourimgfou];
    [midfourimgfou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midfourviewfou).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(midfourviewfou).with.offset((midwidth-35)/2);
    }];
    //    按钮文字
    UILabel *midfourlabfou        = [[UILabel alloc]init];
    midfourlabfou.textAlignment   = NSTextAlignmentCenter;
    midfourlabfou.textColor       = [UIColor blackColor];
    midfourlabfou.text            = @"招聘中心";
    midfourlabfou.font            = [UIFont systemFontOfSize:12.0f];
    [midfourviewfou addSubview:midfourlabfou];
    
    [midfourlabfou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(midwidth, 15));
        make.top. equalTo (midfourimgfou.mas_bottom).with.offset(5);
        make.left.equalTo (midfourviewfou).with.offset(0);
    }];
}

#pragma -mark 转让事件
-(void)midoneGesclick:(UITapGestureRecognizer *)GES{
    NSLog(@"转让");
    TransferserviceController *ctl =[[TransferserviceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示

}

#pragma -mark 出租事件
-(void)midtwoGesclick:(UITapGestureRecognizer *)GES{
     NSLog(@"出租");

    RentserviceController *ctl =[[RentserviceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}

#pragma -mark 选址事件
-(void)midthrGesclick:(UITapGestureRecognizer *)GES{
    
    ChooseserviceController *ctl =[[ChooseserviceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}

#pragma -mark 招聘事件
-(void)midfouGesclick:(UITapGestureRecognizer *)GES{
     NSLog(@"招聘");
   
    RecruitserviceController *ctl =[[RecruitserviceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}

#pragma -mark 充值按钮
-(void)creatrecharge{
//    按钮
    self.rechargebtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargebtn setTitle:@"充 值" forState:UIControlStateNormal];
    [self.rechargebtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    self.rechargebtn.titleLabel.font  = [UIFont systemFontOfSize:20.0f];
    [self.rechargebtn setTintColor:[UIColor whiteColor]];
    [self.rechargebtn addTarget:self action:@selector(rechargeclick:) forControlEvents:UIControlEventTouchUpInside];
    [IntergralScroll addSubview:self.rechargebtn];
    [self.rechargebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 40));
        make.left.equalTo(IntergralScroll).with.offset(20);
        make.top.equalTo(self.midview.mas_bottom).with.offset(24);
    }];
    
//    协议
//    UITapGestureRecognizer *MidGes   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Protocolclick:)];
//    [MidGes setNumberOfTapsRequired:1];
//   UILabel * protocollab = [[UILabel alloc]init];
//    protocollab.textColor = kTCColor(102, 102, 102);
//    protocollab.textAlignment = NSTextAlignmentCenter;
//    NSMutableAttributedString *str      = [[NSMutableAttributedString alloc] initWithString:@"点击上述按钮即同意《中国铺皇网充值服务信息合同》及授权条款"];
//    [str addAttribute:NSForegroundColorAttributeName value:kTCColor(31, 169, 255) range:NSMakeRange(9, 15)];
//    protocollab.attributedText              = str;
//    protocollab.font                        = [UIFont systemFontOfSize:9.0f];
//    protocollab.userInteractionEnabled       = YES;
//    [protocollab addGestureRecognizer:MidGes];
//    [IntergralScroll addSubview:protocollab];
//
//    [protocollab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.rechargebtn.mas_bottom).with.offset(5);
//        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 15));
//        make.left.equalTo(IntergralScroll).with.offset(20);
//    }];
}

#pragma -mark 充值按钮事件
-(void)rechargeclick:(UIButton *)btn{
    NSLog(@"充值moneys");
   
    YJLshowpayController *ctl =[[YJLshowpayController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}


//#pragma -mark 协议点击事件
//-(void)Protocolclick:(UIGestureRecognizer *)GES{
//
//    NSLog(@"协议点击");
//}

#pragma -mark 温馨提醒
-(void)creataleat{
    
    self.aleat= [[UILabel alloc]init];
    self. aleat.text = @"温馨提示\n\n1.该积分可用于店铺转让、店铺出租、店铺选址、招聘中心等业务开通；\n\n2.积分业务一经开通后不支持退款；\n\n3.充值后若还是无法正常使用，请尝试联系客服；";
    self.aleat.textColor        = [UIColor blackColor];
    self.aleat.textAlignment    = NSTextAlignmentLeft;
    self.aleat.numberOfLines    = 0;
    self.aleat.font             = [UIFont systemFontOfSize:12.0f];
    [IntergralScroll addSubview:self.aleat];
    
    [self.aleat mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 150));
        make.top.equalTo(self.rechargebtn.mas_bottom).with.offset(30);
        make.left.equalTo(IntergralScroll).with.offset(20);
    }];
    
#pragma -mark 积分活动
    self.changeimg = [[UIImageView alloc]init];
    self.changeimg.image =[UIImage imageNamed:@"积分活动"];
    self.changeimg.userInteractionEnabled = YES;
    UITapGestureRecognizer *changeGES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeGesclick:)];
    [self.changeimg addGestureRecognizer:changeGES];
    [IntergralScroll addSubview:self.changeimg];
    
    [self.changeimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aleat.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 175));
        make.left.equalTo(IntergralScroll).with.offset(0);
    }];
}

#pragma -mark 获取分享码
-(void)loadsharecode{
    
    //    UMSocialPlatformType_Sina               = 0, //新浪
    //    UMSocialPlatformType_WechatSession      = 1, //微信聊天
    //    UMSocialPlatformType_WechatTimeLine     = 2, //微信朋友圈
    //    UMSocialPlatformType_QQ                 = 4, //QQ聊天页面
    //    UMSocialPlatformType_Qzone              = 5, //qq空间  暂时出错
    //    @(UMSocialPlatformType_WechatTimeLine)]
    //    设置分享平台的顺序。如果没有择出现很多不需要的
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//默认的方式
    
    NSDictionary *params = @{@"id": [[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]};
    
    [manager POST:Sharecodepath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"邀请码数据----%@",responseObject[@"data"]);
        
             code = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败----%@",error);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"服务器访问存在限制，请稍后！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
               NSLog(@"确定");
        }];
        
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

#pragma -mark 活动兑换
-(void)changeGesclick:(UITapGestureRecognizer *)GES{
    NSLog(@"积分兑换");
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo){
        
            [self shareWebPageToPlatformType:platformType];
    }];
}

#pragma mark 分享调用 (分享网页链接)

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    
    //    如果分享的url中含有中文字符，需要将中文部分进行url转码后可正常分享。 如：https://www.umeng.com/U-Share分享 需要将「分享」二字进行url转码放在链接中再进行分享，如下： https://www.umeng.com/U-Share%E5%88%86%E4%BA%AB
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象  主标题+副标题+图片
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享的邀请码，下载APP注册成功给好友增加积分" descr:code thumImage:[UIImage imageNamed:@"Applogo"]];
    //设置网页地址 放置店铺URL
    //设置网页地址 放置店铺URL
    shareObject.webpageUrl = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/%@/id1315260303?l=zh&ls=1&mt=8",[@"铺皇" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]; //@" https://itunes.apple.com/us/app/铺皇/id1315260303?l=zh&ls=1&mt=8";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
   //                              调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }
            else
            {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

#pragma mark 分享错误提示
-(void)alertWithError:(NSError *)error{
    NSLog(@"错误信息=%@",error);
    if (!error) {
    
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"分享成功"];
        [YJLHUD dismissWithDelay:2];
        
    }else{
        
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:[NSString stringWithFormat:@"%@",error]];
        [YJLHUD dismissWithDelay:2];
    }
}

#pragma -mark 按钮返回
-(void)clickback:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{

    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
//    NSLog(@"已经滑动====%f",offset);
    if (offset  >  20 ){
        //    根据滑动的距离增加透明度
        CGFloat alpha = MIN(1, offset / 40);
        self.Navview.backgroundColor = BXAlphaColor(77, 166, 214, alpha);
    }else{
        self.Navview.backgroundColor = BXAlphaColor(77, 166, 214, 0);
    }
    
    if (offset > 44) {
        CGFloat alpha               = MIN(1, offset / 88);
        self.Titlelab.textColor     = kTCColor2(255, 255, 255, alpha);
        [_BackBtn setImage:[UIImage imageNamed:@"baise_fanghui"] forState:UIControlStateNormal];
    }else{
        
        self.Titlelab.textColor     = kTCColor2(0, 0, 0, 1);
        [_BackBtn setImage:[UIImage imageNamed:@"heise_fanghui"] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
 
    //    让导航栏不显示出来***********************************
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //    获取数据
    [self loaddata];
    
    [self loadsharecode];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}
@end
