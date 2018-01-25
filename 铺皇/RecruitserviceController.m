//
//  RecruitserviceController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/8/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RecruitserviceController.h"

@interface RecruitserviceController ()<UIScrollViewDelegate>
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

@implementation RecruitserviceController

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

    
    Headerimage         = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 194)];
    Headerimage.image   = [UIImage imageNamed:@"banner background@2x"];
    [MainScrollow addSubview:Headerimage];
    
    Navview                 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 64)];
    Navview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:Navview];
    [self.view bringSubviewToFront:Navview];
    
    Navtitle =  [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth/2-40, 20, 80, 44)];
    Navtitle.text = @"招聘中心";
    Navtitle.textColor = [UIColor blackColor];
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
    Headermainlab.text          = @"资源充足";
    Headermainlab.textAlignment =  NSTextAlignmentCenter;
    Headermainlab.textColor     = kTCColor(255, 255, 255);
    Headermainlab.font          = [UIFont systemFontOfSize:20.0f];
    [MainScrollow addSubview:Headermainlab];
    [MainScrollow bringSubviewToFront:Headermainlab];
    
    Headersublab               =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Headermainlab.frame)+10,KMainScreenWidth , 20)];
    Headersublab.text          = @"最优质的服务";
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
    Midmainlab.text             = @"招聘中心";
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
    [Midmainbtn setTitle:@"购买招聘信息量" forState:UIControlStateNormal];
    [Midmainbtn  setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [Midmainbtn addTarget:self action:@selector(Midclick:) forControlEvents:UIControlEventTouchUpInside];
    [MidFloctview addSubview:Midmainbtn];
    
    UITapGestureRecognizer *MidGes   =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Protocolclick:)];
    [MidGes setNumberOfTapsRequired:1];
    Midprotocollab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(Midmainbtn.frame)+2, KMainScreenWidth-20, 20)];
    Midprotocollab.textColor = kTCColor(102, 102, 102);
    Midprotocollab.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击上述按钮《中国铺皇网招聘服务信息合同》及授权条款"];
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
                midThreelab.text = @"商铺转让";
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
                midThreelab.text = @"商铺出租";
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
    
    NSLog(@"商铺转让");
    
    TransferserviceController *ctl =[[TransferserviceController alloc]init];
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
    
    NSLog(@"马上开通招聘");
   
    RecuritSetmalController *ctl     = [[RecuritSetmalController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

-(void)Giftclick:(UITapGestureRecognizer *)tap{
    NSLog(@"礼物点击");
}

#pragma -mark 协议点击
-(void)Protocolclick:(UITapGestureRecognizer *)tap{
    NSLog(@"协议点击");

    WebsetController *ctl = [[WebsetController alloc]init];
    ctl.url =@"https://ph.chinapuhuang.com/index.php/index/zp";//注册协议
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    
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

#pragma  -mark - 背包
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
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                             [self joinBag];
                                            
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

-(void)joinBag{
    
    NSLog(@"加载数据中.....");
   
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"查询数据中～"];
    
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;

    NSDictionary *params = @{
                                 @"id":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                             };
    [manager GET:Myservicezpbagpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        
        NSLog(@"请求成功咧");
        NSString * recruits = [NSString new];
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            
            [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"查询成功～"];
            [YJLHUD dismissWithDelay:1.0f];
            
            NSLog(@"可以拿到数据的");
            for (NSDictionary *dic in responseObject[@"data"]){
                
                NSLog(@"数据:%@",dic[@"recruits"]);
                recruits = dic[@"recruits"];
                
            }
            
            if ([recruits integerValue] > 0) {
                [LEEAlert alert].config
                
                .LeeAddTitle(^(UILabel *label) {
                    
                    label.text = @"尊敬的用户";
                    
                    label.textColor = [UIColor blackColor];
                })
                .LeeAddContent(^(UILabel *label) {
                    
                    label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.75f];
                    NSString *content = [NSString stringWithFormat:@"您当前还可以发布招聘信息%@条,是否需要发布?",recruits];
                    NSArray *number = @[@"您",@"当",@"前",@"还",@"可",@"以",@"发",@"布",@"招",@"聘",@"信",@"息",@"条",@",",@"是",@"否",@"需",@"要",@"?"];
                    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
                    for (int i = 0; i < content.length; i ++) {
                        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
                        if ([number containsObject:a]) {
                            [attributeString setAttributes:@{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.75f]} range:NSMakeRange(i, 1)];
                        }
                    };
                    
                    label.attributedText = attributeString;
                    
                })
                
                .LeeAddAction(^(LEEAction *action) {
                    
                    action.type = LEEActionTypeCancel;
                    
                    action.title = @"放弃";
                    
                    action.titleColor = kTCColor(255, 255, 255);
                    
                    action.backgroundColor = kTCColor(174, 174, 174);
                    
                    action.clickBlock = ^{
                        
                        NSLog(@"放弃");
                    };
                })
                
                .LeeAddAction(^(LEEAction *action) {
                    
                    action.type = LEEActionTypeDefault;
                    
                    action.title = @"发布";
                    
                    action.titleColor = kTCColor(255, 255, 255);
                    
                    action.backgroundColor = kTCColor(77, 166, 214);
                    
                    action.clickBlock = ^{
                        
                        ReleaseXZController *ctl =[[ReleaseXZController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    };
                })
                
                .LeeHeaderColor(kTCColor(255, 255, 255))
                .LeeShow();
                NSLog(@"数据拿到了 ");
                
            }else{
                
               
                [YJLHUD showErrorWithmessage:@"您尚未购买招聘套餐"];
                [YJLHUD dismissWithDelay:2];
            }
        }
        else{
            
            
            //code 401
            NSLog(@"不可以拿到数据的");
        
            [YJLHUD showErrorWithmessage:@"服务器烦忙，请稍后再来～"];
            [YJLHUD dismissWithDelay:2];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        [YJLHUD showErrorWithmessage:@"服务器烦忙，请稍后再来～"];
        [YJLHUD dismissWithDelay:2];
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
