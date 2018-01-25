//
//  DetailedController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/24.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "DetailedController.h"
#import "XLsn0wLoop.h"

//分享头文件
#import <UShareUI/UShareUI.h>

@interface DetailedController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,XLsn0wLoopDelegate>{
    
    BOOL isSC;
    NSString *NSloginstate;
    NSString * URL;
    CGFloat  UItextHeight_adaptation;
    
//    弹出图片的东西啊
    UIView *IMGBACK;//背景
    UIButton *  left_up_btn;//上一个
    UIButton *  right_up_btn;//下一个
    UIButton *  Close_btn;//关闭
    UIImageView *bgImage;
    NSInteger  Click_num;
    NSInteger  Img_count;
    UILabel  * Count_index;
}

@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (nonatomic , strong) XLsn0wLoop    *   loop;
@property (nonatomic , strong)UIButton      *   BackBtn;
@property (nonatomic , strong)UIButton      *   ShareBtn;
@property (nonatomic , strong)UIView        *   HeaderView;
@property (nonatomic , strong)ShoppingBtn   *   SCBtn;
@property (nonatomic , strong)UIButton      *   LXBtn;
@property (nonatomic , strong)UIView        *   syntheticalview;    //自定义导航栏
@property (nonatomic , strong)UILabel       *   titlelab;           //自定义导航栏标题

@property (nonatomic , strong) Detailedmodel  * model;
@property (nonatomic , strong) NSMutableArray * imageArr;
@property(nonatomic,strong)NSURLSessionDataTask*task;
@end

@implementation DetailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    dataArr   = [[NSMutableArray alloc]init];
    _model    = [[Detailedmodel alloc ]init];
    _imageArr = [[NSMutableArray alloc]init];
    NSLog(@"传值过来的店铺固定subid=%@",_shopsubid);
    
//    背景色w
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bjt.jpg"]];
    [self creatBacktitle];
    [self creattableview];
#pragma -mark 数据获取
    [self loaddata];
  
//    轮播图视图控件
    self.loop                 = [[XLsn0wLoop alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight/3)];
    self.loop.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = self.loop;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma -mark创建tableview
-(void)creattableview{

    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, KMainScreenWidth, KMainScreenHeight+20)style:UITableViewStylePlain];
    //    隐藏右侧滚动
    tableView.showsVerticalScrollIndicator = NO;
    //    隐藏分割线
    tableView.separatorStyle = NO;
    [self.view addSubview:tableView];
    [self.view sendSubviewToBack:tableView];
    tableView.backgroundColor = kTCColor(240, 240, 240);
}

