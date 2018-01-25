//
//  FirstViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<UINavigationControllerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,ScrollImageDelegate,TLCityPickerDelegate
,UICollectionViewDelegate,UICollectionViewDataSource,CDDRollingDelegate>{
    
     int PHpage;//      获取数据分页
     int number;//      防止重复定位
    
    //分页控制器
    UIPageControl           *   _pageCtl;
    UIImageView             *   _imageView;
    
    BOOL isLocationFail;
    BOOL isLocating;
    NSString                *currentLocationCityName;
    UITableView             *Newtableview;              //案例
    UICollectionView        *Voidecollecview;           //视频
    UICollectionView        *recreationcollecview;      //娱乐类
    UICollectionView        *lifecollecview;            //生活类
    UICollectionView        *departmentcollecview;      //百货类
    UICollectionView        *caseallcollecview;         //案例类
    UIScrollView            *Mainscrollow;              //主背景控件
    AVPlayerViewController  *YJLPlayer;                 //视频控件
    
     DCTitleRolling  * TTRollingview;/* 头条 */

}

@property (nonatomic,strong)  NSString   * maincityName;    //存储定位获取的城市名称
@property (nonatomic, strong) NSString   * maincityID;      //当前定位城市id
//第三方文件轮播图加载
@property (nonatomic,strong) ScrollHeadView *scrollView;
@property (nonatomic,strong) UIButton      *locationbtn;//定位按钮

@property (nonatomic,assign) NSInteger        page;
@property (nonatomic,strong) NSTimer         *timer;

@property (nonatomic,strong)UIView *HeaderView;       //头部
@property (nonatomic,strong)UIView *TwoHeaderview;     //6个按钮

@property (nonatomic,strong)UIView  *NewView;           //大数据view1
@property (nonatomic,strong)UIView  *AgoView;           //大数据view2
@property (nonatomic,strong)UIView  *SettledView;       //大数据view3
@property (nonatomic,strong)UILabel *biglab;            //大数据lab
@property (nonatomic,strong)UIImageView *bigimgview;     //大数据图片
@property (nonatomic,strong)UILabel *Newlab;            //大数据lab1
@property (nonatomic,strong)UILabel *Agolab;            //大数据lab2
@property (nonatomic,strong)UILabel *Settlelab;         //大数据lab3

@property (nonatomic,strong)UIView  *Dayview;           //今日头条

@property (nonatomic,strong)UILabel *choicelab;         //精选开店
@property (nonatomic,strong)UIView  *JXview_1;          //区域
@property (nonatomic,strong)UIView  *JXview_2;          //租金
@property (nonatomic,strong)UIView  *JXview_3;          //低价
@property (nonatomic,strong)UIView  *JXview_4;          //面积

@property (nonatomic,strong)UIImageView     *recommendImgView;  //推荐店铺banner
@property (nonatomic,strong)UIView          *recreationView;    //娱乐类
@property (nonatomic,strong)UIView          *lifeView;          //生活类
@property (nonatomic,strong)UIView          *departmentView;    //百货类
@property (nonatomic,strong)UIView          *ZXcaseView;        //最新案例

@property (nonatomic, strong)ShoppingBtn    * casebtnButtom;    //案例无数据按钮图片
@property (nonatomic, strong)ShoppingBtn    * yulebtnButtom;    //娱乐无数据按钮图片
@property (nonatomic, strong)ShoppingBtn    * shuobtnButtom;    //生活无数据按钮图片
@property (nonatomic, strong)ShoppingBtn    * bhuobtnButtom;    //百货无数据按钮图片

@property (nonatomic,strong)UIView          *VideoView;         //推荐视频
@property (nonatomic,strong)UIView          *BottomView;        //底部到底提示语

@property (nonatomic,strong)NSMutableArray  *Videodataimages;       //推荐视频图片数据源
@property (nonatomic,strong)NSMutableArray  *Videodatatitles;       //推荐视频标题数据源
@property (nonatomic,strong)NSMutableArray  *Videodatatimes;        //推荐视频时间数据源
@property (nonatomic,strong)NSMutableArray  *Videodatawebs;         //推荐视频地址数据源

/** 导航条View */
@property (nonatomic , strong)  UIView              * NavView;
@property (nonatomic , strong)  CLLocationManager   * locManager;       //获取用户位置
@property (nonatomic , strong)  CLGeocoder          * geocoder;         //反地理编码

@property(nonatomic,strong)NSMutableArray  * PHArr_Today;       //头条存储数据
@property(nonatomic,strong)NSMutableArray  * PHArr_case;        //案例存储数据
@property(nonatomic,strong)NSMutableArray  * PHArr_recreation;  //推荐娱乐类存储数据
@property(nonatomic,strong)NSMutableArray  * PHArr_life;        //推荐生活类存储数据
@property(nonatomic,strong)NSMutableArray  * PHArr_department;  //推荐百货类存储数据
@property(nonatomic,strong)NSMutableArray  * PHArr_video;       //视频存储数据

@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation FirstViewController
#pragma  -mark 懒加载视频所需数据源
- (NSMutableArray *)Videodataimages{
    if (_Videodataimages == nil)
    {
        _Videodataimages = [[NSMutableArray alloc]initWithObjects:@[@"铺皇app宣传",@"宣传图_2.jpeg"],nil];
    }
    return _Videodataimages;
}
- (NSMutableArray *)Videodatatitles{
    if (_Videodatatitles == nil){
        _Videodatatitles = [[NSMutableArray alloc]initWithObjects:@[@"铺皇app宣传",@"铺皇致富之路"],nil];
    }
    return _Videodatatitles;
}

- (NSMutableArray *)Videodatatimes{
    if (_Videodatatimes == nil){
        _Videodatatimes = [[NSMutableArray alloc]initWithObjects:@[@"2017-01-10",@"2017-05-20"],nil];
    }
    return _Videodatatimes;
}


- (NSMutableArray *)Videodatawebs{
    if (_Videodatawebs == nil){
        
        _Videodatawebs = [[NSMutableArray alloc]initWithObjects:@[@"https://ph.chinapuhuang.com/Public/Video/2017-11-30/5a1fa547c11e70.02050213.mp4",@"https://ph.chinapuhuang.com/Public/Video/2017-12-21/5a3b309ed83ee9.29373947.mp4"],nil];
    }

    return _Videodatawebs;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    //   视图基础
    [self creatbase];
    
    //    视图刷新
     [self refresh];
    
    //    定位位置
    [self statLocation];
    
    // 打广告
    [self Advertisement];
    
    //    设置Navview
    [self creatTOPview];
    
    //    设置广告图
    [self creatScroll];
    
    //    设置第二页6个功能按钮
    [self creatSixbtn];
    
    //    设置大数据展示功能
    [self creatbigdata];
    
    //    设置今日头条动态信息
    [self creatday];
    
    //    设置精选信息 一类
    [self creatchoice];
    
    //    设置推荐banner
    [self creatrecommendIMG];
    //    设置推荐娱乐类
    [self creatrecommendONE];
    //    设置推荐生活类
    [self creatrecommendTWO];
    //    设置推荐百货类
    [self creatrecommendTHR];
    
    //    设置最新案例视图
    [self creatzxcase];
    
    //    设置推荐视频
    [self creatvideo];
    
    //    设置底部提示语
    [self creatbottom];

//    接收第一次进入应用通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JoinClick:) name:@"Joinapp" object:nil];

    //    接收tabbar点击事件通知
    static NSString *tabBarDidSelectedNotification = @"tabBarDidSelectedNotification";
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSeleted) name:tabBarDidSelectedNotification object:nil];
}

#pragma - mark 接收到点击tabbar通知实现方法
- (void)tabBarSeleted {

    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",self.lastSelectedIndex] forKey:@"PUSHNUMBER"];
}

- (BOOL)isShowingOnKeyWindow{
    
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.view.frame fromView:self.view.superview];
    CGRect winBounds = keyWindow.bounds;
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return !self.view.isHidden && self.view.alpha > 0.01 && self.view.window == keyWindow && intersects;
}

#pragma - mark 接收第一次进入应用通知 进行处理
-(void)JoinClick:(NSNotification *)notification{
    
#pragma -mark 指导页出现 ？不出现
    if ( [[NSUserDefaults standardUserDefaults]boolForKey:@"firstCouponBoard_iPhone1"]) {
        NSLog(@"加载过了指导页，不能加载第二次了");
        
    }else{
        
        NSLog(@"没有加载过指导页，马上加载第1次了");
        
        GUIDbackview                     =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        GUIDbackview.layer.masksToBounds = YES;
        GUIDbackview.backgroundColor     = [UIColor colorWithWhite:0 alpha:0];
        
        GUIDimgview        = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        GUIDimgview.center = GUIDbackview.center;
        GUIDimgview.layer.masksToBounds         = YES;
        GUIDimgview.image  = [UIImage imageNamed:@"teach_1"];

        [GUIDbackview addSubview:GUIDimgview];
        
        GUIDbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        GUIDbtn.frame = CGRectMake(152, KMainScreenHeight-444, 90, 35);
        [GUIDbtn setImage:[UIImage imageNamed:@"teach_btn"] forState:UIControlStateNormal];
        [GUIDbtn addTarget:self action:@selector(sureTapClick:) forControlEvents:UIControlEventTouchUpInside];
        [GUIDbackview addSubview:GUIDbtn];
        
        [[UIApplication sharedApplication].delegate.window addSubview:GUIDbackview];
        [UIView animateWithDuration:1.0 delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            GUIDbackview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
            
        } completion:^(BOOL finished) {
//            NSLog(@"动画结束");
        }];
    }
}

