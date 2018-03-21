//
//  ShopsiteXQController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/8.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsiteXQController.h"
#import "ShopsiteXQViewCell.h"
#import "Defination.h"
#import "siteXQmodel.h"


@interface ShopsiteXQController ()<UITableViewDelegate,UITableViewDataSource>{
     BOOL isSC;

     NSString * URL;
}
@property (nonatomic , strong)ShoppingBtn       *SCBtn;
@property (nonatomic , strong)UIButton          *LXBtn;
@property (nonatomic , strong)siteXQmodel       *model;

@end

@implementation ShopsiteXQController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.view.backgroundColor = kTCColor(255, 255, 255);
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];
//    返回
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClicksite)];
    self.navigationItem.leftBarButtonItem = backItm;

    self.title = @"选址店铺详情";
    dataArr = [[NSMutableArray alloc]init];
    _model = [[siteXQmodel alloc]init];
    NSLog(@"传值过来的店铺固定subid=%@",_shopsubid);
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+20)];
   
    //    隐藏右侧滚动条
    _tableView.showsVerticalScrollIndicator = NO;
    //    隐藏分割线
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    

#pragma -mark 数据获取
    [self loaddata];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
}

-(void)loaddata{
   
     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    //判断登录状态
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]) {
       URL= [NSString stringWithFormat:@"%@?subid=%@&uid=%@",Hostselectionpath,_shopsubid,[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]];
        NSLog(@"登录店铺详情入境：%@",URL);
    }else{
        URL = [NSString stringWithFormat:@"%@?subid=%@",Hostselectionpath,_shopsubid];
        NSLog(@"未登录店铺详情入境：%@",URL);
    }
    
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
  [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
     
      
         _model.Shoptitle     = responseObject[@"data"][@"title"];
         _model.Shoptime      = responseObject[@"data"][@"time"];
         _model.Shoprent      = responseObject[@"data"][@"rent"];
         _model.Shoparea      = responseObject[@"data"][@"areas"];
         _model.Shoptype       = responseObject[@"data"][@"type"];
         _model.Shopquyu      = responseObject[@"data"][@"area"];
         _model.ShopXQrent    = responseObject[@"data"][@"rent"];
         _model.ShopXQarea    = responseObject[@"data"][@"areas"];
         _model.ShopXQtype    = responseObject[@"data"][@"type"];
         _model.ShopXQquyu    = responseObject[@"data"][@"searchs"];
         _model.ShopXQdescribed= responseObject[@"data"][@"detail"];
         _model.Shopimg01 =responseObject[@"data"][@"facility"][0];
         _model.Shopimg02 =responseObject[@"data"][@"facility"][1];
         _model.Shopimg03 =responseObject[@"data"][@"facility"][2];
         _model.Shopimg04 =responseObject[@"data"][@"facility"][3];
         _model.Shopimg05 =responseObject[@"data"][@"facility"][4];
         _model.Shopimg06 =responseObject[@"data"][@"facility"][5];
         _model.Shopimg07 =responseObject[@"data"][@"facility"][6];
         _model.Shopimg08 =responseObject[@"data"][@"facility"][7];
         _model.Shopimg09 =responseObject[@"data"][@"facility"][8];
         _model.Shopimg10 =responseObject[@"data"][@"facility"][9];
         _model.Shopcollect =responseObject[@"data"][@"collect"];
        
#pragma mark   从本地缓存拿数据
  
        if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
            
            _model.ShopXQperson  = responseObject[@"data"][@"person"];
            _model.ShopXQnumber  = responseObject[@"data"][@"phone"];
        }else{
            
            _model.ShopXQperson  = @"客服专员";
            _model.ShopXQnumber  = @"0755-23212184";
        }
        
         [_model setValuesForKeysWithDictionary:responseObject];
         [dataArr addObject:_model];
         NSLog(@"数组数据？？=%ld",dataArr.count);
         [_tableView reloadData];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        //    底部按钮
        [self creatBottom];
        NSLog(@"收藏state:%@",_model.Shopcollect);
      
        if ([_model.Shopcollect isEqualToString:@"no"]) {
            isSC = NO;
            [_SCBtn setTitle:@"未收藏" forState:UIControlStateNormal];
            [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
        }else{
            isSC  = YES;
            [_SCBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
        }
        
      [YJLHUD showSuccessWithmessage:@"加载成功"];
      [YJLHUD dismissWithDelay:0.2];
     } failure:^(NSURLSessionDataTask *task, NSError *error)  {
         NSLog(@"error=====%@",error);
         [YJLHUD showErrorWithmessage:@"服务器开小差了，稍等~"];
         [YJLHUD dismissWithDelay:1];

     }];
}