-(void)loaddata{
    
   
    #pragma 出租数据获取
    if ([self.shopcode  isEqualToString:@"rentout"]) {
         [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
        //判断登录状态
        if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]) {
            URL= [NSString stringWithFormat:@"%@?subid=%@&uid=%@",Hostrentpath,_shopsubid,[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]];
            NSLog(@"登录店铺详情入境：%@",URL);
        }else{
            URL = [NSString stringWithFormat:@"%@?subid=%@",Hostrentpath,_shopsubid];
            NSLog(@"未登录店铺详情入境：%@",URL);
        }
    
        NSLog(@"店铺详情入境：%@",URL);
       
        AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
        manager.responseSerializer          = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
        self.task =   [manager GET: URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
            NSLog(@"数据源:%@",responseObject[@"data"]);
             _model.Shopcollect   = responseObject[@"data"][@"collect"];
             _model.Shopname      = responseObject[@"data"][@"name"];
             _model.Shoptime      = responseObject[@"data"][@"time"];
             _model.Shoprent      = responseObject[@"data"][@"rent"];
             _model.Shoparea      = responseObject[@"data"][@"area"];
             _model.Shopprice     = responseObject[@"data"][@"cost"];
             _model.Shopquyu      = responseObject[@"data"][@"district"];
             _model.Shopfit       = responseObject[@"data"][@"contract"];
             _model.ShopXQrent    = responseObject[@"data"][@"rent"];
             _model.ShopXQarea    = responseObject[@"data"][@"area"];
             _model.ShopXQtype    = responseObject[@"data"][@"trade"];
             _model.ShopXQquyu    = responseObject[@"data"][@"searchs"];
             _model.ShopXQstate   = responseObject[@"data"][@"spin"];
             _model.ShopXQprice   = responseObject[@"data"][@"cost"];
             _model.ShopXQdescribe= responseObject[@"data"][@"descript"];
            
            _model.ShopDitu      = responseObject[@"data"][@"district"];//反编码
            _model.ShopDitudata  = responseObject[@"data"][@"coordinate"];//经纬度
            
            
            NSLog(@"出租经纬度:%@",responseObject[@"data"][@"coordinate"]);
            
             _model.Shoping11 =responseObject[@"data"][@"facilty"][0];
             _model.Shoping12 =responseObject[@"data"][@"facilty"][1];
             _model.Shoping13 =responseObject[@"data"][@"facilty"][2];
             _model.Shoping14 =responseObject[@"data"][@"facilty"][3];
             _model.Shoping15 =responseObject[@"data"][@"facilty"][4];
             _model.Shoping21 =responseObject[@"data"][@"facilty"][5];
             _model.Shoping22 =responseObject[@"data"][@"facilty"][6];
             _model.Shoping23 =responseObject[@"data"][@"facilty"][7];
             _model.Shoping24 =responseObject[@"data"][@"facilty"][8];
             _model.Shoping25 =responseObject[@"data"][@"facilty"][9];
#pragma mark   从本地缓存拿数据

             if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
                 
                 _model.ShopXQperson  = responseObject[@"data"][@"user"];
                 _model.ShopXQnumber  = responseObject[@"data"][@"phone"];
             }else{
                 
                 _model.ShopXQperson  = @"客服专员";
                 _model.ShopXQnumber  = @"0755-23212184";
             }
             
             [_model setValuesForKeysWithDictionary:responseObject[@"data"]];
             [dataArr addObject:_model];
             NSLog(@"数组数据？？=%ld",dataArr.count);
             [tableView reloadData];
            tableView.delegate  =self;
            tableView.dataSource=self;
             [self creattabbar];
             
             for (NSDictionary *dicimg in responseObject[@"data"][@"imagers"])
             {
                 NSLog(@"图片=%@",dicimg);
                 [_imageArr addObject:dicimg];
                 NSLog(@"有%ld个图片",_imageArr.count);
             }
             //    轮播图的方法
             [self addLoop];
            [YJLHUD showSuccessWithmessage:@"加载成功"];
            [YJLHUD dismissWithDelay:1];
             
             NSLog(@"出租收藏state:%@",_model.Shopcollect);
             if ([_model.Shopcollect isEqualToString:@"no"]) {
                 isSC = NO;
                 [_SCBtn setTitle:@"未收藏" forState:UIControlStateNormal];
                 [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
             }else{
                 isSC  = YES;
                 [_SCBtn setTitle:@"收藏" forState:UIControlStateNormal];
                 [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
                 
             }
         }
         
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"请求数据失败----%@",error);
                 //在数据请求失败中 写
                 if (error.code == -999) {
                     NSLog(@"网络数据连接取消");
                 }else{
               
                             //    轮播图的方法
                             [self addLoop];
                     [YJLHUD showErrorWithmessage:@"服务器繁忙"];
                     [YJLHUD dismissWithDelay:1];
                     
                        }
                 }];
    }
    
#pragma 转让数据获取
    else{     //[self.shopcode  isEqualToString:@"transfer"] 转让
         [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
        //判断登录状态
        if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]) {
            URL= [NSString stringWithFormat:@"%@?subid=%@&uid=%@",HostZRparticular,_shopsubid,[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]];
            NSLog(@"登录店铺详情入境：%@",URL);
        }else{
            URL = [NSString stringWithFormat:@"%@?subid=%@",HostZRparticular,_shopsubid];
            NSLog(@"未登录店铺详情入境：%@",URL);
        }
        