#pragma -mark 基本初始化
-(void)creatbase{
    
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    if (iOS11) {
        Mainscrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, KMainScreenWidth, KMainScreenHeight+20)];
    }
    else{
        Mainscrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    }
    Mainscrollow.userInteractionEnabled         = YES;
    Mainscrollow.showsVerticalScrollIndicator   = NO;//隐藏滚动条
    Mainscrollow.showsHorizontalScrollIndicator = NO;//
    Mainscrollow.delegate                       = self;
    Mainscrollow.contentSize                    = CGSizeMake(KMainScreenWidth, 3200);
    [self.view addSubview:Mainscrollow];

    //    创建一个背景视图
    self.HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 3200)];
    self.HeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [Mainscrollow addSubview:self.HeaderView];
   
    
    PHpage              = 0;
    number              = 0;
    _PHArr_Today        = [[NSMutableArray alloc]init];
    _PHArr_case         = [[NSMutableArray alloc]init];
    _PHArr_recreation   = [[NSMutableArray alloc]init];
    _PHArr_life         = [[NSMutableArray alloc]init];
    _PHArr_department   = [[NSMutableArray alloc]init];
    _PHArr_video        = [[NSMutableArray alloc]init];
    
}

#pragma -mark 创建刷新视图
-(void)refresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadData)];
    // Set title
    [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
    [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
    [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // Set textColor
    header.stateLabel.textColor                 = kTCColor(161, 161, 161);
    header.lastUpdatedTimeLabel.textColor       = kTCColor(161, 161, 161);
    
    Mainscrollow.mj_header = header;
}

#pragma -mark 刷新事件
-(void)LoadData{
    
    //直接写刷新代码
    NSLog(@"首页在此刷新");
    [self loadallData];
    [Mainscrollow.mj_header endRefreshing];
}

#pragma -mark 打广告
-(void)Advertisement{
    
    NSString *image = @"http://pic.58pic.com/58pic/13/79/56/53M58PICkvQ_1024.jpg";
    NSString *ad = @"http://www.yinyuetai.com/fanclub/27282";
    //1、创建广告
    ADView *adView = [[ADView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds imgUrl:image adUrl:ad clickImg:^(NSString *clikImgUrl) {
//        NSLog(@"进入广告:%@",clikImgUrl);
         self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        ADViewController *adVc = [[ADViewController alloc] init];
        adVc.adUrl = ad;
        [self.navigationController pushViewController:adVc animated:YES];
         self.hidesBottomBarWhenPushed = NO;//如果在push跳转时需要隐藏tabBar
    }];
    
    //设置倒计时（默认3秒）
    adView.showTime = 7;
    //2、显示广告
//    [adView show];
}

#pragma mark 进入开始定位
-(void)statLocation{

    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位，定位后签到
        //创建CLLocationManager对象
        self.locManager = [[CLLocationManager alloc] init];
        //设置代理为自己
        self.locManager.delegate = self;
        [self.locManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        [self.locManager startUpdatingLocation];
    }
    
}

#pragma mark 反响获取刚刚定位到城市的id
- (NSMutableArray *) cityData{
    if (_cityData == nil) {
        _cityData = [[NSMutableArray alloc] init];
    }
    return _cityData;
}

#pragma mark CoreLocation delegate

#pragma mark 定位失败执行方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationbtn setTitle:@"手动切换" forState:UIControlStateNormal];
     NSLog(@"访问拒绝");

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
                if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
    
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"允许“铺皇”访问您的位置？" message:@"使用您的位置为您提供搜索周边店铺服务,请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                [[UIApplication sharedApplication] openURL:url];
                            }
                        }];
                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        
                        [alertController addAction:commitAction];
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
}

#pragma mark 定位成功
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
//    防止重复定位
    number = number+1;
    
    NSLog(@"longitude = %f", ((CLLocation *)[locations lastObject]).coordinate.longitude);
    NSLog(@"latitude  = %f", ((CLLocation *)[locations lastObject]).coordinate.latitude);
    NSLog(@"定位成功");
    CLLocation *currentLocation = [locations lastObject];
    
    // 反编码获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
          [self.locManager stopUpdatingLocation];
        if (placemarks.count > 0) {

            CLPlacemark * placeMark = placemarks[0];
            NSLog(@"定位到城市名称: = %@", placeMark.locality);
            NSLog(@"定位到城市具体地址: = %@", placeMark.name);
            if (!placeMark.locality) {
                self.maincityName = @"无法定位当前城市";
            }else{
                self.maincityName = placeMark.locality;
            }
            
            [[YJLUserDefaults shareObjet]saveObject:self.maincityName forKey:YJLCityname];
            [self.locationbtn setTitle:[NSString stringWithFormat:@"%@",self.maincityName] forState:UIControlStateNormal];
            
#pragma mark 拿到城市名称 开始反向获取城市id
            NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
            _data = [[NSMutableArray alloc] init];
            for (NSDictionary *groupDic in array){
                TLCityGroup *group = [[TLCityGroup alloc] init];
                group.groupName    = [groupDic objectForKey:@"initial" ];
                for (NSDictionary  * dic in [groupDic objectForKey:@"citys"]){
                    TLCity *city   = [[TLCity alloc] init              ];
                    city.cityID    = [dic objectForKey:@"city_key"     ];
                    city.cityName  = [dic objectForKey:@"city_name"    ];
                    city.shortName = [dic objectForKey:@"short_name"   ];
                    city.pinyin    = [dic objectForKey:@"pinyin"       ];
                    city.initials  = [dic objectForKey:@"initials"     ];
                    [group.arrayCitys addObject:city                   ];
                    [self.cityData addObject:city                      ];
                }
            }
            
            TLCity *city = nil;
            for (TLCity *item in self.cityData){
                
                if ([item.cityName isEqualToString:self.maincityName]){
                    city = item;
                    NSLog(@"定位到城市I:%@",city.cityID);
                    self.maincityID = city.cityID;
                    [[YJLUserDefaults shareObjet]saveObject:city.cityID forKey:YJLCityid];
                    
                NSLog(@"number====%d",number);
                 if (number < 100) {
                     [self loadallData];
                     number = 10000000;
                 }else{
                     NSLog(@"不要了");
                 }
        }
            }
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
    }];
}

#pragma mark-ClickLocation 定位点击
-(void)ClickLocation{
    
    NSLog(@"点击定位系统");
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    cityPickerVC.loactionCityName = self.maincityName;

    //    cityPickerVC.locationCityID   = @"291";
    //        cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"291", @"289", @"258"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"291", @"289", @"258",@"1", @"299", @"9"];//深圳 广州 武汉 北京 惠州 上海
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
//        NSLog(@"cityPickerVC.locationCityID==%@",cityPickerVC.locationCityID);
        
    }];
}

#pragma mark - TLCityPickerDelegate定位代理2 调出选择城市界面
- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - TLCityPickerDelegate定位代理1 切换了城市  做需求处理判断
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city{
    
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
        if (city.cityID.length > 5 ){
            
            [YJLHUD showImage:nil message:[NSString stringWithFormat:@"%@ 未加盟铺皇,如有需要可看联系客服",city.cityName]];//无图片 纯文字
            [YJLHUD dismissWithDelay:2];
            
            [self.locationbtn setTitle:@"重新定位" forState:UIControlStateNormal];
            self.maincityID = city.cityID;
        }
        
        else{
//            NSLog(@"当前城市:%@，城市ID：%@",city.cityName,city.cityID);
            self.maincityID = city.cityID;
            [self.locationbtn setTitle:city.cityName forState:UIControlStateNormal];
            
        
            [YJLHUD showImage:nil message:[NSString stringWithFormat:@"正在更新%@数据，请稍等片刻",city.cityName]];//无图片 纯文字
            [YJLHUD dismissWithDelay:4];
            
            NSLog(@"self.maincityID===%@",self.maincityID);
            
#pragma -mark 本地存储换了手动切换城市IP地址 方便 发布界面 消息 我的界面使用一个id  start
            
            [[NSUserDefaults standardUserDefaults] setObject:city.cityID forKey:@"Firstcityid"];//账号
            [[NSUserDefaults standardUserDefaults] synchronize];
            
#pragma -mark 本地存储换了手动切换城市IP地址 方便 发布界面 消息 我的界面使用一个id  end
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCity" object:nil userInfo:nil];

            [[Cityarea shareCityData]deletedCityarea];
//            加载数据
            [self loadallData];
        }
    }];
}

#pragma -mark-创建固定搜索点
-(void)creatTOPview{
    
    //    创建自己的导航栏
    self.NavView = [[UIView alloc]initWithFrame:CGRectMake(0,0, KMainScreenWidth, 64)];
    self.NavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.NavView];
    
    //    创建一个定位按钮
    self.locationbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationbtn.frame= CGRectMake(0, 20, KMainScreenWidth/7*2, KDaohang_Height);
    //    设置定位背景颜色
    self.locationbtn.backgroundColor = [UIColor clearColor];
    //    设置定位字体颜色
    [self.locationbtn setTitleColor:[UIColor colorWithRed:51 green:51 blue:51 alpha:1.0] forState:UIControlStateNormal];
    //    设置定位字体大小，*******************
    self.locationbtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];

    //    设置定位按钮标题****************************
    [self.locationbtn setImage:[UIImage imageNamed:@"dingwei"]   forState:UIControlStateNormal];
    //    按钮文字居左
    self.locationbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//横向居右
    [self.locationbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 18)];
    [self.locationbtn setImageEdgeInsets:UIEdgeInsetsMake(0, KMainScreenWidth/7*2 - 15, 0, 0)];
    //    设置点击事件
    [self.locationbtn addTarget:self action:@selector(ClickLocation) forControlEvents:UIControlEventTouchUpInside];
    //   将 定位 添加到 定位点 搜索 二维码视
    [_NavView addSubview:self.locationbtn];
    
    //    创建一个搜索视图
    UIView *serachView = [[UIView alloc]initWithFrame:CGRectMake(KMainScreenWidth/7*2, 29.5, KMainScreenWidth/7*5,KDaohang_Height-19)];
    
    //    为搜索视图添加一个图片视图用作背景色
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth/7*4,KDaohang_Height-19)];
    imageView.image = [UIImage imageNamed:@"sousuokuang"];
   
    //    创建搜索文本框
    UILabel *serachLabel    = [[UILabel alloc]init];
    serachLabel.frame       = CGRectMake(55, 0, KMainScreenWidth/7*4-55,25 );
    serachLabel.text        = @"请输入店铺条件";
    serachLabel.textColor   = [UIColor lightGrayColor];
    serachLabel.font        = [UIFont systemFontOfSize:13];
    
    //    创建搜索图标显示
    UIImage *serachimage            = [UIImage imageNamed:@"search_left"];
    UIImageView *serachImageview    = [[UIImageView alloc]initWithImage:serachimage] ;
    serachImageview.frame           = CGRectMake(30, 0, 20, 25);
    serachImageview.contentMode     = UIViewContentModeCenter;
   
    //    添加到搜索视图上面
    [serachView addSubview:imageView];
    [serachView addSubview:serachLabel];
    [serachView addSubview:serachImageview];
    
    //   在搜索视图上面加手势
    UITapGestureRecognizer * serachGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serachsan:)];
    serachView.userInteractionEnabled = YES;
    [serachView addGestureRecognizer:serachGes];
    //   将 搜索视图 添加导航栏
    [_NavView addSubview:serachView];
}

