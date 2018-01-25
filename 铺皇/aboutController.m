//
//  aboutController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "aboutController.h"

@interface aboutController ()<UIScrollViewDelegate>{
//    UIView  *   IntroduceView ;
}

@property (nonatomic,strong )UIScrollView *Mainscrollview;
@property (nonatomic,strong )UIImageView  *iconimgView;
@property (nonatomic,strong) UILabel *iconname;
@property (nonatomic,strong) UILabel *left1;
@property (nonatomic,strong)UIImageView *left1_line;
@property (nonatomic,strong) UILabel *right1;

@property (nonatomic,strong) UILabel *left2;
@property (nonatomic,strong)UIImageView *left2_line;
@property (nonatomic,strong) UILabel *right2;

@property (nonatomic,strong) UILabel *left3;
@property (nonatomic,strong)UIImageView *left3_line;
@property (nonatomic,strong) UILabel *right3;

@property (nonatomic,strong) UILabel *left4;
@property (nonatomic,strong) UIImageView *left4_line;
@property (nonatomic,strong) UILabel *right4;
@property(nonatomic,strong)  UIButton *TELbtn;
@property(nonatomic,strong)  UILabel  *company;

@end

@implementation aboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(backset4)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];

    [self creatverson];
    
}

-(void)creatverson{
    
    if (iOS11) {
        self.Mainscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    }else{
        self.Mainscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+49)];
    }
    
    self.Mainscrollview.userInteractionEnabled = YES;
    self.Mainscrollview.showsVerticalScrollIndicator = YES;
    self.Mainscrollview.showsHorizontalScrollIndicator = YES;
    self.Mainscrollview.delegate = self;
    self.Mainscrollview.contentSize = CGSizeMake(KMainScreenWidth, KMainScreenHeight);
    [self.view addSubview:self.Mainscrollview];
    
#pragma -mark AppLogo
    self.iconimgView             = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Applogo"]];
    [self.Mainscrollview addSubview:self.iconimgView];
    [self.iconimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Mainscrollview).with.offset(20);
        make.left.equalTo(self.Mainscrollview).with.offset(KMainScreenWidth/2-40);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    #pragma -mark Appname
    self.iconname                = [[UILabel alloc]init];
    self.iconname.text           =  @"铺皇";
    self.iconname.textColor = kTCColor(85, 85, 85);
    self.iconname.textAlignment  = NSTextAlignmentCenter;
//    self.iconname.backgroundColor  =  [UIColor cyanColor];
    self.iconname.font           = [UIFont systemFontOfSize:16.0f];
    [self.Mainscrollview addSubview:self.iconname];
    [self.iconname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconimgView.mas_bottom).with.offset(5);
        make.left.equalTo(self.Mainscrollview).with.offset(KMainScreenWidth/2-40);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
#pragma -mark 版本信息
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称:%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    
    self.left1                  = [[UILabel alloc]init];
    self.left1.text             = @"版本信息";
    self.left1.textColor        = [UIColor blackColor];
    self.left1.textAlignment    = NSTextAlignmentLeft;
//    self.left1.backgroundColor  = [UIColor cyanColor];
    self.left1.font             = [UIFont systemFontOfSize:14.0f];
    [self.Mainscrollview addSubview:self.left1];
    [self.left1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconname.mas_bottom).with.offset(40);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    
    self.right1                  = [[UILabel alloc]init];
    self.right1.text             = [NSString stringWithFormat:@"%@(%@)",appCurName,appCurVersion];
    self.right1.textColor        = [UIColor blackColor];
    self.right1.textAlignment    = NSTextAlignmentRight;
//    self.right1.backgroundColor  = [UIColor cyanColor];
    self.right1.font             = [UIFont systemFontOfSize:14.0f];
    [self.Mainscrollview addSubview:self.right1];
    [self.right1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconname.mas_bottom).with.offset(40);
        make.left.equalTo(self.left1.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-80, 20));
    }];
   
    self.left1_line             =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutus_line"]];
    [self.Mainscrollview addSubview:self.left1_line];
    [self.left1_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.left1.mas_bottom).with.offset (0);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(KMainScreenWidth-20);
    }];
    
#pragma -mark 官方网站
    self.left2                  = [[UILabel alloc]init];
    self.left2.text             = @"官方网站";
    self.left2.textColor        = [UIColor blackColor];
    self.left2.textAlignment    = NSTextAlignmentLeft;
//    self.left2.backgroundColor  = [UIColor cyanColor];
    self.left2.font             = [UIFont systemFontOfSize:14.0f];
    [self.Mainscrollview addSubview:self.left2];
    [self.left2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.left1_line.mas_bottom).with.offset(20);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.right2                  = [[UILabel alloc]init];
    self.right2.text             = @"https://chinapuhuang.com";
    self.right2.textColor        = kTCColor(77, 166, 214);
    self.right2.textAlignment    = NSTextAlignmentRight;
