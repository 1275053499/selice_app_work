//
//  AnliallController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "AnliallController.h"
#define CaseAllpath  @"&upid=00000&rent=00000&leixing=00000&area=00000" //案例入境街区
@interface AnliallController ()<UITableViewDelegate, UITableViewDataSource>{
    int PHpage;
}
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@property   (strong, nonatomic) UITableView     *   CasetableView;
@property   (strong, nonatomic) UIView          *   HeadView;
@property (nonatomic , strong) UILabel        * BGlab;               //无网络提示语
@property   (nonatomic, strong) NSMutableArray  *   PHArr_caseAll; //存储数据
@property   (nonatomic, strong) UIImageView     *   interimg;

@property(nonatomic,strong)NSURLSessionDataTask*task;
@end

@implementation AnliallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatbase];
    [self creatHead];
    
    [self creattableview];
    [self refresh];
    //   接收首页的城市切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changevalue) name:@"ChangeCity" object:nil];
    
    // 是否是第一次进入该处
    [self isFirstCome];
}

#pragma  -mark 切换城市进行判断并删除上一个城市数据
-(void)changevalue{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"iscaseFirstCome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[FirstcaseData sharecaseData]deletedallcaseData];
}

-(void)isFirstCome{

    NSString       * isFirstCome       = [[NSUserDefaults standardUserDefaults] objectForKey:@"iscaseFirstCome"];
    NSLog(@"YES OR NO                                                  ===%@",isFirstCome);
    if (![isFirstCome isEqualToString:@"YES"]){   //NO
        
        NSLog(@"是第一次请求");
#pragma -mark 网络检测
        [self reachability];
    }
    else{ //YES
        NSLog(@"不是第一次进来了");
        _PHArr_caseAll = [[FirstcaseData sharecaseData] getcaseallAllDatas];
        if (_PHArr_caseAll.count <1) {
             [self reachability];
        }else{
        
            [self.CasetableView reloadData];
            if (_PHArr_caseAll.count%10>0) {
                
                PHpage = (int)_PHArr_caseAll.count/10;
            }else{
                PHpage = (int)_PHArr_caseAll.count/10-1;
            }
        }
    }
}

#pragma mark 网络检测
-(void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusReachableViaWiFi||status==AFNetworkReachabilityStatusReachableViaWWAN) {
            // 加载数据
            [self loaddataUPtodown         ];
            #pragma -mark Wi-Fi或者3G网络做事情
        }else{
            NSLog(@"无连接网络");
            #pragma -mark 未知网络或者无网络连接做事情
        }
    }];
 }
#pragma  -mark 添加刷新空间
-(void)refresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddataUPtodown)];
    
    // Set title
    [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
    [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
    [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // Set textColor
    header.stateLabel.textColor = kTCColor(161, 161, 161);
    header.lastUpdatedTimeLabel.textColor = kTCColor(161, 161, 161);
    self.CasetableView.mj_header = header;
    
#pragma  -mark上拉加载获取网络数据
    self.CasetableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉刷新一下试试");
         NSLog(@"上一个第%d页",PHpage       );
         PHpage++;
        [self loaddataDowntoup];
    }];
}