#pragma - mark - 搜索手势
-(void)serachsan:(UIGestureRecognizer *)ges{
//    NSLog(@"点击了搜索框");
    if (!_maincityID) {
//        NSLog(@"没有定位成功11111");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位尚未成功，可以进行手动定位" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//            NSLog(@"点击了确认");
        }];
        
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else{
         self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        SerachViewController *ctl =[[SerachViewController alloc]init];
         ctl.Cityid = _maincityID;
        [self.navigationController pushViewController:ctl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//如果在push跳转时需要隐藏tabBar
    }
}

#pragma -mark-创建广告图
-(void)creatScroll{
    NSMutableArray *IMG = [NSMutableArray arrayWithObjects:@"banner_3",@"banner_1",@"banner_2",@"banner_3",@"banner_1",nil];//本地图片
//     NSMutableArray *IMG = [NSMutableArray arrayWithObjects://网络图片
//                            @"https://ph.chinapuhuang.com/Public/Uploads/2017-12-04/5a24f568efd959.16884004.png",
//                            @"https://ph.chinapuhuang.com/Public/Uploads/2017-12-04/5a24f568efd959.16884004.png",
//                            @"https://ph.chinapuhuang.com/Public/Uploads/2017-12-04/5a24f568efd959.16884004.png",
//                            @"https://ph.chinapuhuang.com/Public/Uploads/2017-12-04/5a24f568efd959.16884004.png",
//                            @"https://ph.chinapuhuang.com/Public/Uploads/2017-12-04/5a24f568efd959.16884004.png",nil];
   
    _scrollView = [[ScrollHeadView alloc]initWithFrame:CGRectMake( 0 , 0 , KMainScreenWidth, 194) arraySource:IMG];
    self.automaticallyAdjustsScrollViewInsets = NO;  //ios7 之后必写这句不然图片会跑出范围
    _scrollView.nav = self.navigationController;
    [self.HeaderView addSubview:_scrollView];
    [self.HeaderView sendSubviewToBack:_scrollView];
    
}

#pragma -mark-创建6个按钮功能
-(void)creatSixbtn{
    
//    NSLog(@"6个功能");
    //  先创建一个   6个   按钮背景视图
    self.TwoHeaderview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), KMainScreenWidth, 216)];
    self.TwoHeaderview.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:self.TwoHeaderview];
    
    //    第一排按钮
    //    地图选址
    JXButton *selectionbtn = [[JXButton alloc]initWithFrame:CGRectMake(10, 10, (KMainScreenWidth-60)/3, 216/2-15)];
    [selectionbtn setTitle:@"地图选址" forState:0];
    [selectionbtn setImage:[UIImage imageNamed:@"地图选铺"] forState:0];
    [selectionbtn setTitleColor:[UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0] forState:0];
    selectionbtn.tag = 100;
    [selectionbtn addTarget:self action:@selector(SixClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.TwoHeaderview addSubview:selectionbtn];
    
    //    店铺转让
    JXButton *transferbtn = [[JXButton alloc]initWithFrame:CGRectMake((KMainScreenWidth-60)/3+30, 10,(KMainScreenWidth-60)/3 , 216/2-15)];
    [transferbtn setTitle:@"店铺转让" forState:0];
    [transferbtn setImage:[UIImage imageNamed:@"店铺转让"] forState:0];
    [transferbtn setTitleColor:[UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0] forState:0];
    transferbtn.tag = 101;
    [transferbtn addTarget:self action:@selector(SixClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.TwoHeaderview addSubview:transferbtn];
    
    //    商铺选址
    JXButton *locationbtn = [[JXButton alloc]initWithFrame:CGRectMake(((KMainScreenWidth-60)/3+20)*2+10, 10, (KMainScreenWidth-60)/3, 216/2-15)];
    [locationbtn setTitle:@"商铺选址" forState:0];
    [locationbtn setImage:[UIImage imageNamed:@"商铺选址"] forState:0];
    [locationbtn setTitleColor:[UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0] forState:0];
    locationbtn.tag = 102;
    [locationbtn addTarget:self action:@selector(SixClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.TwoHeaderview addSubview:locationbtn];
    
    //    第二排按钮
    //    商铺招商/出租
    JXButton *investmentbtn = [[JXButton alloc]initWithFrame:CGRectMake(10, 216/2+5, (KMainScreenWidth-60)/3, 216/2-15)];
    [investmentbtn setTitle:@"出租招商" forState:0];
    [investmentbtn setImage:[UIImage imageNamed:@"出租招商"] forState:0];
    [investmentbtn setTitleColor:[UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0] forState:0];
    investmentbtn.tag = 103;
    [investmentbtn addTarget:self action:@selector(SixClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.TwoHeaderview addSubview:investmentbtn];
    
    //    招聘中心
    JXButton *cooperationbtn = [[JXButton alloc]initWithFrame:CGRectMake(((KMainScreenWidth-60)/3+20)*1+10, 216/2+5, (KMainScreenWidth-60)/3, 216/2-15)];
    [cooperationbtn setTitle:@"招聘中心" forState:0];
    [cooperationbtn setImage:[UIImage imageNamed:@"招聘中心"] forState:0];
    [cooperationbtn setTitleColor:[UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0] forState:0];
    cooperationbtn.tag = 104;
    [cooperationbtn addTarget:self action:@selector(SixClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.TwoHeaderview addSubview:cooperationbtn];
    
    //    开店服务
    JXButton *recruitmentbtn = [[JXButton alloc]initWithFrame:CGRectMake(((KMainScreenWidth-60)/3+20)*2+10, 216/2+5, (KMainScreenWidth-60)/3, 216/2-15)];
    [recruitmentbtn setTitle:@"开店服务" forState:0];
    [recruitmentbtn setImage:[UIImage imageNamed:@"开店服务"] forState:0];
    [recruitmentbtn setTitleColor:[UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0] forState:0];
    recruitmentbtn.tag = 105;
    [recruitmentbtn addTarget:self action:@selector(SixClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.TwoHeaderview addSubview:recruitmentbtn];
}


#pragma -mark-6个按钮点击功能
-(void)SixClick:(UIButton *)btn{
    
    if (!_maincityID) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位尚未成功，可以进行手动定位" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    NSLog(@"点击了确认");
        }];
        
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else{
    
    if (btn.tag == 100) {
//        地图选址
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        ShopsmapsiteViewController *Ctl = [ShopsmapsiteViewController new];
        Ctl.cityid   = self.maincityID;
        Ctl.cityname = self.maincityName;
        [self.navigationController pushViewController:Ctl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
    }
    if (btn.tag == 101) {
//        店铺转让
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        ShopsattornViewController *daiCtl = [ShopsattornViewController new];
        daiCtl.hostcityid = _maincityID;
        [self.navigationController pushViewController:daiCtl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
    }
        
    if (btn.tag == 102) {
//        商铺选址
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        ShopssiteViewController *daiCtl = [ShopssiteViewController new];
        daiCtl.hostcityid = _maincityID;
        [self.navigationController pushViewController:daiCtl animated:YES];
         self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
    }
    if (btn.tag == 103) {
//        出租招商(用出租)
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        ShopsleaseViewController *daiCtl = [ShopsleaseViewController new];
        daiCtl.hostcityid = _maincityID;
        [self.navigationController pushViewController:daiCtl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
    }
    
    if (btn.tag == 104) {
//        招聘中心
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        ShopsrecruitViewController *daiCtl = [ShopsrecruitViewController new];
        daiCtl.city = self.maincityID;
        [self.navigationController pushViewController:daiCtl animated:YES];
         self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
    }
        
    if (btn.tag == 105) {
        
//        开店服务
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        ShopsserviceViewController *daiCtl = [ShopsserviceViewController new];
        [self.navigationController pushViewController:daiCtl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
    }
   }
}

#pragma -mark-创建大数据按钮
-(void)creatbigdata{

//    NSLog(@"大数据展示");
    //    正在找店量
    self.NewView = [[UIView alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(_TwoHeaderview.frame)+10 , (KMainScreenWidth-2)/3 * 1, 55)];
    self.NewView.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:self.NewView];
    
    //    最近成交量
    self.AgoView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.NewView.frame)+1,  CGRectGetMaxY(_TwoHeaderview.frame)+10, (KMainScreenWidth-2)/3, 55)];
    self.AgoView.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:self.AgoView];
    
    //    转店客户量
    self.SettledView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.AgoView.frame)+1, CGRectGetMaxY(_TwoHeaderview.frame)+10, (KMainScreenWidth-2)/3, 55)];
    self.SettledView.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:self.SettledView];
    
    //    数据加载显示框
    NSArray * ZDLarrimage   =     @[@"find",@"deal",@"Putin"];
    NSArray * ZDLarrtitle   =     @[@"找店量",@"成交量",@"转店量"];
    for (NSInteger i = 0; i < 3; i ++){
        
        _bigimgview       = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 55-20,55-20 )];
        _bigimgview.image = [UIImage imageNamed:ZDLarrimage[i]];
        
        _biglab           = [[UILabel alloc]initWithFrame:CGRectMake(10+55-20+5, 10,                           60, (55-20)/2)];
        _biglab.text = [NSString stringWithFormat:@"%@",ZDLarrtitle[i]];
        _biglab.textAlignment = NSTextAlignmentLeft;
        
        if (KMainScreenWidth>320){
            
            _biglab.font = [UIFont systemFontOfSize:10];
        }
        else{
            _biglab.font = [UIFont systemFontOfSize:8];
        }
        _biglab.textColor = [UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0];
        
        if ( i == 0){
            [self.NewView addSubview:_biglab];
            [self.NewView addSubview:_bigimgview];
        }
        if (i == 1){
            [self.AgoView addSubview:_biglab];
            [self.AgoView addSubview:_bigimgview];
        }
        if (i == 2){
            [self.SettledView addSubview:_biglab];
            [self.SettledView addSubview:_bigimgview];
        }
    }
    
    _Newlab    = [[UILabel alloc]initWithFrame:CGRectMake(10+55-20+5, (55-20)/2+10, 60, (55-20)/2)];
    _Newlab.textAlignment = NSTextAlignmentLeft;
    _Newlab.textColor = [UIColor colorWithRed:214/250.0 green:77/250.0 blue:77/250.0 alpha:1.0];
    
    [self.NewView addSubview:_Newlab];
    
    _Agolab    = [[UILabel alloc]initWithFrame:CGRectMake(10+55-20+5, (55-20)/2+10, 60, (55-20)/2)];
    _Agolab.textAlignment = NSTextAlignmentLeft;
    _Agolab.textColor = [UIColor colorWithRed:214/250.0 green:77/250.0 blue:77/250.0 alpha:1.0];
    [self.AgoView addSubview:_Agolab];
    
    _Settlelab    = [[UILabel alloc]initWithFrame:CGRectMake(10+55-20+5, (55-20)/2+10, 60, (55-20)/2)];
    _Settlelab.textAlignment = NSTextAlignmentLeft;
    _Settlelab.textColor = [UIColor colorWithRed:214/250.0 green:77/250.0 blue:77/250.0 alpha:1.0];
    [self.SettledView addSubview:_Settlelab];
    if (KMainScreenWidth>320){
        
        _biglab.font =_Newlab.font =_Agolab.font =_Settlelab.font = [UIFont systemFontOfSize:10];
    }
    else{
        
        _biglab.font =_Newlab.font =_Agolab.font =_Settlelab.font = [UIFont systemFontOfSize:8];
    }
}