//        ph.chinapuhuang.com/API.php/zrrecord?shopid=693
//        NSLog(@"店铺详情入境：%@",URL);
        
            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 10.0;
            [manager GET: URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
                
            NSLog(@"转让数据源:%@",responseObject[@"data"]);
             _model.Shopcollect   = responseObject[@"data"][@"collect"];
             _model.Shopname      = responseObject[@"data"][@"title"];
             _model.Shoptime      = responseObject[@"data"][@"time"];
             _model.Shoprent      = responseObject[@"data"][@"rent"];
             _model.Shoparea      = responseObject[@"data"][@"area"];
             _model.Shopprice     = responseObject[@"data"][@"moneys"];
             _model.Shopquyu      = responseObject[@"data"][@"district"];
             _model.Shopfit       = responseObject[@"data"][@"suit"];
             
             _model.ShopXQrent    = responseObject[@"data"][@"rent"];
             _model.ShopXQarea    = responseObject[@"data"][@"area"];
             _model.ShopXQtype    = responseObject[@"data"][@"type"];
             _model.ShopXQquyu    = responseObject[@"data"][@"dityour"];
             _model.ShopXQstate   = responseObject[@"data"][@"states"];
             _model.ShopXQprice   = responseObject[@"data"][@"moneys"];
             _model.ShopXQdescribe= responseObject[@"data"][@"descript"];
                
             _model.ShopDitu      = responseObject[@"data"][@"district"];//反编码
             _model.ShopDitudata  = responseObject[@"data"][@"coordinate"];//经纬度
             NSLog(@"转让经纬度:%@",responseObject[@"data"][@"coordinate"]);
                
             _model.Shoping11 =responseObject[@"data"][@"peitao"][0];
             _model.Shoping12 =responseObject[@"data"][@"peitao"][1];
             _model.Shoping14 =responseObject[@"data"][@"peitao"][3];
             _model.Shoping15 =responseObject[@"data"][@"peitao"][4];
             _model.Shoping21 =responseObject[@"data"][@"peitao"][5];
             _model.Shoping22 =responseObject[@"data"][@"peitao"][6];
             _model.Shoping23 =responseObject[@"data"][@"peitao"][7];
             _model.Shoping24 =responseObject[@"data"][@"peitao"][8];
             _model.Shoping25 =responseObject[@"data"][@"peitao"][9];
             
#pragma mark   从本地缓存拿数据
           
             if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
                 
                 _model.ShopXQperson  = responseObject[@"data"][@"users"];
                 _model.ShopXQnumber  = responseObject[@"data"][@"phone"];
             }else{
                 
                 _model.ShopXQperson  = @"客服专员";
                 _model.ShopXQnumber  = @"0755-23212184";
             }
             
             [_model setValuesForKeysWithDictionary:responseObject[@"data"]];
             [dataArr addObject:_model];
             NSLog(@"数组数据？？=%ld",dataArr.count);
             [tableView reloadData];
             tableView.delegate  =self;
             tableView.dataSource=self;
             [self creattabbar];
            
             for (NSDictionary *dicimg in responseObject[@"data"][@"imagers"]){
                 
                 NSLog(@"图片=%@",dicimg);
                 [_imageArr addObject:dicimg];
             }
             
             //    轮播图的方法
             [self addLoop];
                [YJLHUD showSuccessWithmessage:@"加载成功"];
                [YJLHUD dismissWithDelay:1];
            
            NSLog(@"转让收藏state:%@",_model.Shopcollect);
            if ([_model.Shopcollect isEqualToString:@"no"]) {
                isSC = NO;
                [_SCBtn setTitle:@"未收藏" forState:UIControlStateNormal];
                [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
            }else{
                isSC  = YES;
                [_SCBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
            }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"请求数据失败----%@",error);
                if (error){
                    [YJLHUD showErrorWithmessage:@"服务器连接失败"];
                    [YJLHUD dismissWithDelay:1];
                
                }
            }];
    }
}

#pragma mark轮播图的方法  (只支持网络图片)
- (void)addLoop {
    
    self.loop.xlsn0wDelegate = self;
    self.loop.time = 2;
    [self.loop setPageColor:[UIColor whiteColor] andCurrentPageColor:[UIColor blackColor]];
     NSLog(@"有%ld个图片",_imageArr.count);
//     self.imageArr = @[@"餐饮美食",@"美容美发",@"服饰鞋包",@"休闲娱乐",@"百货超市",@"生活服务",@"电子通讯",@"汽车服务",@"医疗保健",@"家居建材",@"教育培训",@"酒店宾馆"];
    self.loop.imageArray =_imageArr;
}

