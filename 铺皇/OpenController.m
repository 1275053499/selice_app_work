//
//  OpenController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/8/21.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "OpenController.h"
@interface OpenController ()<UIScrollViewDelegate>{
    
    //    背景视图Scrollow
    UIScrollView *  MainScrollow;
    
    //    顶部
    UIButton    *   Headerbackbtn;
    UIButton    *   Headernextbtn;
    UIView      *   Navview;
    UILabel     *   Navtitle;
    UIImageView *   Headerimage;
    UIImageView *   Headernoimage;
    UIImageView *   Headeryesimage;
    UILabel     *   headerlabel;
    
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
    
     Contractmodel *model;
    
}

@end

@implementation OpenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"店铺🆔:%@ 傻我的唯一id",_shopid);
    model = [[Contractmodel alloc]init];
//    创建基本信息
    [self creatBase];
//    创建头部视图
    [self creatHeadeview];
//   中间Floatview
    [self creatMidview];
//    广告图
    [self creatThreeimage];
//    底部广告图
    [self creatBottomview];
    
}

-(void)creatHeadeview{
    
    MainScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, KMainScreenWidth, KMainScreenHeight+64)];
    MainScrollow.userInteractionEnabled         = YES;
    MainScrollow.showsVerticalScrollIndicator   = YES;
    MainScrollow.showsHorizontalScrollIndicator = YES;
    MainScrollow.delegate               = self;
    MainScrollow.contentSize            = CGSizeMake(KMainScreenWidth, KMainScreenHeight+100);
    [self.view addSubview:MainScrollow];
    
    Headerimage         = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 194)];
    Headerimage.image   = [UIImage imageNamed:@"banner background"];
    [MainScrollow addSubview:Headerimage];
    
    
    Navview  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 64)];
    Navview.backgroundColor =[UIColor clearColor];
    [self.view addSubview:Navview];
    [self.view bringSubviewToFront:Navview];
    
    Headerbackbtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    Headerbackbtn.frame     = CGRectMake(0, 20, 44, 44);
    [Headerbackbtn setImage:[UIImage imageNamed:@"baise_fanghui"] forState:UIControlStateNormal];
    [Headerbackbtn addTarget:self action:@selector(clickBlock) forControlEvents:UIControlEventTouchUpInside];
    [Navview addSubview:Headerbackbtn];

    Headeryesimage          = [[UIImageView alloc]init];
    Headeryesimage.frame    = CGRectMake(KMainScreenWidth/2-60, 37, 120, 120);
    Headeryesimage.image    = [UIImage imageNamed:@"no"];
    [MainScrollow addSubview:Headeryesimage];
    [MainScrollow bringSubviewToFront:Headeryesimage];
    
    headerlabel                 = [[UILabel alloc]init];
    headerlabel.frame           = CGRectMake(0, 0, 120, 20);
    headerlabel.text            = @"剩余XX天";
    headerlabel.center          = Headeryesimage.center;
    headerlabel.textColor       = [UIColor whiteColor];
    headerlabel.textAlignment   = NSTextAlignmentCenter;
    headerlabel.font            = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];//加粗
    [MainScrollow addSubview:headerlabel];
    [MainScrollow bringSubviewToFront:headerlabel];
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
    Midmainlab.text             = @"信息类型";
    Midmainlab.font             = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];//加粗
    [MidFloctview addSubview:Midmainlab];
    
    //    mid悬浮块 UIlab
    Midsublab               =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Midmainlab.frame)+5, KMainScreenWidth-20, 20)];
    Midsublab.textAlignment = NSTextAlignmentCenter;
    Midsublab.text          =  @"开始时间：---- 结束时间：";
    //    Midsublab.backgroundColor = [UIColor cyanColor];
    Midsublab.textColor     = kTCColor(102, 102, 102);
    Midsublab.font          = [UIFont systemFontOfSize:13.0f];
    [MidFloctview addSubview:Midsublab];
    
    //    mid悬浮块 UIbutton
    Midmainbtn          = [UIButton buttonWithType:UIButtonTypeCustom];
    Midmainbtn.frame    = CGRectMake(20, CGRectGetMaxY(Midsublab.frame)+20, KMainScreenWidth-20-40, 40);
    [Midmainbtn setTitle:@"续约" forState:UIControlStateNormal];
    [Midmainbtn  setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [Midmainbtn addTarget:self action:@selector(Midclick:) forControlEvents:UIControlEventTouchUpInside];
    [MidFloctview addSubview:Midmainbtn];
    
    UITapGestureRecognizer *MidGes   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Protocolclick:)];
    [MidGes setNumberOfTapsRequired:1];
    Midprotocollab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Midmainbtn.frame)+2, KMainScreenWidth-20, 20)];
    Midprotocollab.textColor            = kTCColor(102, 102, 102);
    Midprotocollab.textAlignment        = NSTextAlignmentCenter;
    NSMutableAttributedString *str      = [[NSMutableAttributedString alloc] initWithString:@"点击上述按钮《中国铺皇网商铺转让信息合同》及授权条款"];
    [str addAttribute:NSForegroundColorAttributeName value:kTCColor(31, 169, 255) range:NSMakeRange(6, 14)];
    Midprotocollab.attributedText            = str;
    Midprotocollab.font = [UIFont systemFontOfSize:9.0f];
    Midprotocollab.userInteractionEnabled    = YES;
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
        [MainScrollow bringSubviewToFront:midThreelab];
        
        midsubThreelab  = [[UILabel alloc]initWithFrame:CGRectMake(i*10+((KMainScreenWidth-40)/3)*(i-1), CGRectGetMaxY(midThreelab.frame) + 50, (KMainScreenWidth-40)/3, 40)];
        //        midsubThreelab.backgroundColor = randomColor;
        midsubThreelab.textAlignment = NSTextAlignmentCenter;
        midsubThreelab.numberOfLines = 0;
        midsubThreelab.font = [UIFont systemFontOfSize:11.0f];
        midsubThreelab.textColor =[UIColor whiteColor];
        [MainScrollow addSubview:midsubThreelab];
        [MainScrollow bringSubviewToFront:midsubThreelab];
        
        switch (i) {
            case 1:{
                
                UITapGestureRecognizer *MidPicGes0   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MidThreeclick0:)];
                [MidPicGes0 setNumberOfTapsRequired:1];
                [MidThreeimage addGestureRecognizer:MidPicGes0];
                midThreelab.text = @"招聘中心";
                midsubThreelab.text =@"资源充足\n最优质的服务";
            }
                break;
            case 2:{
                
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
                midThreelab.text = @"商铺出租";
                midsubThreelab.text =@"全网布局广\n客户需求量大";
            }
                break;
        }
    }
}