#pragma -mark-点击今日头条动态
#pragma mark - <CDDRollingDelegate>
- (void)dc_RollingViewSelectWithActionAtIndex:(NSInteger)index{
    
    NSLog(@"点击");
}

#pragma -mark-创建今日头条
-(void)creatday{
//    ✨✨✨✨✨✨✨✨✨✨
    self.Dayview = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.NewView.frame) + 1, KMainScreenWidth, 55 )];
    self.Dayview.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:self.Dayview];
    
    TTRollingview = [[DCTitleRolling alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 55) WithTitleData:^(CDDRollingGroupStyle *rollingGroupStyle, NSString *__autoreleasing *leftImage, NSArray *__autoreleasing *rolTitles, NSArray *__autoreleasing *rolTags, NSArray *__autoreleasing *rightImages, NSString *__autoreleasing *rightbuttonTitle, NSInteger *interval, float *rollingTime, NSInteger *titleFont, UIColor *__autoreleasing *titleColor, BOOL *isShowTagBorder) {
        
//        *rolTags = @[@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新",@"最新"];
        *rolTitles = @[ @"恭喜程先生15天成功转让商铺1588253****",
                        @"恭喜李先生成功选址,开业大吉1382542****",
                        @"恭喜周小姐21天成功转让商铺1321458****",
                        @"恭喜王先生成功办理首页推广,祝早日转店1599474****",
                        @"恭喜李先生成功选址,开业大吉1351047****",
                        @"恭喜李先生成功选址,开业大吉1351047****",
                        @"恭喜卢小姐店铺成功出租,1351642****",
                        @"恭喜赵先生火爆商铺9天成功转让,1588232****",
                        @"恭喜刘小姐成功办理首页推广,祝早日转店,1583252****",
                        @"恭喜李先生成功开店,祝开业大吉,1588865****",
                        @"恭喜闻女士成功开店,祝开业大吉1588232****",
                        @"恭喜李老师,成功办理首页推广,祝早日转店,1525353****",
                        @"恭喜程女士,选址成功，祝开业大吉，1551320****",
                        @"恭喜李先生24天店铺成功转让,1588457****",
                        @"恭喜邹先生16天店铺成功转让,1581874****",
                        @"恭喜王先生35天店铺成功转让,转让费获得80万,1582537****",
                        @"恭喜徐小姐7天店铺成功转让,获取转让费6万,1583212****",
                        @"恭喜廖小姐15天店铺成功转让,获取转让费30万,1368256****",
                        @"恭喜黄先生选址成功,祝开业大吉,1503212****",
                        @"恭喜汤先生维客佳15天成功转让,转让费15万,1836731****",
                        @"恭喜钱女士成功选址,祝开业大吉,1522132****"
                        ];
        *leftImage = @"headlines";
        *interval = 3.0;
        *titleFont = 11;
        *titleColor = [UIColor orangeColor];
        *isShowTagBorder = YES;
        *rollingTime = 0.2;
    }];
    
    TTRollingview.delegate = self;//设置代理进行点击事件判断
    [TTRollingview dc_beginRolling];
    TTRollingview.backgroundColor = [UIColor whiteColor];
    [self.Dayview addSubview:TTRollingview];
}

#pragma -mark-创建设置精选信息一类
-(void)creatchoice{
    //                          精选标题
    _choicelab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_Dayview.frame)+10  , KMainScreenWidth, 30)];
    _choicelab.text = @" - 精 选 开 店 - ";
    _choicelab.backgroundColor = [UIColor whiteColor];
    _choicelab.font = [UIFont systemFontOfSize:15];
    _choicelab.textAlignment = NSTextAlignmentCenter;
    _choicelab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.HeaderView addSubview:_choicelab];
    
    //                          区域选店
    _JXview_1 = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_choicelab.frame)+1 , (KMainScreenWidth-3)/4, 100)];
    _JXview_1.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_JXview_1];
    
    //                          租金选店
   _JXview_2= [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_JXview_1.frame)+1, CGRectGetMaxY(_choicelab.frame)+1, (KMainScreenWidth-3)/4, 100)];
    _JXview_2.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_JXview_2];
    
    //                          低价商铺
    _JXview_3 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_JXview_2.frame)+1, CGRectGetMaxY(_choicelab.frame)+1, (KMainScreenWidth-3)/4, 100)];
    _JXview_3.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_JXview_3];
    
    //                          适合面积
    _JXview_4 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_JXview_3.frame)+1, CGRectGetMaxY(_choicelab.frame)+1, (KMainScreenWidth-3)/4, 100)];
    _JXview_4.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_JXview_4];
    
    //  创建一个手势按钮点击事件
    UITapGestureRecognizer *JX_1Ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JX_1Gesclick)];
    UITapGestureRecognizer *JX_2Ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JX_2Gesclick)];
    UITapGestureRecognizer *JX_3Ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JX_3Gesclick)];
    UITapGestureRecognizer *JX_4Ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JX_4Gesclick)];
    
    NSArray *JXArr1 = @[@"区域选店",@"租金选店",@"低价商铺",@"合适面积"];
    NSArray *JXArr2 = @[@"选好区域,做好生意",@"租金大减,费用低价",@"立即接手,马上赚钱",@"面积众多,随您挑选"];
    NSArray *JXImageArr =@[@"QYXD",@"ZJXD",@"DJDP",@"SHMJ"];
    
    // 遍历创建精选
    for (NSInteger i = 0; i < 4; i ++) {
        
        UILabel * JX_1lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, KMainScreenWidth/4, 10)];
        UILabel * JX_2lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, KMainScreenWidth/4, 10)];
        UIImageView * JXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35, KMainScreenWidth/4-20, KMainScreenWidth / 4-30)];

        if (i == 0) {
            
            JX_1lab.text = JXArr1[i];
            JX_1lab.font = [UIFont systemFontOfSize:12];
            JX_1lab.textAlignment = NSTextAlignmentCenter;
            JX_1lab.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            JX_2lab.text = JXArr2[i];
            JX_2lab.font = [UIFont systemFontOfSize:9];
            JX_2lab.textAlignment = NSTextAlignmentCenter;
            JX_2lab.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1];
            JXImageView.image = [UIImage imageNamed:JXImageArr[i]];
            [_JXview_1 addSubview:JX_1lab];
            [_JXview_1 addSubview:JX_2lab];
            [_JXview_1 addSubview:JXImageView];
            [_JXview_1 addGestureRecognizer:JX_1Ges];
        }
        
        if (i == 1) {
            JX_1lab.text = JXArr1[i];
            JX_1lab.font = [UIFont systemFontOfSize:12];
            JX_1lab.textAlignment = NSTextAlignmentCenter;
            JX_1lab.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            JX_2lab.text = JXArr2[i];
            JX_2lab.font = [UIFont systemFontOfSize:9];
            JX_2lab.textAlignment = NSTextAlignmentCenter;
            JX_2lab.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1];
            JXImageView.image = [UIImage imageNamed:JXImageArr[i]];
            [_JXview_2 addSubview:JX_1lab];
            [_JXview_2 addSubview:JX_2lab];
            [_JXview_2 addSubview:JXImageView];
            [_JXview_2 addGestureRecognizer:JX_2Ges];
        }
        if (i == 2) {
            JX_1lab.text = JXArr1[i];
            JX_1lab.font = [UIFont systemFontOfSize:12];
            JX_1lab.textAlignment = NSTextAlignmentCenter;
            JX_1lab.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            JX_2lab.text = JXArr2[i];
            JX_2lab.font = [UIFont systemFontOfSize:9];
            JX_2lab.textAlignment = NSTextAlignmentCenter;
            JX_2lab.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1];
            JXImageView.image = [UIImage imageNamed:JXImageArr[i]];
            [_JXview_3 addSubview:JX_1lab];
            [_JXview_3 addSubview:JX_2lab];
            [_JXview_3 addSubview:JXImageView];
            [_JXview_3 addGestureRecognizer:JX_3Ges];
        }
        if (i == 3) {
            JX_1lab.text = JXArr1[i];
            JX_1lab.font = [UIFont systemFontOfSize:12];
            JX_1lab.textAlignment = NSTextAlignmentCenter;
            JX_1lab.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            JX_2lab.text = JXArr2[i];
            JX_2lab.font = [UIFont systemFontOfSize:9];
            JX_2lab.textAlignment = NSTextAlignmentCenter;
            JX_2lab.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1];
            JXImageView.image = [UIImage imageNamed:JXImageArr[i]];
            [_JXview_4 addSubview:JX_1lab];
            [_JXview_4 addSubview:JX_2lab];
            [_JXview_4 addSubview:JXImageView];
            [_JXview_4 addGestureRecognizer:JX_4Ges];
        }
    }
}