#pragma  -mark 底部按钮
-(void)creatBottom{
    
    //    收藏
    _SCBtn  = [[ShoppingBtn alloc]initWithFrame: CGRectMake(0, KMainScreenHeight-49, 90, 49) buttonStyle:UIButtonStyleButtom spaceing:0 imagesize:25];
    _SCBtn.backgroundColor = [UIColor whiteColor];
    _SCBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _SCBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_SCBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_SCBtn addTarget:self action:@selector(SC:) forControlEvents:UIControlEventTouchUpInside];
    [_SCBtn setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_SCBtn setTitle:@"未收藏" forState:UIControlStateNormal];
    [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
    isSC = NO;
    [self.view addSubview:_SCBtn];

    //    联系房东
    _LXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _LXBtn.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"lvsekuai"]];
    _LXBtn.frame=CGRectMake(90, KMainScreenHeight-49, KMainScreenWidth-90, 49);
    [_LXBtn setImage:[UIImage imageNamed:@"lianxifangdong"] forState:UIControlStateNormal];
    [_LXBtn setTitle:@"联系铺主" forState:UIControlStateNormal];
    _LXBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_LXBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_LXBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_LXBtn addTarget:self action:@selector(LXclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_LXBtn];

}


#pragma - mark 联系房东
-(void)LXclick:(UIButton *)btn{
    
  if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]) {
    [LEEAlert alert].config
    
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = [NSString stringWithFormat:@"联系人：%@",_model.ShopXQperson];
        
        label.textColor = [UIColor blackColor];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = [NSString stringWithFormat:@"TEL:%@",_model.ShopXQnumber];
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
            NSString * str =[NSString stringWithFormat:@"tel://%@",_model.ShopXQnumber];
            NSLog(@"str======%@",str);
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
            
        };
    })
    .LeeHeaderColor(kTCColor(255, 255, 255))
    .LeeShow();
    
}
else{

    [YJLHUD showImage:nil message:@"请先登录账号"];//无图片 纯文字
    [YJLHUD dismissWithDelay:2];
}
}

#pragma - mark 收藏方法
-(void)SC:(UIButton *)btn{
    
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
        
        if (!isSC){
            //        添加收藏的
            [_SCBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
            
           
            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 5.0;
       
            NSDictionary *params = @{
                                     @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                     @"shopid":_shopsubid,
                                     @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                                     @"collect":@"1",
                                     };
            
            [manager POST:Hostxzcollectpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSLog(@"状态码:%@",responseObject[@"code"]);
                if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                    NSLog(@"收藏成功");
                    isSC = !isSC;
                
                    [YJLHUD showSuccessWithmessage:@"添加收藏成功"];
                    [YJLHUD dismissWithDelay:0.2];
                }
                
                else{
                    
                    NSLog(@"收藏失败");
                   
                    [YJLHUD showErrorWithmessage:@"添加收藏失败"];
                    [YJLHUD dismissWithDelay:0.2];
                    [_SCBtn setTitle:@"未收藏" forState:UIControlStateNormal];
                    [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"error:%@",error);
            
                [YJLHUD showErrorWithmessage:@"服务器繁忙~"];
                [YJLHUD dismissWithDelay:1];
            }];
        }
        
        else{
            
            //        取消收藏的
            [_SCBtn setTitle:@"未收藏" forState:UIControlStateNormal];
            [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
            
            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 10.0;
            NSDictionary *params = @{
                                     @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                     @"shopid":_shopsubid,
                                     @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                                     @"collect":@"0",
                                     };
            
            [manager POST:Hostxzcollectpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSLog(@"状态码:%@",responseObject[@"code"]);
                if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                    NSLog(@"取消收藏成功");
                    
                    isSC = !isSC;
                    [YJLHUD showSuccessWithmessage:@"取消收藏成功"];
                    [YJLHUD dismissWithDelay:0.2];
                   
                }
                else{
                 
                    [YJLHUD showErrorWithmessage:@"取消收藏失败"];
                   [YJLHUD dismissWithDelay:0.2];
                    
                    [_SCBtn setTitle:@"收藏" forState:UIControlStateNormal];
                    [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
                    NSLog(@"取消收藏失败");
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"error:%@",error);
            
                [YJLHUD showErrorWithmessage:@"服务器繁忙~"];
                [YJLHUD dismissWithDelay:1];
                
            }];
        }
       
    }else{
    
        [YJLHUD showImage:nil message:@"请先登录账号"];//无图片 纯文字
        [YJLHUD dismissWithDelay:2];
    }
    
}

