//
//  RentserviceController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/8/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RentserviceController.h"
@interface RentserviceController ()<UIScrollViewDelegate>
{
    //    背景视图Scrollow
    UIScrollView *  MainScrollow;
    
    //    顶部
    UIButton    *   Headerbackbtn;
      UIButton    *   Headershopbtn;
    UIView      *   Navview;
    UILabel     *   Navtitle;
    UIImageView *   Headerimage;
    UILabel     *   Headermainlab;
    UILabel     *   Headersublab;
    UIImageView *   Headergift;
    
    //    中间 1
    UIView      *   Midview;
    UIView      *   MidFloctview;
    UILabel     *   Midmainlab;
    UILabel     *   Midsublab;
    UIButton    *   Midmainbtn;
    UILabel     *   Midprotocollab;
    
    //    中间 2
    UIImageView *   MidThreeimage;
    UILabel     *   midThreelab;
    UILabel     *   midsubThreelab;
    
    //    底部
    
    UIImageView *   Bottomimageview;
    UILabel     *   Bottomlab;
    
}

@end

@implementation RentserviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kTCColor(255, 255, 255);
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    [self creatHeadeview];
    [self creatMidview];
    [self creatThreeimage];
    [self creatBottomview];
}

-(void)creatHeadeview{
    
    MainScrollow                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, KMainScreenWidth, KMainScreenHeight+64)];
    MainScrollow.userInteractionEnabled         = YES;
    MainScrollow.showsVerticalScrollIndicator   = YES;
    MainScrollow.showsHorizontalScrollIndicator = YES;
    MainScrollow.delegate                       = self;
    MainScrollow.contentSize                    = CGSizeMake(KMainScreenWidth, KMainScreenHeight+100);
    [self.view addSubview:MainScrollow];
    
    Headerimage             = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 194)];
    Headerimage.image       = [UIImage imageNamed:@"banner background@2x"];
    [MainScrollow addSubview:Headerimage];
    
    Navview                 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 64)];
    Navview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:Navview];
    [self.view bringSubviewToFront:Navview];
    
    Navtitle            =  [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth/2-40, 20, 80, 44)];
    Navtitle.text       = @"商铺出租";
    Navtitle.textColor  = [UIColor blackColor];
    [Navview addSubview:Navtitle];
    
    Headerbackbtn             = [UIButton buttonWithType:UIButtonTypeCustom];
    Headerbackbtn.frame       = CGRectMake(0, 20, 44, 44);
    [Headerbackbtn setImage:[UIImage imageNamed:@"baise_fanghui"] forState:UIControlStateNormal];
    [Headerbackbtn addTarget:self action:@selector(Clickback) forControlEvents:UIControlEventTouchUpInside];
    [Navview addSubview:Headerbackbtn];
    
    Headershopbtn               = [UIButton buttonWithType:UIButtonTypeCustom];
    Headershopbtn.frame         = CGRectMake(KMainScreenWidth-64, 20, 44, 44);
    [Headershopbtn addTarget:self action:@selector(Clickshop) forControlEvents:UIControlEventTouchUpInside];
    [Navview addSubview:Headershopbtn];
    
    Headermainlab               =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Navview.frame)+5,KMainScreenWidth , 20)];
    Headermainlab.text          = @"全网布局广";
    Headermainlab.textAlignment =  NSTextAlignmentCenter;
    Headermainlab.textColor     = kTCColor(255, 255, 255);
    Headermainlab.font          = [UIFont systemFontOfSize:20.0f];
    [MainScrollow addSubview:Headermainlab];
    [MainScrollow bringSubviewToFront:Headermainlab];
    
    Headersublab               =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Headermainlab.frame)+10,KMainScreenWidth , 20)];
    Headersublab.text          = @"客户需求量大";
    Headersublab.textAlignment =  NSTextAlignmentCenter;
    Headersublab.textColor     = kTCColor(255, 255, 255);
    Headersublab.font          = [UIFont systemFontOfSize:20.0f];
    [MainScrollow addSubview:Headersublab];
    [MainScrollow bringSubviewToFront:Headersublab];
    
    UITapGestureRecognizer *HeaderGes   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Giftclick:)];
    [HeaderGes setNumberOfTapsRequired:1];
    Headergift                          = [[UIImageView alloc]initWithFrame:CGRectMake(KMainScreenWidth/2-12, Headerimage.frame.size.height-24, 24, 24)];
    Headergift.image                    = [UIImage imageNamed:@"new person gift@2x"];
    [Headergift addGestureRecognizer:HeaderGes];
    Headergift.userInteractionEnabled   = YES;
    [MainScrollow addSubview:Headergift];
    [MainScrollow bringSubviewToFront:Headergift];
}