#pragma  -mark下拉刷新
-(void)loaddataUPtodown{
//    下拉刷新需要先删除数据库
    
    [self.BGlab setHidden:YES];
    [self.CasetableView.mj_footer resetNoMoreData];
    PHpage = 0;
     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    NSLog(@"即将下拉刷新之前数组有%ld个数据",_PHArr_caseAll.count);
    NSString *str = [NSString stringWithFormat:@"%@?id=%@&page=%d%@",HostTareapath,_cityid,PHpage,CaseAllpath];
     NSLog(@"最新合作刷新请求入境：%@",str);
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
  
   self.task = [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_PHArr_caseAll removeAllObjects];
       [YJLHUD showSuccessWithmessage:@"加载成功"];
       [YJLHUD dismissWithDelay:1];
       [[FirstcaseData sharecaseData]deletedallcaseData];
        
        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"可以拿到数据的");
            for (NSDictionary *dic in responseObject[@"values"]){
                 Anlimodel *model = [[Anlimodel alloc]init];
                 model.Anli_picture    = dic[@"img"];
                 model.Anli_title      = dic[@"title"];
                 model.Anli_quyu       = dic[@"districter"];
                 model.Anli_time       = dic[@"time"];
                 model.Anli_tag        = dic[@"type"];
                 model.Anli_area       = dic[@"area"];
                 model.Anli_price      = dic[@"rent"];
                 model.Anli_subid      = dic[@"subid"];
                 [model setValuesForKeysWithDictionary:dic];
                 
                 [[FirstcaseData sharecaseData]addallcaseData:model];
                 [_PHArr_caseAll addObject:model];
             }
             NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr_caseAll.count);
            //  后台执行：
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"iscaseFirstCome"];//设置下一次不走这里了
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
             self.CasetableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
             [self.BGlab setHidden:YES];
         }
         else{
             
             [self.BGlab setHidden:NO];
             self.BGlab.text             = @"没有更多数据";
             self.CasetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
           
             [YJLHUD showErrorWithmessage:@"没有更多数据"];
             [YJLHUD dismissWithDelay:1];

         }
       
              [self.CasetableView .mj_header endRefreshing];
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
              [_CasetableView reloadData];
            
        });
        
        
     }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"请求数据失败----%@",error);
          if (error.code == -999) {
              NSLog(@"网络数据连接取消");
          }else{
              
              [self.BGlab setHidden:YES];
              [self.CasetableView reloadData];
              [self.CasetableView .mj_footer endRefreshing];
           
              [YJLHUD showErrorWithmessage:@"网络数据连接超时了，稍等~~"];
              [YJLHUD dismissWithDelay:1];
          }
             }];
}

#pragma  -mark 上拉加载
-(void)loaddataDowntoup{
    
    NSLog(@"上拉加载数组里面的数剧有%ld个",_PHArr_caseAll.count);
    NSLog(@"马上加载第%d页",PHpage);
   [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    NSString  * URL = [NSString stringWithFormat:@"%@?id=%@&page=%d%@",HostTareapath,_cityid,PHpage,CaseAllpath];
    NSLog(@"上拉加载请求入境：%@",URL);
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
   
   self.task = [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"可以拿到数据的");
            
            [YJLHUD dismissWithDelay:1];
            for (NSDictionary *dic in responseObject[@"values"]){

                Anlimodel *model = [[Anlimodel alloc]init];
                model.Anli_picture    = dic[@"img"];
                model.Anli_title      = dic[@"title"];
                model.Anli_quyu       = dic[@"districter"];
                model.Anli_time       = dic[@"time"];
                model.Anli_tag        = dic[@"type"];
                model.Anli_area       = dic[@"area"];
                model.Anli_price      = dic[@"rent"];
                model.Anli_subid      = dic[@"subid"];
                [model setValuesForKeysWithDictionary:dic];
                [[FirstcaseData sharecaseData]addallcaseData:model];
                [_PHArr_caseAll addObject:model];
            }
            
            NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr_caseAll.count);
        }
        
        else{
            
            NSLog(@"300--拿不到数据啊");
            PHpage--;
          
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
        }
       
        [self.BGlab setHidden:YES];
        [self.CasetableView .mj_footer endRefreshing];
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.CasetableView reloadData];
        });
       
        if (PHpage == 9) {
            
             [self.CasetableView.mj_footer endRefreshingWithNoMoreData];
        }
        
       
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if (error.code == -999) {
            NSLog(@"网络数据连接取消");
        }else{
            
            [self.BGlab setHidden:YES];
            [self.CasetableView reloadData];
            [self.CasetableView .mj_footer endRefreshing];
          
            [YJLHUD showErrorWithmessage:@"网络数据连接超时了，稍等~~"];
            [YJLHUD dismissWithDelay:1];
        }
        
    }];
}