#pragma mark XRCarouselViewDelegate 轮播图代理
- (void)loopView:(XLsn0wLoop *)loopView clickImageAtIndex:(NSInteger)index {
    NSLog(@"点击了第%ld张图片", index);

    [self.loop stopTimer];//停止滚动
    
    Click_num = (long)index;
    Img_count = _imageArr.count;
    NSLog(@"一共有%ld个图片",Img_count);
    self.navigationController.navigationBar.alpha = 0;
    tableView.scrollEnabled = NO;
    
    IMGBACK = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    IMGBACK.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [[UIApplication sharedApplication].delegate.window addSubview:IMGBACK];
    
//      手势左滑动
    UISwipeGestureRecognizer *swipeleft =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipeleft.direction =UISwipeGestureRecognizerDirectionLeft;
    [IMGBACK addGestureRecognizer:swipeleft];
//      手势右滑动
    UISwipeGestureRecognizer *swiperight =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swiperight.direction =UISwipeGestureRecognizerDirectionRight;
    [IMGBACK addGestureRecognizer:swiperight];
    
//    手势下滑关闭
    UISwipeGestureRecognizer *swipedown =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swiperight.direction =UISwipeGestureRecognizerDirectionDown;
    [IMGBACK addGestureRecognizer:swipedown];
    
    
    Count_index = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, KMainScreenWidth, 20)];
    Count_index.text = [NSString stringWithFormat:@"%ld/%ld",Click_num+1,Img_count];
    Count_index.textAlignment = NSTextAlignmentCenter;
    Count_index.textColor = [UIColor whiteColor];
    Count_index.font =[UIFont systemFontOfSize:14.0f];
    [IMGBACK addSubview:Count_index];
    
    bgImage = [[UIImageView alloc]init];
    [bgImage sd_setImageWithURL:[NSURL URLWithString:_imageArr[index]] placeholderImage:[UIImage imageNamed:@"upload"]];
    bgImage.userInteractionEnabled = YES;
    bgImage.contentMode = UIViewContentModeScaleAspectFit;