-(void)creatMidview{
    
    //    mid块背景色加灰
    Midview                         = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Headerimage.frame), KMainScreenWidth, 155)];
    Midview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"midview_bg"]];
    [MainScrollow addSubview:Midview];
    
    //    mid悬浮块
    MidFloctview                    = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(Headerimage.frame)-6, KMainScreenWidth-20, 150)];
    MidFloctview.backgroundColor    = [UIColor whiteColor];
    MidFloctview.layer.cornerRadius = 10.0f;
    [MainScrollow addSubview:MidFloctview];
    
    //    mid悬浮块 UIlab
    Midmainlab                  =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, KMainScreenWidth-20, 20)];
    Midmainlab.textAlignment    = NSTextAlignmentCenter;
    Midmainlab.text             = @"商铺出租";
    //    Midmainlab.backgroundColor = [UIColor cyanColor];
    Midmainlab.font             = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];//加粗
    [MidFloctview addSubview:Midmainlab];
    
    //    mid悬浮块 UIlab
    Midsublab               =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Midmainlab.frame)+5, KMainScreenWidth-20, 20)];
    Midsublab.textAlignment = NSTextAlignmentCenter;
    Midsublab.text          = @"拥有多种模式和各大平台推广";
    //    Midsublab.backgroundColor = [UIColor cyanColor];
    Midsublab.textColor     = kTCColor(102, 102, 102);
    Midsublab.font          = [UIFont systemFontOfSize:13.0f];
    [MidFloctview addSubview:Midsublab];
    
    //    mid悬浮块 UIbutton
    Midmainbtn          = [UIButton buttonWithType:UIButtonTypeCustom];
    Midmainbtn.frame    = CGRectMake(20, CGRectGetMaxY(Midsublab.frame)+20, KMainScreenWidth-20-40, 40);
    [Midmainbtn setTitle:@"马上开通" forState:UIControlStateNormal];
    [Midmainbtn  setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [Midmainbtn addTarget:self action:@selector(Midclick:) forControlEvents:UIControlEventTouchUpInside];
    [MidFloctview addSubview:Midmainbtn];
    
    UITapGestureRecognizer *MidGes   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Protocolclick:)];
    [MidGes setNumberOfTapsRequired:1];
    Midprotocollab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Midmainbtn.frame)+2, KMainScreenWidth-20, 20)];
    Midprotocollab.textColor = kTCColor(102, 102, 102);
    Midprotocollab.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击上述按钮《中国铺皇网商铺出租信息合同》及授权条款"];
    [str addAttribute:NSForegroundColorAttributeName value:kTCColor(31, 169, 255) range:NSMakeRange(6, 15)];
    Midprotocollab.attributedText = str;
    Midprotocollab.font = [UIFont systemFontOfSize:9.0f];
    Midprotocollab.userInteractionEnabled = YES;
    [Midprotocollab addGestureRecognizer:MidGes];
    [MidFloctview addSubview:Midprotocollab];
}

-(void)creatThreeimage{
    
    for (int i = 1; i < 4; i++){
        MidThreeimage = [[UIImageView alloc]initWithFrame:CGRectMake(i*10+((KMainScreenWidth-40)/3)*(i-1), CGRectGetMaxY(Midview.frame), (KMainScreenWidth-40)/3, 169)];
        MidThreeimage.image  = [UIImage imageNamed:[NSString stringWithFormat:@"advertising%d",i]];
        [MainScrollow addSubview:MidThreeimage];
        MidThreeimage.userInteractionEnabled = YES;
        MidThreeimage.tag = i+100;
        
        midThreelab   = [[UILabel alloc]initWithFrame:CGRectMake(i*10+((KMainScreenWidth-40)/3)*(i-1), CGRectGetMaxY(Midview.frame) + 30, (KMainScreenWidth-40)/3, 20)];
        //        midThreelab.backgroundColor = randomColor;
        midThreelab.textAlignment = NSTextAlignmentCenter;
        midThreelab.numberOfLines = 0;
        midThreelab.font = [UIFont systemFontOfSize:15.0f];
        midThreelab.textColor =[UIColor whiteColor];
        [MainScrollow addSubview:midThreelab];
        
        midsubThreelab  = [[UILabel alloc]initWithFrame:CGRectMake(i*10+((KMainScreenWidth-40)/3)*(i-1), CGRectGetMaxY(midThreelab.frame) + 50, (KMainScreenWidth-40)/3, 40)];
        //        midsubThreelab.backgroundColor = randomColor;
        midsubThreelab.textAlignment = NSTextAlignmentCenter;
        midsubThreelab.numberOfLines = 0;
        midsubThreelab.font = [UIFont systemFontOfSize:11.0f];
        midsubThreelab.textColor =[UIColor whiteColor];
        [MainScrollow addSubview:midsubThreelab];
        
        switch (i) {
            case 1:
            {
                UITapGestureRecognizer *MidPicGes0   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MidThreeclick0:)];
                [MidPicGes0 setNumberOfTapsRequired:1];
                [MidThreeimage addGestureRecognizer:MidPicGes0];
                midThreelab.text = @"招聘中心";
                midsubThreelab.text =@"资源充足\n最优质的服务";
            }
                break;
            case 2:
            {
                UITapGestureRecognizer *MidPicGes1   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MidThreeclick1:)];
                [MidPicGes1 setNumberOfTapsRequired:1];
                [MidThreeimage addGestureRecognizer:MidPicGes1];
                midThreelab.text = @"商铺选址";
                midsubThreelab.text =@"优质推荐\n全方位审核";
            }
                break;
            default:{
                UITapGestureRecognizer *MidPicGes2   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MidThreeclick2:)];
                [MidPicGes2 setNumberOfTapsRequired:1];
                [MidThreeimage addGestureRecognizer:MidPicGes2];
                midThreelab.text = @"商铺转让";
                midsubThreelab.text =@"全网布局广\n客户需求量大";
            }
                break;
        }
    }
}