//    self.right2.backgroundColor  = [UIColor cyanColor];
    self.right2.font             = [UIFont systemFontOfSize:14.0f];
    [self.Mainscrollview addSubview:self.right2];
    [self.right2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.left1_line.mas_bottom).with.offset(20);
        make.left.equalTo(self.left2.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-80, 20));
    }];
    
    self.left2_line =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutus_line"]];
    [self.Mainscrollview addSubview:self.left2_line];
    [self.left2_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.left2.mas_bottom).with.offset (0);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(KMainScreenWidth-20);
    }];
     self.right2.userInteractionEnabled = YES;
    UITapGestureRecognizer *left2Tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(left2:)];
    [left2Tap setNumberOfTapsRequired:1];
    [self.right2  addGestureRecognizer:left2Tap];
    
    #pragma -mark 联系我们
    self.left3                  = [[UILabel alloc]init];
    self.left3.text             = @"联系我们";
    self.left3.textColor        = [UIColor blackColor];
    self.left3.textAlignment    = NSTextAlignmentLeft;
//    self.left3.backgroundColor  = [UIColor cyanColor];
    self.left3.font             = [UIFont systemFontOfSize:14.0f];
    [self.Mainscrollview addSubview:self.left3];
    [self.left3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.left2_line.mas_bottom).with.offset(20);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.right3                  = [[UILabel alloc]init];
    self.right3.text             = @"查看";
//    self.right3.textColor        = [UIColor blackColor];
    self.right3.textAlignment    = NSTextAlignmentRight;
//    self.right3.backgroundColor  = [UIColor cyanColor];
    self.right3.font             = [UIFont systemFontOfSize:14.0f];
    [self.Mainscrollview addSubview:self.right3];
    [self.right3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.left2_line.mas_bottom).with.offset(10);
        make.left.equalTo(self.left3.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-80, 20));
    }];
    
    self.left3_line =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutus_line"]];
    [self.Mainscrollview addSubview:self.left3_line];
    [self.left3_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.left3.mas_bottom).with.offset (0);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(KMainScreenWidth-20);
    }];
    
    self.right3.userInteractionEnabled = YES;
    UITapGestureRecognizer *left3Tap   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(left3:)];
    [left3Tap setNumberOfTapsRequired:1];
    [self.right3  addGestureRecognizer:left3Tap];
    
#pragma -mark 功能介绍
    self.left4                  = [[UILabel alloc]init];
    self.left4.text             = @"功能介绍";
    self.left4.textColor        = [UIColor blackColor];
    self.left4.textAlignment    = NSTextAlignmentLeft ;
    //    self.left3.backgroundColor  = [UIColor cyanColor];
    self.left4.font             = [UIFont systemFontOfSize:14.0f];
    [self.Mainscrollview addSubview:self.left4];
    [self.left4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.left3_line.mas_bottom).with.offset(20);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.right4                  = [[UILabel alloc]init];
    self.right4.text             = @"浏览";
    //    self.right3.textColor        = [UIColor blackColor];
    self.right4.textAlignment    = NSTextAlignmentRight;
    //    self.right3.backgroundColor  = [UIColor cyanColor];
    self.right4.font             = [UIFont systemFontOfSize:14.0f];
    [self.Mainscrollview addSubview:self.right4];
    [self.right4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.left3_line.mas_bottom).with.offset(10);
        make.left.equalTo(self.left4.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-80, 20));
    }];
    
    self.left3_line =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutus_line"]];
    [self.Mainscrollview addSubview:self.left3_line];
    [self.left3_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.left4.mas_bottom).with.offset (0);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(KMainScreenWidth-20);
    }];
     self.right4.userInteractionEnabled = YES;
    UITapGestureRecognizer *left4Tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(left4:)];
    [left4Tap setNumberOfTapsRequired:1];
    [self.right4  addGestureRecognizer:left4Tap];
    
    self.TELbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.TELbtn.backgroundColor  = [UIColor cyanColor];
    [self.TELbtn setTitle:@"客服电话：0755-23212184" forState:UIControlStateNormal];
    [self.TELbtn setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    [self.TELbtn addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchUpInside];
    [self.Mainscrollview addSubview:self.TELbtn];
    [self.TELbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Mainscrollview).with.offset(KMainScreenHeight-64-49-40);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-20, 30));
    }];
    
#pragma -mark 底部2
    self.company                  = [[UILabel alloc]init];
    self.company.text             = @"深圳市铺王电子商务有限公司\nCopyright © 2008-2017";
    self.company.textAlignment    = NSTextAlignmentCenter;
//    self.company.backgroundColor  = [UIColor cyanColor];
    self.company.font             = [UIFont systemFontOfSize:14.0f];
    self.company.textColor        = kTCColor(161, 161, 161);
    self.company.numberOfLines   = 0;
    [self.Mainscrollview addSubview:self.company];
    [self.company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TELbtn.mas_bottom).with.offset(5);
        make.left.equalTo(self.Mainscrollview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-20, 40));
    }];
    
}

#pragma -mark 进入官网
-(void)left2:(UIButton *)btn {
    
    NSLog(@"进入官网");
   
    WebsetController *ctl = [[WebsetController alloc]init];
    ctl.url = @"http://chinapuhuang.com";
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

-(void)left3:(UIButton *)btn {
    
    NSLog(@"查看公众号");

    PHGZHController *ctl = [[PHGZHController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

-(void)left4:(UIButton *)btn {
    NSLog(@"功能介绍");

    Introduce_Guide *GUIDE_VIEW = [[Introduce_Guide alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    [[UIApplication sharedApplication].delegate.window addSubview:GUIDE_VIEW];
    [UIView animateWithDuration:1.0 delay:1.0f usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         GUIDE_VIEW.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);

    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
    }];
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
 
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 返回
-(void)backset4{
    
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
}

- (void)phone:(UIButton *)sender {
    
    NSLog(@"联系客服小姐");

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
@end