//    https://www.jianshu.com/p/8c784b59fe6a  图片的处理
    [IMGBACK addSubview:bgImage];

    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {

        if (bgImage.image.size.width>375){
            make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width/2, bgImage.image.size.height/2));
        }
        else{
            make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width, bgImage.image.size.height));
        }
        make.centerY.equalTo(IMGBACK);
        make.centerX.equalTo(IMGBACK);
    }];

    left_up_btn                           = [UIButton buttonWithType:UIButtonTypeCustom];
    [IMGBACK addSubview:left_up_btn];
    [IMGBACK bringSubviewToFront:left_up_btn];
    [left_up_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.width .mas_equalTo(@50);
        make.left.equalTo(IMGBACK).with.offset(10);
        make.top.equalTo(IMGBACK).with.offset(KMainScreenHeight-60);
    }];
    [left_up_btn setTitle:@"上一个" forState:UIControlStateNormal];
    [left_up_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    left_up_btn.titleLabel.font            = [UIFont systemFontOfSize: 14.0];
    [left_up_btn addTarget:self action:@selector(left_up_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    right_up_btn                           = [UIButton buttonWithType:UIButtonTypeCustom];
    [IMGBACK addSubview:right_up_btn];
    [IMGBACK bringSubviewToFront:right_up_btn];
    [right_up_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.width .mas_equalTo(@50);
        make.right.equalTo(IMGBACK).with.offset(-10);
        make.top.equalTo(IMGBACK).with.offset(KMainScreenHeight-60);
    }];
    
    [right_up_btn setTitle:@"下一个" forState:UIControlStateNormal];
    [right_up_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    right_up_btn.titleLabel.font            = [UIFont systemFontOfSize: 14.0];
    [right_up_btn addTarget:self action:@selector(right_up_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    Close_btn                           = [UIButton buttonWithType:UIButtonTypeCustom];
    [IMGBACK addSubview:Close_btn];
    [IMGBACK bringSubviewToFront:Close_btn];
    [Close_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.width .mas_equalTo(@50);
        make.left.equalTo(IMGBACK).with.offset(KMainScreenWidth/2-25);
        make.top.equalTo(IMGBACK).with.offset(KMainScreenHeight-60);
    }];
    [Close_btn setTitle:@"关闭" forState:UIControlStateNormal];
    [Close_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Close_btn.titleLabel.font            = [UIFont systemFontOfSize: 14.0];
    [Close_btn addTarget:self action:@selector(Close_btn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma -mark 图片切换查看 方法 start
//关闭
-(void)Close_btn:(id)sender{

    self.navigationController.navigationBar.alpha = 1;
    tableView.scrollEnabled = YES;
    [IMGBACK removeFromSuperview];
    [self.loop startTimer];//开启滚动
}
//关闭
-(void)Close_swipe{
    self.navigationController.navigationBar.alpha = 1;
    tableView.scrollEnabled = YES;
    [IMGBACK removeFromSuperview];
    [self.loop startTimer];//开启滚动
}
//下一个
-(void)right_up_btn:(id)sender{
    [self next_img];
}
//上一个
-(void)left_up_btn:(id)sender{
    [self up_img];
}

//清扫事件
-(void)swipeAction:(UISwipeGestureRecognizer *)swipe{
    if (swipe.direction ==UISwipeGestureRecognizerDirectionLeft){
        [self next_img]; NSLog(@"左扫一下 下一个");
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
        [self up_img]; NSLog(@"右扫一下 上一个");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown){
        [self Close_swipe];
        NSLog(@"下滑 关闭");
    }
}

-(void)next_img{
    Click_num = Click_num + 1;
    if (Click_num <= Img_count-1) {
        Count_index.text = [NSString stringWithFormat:@"%ld/%ld",Click_num+1,Img_count];
        [bgImage sd_setImageWithURL:[NSURL URLWithString:_imageArr[Click_num]] placeholderImage:[UIImage imageNamed:@"upload"]];
        [bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            if (bgImage.image.size.width>375){
                make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width/2, bgImage.image.size.height/2));
            }
            else{
                make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width, bgImage.image.size.height));
            }
            make.centerY.equalTo(IMGBACK);
            make.centerX.equalTo(IMGBACK);
            
        }];
    }else{
        
        Count_index.text = [NSString stringWithFormat:@"1/%ld",Img_count];
        [bgImage sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]] placeholderImage:[UIImage imageNamed:@"upload"]];
        [bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            if (bgImage.image.size.width>375){
                make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width/2, bgImage.image.size.height/2));
            }
            else{
                make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width, bgImage.image.size.height));
            }
            make.centerY.equalTo(IMGBACK);
            make.centerX.equalTo(IMGBACK);
        }];
        Click_num = 0;
    }
}

-(void)up_img{

     Click_num = Click_num - 1;
    if (Click_num>=0) {
        Count_index.text = [NSString stringWithFormat:@"%ld/%ld",Click_num+1,Img_count];
        [bgImage sd_setImageWithURL:[NSURL URLWithString:_imageArr[Click_num]] placeholderImage:[UIImage imageNamed:@"upload"]];
        [bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            if (bgImage.image.size.width>375){
                make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width/2, bgImage.image.size.height/2));
            }
            else{
                make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width, bgImage.image.size.height));
            }
            make.centerY.equalTo(IMGBACK);
            make.centerX.equalTo(IMGBACK);
        }];
        
    }else{
        
        Count_index.text = [NSString stringWithFormat:@"%ld/%ld",Img_count,Img_count];
        [bgImage sd_setImageWithURL:[NSURL URLWithString:_imageArr[Img_count-1]] placeholderImage:[UIImage imageNamed:@"upload"]];
        [bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            if (bgImage.image.size.width>375){
                make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width/2, bgImage.image.size.height/2));
            }
            else{
                make.size.mas_equalTo(CGSizeMake(bgImage.image.size.width, bgImage.image.size.height));
            }
            make.centerY.equalTo(IMGBACK);
            make.centerX.equalTo(IMGBACK);
        }];
        
        Click_num  = Img_count-1;
    }
}