-(void)creatBottomview{
    Bottomlab               = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(MidThreeimage.frame)+20, KMainScreenWidth-20, 20)];
    Bottomlab.textAlignment = NSTextAlignmentCenter;
    Bottomlab.font          = [UIFont  systemFontOfSize:13.0f];
    Bottomlab.textColor     =[UIColor blackColor];
    Bottomlab.text          = @"合作平台";
    [MainScrollow addSubview:Bottomlab];
    
    Bottomimageview         =[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(Bottomlab.frame)+20, KMainScreenWidth-20, 60)];
    Bottomimageview.image   = [UIImage imageNamed:@"partners"];
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
    
    NSLog(@"商铺出租");
   
    RentserviceController *ctl =[[RentserviceController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
    
}

-(void)Midclick:(UIButton *)btn{
    
    if (!model.TTID) {
        
        NSLog(@"点击过快");
        [YJLHUD showErrorWithmessage:@"放慢脚步,欣赏景色"];
        [YJLHUD dismissWithDelay:1];
    }else{
        NSLog(@"<<<<<< 续约 >>>>");
       
        TransferSetmealController *ctl =[[TransferSetmealController alloc]init];//套餐页面
        ctl.isContract = @"isContract";     //续约字眼
        ctl.isContractshopid = model.TTID;      //店铺id
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        [self.navigationController pushViewController:ctl animated:YES];
        self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。

    }
}

-(void)Protocolclick:(UITapGestureRecognizer *)tap{
    NSLog(@"协议点击");
    WebsetController *ctl = [[WebsetController alloc]init];
    ctl.url =@"https://ph.chinapuhuang.com/index.php/index/zr";//注册协议
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

#pragma  - mark 返回上一页
-(void)clickBlock{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"选好了我要返回");
}

#pragma  mark 基本信息
-(void)creatBase{
    
    self.view.backgroundColor = [UIColor whiteColor];
}



-(void)loadData{
    
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    //        manager.requestSerializer           = [AFHTTPRequestSerializer serializer];//默认的方式
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;

    NSDictionary *params =  @{
                                 @"shopid":self.shopid
                             };
    [manager GET:ContractZRpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        
        NSLog(@"请求数据成功----%@",responseObject);
       
        model.SYTC      = responseObject[@"data"][@"home_times"];            //首页套餐
        model.SYTCstart = responseObject[@"data"][@"home_time"];             //首页套餐开始时间
        model.SYTCend   = responseObject[@"data"][@"home_timeed"];           //首页套餐结束时间
        model.SYSYtime  = responseObject[@"data"][@"h_time"];                //首页套餐剩余时间
        
        model.XXTCtime  = responseObject[@"data"][@"d_time"];                //信息套餐剩余时间
        model.XXTC      = responseObject[@"data"][@"display_times"];         //信息套餐
        model.XXTCstart = responseObject[@"data"][@"map_time"];              //信息套餐开始时间
        model.XXTCend   = responseObject[@"data"][@"display_timeed"];        //信息套餐结束时间
        
        model.TTID      = responseObject[@"data"][@"shopid"];                 //店铺id

        if ([model.SYSYtime integerValue] == 0) {
            
            Headeryesimage.image        = [UIImage imageNamed:@"no"];//剩余XX天图片
        }
        else  if ([model.SYSYtime integerValue] >0&&[model.SYSYtime integerValue]<=30) {
            
            Headeryesimage.image        = [UIImage imageNamed:@"one"];
            
        }else if ([model.SYSYtime integerValue] >30&&[model.SYSYtime integerValue]<=60){
            
            Headeryesimage.image        = [UIImage imageNamed:@"two"];
        }
        else{
            
            Headeryesimage.image        = [UIImage imageNamed:@"three"];
        }
        
        headerlabel.text           = [NSString stringWithFormat:@"剩余%@天",model.SYSYtime];//剩余XX天
        Midmainlab.text            = [NSString stringWithFormat:@"%@",model.SYTC];//首页套餐30天
        Midsublab.text             = [NSString stringWithFormat:@"开始时间:%@---结束时间:%@",model.SYTCstart,model.SYTCend];//开始时间-结束时间
        
        
        if (model.XXTC.length>0) {
            NSLog(@"有2类套餐");
            Headernextbtn           = [UIButton buttonWithType:UIButtonTypeCustom];
            Headernextbtn.frame     = CGRectMake(KMainScreenWidth-70, 20, 60, 44);
            [Headernextbtn setTitle:@"其他套餐" forState:UIControlStateNormal];
            Headernextbtn.titleLabel.textColor       = [UIColor blueColor];
            Headernextbtn.titleLabel.font            = [UIFont systemFontOfSize:14.0f];
            Headernextbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [Headernextbtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
            [Navview addSubview:Headernextbtn];
            
        }else{
            
            NSLog(@"有1类套餐");
        }
        
        
        [YJLHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"请求数据失败----%@",error);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
           
            [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
            [YJLHUD dismissWithDelay:1];
            dispatch_async(dispatch_get_main_queue(),^{
                
                 [self clickBlock];
            });
        });
    
    }];
}


-(void)next:(id)sender{
    NSLog(@"套餐2");
   
    OpennextController *ctl =[[OpennextController alloc]init];
    ctl.shopnextid =model.TTID;
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
//     self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    加载信息数据 同时创建了控件赋值
    [self loadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
    
}


@end