-(void)creatBottomview{
    Bottomlab  = [[UILabel alloc]initWithFrame:CGRectMake(10, KMainScreenHeight-110, KMainScreenWidth-20, 20)];
    Bottomlab.textAlignment = NSTextAlignmentCenter;
    Bottomlab.font = [UIFont  systemFontOfSize:13.0f];
    Bottomlab.textColor =[UIColor blackColor];
    Bottomlab.text = @"合作平台";
    [MainScrollow addSubview:Bottomlab];
    
    Bottomimageview  =[[UIImageView alloc]initWithFrame:CGRectMake(10, KMainScreenHeight-80, KMainScreenWidth-20, 60)];
    Bottomimageview.image = [UIImage imageNamed:@"partners"];
    [MainScrollow addSubview:Bottomimageview];
}

-(void)MidThreeclick0:(UITapGestureRecognizer *)tag{
    
    NSLog(@"招聘中心");
    RecruitserviceController *ctl =[[RecruitserviceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}
-(void)MidThreeclick1:(UITapGestureRecognizer *)tag{
    
    NSLog(@"商铺选址");
   
    ChooseserviceController *ctl =[[ChooseserviceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}
-(void)MidThreeclick2:(UITapGestureRecognizer *)tag{
    
    NSLog(@"商铺转让");
   
    TransferserviceController *ctl =[[TransferserviceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

-(void)Midclick:(UIButton *)btn{
    NSLog(@"马上开通出租");
   
    RenttaocanController *ctl =[[RenttaocanController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

-(void)Giftclick:(UITapGestureRecognizer *)tap{
    NSLog(@"礼物点击");
    
}

-(void)Protocolclick:(UITapGestureRecognizer *)tap{
    NSLog(@"协议点击");
    
    
    WebsetController *ctl = [[WebsetController alloc]init];
    ctl.url =@"https://ph.chinapuhuang.com/index.php/index/cz";//注册协议
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
//    NSLog(@"已经滑动====%f",offset);
    if (offset  >  20 ){
        //    根据滑动的距离增加透明度
        CGFloat alpha = MIN(1, offset / 40);
        Navview.backgroundColor = BXAlphaColor(77, 166, 214, alpha);
    }else{
        Navview.backgroundColor = BXAlphaColor(77, 166, 214, 0);
    }
    //导航栏的变化
    if (offset >130) {
        
        Navtitle.hidden = NO;
         [Headerbackbtn setImage:[UIImage imageNamed:@"heise_fanghui"] forState:UIControlStateNormal];
        [Headershopbtn setImage:[UIImage imageNamed:@"bag_black"] forState:UIControlStateNormal];
    }else{
        Navtitle.hidden = YES;
         [Headerbackbtn setImage:[UIImage imageNamed:@"baise_fanghui"] forState:UIControlStateNormal];
        [Headershopbtn setImage:[UIImage imageNamed:@"bag_white"] forState:UIControlStateNormal];
    }
    
}




#pragma  -mark - 进入背包
-(void)Clickshop{
    
    
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLTouchIDneed] isEqualToString:@"yes"])
    {
        
        LAContext *laContext = [[LAContext alloc] init];
        NSError *error = nil;
        
        if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
            
            [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                      localizedReason:@"需要授权Touch ID查询"
                                reply:^(BOOL success, NSError *error) {
                                    if (success) {
                                        NSLog(@"success to evaluate");
                                        
                                        [self joinBag];
                                    }
                                    
                                    if (error) {
                                        
                                        NSLog(@"---failed to evaluate---error: %@---", error.description);
                                    }
                                }];
        }
        
        else {
            
            NSLog(@"==========Not support :%@", error.description);
        }
        
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您尚未开启使用Touch ID进行查询" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"前往开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"开启");
           
            SafeController * NUMBER  = [[SafeController alloc]init];
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            [self.navigationController pushViewController:NUMBER animated:YES];
            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
            
        }];
        
        UIAlertAction *countinueAction = [UIAlertAction actionWithTitle:@"继续查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
            [self joinBag];
            
            NSLog(@"强行进入");
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
            NSLog(@"取消");
        }];
        
        [alertController addAction:countinueAction];
        [alertController addAction:commitAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

#pragma mark 指纹验证成功进行 跳转  //大坑 指纹是在子线程完成的操作 需要回到主线程刷新数据
-(void)joinBag{
    dispatch_async(dispatch_get_main_queue(), ^{
      
        BagczViewController *ctl =[[BagczViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        [self.navigationController pushViewController:ctl animated:YES];
        self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
    });
    NSLog(@"查看转让余下未使用的套餐");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    让导航栏不显示出来***********************************
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}

#pragma  -mark - 返回
-(void)Clickback{
    
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
    
}
#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

@end