#pragma  -mark -列表uitabviewcontroller
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellname";
    ShopsiteXQViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopsiteXQViewCell" owner:self options:nil]lastObject];
    }
    
    cell.shoptitle.text =[NSString stringWithFormat:@"%@",_model.Shoptitle]; //_model.Shoptime;
    cell.shoptime.text =[NSString stringWithFormat:@"%@",_model.Shoptime]; //_model.Shoptime;
    
    cell.shoprent.text =[NSString stringWithFormat:@"%@元/月",_model.Shoprent];// _model.Shoprent;
    cell.shoparea.text = [NSString stringWithFormat:@"%@m²",_model.Shoparea];//
    cell.shoptype.text =[NSString stringWithFormat:@"%@",_model.ShopXQtype];//
    
    cell.shopquyu.text  =[NSString stringWithFormat:@"%@",_model.Shopquyu];// _model.Shopquyu;
    cell.shoptype2.text =[NSString stringWithFormat:@"%@",_model.Shoptype2];// _model.Shoptype2;
    
    cell.shopXQrent.text    = [NSString stringWithFormat:@"%@元/月",  _model.ShopXQrent];//_model.ShopXQrent;
    cell.shopXQarea.text    = [NSString stringWithFormat:@"%@m²",    _model.ShopXQarea];//_model.ShopXQarea;
    cell.shopXQtype.text    = [NSString stringWithFormat:@"%@",      _model.ShopXQtype];//_model.ShopXQtype;
    cell.shopXQquyu.text    = [NSString stringWithFormat:@"%@",      _model.ShopXQquyu];//_model.ShopXQquyu;
    cell.shopXQnumber.text  = [NSString stringWithFormat:@"%@",      _model.ShopXQnumber];//_model.ShopXQnumber;
    cell.shopXQperson.text  = [NSString stringWithFormat:@"%@",      _model.ShopXQperson];// _model.ShopXQperson;
    cell.shopXQdescribed.text =[NSString stringWithFormat:@"%@",     _model.ShopXQdescribed]; //_model.ShopXQdescribed;
    
    
    if ([_model.Shopimg01 isEqualToString: @"1"] ) {
        //        NSLog(@"00000");
        cell.shopimg01.image = [UIImage imageNamed:@"shangxiahuo_blue"];
    }
    
    if ([_model.Shopimg02 isEqualToString: @"1"] ) {
        //        NSLog(@"00000");
        cell.shopimg02.image = [UIImage imageNamed:@"keminghuo_blue"];
    }
    if ([_model.Shopimg03 isEqualToString: @"1"]) {
        //        NSLog(@"00000");
        cell.shopimg03.image = [UIImage imageNamed:@"380V_blue"];
    }
    if ([_model.Shopimg04 isEqualToString: @"1"] ) {
        //        NSLog(@"00000");
        cell.shopimg04.image = [UIImage imageNamed:@"meiqiguandao_lvse"];
    }
    if ([_model.Shopimg05 isEqualToString: @"1"] ) {
        //        NSLog(@"00000");
        cell.shopimg05.image = [UIImage imageNamed:@"paiyan_blue"];
    }
    
    if ([_model.Shopimg06 isEqualToString: @"1"] ) {
        //        NSLog(@"00000");
        cell.shopimg06.image = [UIImage imageNamed:@"paiwu_blue"];
    }
    if ([_model.Shopimg07 isEqualToString: @"1"]) {
        //        NSLog(@"00000");
        cell.shopimg07.image = [UIImage imageNamed:@"park_blue"];
    }
    if ([_model.Shopimg08 isEqualToString: @"1"] ) {
        //        NSLog(@"00000");
        cell.shopimg08.image = [UIImage imageNamed:@"changqun_blue"];
    }
    if ([_model.Shopimg09 isEqualToString: @"1"]) {
        //        NSLog(@"00000");
        cell.shopimg09.image = [UIImage imageNamed:@"zhengjian_blue"];
    }
    if ([_model.Shopimg10 isEqualToString: @"1"] ) {
        //        NSLog(@"00000");
        cell.shopimg10.image = [UIImage imageNamed:@"kongtiao_blue"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 850;
}
#pragma mark 返回
- (void)BackButtonClicksite{
    
  
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
   
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

//#pragma mark 分享
//- (void)ShareButtonClicksite
//{
//
//    NSLog(@"shareing");
//    //    UMSocialPlatformType_WechatSession      = 1, //微信聊天
//    //    UMSocialPlatformType_WechatTimeLine     = 2, //微信朋友圈
//    //    UMSocialPlatformType_QQ                 = 4, //QQ聊天页面
//    //    UMSocialPlatformType_Qzone              = 5, //qq空间
//    //    @(UMSocialPlatformType_WechatTimeLine)]
//
//    //      设置分享平台的顺序。如果没有择出现很多不需要的
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
//
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//
//        [self shareWebPageToPlatformType:platformType];
//    }];
//}
//
//
//#pragma mark 分享调用
////分享网页链接。
////http://dev.umeng.com/social/ios/进阶文档#2     【全部分享类型】
//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//
//    //创建网页内容对象  主标题+副标题+图片
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎进入我的QQ空间" descr:@"欢迎您的光临～要不要进来看一看啊" thumImage:thumbURL];
//
//    //设置网页地址 放置店铺URL
//    shareObject.webpageUrl = @"https://user.qzone.qq.com/1275053499";
//
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        [self alertWithError:error];
//    }];
//}
//#pragma mark 分享错误提示
//-(void)alertWithError:(NSError *)error{
//
//    NSLog(@"错误信息===%@",error);
//}


#pragma mark 导航栏渐变

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset=scrollView.contentOffset.y;
//    NSLog(@"%f",offset);
    if (offset>5) {
        self.navigationController.navigationBar.barTintColor = BXAlphaColor(77, 166, 214, 1.0);
        self.title=[NSString stringWithFormat:@"%@",_model.Shoptitle];
    }
    else {
        self.navigationController.navigationBar.barTintColor = BXAlphaColor(243, 244, 248, 1.0);
        self.title=@"选址店铺详情";
    }
}



#pragma mark 当前导航栏出现 ？不出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //   让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}



@end