#pragma -mark - 精选开店1类手势事件1
-(void)JX_1Gesclick{
    
//    NSLog(@"区域选店。    1");
     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    FeaturedistrictController * rentctl = [[FeaturedistrictController alloc]init];
    rentctl.hostcityid = self.maincityID;
    [self.navigationController pushViewController:rentctl animated:YES];
     self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
}

#pragma -mark - 精选开店1类手势事件2
-(void)JX_2Gesclick{
    
//    NSLog(@"租金选店。    2");
     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    FeaturedController * rentctl = [[FeaturedController alloc]init];
    rentctl.hostcityid = self.maincityID;
    [self.navigationController pushViewController:rentctl animated:YES];
     self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
}

#pragma -mark - 精选开店1类手势事件3
-(void)JX_3Gesclick{
    
//    NSLog(@"低价商铺。    3");
     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    FeaturepriceController * pricectl = [[FeaturepriceController alloc]init];
    pricectl.hostcityid = self.maincityID;
    [self.navigationController pushViewController:pricectl animated:YES];
     self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
}

#pragma -mark - 精选开店1类手势事件4
-(void)JX_4Gesclick{
    
//    NSLog(@"合适面积。    4");
     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    FeatureareaController * pricectl = [[FeatureareaController alloc]init];
    pricectl.hostcityid = self.maincityID;
    [self.navigationController pushViewController:pricectl animated:YES];
     self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
}

#pragma -mark - 推荐banner
-(void)creatrecommendIMG{
    
    _recommendImgView           = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_JXview_1.frame)+10 , KMainScreenWidth,113)];
    _recommendImgView.backgroundColor = [UIColor whiteColor];
    _recommendImgView.image     = [UIImage imageNamed:@"recommend_img"];
    _recommendImgView.userInteractionEnabled = YES;
    //  创建一个手势按钮点击事件
    UITapGestureRecognizer *recommendGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recommendGesclick)];
    [_recommendImgView addGestureRecognizer:recommendGes];
    
    [self.HeaderView addSubview:_recommendImgView];
    
    UILabel * caseall = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth-100, 0, 90, 30)];
    caseall.textAlignment =NSTextAlignmentRight;
    caseall.text = @"更多";
    caseall.textColor =[UIColor whiteColor];
    caseall.font = [UIFont systemFontOfSize:14.0f];
    [_recommendImgView addSubview:caseall];
}

#pragma -mark - 推荐店铺banner点击事件
-(void)recommendGesclick{

    if (!_maincityID) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位尚未成功，可以进行手动定位" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
            NSLog(@"点击了确认");
        }];
        
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else{
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        RecommedController *daiCtl = [RecommedController new];
        daiCtl.cityid = _maincityID;
        [self.navigationController pushViewController:daiCtl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
       
    }
}

#pragma -mark - 推荐娱乐类
-(void)creatrecommendONE{
    
    _recreationView         = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_recommendImgView.frame)+7 , KMainScreenWidth,360)];
    _recreationView.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_recreationView];
    
    UIView   *titleview     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 47)];
    titleview.backgroundColor = [UIColor whiteColor];
//    主标题
    UILabel  *titlelab      =[[UILabel alloc]initWithFrame:CGRectMake(0, 7, KMainScreenWidth, 15)];
    titlelab.text           =@"- 娱 乐 类 -";
    titlelab.textColor      = kTCColor(51, 51, 51);
    titlelab.textAlignment  = NSTextAlignmentCenter;
    titlelab.font           =[UIFont systemFontOfSize:15.0f];
    [titleview addSubview:titlelab];
//    副标题
    UILabel  *titlesublab   =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelab.frame)+8, KMainScreenWidth, 10)];
    titlesublab.text        =@"娱乐是开心的  找店是简单的";
    titlesublab.textColor   = kTCColor(102, 102, 102);
    titlesublab.textAlignment = NSTextAlignmentCenter;
    titlesublab.font        =[UIFont systemFontOfSize:11.0f];
    [titleview addSubview:titlesublab];
    
//    添加到主视图
    [_recreationView addSubview:titleview];
    
    //    标题与cell分割线
    UIView *linerecommend  = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleview.frame)+1 , KMainScreenWidth,1)];
    linerecommend.backgroundColor = kTCColor(228, 228, 228);
    [_recreationView addSubview:linerecommend];
    
//    主数据框
   UIView *Cellview         = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleview.frame)+3, KMainScreenWidth,310)];
    [_recreationView addSubview:Cellview];
    
//    加入collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    recreationcollecview    = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,Cellview.frame.size.width , Cellview.frame.size.height) collectionViewLayout:layout];
    [Cellview addSubview:recreationcollecview];
    recreationcollecview.backgroundColor = kTCColor(228, 228, 228);
    
// 注册XIB
    [recreationcollecview registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellWithReuseIdentifier:@"recreationCell"];
    recreationcollecview.delegate    = self;
    recreationcollecview.dataSource  = self;
    
    self.yulebtnButtom = [[ShoppingBtn alloc]initWithFrame:CGRectMake(0, 0, 200, 30) buttonStyle:UIButtonStyleButtom spaceing:0 imagesize:0];
       self.yulebtnButtom.center = recreationcollecview.center;
    [self.yulebtnButtom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.yulebtnButtom.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.yulebtnButtom addTarget:self action:@selector(loadrecreationData) forControlEvents:UIControlEventTouchUpInside];
    self.yulebtnButtom.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.yulebtnButtom.hidden = NO;
    [self.yulebtnButtom setTitle:@"加载数据失败" forState:UIControlStateNormal];
    [Cellview addSubview:self.yulebtnButtom];
}

#pragma -mark - 推荐生活类
-(void)creatrecommendTWO{
    
    _lifeView  = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_recreationView.frame)+7 , KMainScreenWidth,360)];
    _lifeView.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_lifeView];
    
    UIView *titleview       = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 47)];
    //    主标题
    UILabel  *titlelab      =[[UILabel alloc]initWithFrame:CGRectMake(0, 7, KMainScreenWidth, 15)];
    titlelab.text           =@"- 生 活 类 -";
    titlelab.textColor      = kTCColor(51, 51, 51);
    titlelab.textAlignment  = NSTextAlignmentCenter;
    titlelab.font           =[UIFont systemFontOfSize:15.0f];
    [titleview addSubview:titlelab];
    //    副标题
    UILabel  *titlesublab   =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelab.frame)+8, KMainScreenWidth, 10)];
    titlesublab.text        =@"生活五味杂陈  店铺应有尽有";
    titlesublab.textColor   = kTCColor(102, 102, 102);
    titlesublab.textAlignment = NSTextAlignmentCenter;
    titlesublab.font        =[UIFont systemFontOfSize:11.0f];
    [titleview addSubview:titlesublab];
    
    //    添加到主视图
    [_lifeView addSubview:titleview];
    
    //    标题与cell分割线
    UIView *linelife  = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleview.frame)+1 , KMainScreenWidth,1)];
    linelife.backgroundColor = kTCColor(228, 228, 228);
    [_lifeView addSubview:linelife];
    
    //    主数据框
    UIView *Cellview        = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleview.frame)+3, KMainScreenWidth,310)];
    [_lifeView addSubview:Cellview];
    
    //    加入collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    lifecollecview    = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,Cellview.frame.size.width , Cellview.frame.size.height) collectionViewLayout:layout];
    [Cellview addSubview:lifecollecview];
    lifecollecview.backgroundColor = kTCColor(228, 228, 228);
    
    // 注册XIB
    [lifecollecview registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellWithReuseIdentifier:@"lifeCell"];
    lifecollecview.delegate    = self;
    lifecollecview.dataSource  = self;
    
    self.shuobtnButtom = [[ShoppingBtn alloc]initWithFrame:CGRectMake(0, 0, 200, 30) buttonStyle:UIButtonStyleButtom spaceing:0 imagesize:0];
   
    self.shuobtnButtom.center = lifecollecview.center;
    [self.shuobtnButtom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.shuobtnButtom.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.shuobtnButtom addTarget:self action:@selector(loadlifeData) forControlEvents:UIControlEventTouchUpInside];
    self.shuobtnButtom.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.shuobtnButtom.hidden = NO;
    [self.shuobtnButtom setTitle:@"加载数据失败" forState:UIControlStateNormal];
    [Cellview addSubview:self.shuobtnButtom];
}