#pragma -mark 图片切换查看 方法 end

#pragma  -mark -列表uitabviewcontroller
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

//段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20;
}

//段尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel * Heade_title = [[UILabel alloc]init];
    Heade_title.text = @"客官，已经尽力加载了...";
    Heade_title.backgroundColor = [UIColor groupTableViewBackgroundColor];
    Heade_title.textAlignment = NSTextAlignmentCenter;
    Heade_title.textColor = kTCColor(85, 85, 85);
    Heade_title.font = [UIFont systemFontOfSize:13];
    return Heade_title;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellname";
    DetailedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailedViewCell" owner:self options:nil]lastObject];
    }
    
    cell.Shopname.text      = [NSString stringWithFormat:@"%@"          ,_model.Shopname         ];//_model.Shopname;
    cell.Shoptime.text      = [NSString stringWithFormat:@"%@更新"       ,_model.Shoptime         ];//_model.Shoptime;
    cell.Shoprent.text      = [NSString stringWithFormat:@"%@元/月"      ,_model.Shoprent         ];//_model.Shoprent;
    cell.Shoparea.text      = [NSString stringWithFormat:@"%@m²"        ,_model.Shoparea         ];//_model.Shoparea;
    cell.Shopprice.text     = [NSString stringWithFormat:@"%@万元"       ,_model.Shopprice        ];//_model.Shopprice;
    cell.Shopquyu.text      = [NSString stringWithFormat:@"%@"          ,_model.Shopquyu         ];//_model.Shopquyu;
    cell.Shopfit.text       = [NSString stringWithFormat:@"%@"          ,_model.Shopfit          ];//_model.Shopfit;
    cell.ShopXQperson.text  = [NSString stringWithFormat:@"%@"          ,_model.ShopXQperson     ];//_model.ShopXQperson;
    cell.ShopXQnumber.text  = [NSString stringWithFormat:@"%@"          ,_model.ShopXQnumber     ];//_model.ShopXQnumber;
    cell.ShopXQrent.text    = [NSString stringWithFormat:@"%@元/月"      ,_model.ShopXQrent       ];//_model.ShopXQrent;
    cell.ShopXQarea.text    = [NSString stringWithFormat:@"%@m²"        ,_model.ShopXQarea       ];//_model.ShopXQarea;
    cell.ShopXQtype.text    = [NSString stringWithFormat:@"%@"          ,_model.ShopXQtype       ];//_model.ShopXQtype;
    cell.ShopXQquyu.text    = [NSString stringWithFormat:@"%@"          ,_model.ShopXQquyu       ];//_model.ShopXQquyu;
    cell.ShopXQstate.text   = [NSString stringWithFormat:@"%@"          ,_model.ShopXQstate      ];//_model.ShopXQstate;
    cell.ShopXQprice.text   = [NSString stringWithFormat:@"%@万"        ,_model.ShopXQprice      ];//_model.ShopXQprice;
    
    cell.ShopXQdescribe.text= [NSString stringWithFormat:@"%@"          ,_model.ShopXQdescribe   ]; //_model.ShopXQdescribe;
    cell.Describe_height.constant = [self heightForString:cell.ShopXQdescribe andWidth:KMainScreenWidth-20];
    UItextHeight_adaptation = cell.Describe_height.constant;
    
    cell.ShopDitudata   = _model.ShopDitudata;  //经纬度
    cell.ShopDitu       = _model.Shopquyu;      //文字区域
    
    if ([_model.Shoping11 isEqualToString: @"1"] ) {
//        NSLog(@"00000");
        cell.Shoping11.image = [UIImage imageNamed:@"shangxiahuo_blue"];
    }

    if ([_model.Shoping12 isEqualToString: @"1"] ) {
//        NSLog(@"00000");
        cell.Shoping12.image = [UIImage imageNamed:@"keminghuo_blue"];
    }
    if ([_model.Shoping13 isEqualToString: @"1"]) {
//        NSLog(@"00000");
        cell.Shoping13.image = [UIImage imageNamed:@"380V_blue"];
    }
    if ([_model.Shoping14 isEqualToString: @"1"] ) {
//        NSLog(@"00000");
        cell.Shoping14.image = [UIImage imageNamed:@"meiqiguandao_lvse"];
    }
    if ([_model.Shoping15 isEqualToString: @"1"] ) {
//        NSLog(@"00000");
        cell.Shoping15.image = [UIImage imageNamed:@"paiyan_blue"];
    }
    if ([_model.Shoping21 isEqualToString: @"1"] ) {
//        NSLog(@"00000");
        cell.Shoping21.image = [UIImage imageNamed:@"paiwu_blue"];
    }
    if ([_model.Shoping22 isEqualToString: @"1"]) {
//        NSLog(@"00000");
        cell.Shoping22.image = [UIImage imageNamed:@"park_blue"];
    }
    if ([_model.Shoping23 isEqualToString: @"1"] ) {
//        NSLog(@"00000");
        cell.Shoping23.image = [UIImage imageNamed:@"changqun_blue"];
    }
    if ([_model.Shoping24 isEqualToString: @"1"]) {
//        NSLog(@"00000");
        cell.Shoping24.image = [UIImage imageNamed:@"zhengjian_blue"];
    }
    if ([_model.Shoping25 isEqualToString: @"1"] ) {
//        NSLog(@"00000");
        cell.Shoping25.image = [UIImage imageNamed:@"kongtiao_blue"];
    }
    
    [cell.record_service addTarget:self action:@selector(record_service:) forControlEvents:UIControlEventTouchUpInside];//客服服务记录
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nav=self.navigationController;//我的重要点
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 810 + UItextHeight_adaptation; //810是不加上描述的高度预设 
}