#pragma  -mark 基本属性
-(void)creatbase{
    
   
    self.view.backgroundColor = kTCColor(255, 255, 255);
    
    _PHArr_caseAll = [[NSMutableArray alloc]init];

    NSLog(@"获取城市ID：%@ - 城市名称：%@",self.cityid,self.cityname);
    NSLog(@"X比例=%f,Y比例=%f",_autoSizeScaleX,_autoSizeScaleY);
    self.title = @"最新合作案例";
}

#pragma -mark 创建头部视图
-(void)creatHead{
    
    _HeadView = [[UIView alloc]init];
    _HeadView.frame = CGRectMake(0, 64, KMainScreenWidth, 44);

    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake( 10, 12, 20, 20)];
    imgview.image = [UIImage imageNamed:@"ZXAL_tubiao"];
    [_HeadView addSubview:imgview];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, KMainScreenWidth - 50, 20)];
    lab.text = @"【官方案例】最新合作店铺尽收眼底!";
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:14.0];
    [_HeadView addSubview:lab];
    [self.view addSubview:_HeadView];
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma  -mark 创建tableview
-(void)creattableview{
   
    self.CasetableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+64, KMainScreenWidth, KMainScreenHeight-108)style:UITableViewStylePlain] ;
    self.CasetableView.dataSource = self;
    self.CasetableView.delegate     = self;
    [self.view addSubview:self.CasetableView];
    self.CasetableView.backgroundColor = [UIColor whiteColor];
    self.CasetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.CasetableView addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.CasetableView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}



#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}
#pragma  -mark - 返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tableviewsource代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return _PHArr_caseAll.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_PHArr_caseAll.count == 0){
        static NSString *cellID = @"cellname";
        AnliallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AnliallViewCell" owner:self options:nil]lastObject];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else{
        static NSString *cellID = @"cellname";
        AnliallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AnliallViewCell" owner:self options:nil]lastObject];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        }
    
        Anlimodel *model             = [_PHArr_caseAll objectAtIndex:indexPath.row];
        cell.Anlititle.text          = model.Anli_title;//标题
        cell.Anliregin.text          = model.Anli_quyu;//区域所在
        cell.Anlitime.text           = model.Anli_time;//更新时间
        cell.Anlitage.text           = model.Anli_tag;//餐饮美食
        cell.Anliarea.text           = [NSString stringWithFormat:@"%@m²",model.Anli_area];//店铺面积
        cell.Anliprice.text          = [NSString stringWithFormat:@"%@元/月",model.Anli_price];//店铺租金
        [cell.Anliimgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.Anli_picture]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
        return cell;
    }
}

#pragma mark点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"乱点击什么啊======");
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    //    获取店铺唯一id
    Anlimodel *model = [_PHArr_caseAll objectAtIndex:indexPath.row];
    DetailedController *ctl =[[DetailedController alloc]init];
    ctl.shopsubid = model.Anli_subid;
    ctl.shopcode  = @"transfer";
    NSLog(@"店铺🆔%@",ctl.shopsubid);
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 100;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 44.0f;
//}

#pragma  -mark 处理cell滑动事view的颜色变化
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
        CGFloat offset = scrollView.contentOffset.y;
//        NSLog(@"已经滑动====%f",offset);
        if (offset  >  0 ){
            //    根据滑动的距离增加透明度
            CGFloat alpha = MIN(1, offset / 88);
            _HeadView.backgroundColor = BXAlphaColor(77, 166, 214, alpha);
        }else{
            _HeadView.backgroundColor = BXAlphaColor(77, 166, 214, 0);
        }
}

#pragma mark 当前导航栏出现？不出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
  
    // 让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