#pragma -mark - 推荐百货类
-(void)creatrecommendTHR{

    _departmentView  = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lifeView.frame)+7 , KMainScreenWidth,360)];
    _departmentView.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_departmentView];
    
    UIView *titleview       = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 47)];
    UILabel  *titlelab      =[[UILabel alloc]initWithFrame:CGRectMake(0, 7, KMainScreenWidth, 15)];
    UILabel  *titlesublab   =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelab.frame)+8, KMainScreenWidth, 10)];
    titlelab.text           = @"- 百 货 类 -";
    titlesublab.text        = @"收揽世界品牌  推送精品店铺";
    titlelab.textColor      = kTCColor(51, 51, 51);
    titlesublab.textColor   = kTCColor(102, 102, 102);
    titlelab.textAlignment  = titlesublab.textAlignment  = NSTextAlignmentCenter;
    titlelab.font           = [UIFont systemFontOfSize:15.0f];
    titlesublab.font        = [UIFont systemFontOfSize:11.0f];
    
    [titleview addSubview:titlelab];
    [titleview addSubview:titlesublab];
    [_departmentView addSubview:titleview];
    
    //    标题与cell分割线
    UIView *linedepart  = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleview.frame)+1 , KMainScreenWidth,1)];
    linedepart.backgroundColor = kTCColor(228, 228, 228);
    [_departmentView addSubview:linedepart];
    
    UIView *Cellview         = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleview.frame)+3, KMainScreenWidth,310)];
    [_departmentView addSubview:Cellview];
    
    //    加入collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    departmentcollecview   = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,Cellview.frame.size.width , Cellview.frame.size.height) collectionViewLayout:layout];
    [Cellview addSubview:departmentcollecview];
    departmentcollecview.backgroundColor = kTCColor(228, 228, 228);

    // 注册XIB
    [departmentcollecview registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellWithReuseIdentifier:@"departmentCell"];
    departmentcollecview.delegate    = self;
    departmentcollecview.dataSource  = self;
    
    self.bhuobtnButtom = [[ShoppingBtn alloc]initWithFrame:CGRectMake(0, 0, 200, 30) buttonStyle:UIButtonStyleButtom spaceing:0 imagesize:0];
     self.bhuobtnButtom.center = departmentcollecview.center;
    [self.bhuobtnButtom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.bhuobtnButtom.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.bhuobtnButtom addTarget:self action:@selector(loaddepartmentData) forControlEvents:UIControlEventTouchUpInside];
    self.bhuobtnButtom.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.bhuobtnButtom.hidden = NO;
    [self.bhuobtnButtom setTitle:@"加载数据失败" forState:UIControlStateNormal];
    [Cellview addSubview:self.bhuobtnButtom];
}

#pragma -mark - 最新案例视图 //高度 829
-(void)creatzxcase{
    
    _ZXcaseView  = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_departmentView.frame)+10 , KMainScreenWidth,819)];
    _ZXcaseView.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_ZXcaseView];
    
    UIImageView *caseimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 113)];
    caseimgView.image =[UIImage imageNamed:@"newcase"];
    caseimgView.userInteractionEnabled=YES;
    [_ZXcaseView addSubview:caseimgView];
    
    //  创建一个手势按钮点击事件
    UITapGestureRecognizer *caseimgdGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(caseimgGesclick)];
    [caseimgView addGestureRecognizer:caseimgdGes];
    
    UILabel * caseall = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth-100, 0, 90, 30)];
    caseall.textAlignment =NSTextAlignmentRight;
    caseall.text = @"更多";
    caseall.textColor =[UIColor whiteColor];
    caseall.font = [UIFont systemFontOfSize:14.0f];
    [caseimgView addSubview:caseall];
    
    UILabel * caseNewlab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(caseimgView.frame), KMainScreenWidth, 30)];
    caseNewlab.text = @"- 恭 喜 合 作 -";
    caseNewlab.font =[UIFont systemFontOfSize:15];
    
    caseNewlab.textColor = [UIColor blackColor];
    caseNewlab.textAlignment  = NSTextAlignmentCenter;
//    caseNewlab.backgroundColor =[UIColor purpleColor];
    [_ZXcaseView addSubview:caseNewlab];
    
    //    横线1
    UIImageView *lineimg =[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(caseNewlab.frame), KMainScreenWidth, 1)];
    lineimg.backgroundColor = kTCColor(228, 228, 228);
    [_ZXcaseView addSubview:lineimg];
    
    UIView *Newcellview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineimg.frame)+5,KMainScreenWidth , 670)];
    [_ZXcaseView addSubview:Newcellview];
    
    //    加入collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    caseallcollecview   = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,Newcellview.frame.size.width , Newcellview.frame.size.height) collectionViewLayout:layout];
    [Newcellview addSubview:caseallcollecview];
    caseallcollecview.backgroundColor = kTCColor(228, 228, 228);
    
    // 隐藏垂直滚动条
    caseallcollecview.showsVerticalScrollIndicator = NO;

    // 注册XIB
    [caseallcollecview registerNib:[UINib nibWithNibName:@"CasecollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CaseCell"];
    caseallcollecview.delegate    = self;
    caseallcollecview.dataSource  = self;
 
    self.casebtnButtom = [[ShoppingBtn alloc]initWithFrame:CGRectMake(0, 0, 200, 30) buttonStyle:UIButtonStyleButtom spaceing:0 imagesize:0];
    self.casebtnButtom.center = caseallcollecview.center;
    [self.casebtnButtom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.casebtnButtom.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.casebtnButtom addTarget:self action:@selector(loadcaseData) forControlEvents:UIControlEventTouchUpInside];
    self.casebtnButtom.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.casebtnButtom.hidden = NO;
    [self.casebtnButtom setTitle:@"加载数据失败" forState:UIControlStateNormal];
    [Newcellview addSubview:self.casebtnButtom];
}

#pragma  -mark-最新案例全部信息
-(void)caseimgGesclick{
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            AnliallController *ctl =[[AnliallController alloc]init];
            ctl.cityid = self.maincityID;
            ctl.cityname = self.maincityName;
            [self.navigationController pushViewController:ctl animated:YES];
            self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
        });
    });
}

#pragma  -mark *************************************刷新数据 方法汇总
-(void)loadallData{
    
//     [[RecommendData sharerecommendData]deletedrecreationData   ];
//     [[FirstcaseData sharecaseData]deletedcaseData              ];
//     [[RecommendData sharerecommendData]deletedlifeData         ];
//     [[RecommendData sharerecommendData]deleteddepartmentData   ];
//     [[RecommendData sharerecommendData]deletedrecreationData   ];
    
    [self LoadCitymenu      ];  //      城市区域 名称+id
    [self loadbigData       ];  //      大数据
    [self loadcaseData      ];  //      案例
    [self loadlifeData      ];  //      生活类
    [self loaddepartmentData];  //      百货类
    [self loadrecreationData];  //      娱乐类
   
}

#pragma  - mark ************************************获取大数据显示的数据
-(void)loadbigData{
    
    AFHTTPSessionManager *manager;//网络管理者
    manager = [AFHTTPSessionManager manager];
    NSString  * NewUrlstr = [NSString stringWithFormat:@"%@",Biglshoppath];
    NSLog(@"大数据 找店 请求入境：%@",NewUrlstr);
    
    [manager GET:Biglshoppath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        _Newlab.text = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"大数据未知");
    }];

    AFHTTPSessionManager *Agomanager;//网络管理者
    Agomanager = [AFHTTPSessionManager manager];
    
    NSString  *AgoUrlstr = [NSString stringWithFormat:@"%@",Bigkshoppath];
    NSLog(@"大数据 转店 请求入境：%@",AgoUrlstr);

    [Agomanager GET:Bigkshoppath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        _Settlelab.text = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
        _Agolab.text    = [NSString stringWithFormat: @"%ld",[responseObject[@"data"] integerValue]/3*2];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"大数据转店未知错误");
        
    }];
}

#pragma  -mark 获取案例数据
-(void)loadcaseData{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Gifcanshow"]){
        NSLog(@"Gif不能show");
    }else{
        
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    }
    [_PHArr_case removeAllObjects];
    
    NSString  * URL = [NSString stringWithFormat:@"%@?cid=%@",Newcasepath,_maincityID];
    https://ph.chinapuhuang.com/API.php/zxcase?cid=291 入境
    NSLog(@"案例类刷新请求入境：%@",URL);
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
     ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){

        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            
            for (NSDictionary *dic in responseObject[@"data"]){
                
                casecellmodel *model = [[casecellmodel alloc]init];
                model.caseimageview    = dic[@"imagers"];      //店铺图片
                model.casetitle        = dic[@"title"];        //店铺名称
                model.casedistrict     = dic[@"districter"];   //区域
                model.casetime         = dic[@"time"];         //店铺发布时间
                model.casetag          = dic[@"type"];         //店铺类型
                model.casesubid        = dic[@"subid"];        //店铺id
                model.caseprice        = dic[@"money"];         //店铺价钱
                [model setValuesForKeysWithDictionary:dic];
//                [[FirstcaseData sharecaseData]addcaseData:model];
                [_PHArr_case addObject:model];
            }
            NSLog(@"案例 现在总请求到数据有%ld个",_PHArr_case.count);
           
            self.casebtnButtom.hidden = YES;
        }
        else{//code 305
            NSLog(@"案例 不可以拿到数据的");
            [self.casebtnButtom setTitle:@"加载数据失败，刷新看看" forState:UIControlStateNormal];
             self.casebtnButtom.hidden=NO;
        }
        [YJLHUD dismiss];
        [caseallcollecview reloadData];
    }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
         //       网络失败
         NSLog(@"案例error=====%@",error);
       [YJLHUD dismiss];
        [self.casebtnButtom setTitle:@"网络错误,加载失败 " forState:UIControlStateNormal];
        self.casebtnButtom.hidden = NO;
     }];
}