#pragma -mark 客服服务记录
-(void)record_service:(id)sender{

    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
            GesbackController *ctl = [[GesbackController alloc]init];
            ctl.Shopid = _shopsubid;
            ctl.Shopcode = _shopcode;
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            [self.navigationController pushViewController:ctl animated:YES];
            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
    }else{

        [YJLHUD showImage:nil message:@"请先登录账号"];//无图片 纯文字
        [YJLHUD dismissWithDelay:2];
    }

}

#pragma -mark 底部按钮
-(void)creattabbar{
    
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

#pragma mark  自定义导航栏以及bar
-(void)creatBacktitle{
    _syntheticalview = [[UIView alloc]initWithFrame:CGRectMake(0,0, KMainScreenWidth, 64)];
    _syntheticalview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_syntheticalview];
    
    _titlelab=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, KMainScreenWidth-110, 44)];
    _titlelab.textAlignment=NSTextAlignmentCenter;
    _titlelab.hidden = YES;
    [_syntheticalview addSubview:_titlelab];

//    返回功能
    _BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _BackBtn.frame = CGRectMake(0, 20, 44, 44);
    [_BackBtn setImage:[UIImage imageNamed:@"heise_fanghui"] forState:UIControlStateNormal];
    [_BackBtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    [_syntheticalview addSubview:_BackBtn];

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
     }else{
         [YJLHUD showImage:nil message:@"请先登录账号"];//无图片 纯文字
         [YJLHUD dismissWithDelay:2];
     }
}