#pragma  -mark 获取推荐店铺 百货类数据
-(void)loaddepartmentData{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Gifcanshow"]){
        NSLog(@"Gif不能show");
    }else{
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    }
    [_PHArr_department removeAllObjects];
    [[RecommendData sharerecommendData]deleteddepartmentData];
    
    NSString  * URL = [NSString stringWithFormat:@"%@?cid=%@",Departmentpath,_maincityID];
    NSLog(@"百货类 刷新请求入境：%@",URL);
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
     ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
//        NSLog(@"数据:%@",     responseObject[@"data"]);
//        NSLog(@"数据状态:%@", responseObject[@"code"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            
            NSLog(@"百货 可以拿到数据的");
            for (NSDictionary *dic in responseObject[@"data"]){
                
                recomendcellmodel *model = [[recomendcellmodel alloc]init];
                model.reommendImgview    = dic[@"images"];   //店铺图片
                model.recomendTitle      = dic[@"title"];        //店铺名称
                model.recomendPrice      = dic[@"money"];       //价格
                model.recomendTime       = dic[@"time"];         //时间
                model.recomendTag        = dic[@"type"];         //类型
                model.recomendSubid      = dic[@"subid"];        //店铺id
                [model setValuesForKeysWithDictionary:dic];
//                [[RecommendData sharerecommendData]adddepartmentData:model];
                [_PHArr_department addObject:model];
            }
            
            [YJLHUD dismiss];
            self.bhuobtnButtom.hidden=YES;
            NSLog(@"百货 总请求到数据有%ld个",_PHArr_department.count);
        }
        else{
             [YJLHUD dismiss];
            //code 305
            NSLog(@"百货 不可以拿到数据的");
            [self.bhuobtnButtom setTitle:@"加载数据失败，刷新看看" forState:UIControlStateNormal];
            self.bhuobtnButtom.hidden=NO;
           
        }
        //        刷新列表数据
        [departmentcollecview reloadData];
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         //                网络失败
         NSLog(@"百货 error=====%@",error);
         
        [YJLHUD dismiss];
         [self.bhuobtnButtom setTitle:@"网络错误,加载失败 " forState:UIControlStateNormal];
         self.bhuobtnButtom.hidden   =NO;
     }];
}

#pragma  -mark 获取推荐店铺 生活类数据
-(void)loadlifeData{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Gifcanshow"]){
        NSLog(@"Gif不能show");
    }else{
        
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    }
    [_PHArr_life removeAllObjects];
    [[RecommendData sharerecommendData]deletedlifeData];
    NSString  * URL = [NSString stringWithFormat:@"%@?cid=%@",Lifepath,_maincityID];
    https://ph.chinapuhuang.com/API.php/shrecreation?cid=291 入境
    NSLog(@"生活类 刷新请求入境：%@",URL);
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
     ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
//        NSLog(@"数据:%@",     responseObject[@"data"]);
//        NSLog(@"数据状态:%@",  responseObject[@"code"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"生活 可以拿到数据的");
            for (NSDictionary *dic in responseObject[@"data"]){
                
                recomendcellmodel *model = [[recomendcellmodel alloc]init];
                model.reommendImgview    = dic[@"images"];   //店铺图片
                model.recomendTitle      = dic[@"title" ];        //店铺名称
                model.recomendPrice      = dic[@"money" ];       //价格
                model.recomendTime       = dic[@"time"  ];         //时间
                model.recomendTag        = dic[@"type"  ];         //类型
                model.recomendSubid      = dic[@"subid" ];        //店铺id
                [model setValuesForKeysWithDictionary:dic];

//                 [[RecommendData sharerecommendData]addlifeData:model];
                 [_PHArr_life addObject:model];
            }
            NSLog(@"生活 总请求到数据有%ld个",_PHArr_life.count);
            [YJLHUD dismiss];
            self.shuobtnButtom.hidden=YES;
           
        }
        else{
            
            //code 305
            NSLog(@"生活 不可以拿到数据的");
            [YJLHUD dismiss];
            [self.shuobtnButtom setTitle:@"加载数据失败，刷新看看"  forState:UIControlStateNormal];
            self.shuobtnButtom.hidden=NO;
        }
        //        刷新列表数据
        [lifecollecview reloadData];
    }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            
         //                网络失败
         NSLog(@"生活 error=====%@",error);
        [YJLHUD dismiss];
         [self.shuobtnButtom setTitle:@"网络错误,加载失败 "  forState:UIControlStateNormal];
         self.shuobtnButtom.hidden=NO;
        
     }];
}

#pragma  -mark 获取推荐店铺 娱乐类数据
-(void)loadrecreationData{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Gifcanshow"]){
        NSLog(@"Gif不能show");
    }else{
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    }
    
    [_PHArr_recreation removeAllObjects];
    [[RecommendData sharerecommendData]deletedrecreationData];
    NSString  * URL = [NSString stringWithFormat:@"%@?cid=%@",Ainmentpath,_maincityID];
        NSLog(@"娱乐类 刷新请求入境：%@",URL);
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
   ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
    
//        NSLog(@"娱乐类数据:%@",     responseObject[@"data"]);
//        NSLog(@"娱乐类数据状态:%@", responseObject[@"code"]);

        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                     
                     NSLog(@"娱乐可以拿到数据的");
                     for (NSDictionary *dic in responseObject[@"data"]){
                         
                         recomendcellmodel *model = [[recomendcellmodel alloc]init];
                         model.reommendImgview    = dic[@"images"];       //店铺图片
                         model.recomendTitle      = dic[@"title"];        //店铺名称
                         model.recomendPrice      = dic[@"money"];        //价格
                         model.recomendTime       = dic[@"time"];         //时间
                         model.recomendTag        = dic[@"type"];         //类型
                         model.recomendSubid      = dic[@"subid"];        //店铺id
                         [model setValuesForKeysWithDictionary:dic];
                         
//                        [[RecommendData sharerecommendData]addrecreationData:model];
                         [_PHArr_recreation addObject:model];
                     }
        
                     NSLog(@"娱乐 总请求到数据有%ld个",_PHArr_recreation.count);
                     [YJLHUD dismiss];
                     self.yulebtnButtom.hidden   =YES;
                 }
                 else{
                     
                     //code 500
                     NSLog(@"娱乐 不可以拿到数据的");
                     [self.yulebtnButtom setTitle:@"加载数据失败，刷新看看" forState:UIControlStateNormal];
                     self.yulebtnButtom.hidden=NO;
                     [YJLHUD dismiss];
                 }
//        刷新列表数据
        [recreationcollecview reloadData];
        
         }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                //                网络失败
//                NSLog(@"error=====%@",error);
                [self.yulebtnButtom setTitle:@"网络错误,加载失败 " forState:UIControlStateNormal];
                self.yulebtnButtom.hidden=NO;
                [YJLHUD dismiss];
            
            }];
}

#pragma - mark -推荐视频视图
-(void)creatvideo{
    
    _VideoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_ZXcaseView.frame)+10, KMainScreenWidth, 379)];
    _VideoView.backgroundColor = [UIColor whiteColor];
    [self.HeaderView addSubview:_VideoView];
    
    UIImageView *voideimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 113)];
    voideimgView.image =[UIImage imageNamed:@"video_img"];
    voideimgView.userInteractionEnabled=YES;
    [_VideoView addSubview:voideimgView];
    
    //  创建一个手势按钮点击事件
    UITapGestureRecognizer *caseimgdGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoimgGesclick)];
    [voideimgView addGestureRecognizer:caseimgdGes];
    
    UILabel * voideall = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth-100, 0, 90, 30)];
    voideall.textAlignment =NSTextAlignmentRight;
    voideall.text = @"更多";
    voideall.textColor =[UIColor whiteColor];
    voideall.font = [UIFont systemFontOfSize:14.0f];
    [voideimgView addSubview:voideall];
    
    UILabel * voideNewlab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(voideimgView.frame)+5, KMainScreenWidth, 30)];
    voideNewlab.text = @"- 客 户 视 频 集 -";
    voideNewlab.textColor = [UIColor blackColor];
    voideNewlab.font = [UIFont systemFontOfSize:15];
    voideNewlab.textAlignment  = NSTextAlignmentCenter;
    [_VideoView addSubview:voideNewlab];
    
    //    横线1
    UIImageView *lineimg =[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(voideNewlab.frame)+5, KMainScreenWidth, 1)];
    lineimg.backgroundColor = kTCColor(228, 228, 228);
    [_VideoView addSubview:lineimg];

    UIView * Voideview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineimg.frame)+5,KMainScreenWidth , 220)];
    [_VideoView addSubview:Voideview];
    
//    加入collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    Voidecollecview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,Voideview.frame.size.width , Voideview.frame.size.height) collectionViewLayout:layout];
    [Voideview addSubview:Voidecollecview];
    Voidecollecview.backgroundColor = kTCColor(228, 228, 228);

// 注册XIB
    [Voidecollecview registerNib:[UINib nibWithNibName:@"VoideCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"voidCell"];
    Voidecollecview.delegate    = self;
    Voidecollecview.dataSource  = self;
}

#pragma -mark UIcollectionView代理方法   开始
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

        return 1;
}

//根据cell不同返回个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if      (collectionView == caseallcollecview) {//案例
//        NSLog(@"%ld", _PHArr_case.count);
            return _PHArr_case.count;
    }
    else if (collectionView == departmentcollecview){//百货
//        NSLog(@"%ld", _PHArr_department.count);
            return _PHArr_department.count;
    }
    else if (collectionView == lifecollecview){//生活
//        NSLog(@"%ld", _PHArr_life.count);
            return _PHArr_life.count;
    }
    else if (collectionView == recreationcollecview){//娱乐

//        NSLog(@"%ld", _PHArr_recreation.count);
            return _PHArr_recreation.count;
    }
    
    else{//视频
        
        return 2;
    }
}

//根据cell不同进行初始化+赋值
- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView
                  cellForItemAtIndexPath: (NSIndexPath *)indexPath {
    
    if (collectionView == Voidecollecview) {
        VoideCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"voidCell" forIndexPath:indexPath];
        NSArray *titles = self.Videodatatitles[indexPath.section];
        NSArray *times  = self.Videodatatimes [indexPath.section];
        NSArray *images = self.Videodataimages[indexPath.section];
        NSString *image = images[indexPath.row];
        
        cell.Voideimage.image   = [UIImage imageNamed:[NSString stringWithFormat:@"%@",image]];
        cell.Voidetitle.text    = titles[indexPath.row];
        cell.Voidetimes.text    = times[indexPath.row];
        cell.backgroundColor    = [UIColor whiteColor];
        return cell;
    }
    
    
    else if (collectionView ==lifecollecview)                       //生活
    {
        RecommendCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lifeCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        recomendcellmodel *model = [_PHArr_life objectAtIndex:indexPath.item];
        
        [cell.reommendImgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.reommendImgview]] placeholderImage:[UIImage imageNamed:@"recommend_picture"]];                     //店铺图片
        cell.recomendTitle.text = model.recomendTitle;
        cell.recomendTime.text  = model.recomendTime;
        cell.recomendTag.text   = model.recomendTag;
        cell.recomendPrice.text = [NSString stringWithFormat:@"%@万",model.recomendPrice];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    else if (collectionView ==departmentcollecview)                //百货
    {
        
        RecommendCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"departmentCell" forIndexPath:indexPath];
        recomendcellmodel *model = [_PHArr_department objectAtIndex:indexPath.item];
        
        [cell.reommendImgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.reommendImgview]] placeholderImage:[UIImage imageNamed:@"recommend_picture"]];//店铺图片
        cell.recomendTitle.text = model.recomendTitle;
        cell.recomendTime.text  = model.recomendTime ;
        cell.recomendTag.text   = model.recomendTag  ;
        cell.recomendPrice.text = [NSString stringWithFormat:@"%@万",model.recomendPrice];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    else if (collectionView ==recreationcollecview)//娱乐
    {
        RecommendCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recreationCell" forIndexPath:indexPath];
        recomendcellmodel *model = [_PHArr_recreation objectAtIndex:indexPath.item];
        [cell.reommendImgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.reommendImgview]] placeholderImage:[UIImage imageNamed:@"recommend_picture"]];//店铺图片
        cell.recomendTitle.text = model.recomendTitle;
        cell.recomendTime.text  = model.recomendTime;
        cell.recomendTag.text   = model.recomendTag;
        cell.recomendPrice.text = [NSString stringWithFormat:@"%@万",model.recomendPrice];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    else {
        
        //案例
        CasecollectionViewCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CaseCell" forIndexPath:indexPath];
        casecellmodel *model = [_PHArr_case objectAtIndex:indexPath.item];
//        NSLog(@"案例图片id=%@",model.caseimageview);
         [cell.caseimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.caseimageview]] placeholderImage:[UIImage imageNamed:@"case_picture"]];//店铺图片
        cell.casetitle.text     = model.casetitle;
        cell.casetime.text      = model.casetime;
        cell.casearea.text      = model.casedistrict;
        cell.casetag.text       = model.casetag;
        cell.caseprice.text     = [NSString stringWithFormat:@"%@万",model.caseprice];
        cell.backgroundColor    = [UIColor whiteColor];
        return cell;
    }
}

//根据cell不同 适配
- (CGSize)collectionView: (UICollectionView *)collectionView
                  layout: (UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath: (NSIndexPath *)indexPath{
    
    if (collectionView == Voidecollecview) {
         return CGSizeMake((KMainScreenWidth-30) /2, 200);
    }
    
    else if (collectionView == caseallcollecview){
        
         return CGSizeMake((KMainScreenWidth-20) /2, 210);
    }
    
    else{
//        三类推荐
         return CGSizeMake((KMainScreenWidth-50) /3, 140);
    }
}

//根据cell不同 cell宽边
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    if (collectionView == recreationcollecview ||collectionView == lifecollecview ||collectionView == departmentcollecview) {
        
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    else if (collectionView == caseallcollecview)
        {
            return UIEdgeInsetsMake(10, 5, 10, 5);
    }
    else{
        
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KMainScreenWidth, 0);
}

//根据cell不同 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"第%ld段------第%ld个",indexPath.section,indexPath.row+1);    
    if (collectionView == Voidecollecview) {
        
        NSArray *Url = self.Videodatawebs[indexPath.section];
        //直接创建AVPlayer，它内部也是先创建AVPlayerItem，这个只是快捷方法
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:Url[indexPath.row]]];
        //创建AVPlayerViewController控制器
        YJLPlayer = [[AVPlayerViewController alloc] init];
        YJLPlayer.player    = player;
        YJLPlayer.view.frame = self.view.frame;
        //调用控制器的属性player的开始播放方法
        [self presentViewController:YJLPlayer animated:YES completion:nil];
        [YJLPlayer.player play];
    }
    
    else  if (collectionView == recreationcollecview){
//        NSLog(@"娱乐=%ld",indexPath.row);
         self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        recomendcellmodel * model =[_PHArr_recreation objectAtIndex:indexPath.item];
        DetailedController *Ctl  = [[DetailedController alloc] init];
        Ctl.shopsubid            = model.recomendSubid;
        [self.navigationController pushViewController:Ctl animated:YES];
         self.hidesBottomBarWhenPushed = NO;//如果在push跳转时需要隐藏tabBar
    }

    else  if (collectionView == lifecollecview){
//         NSLog(@"生活=%ld",indexPath.row);
         self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        recomendcellmodel * model =[_PHArr_life objectAtIndex:indexPath.item];
        DetailedController *Ctl  = [[DetailedController alloc] init];
        Ctl.shopsubid            = model.recomendSubid;
        [self.navigationController pushViewController:Ctl animated:YES];
         self.hidesBottomBarWhenPushed = NO;//如果在push跳转时需要隐藏tabBar
    }

    else  if (collectionView == departmentcollecview){

         self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
//         NSLog(@"百货=%ld",indexPath.row);
        recomendcellmodel * model =[_PHArr_department objectAtIndex:indexPath.item];
        DetailedController *Ctl  = [[DetailedController alloc] init];
        Ctl.shopsubid            = model.recomendSubid;
        [self.navigationController pushViewController:Ctl animated:YES];
         self.hidesBottomBarWhenPushed = NO;//如果在push跳转时需要隐藏tabBar
    }
    
   else if (collectionView == caseallcollecview){
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
//       NSLog(@"案例case=%ld",indexPath.row);
       casecellmodel * model     = [_PHArr_case objectAtIndex:indexPath.item];
       DetailedController *Ctl  = [[DetailedController alloc] init];
       Ctl.shopsubid            = model.casesubid;
       [self.navigationController pushViewController:Ctl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//如果在push跳转时需要隐藏tabBar
   }
}

#pragma -mark UIcollectionView代理方法   结束

#pragma -mark - 查看视频视图全部
-(void)videoimgGesclick{
    
//    NSLog(@"视频的全部信息");
     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    VideoXQViewController *ctl  =[[VideoXQViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
     self.hidesBottomBarWhenPushed = NO;//如果在push跳转时需要隐藏tabBar
}

#pragma  -mark 最底部的提示框
-(void)creatbottom{
    
    _BottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_VideoView.frame)+10, KMainScreenWidth, 30)];
    [self.HeaderView addSubview:_BottomView];
    
    UILabel *bottomlab =[[UILabel alloc]initWithFrame:CGRectMake(10, 5,KMainScreenWidth-20 , 20)];
    bottomlab.textColor = kTCColor(161, 161, 161);
    bottomlab.textAlignment = NSTextAlignmentCenter;
    bottomlab.text = @"已经扯到底了，客官请手下留情";
    bottomlab.font = [UIFont systemFontOfSize:10.0f];
    [_BottomView addSubview:bottomlab];
    
}

#pragma  mark 其它技术支持
// 是否支持滑动至顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    
    return YES;
}

#pragma -mark 导航栏透明度变化
// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    判断滑动到是Mainscrollow
    if (scrollView == Mainscrollow){
        
        CGFloat offset = scrollView.contentOffset.y;
//            NSLog(@"已经滑动====%f",offset);
        if (offset  >  44 ){
        //    根据滑动的距离增加透明度
            CGFloat alpha = MIN(1, offset / 88);
            _NavView.backgroundColor = BXAlphaColor(77, 166, 214, alpha);
        }else{
            _NavView.backgroundColor = BXAlphaColor(77, 166, 214, 0);
        }

        //    设置下拉的时候能够隐藏掉搜索框
        if (offset < - 64) {
            _NavView.hidden = YES;
        }else{
            _NavView.hidden = NO;
        }
    }
}

#pragma -mark 指导页推出
- (void)sureTapClick:(id)sender{
    
    NSLog(@"指导页推出去了");
    [UIView animateWithDuration:0.1 animations:^{
        
        GUIDbackview.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished) {
        
        [GUIDbackview removeFromSuperview];
    }];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstCouponBoard_iPhone1"];
}

#pragma -mark 加载各个城市的区域
-(void)LoadCitymenu{
    

    NSString  * Urlstr = [NSString stringWithFormat:@"%@?city=%@",Mycitypath,self.maincityID];
    NSLog(@"获取城市区域的入境:%@",Urlstr);

    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager GET:Urlstr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSLog(@"每个城市的区域：%@",responseObject);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            for (NSDictionary *redic in responseObject[@"data"]){
                
                Cityareamodel *model = [[Cityareamodel alloc]init];
                model.Cityareaname = redic[@"name"];
                model.Cityareaid   = redic[@"id"];
                [model setValuesForKeysWithDictionary:redic];
                
                //  得到的menu数据加入数据库
                [[Cityarea shareCityData]addCityarea:model];
                
               
        }
            NSLog(@"区域:%ld个", [[Cityarea shareCityData]getAllCityarea].count);
    }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"城市区域获取失败了");
        
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Joinapp" object:nil];

}

@end