#pragma -mark 收藏二级方法 ····转让
-(void)zrcollect{
    
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
    
    if (!isSC){
        
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
        
        [manager POST:Hostzrcollectpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"状态码:%@",responseObject[@"code"]);
            if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                NSLog(@"收藏成功");
                isSC = !isSC;
               
                [YJLHUD showSuccessWithmessage:@"添加收藏成功"];
                [YJLHUD dismissWithDelay:1];
            }
            
            else{
                
                NSLog(@"收藏失败");
              
                [YJLHUD showErrorWithmessage:@"添加收藏失败~"];
                [YJLHUD dismissWithDelay:1];
                
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
        
        [manager POST:Hostzrcollectpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            
            NSLog(@"状态码:%@",responseObject[@"code"]);
            if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                NSLog(@"取消收藏成功");
                
                isSC = !isSC;
             
                [YJLHUD showSuccessWithmessage:@"取消收藏成功"];
                [YJLHUD dismissWithDelay:1];
            }
            else{
               
                [YJLHUD showErrorWithmessage:@"取消收藏失败"];
                [YJLHUD dismissWithDelay:1];
                [_SCBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
                NSLog(@"取消收藏失败");
                
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error:%@",error);
          
            
            [YJLHUD showErrorWithmessage:@"服务器繁忙"];
            [YJLHUD dismissWithDelay:1];
           
            
        }];
    }
     }else{
         
      
         [YJLHUD showImage:nil message:@"请先登录账号"];//无图片 纯文字
         [YJLHUD dismissWithDelay:2];
         
     }
}

#pragma -mark 收藏二级方法 ····出租
-(void)czcollect{

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
        NSLog(@"出租添加收藏参数:%@",params);
        [manager POST:Hostczcollectpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"状态码:%@",responseObject[@"code"]);
            if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                NSLog(@"收藏成功");
                isSC = !isSC;
                [YJLHUD showSuccessWithmessage:@"添加收藏成功"];
                [YJLHUD dismissWithDelay:1];
            }
            
            else{
                
                NSLog(@"收藏失败");
                [YJLHUD showErrorWithmessage:@"添加收藏失败~"];
                [YJLHUD dismissWithDelay:1];
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
        NSLog(@"出租取消收藏参数:%@",params);
        
        [manager POST:Hostczcollectpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"状态码:%@",responseObject[@"code"]);
            if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                NSLog(@"取消收藏成功");
                isSC = !isSC;
                [YJLHUD showSuccessWithmessage:@"取消收藏成功"];
                [YJLHUD dismissWithDelay:1];
            }
            
            else{
                
                [YJLHUD showErrorWithmessage:@"取消收藏失败"];
                [YJLHUD dismissWithDelay:1];
                [_SCBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [_SCBtn setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
                NSLog(@"取消收藏失败");
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error:%@",error);
            [YJLHUD showErrorWithmessage:@"服务器繁忙"];
            [YJLHUD dismissWithDelay:1];
            
        }];
    }    }else{
        
        [YJLHUD showImage:nil message:@"请先登录账号"];//无图片 纯文字
        [YJLHUD dismissWithDelay:2];
        
    }
}

#pragma - mark 收藏一级方法
-(void)SC:(UIButton *)btn{
#pragma 出租收藏事件
    if ([self.shopcode  isEqualToString:@"rentout"]) {
        
           [self czcollect];
    }
    #pragma 转让收藏事件
    else{
           [self zrcollect];
    }
}

#pragma mark 导航栏渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset=scrollView.contentOffset.y;
//    NSLog(@"%f",offset);
    if (offset  >  64 ) {
        CGFloat alpha = MIN(1, offset / 145);
        _syntheticalview.backgroundColor = BXAlphaColor(77, 166, 214, alpha);
        if (offset>145){
            
//            判断往上拉的时候到那里标题显示起来
            _titlelab.hidden = NO;
            _titlelab.text=_model.Shopname;
        }
    
        else{
//            判断往下拉的时候到那里标题隐藏起来
            if (offset<126) {
                _titlelab.hidden = YES;
            }
        }
    }
    
    else {
        
        if (offset<-55) {
            _BackBtn.hidden   = YES;
            _ShareBtn.hidden  = YES;
        }
        else{
            _BackBtn.hidden   = NO;
            _ShareBtn.hidden  = NO;
        }
        
        _syntheticalview.backgroundColor = BXAlphaColor(77, 166, 214, 0.0);
        
    }
}

#pragma mark 当前导航栏出现？不出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 让导航栏不显示出来***********************************
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark 返回
-(void)Click{
    
    if(self.task) {
        
        [self.task cancel];//取消当前界面的数据请求.
      
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    if(self.task) {
        
        [self.task cancel];//取消当前界面的数据请求.
     
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}


#pragma mark 完美适配 （描述的高度）UITextView 根据字数的计算高度
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

@end
