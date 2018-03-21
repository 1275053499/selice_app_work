//
//  ShopssiteViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopssiteViewController.h"
#import "YJLMenu.h"
#import "ShopsiteViewCell.h"
#import "Shopsitemodel.h"
#import "XZdataBase.h"
#import "ShopsiteXQController.h"
#import "Cityareamodel.h"//城市区域model
#import "Cityarea.h"//城市区域数据库
@interface ShopssiteViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,YJLMenuDelegate,YJLMenuDataSource>{
    int  PHpage;
    YJLMenu         *yjlmenu;
}

@property   (nonatomic, strong) UILabel          * BGlab;           //无网络提示语
@property (nonatomic , strong) UIImageView       * ImageView;       //头部图
@property (nonatomic , strong) UIButton          * BackBtn;         //返回按钮
@property (nonatomic , strong) UILabel           * titlelab;        //标题
@property (nonatomic , strong) UITableView       * Shopsitetableview;//列表
@property (nonatomic , strong) NSMutableArray    * Regionaname;  //区域名字
@property (nonatomic , strong) NSMutableArray    * Regionaid;    //区域id
@property (nonatomic , strong) NSArray           * Rent;         //租金选店
@property (nonatomic , strong) NSArray           * Type;         //类型选店
@property (nonatomic , strong) NSArray           * Area;         //面积选店
@property (nonatomic, strong) NSArray            * Rentid;      //租金id
@property (nonatomic, strong) NSArray            * Typeid;      //类型id
@property (nonatomic, strong) NSArray            * Areaid;      //面积id
@property (nonatomic, strong) NSString           * path;        //入境
@property (nonatomic , strong)NSMutableArray  * PHDataArr;  //存储数据

@property(nonatomic,strong)UIView             *HeaderView;  //滚动+菜单背景合一
@property(nonatomic,strong)UIButton           *Fold;        // 菜单返回

@property(nonatomic,strong)NSURLSessionDataTask*task;

@end

@implementation ShopssiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTCColor(255, 255, 255);
    NSLog(@"请求的城市 hostcityid===%@",self.hostcityid);
    
    self.PHDataArr      = [[NSMutableArray alloc]init];
    self.Regionaname    = [[NSMutableArray alloc]init];
    self.Regionaid      = [[NSMutableArray alloc]init];
    self.path           = [[NSString alloc]initWithFormat:@"&upid=00000&rent=00000&leixing=00000&area=00000"];

    //    创建头部banner
    [self creatTopview];
    //    创建列表table
    [self creattableview];
    //   加载数据控件
    [self refresh];

    //   接收首页的城市切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changevalue) name:@"ChangeCity" object:nil];
    // 是否是第一次进入该处
    [self isNewsFirstCome];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    //    menu发来的通知用来取消隐藏tab
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowNO) name:@"ShowNO" object:nil];
}

#pragma -mark menu发来的通知用来取消隐藏tab
-(void)ShowNO{
    
    [self.Shopsitetableview setHidden:NO];
}

#pragma  -mark 切换城市进行判断并删除上一个城市数据
-(void)changevalue{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"XZisFirstCome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[XZdataBase shareXZdataBase]deletedXZdata];
     NSLog(@"切换城市----选址缓存的数据清理");
}

#pragma -mark 是否是第一次进入该处
-(void)isNewsFirstCome{
    
    NSString       * isFirstCome       = [[NSUserDefaults standardUserDefaults] objectForKey:@"XZisFirstCome"];
    NSLog(@"YES OR NO                                                  ===%@",isFirstCome);
    if (![isFirstCome isEqualToString:@"YES"]){   //NO
        NSLog(@"是第一次请求");

        [self  reachabilitydata];
    }
    
    else{ //YES
        self.PHDataArr = [[XZdataBase shareXZdataBase] getAllDatas];
        if (self.PHDataArr.count>0) {
           [self.Shopsitetableview reloadData];
            if (self.PHDataArr.count%5>0) {
                
                PHpage = (int)self.PHDataArr.count/5;
            }else{
                PHpage = (int)self.PHDataArr.count/5-1;
            }
        }
        else{
            
            [self reachabilitydata];
        }
    }
}

#pragma mark 网络检测
-(void)reachabilitydata{
    
    [self loaddataUPtodown];
}
#pragma mark - 刷新数据
- (void)refresh{
    
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
    self.Shopsitetableview.mj_header = header;
    
#pragma  -mark上拉加载获取网络数据
    self.Shopsitetableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上一个第%d页",PHpage       );
        PHpage++;
        [self loaddataDowntoup];
    }];
}

#pragma -mark 初始下拉刷新
-(void)loaddataUPtodown{
    PHpage = 0;
    [self.BGlab setHidden:YES];
     [self.Shopsitetableview.mj_footer resetNoMoreData];
   
     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    NSLog(@"即将下拉刷新之前数组有%ld个数据",self.PHDataArr.count);
    NSString  * str = [NSString stringWithFormat:@"%@?id=%@&page=%d%@",Hostselectionpath,_hostcityid,PHpage,_path];
    NSLog(@"下拉刷新请求入境：%@",str);
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
   self.task = [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [[XZdataBase shareXZdataBase]deletedXZdata];
        [self.PHDataArr removeAllObjects];
        
//        NSLog(@"请求数据成功----%@",responseObject[@"data"][@"values"]);
//        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
//            NSLog(@"可以拿到数据的");
            [YJLHUD showSuccessWithmessage:@"加载成功"];
           [YJLHUD dismissWithDelay:0.2];
            for (NSDictionary *dic in responseObject[@"data"][@"values"]){
                Shopsitemodel *model = [[Shopsitemodel alloc]init];
                 model.Shopsitetitle      = dic[@"title"];
                 model.Shopsitedescribe   = dic[@"detail"];
                 model.Shopsitetype       = dic[@"type"];
                 model.Shopsitearea       = dic[@"areas"];
                 model.Shopsiterent       = dic[@"rent"];
                 model.Shopsitequyu       = dic[@"districter"];
                 model.Shopsitesubid      = dic[@"subid"];
                 [model setValuesForKeysWithDictionary:dic];
                //                 得到的数据加入数据库
                 [[XZdataBase shareXZdataBase]addshopXZ:model];
                 [self.PHDataArr addObject:model];
            }
             NSLog(@" 加载后现在总请求到数据有%ld个",self.PHDataArr.count);
            //  后台执行：
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"XZisFirstCome"];//设置下一次不走这里了
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
          
            [self.BGlab setHidden:YES];
            self.Shopsitetableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
        }else{
            
            [self.BGlab setHidden:NO];
             self.BGlab.text             = @"没有更多数据";
             self.Shopsitetableview.separatorStyle = UITableViewCellSeparatorStyleNone;
             [self.Shopsitetableview.mj_footer endRefreshingWithNoMoreData];
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
        }
        
       
         [self.Shopsitetableview .mj_header endRefreshing];
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.Shopsitetableview reloadData];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if (error.code == -999) {
            NSLog(@"网络数据连接取消");
        }else{
    
        [self.BGlab setHidden:NO];
         self.BGlab.text      = @"网络数据连接超时了,稍等~~";
        [self.Shopsitetableview .mj_header endRefreshing];
        [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~"];
        [YJLHUD dismissWithDelay:1];
            
        }
    }];
}

#pragma -mark 初始上拉加载
-(void)loaddataDowntoup{
    
//        NSLog(@"上拉加载数组里面的数剧有%ld个",self.PHDataArr.count);
//        NSLog(@"上一个第%d页",PHpage);

     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
        NSString  * str = [NSString stringWithFormat:@"%@?id=%@&page=%d%@",Hostselectionpath,_hostcityid,PHpage,_path];
        NSLog(@"上拉加载请求入境：%@",str);
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    
   self.task = [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
//        NSLog(@"请求数据成功----%@",responseObject);
//        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
//            NSLog(@"可以拿到数据的");
    
            [YJLHUD dismissWithDelay:0.2];
            for (NSDictionary *dic in responseObject[@"data"][@"values"]){
                Shopsitemodel *model     = [[Shopsitemodel alloc]init];
                model.Shopsitetitle      = dic[@"title"];
                model.Shopsitedescribe   = dic[@"detail"];
                model.Shopsitetype       = dic[@"type"];
                model.Shopsitearea       = dic[@"areas"];
                model.Shopsiterent       = dic[@"rent"];
                model.Shopsitequyu       = dic[@"districter"];
                model.Shopsitesubid      = dic[@"subid"];
                [model setValuesForKeysWithDictionary:dic];
                 [[XZdataBase shareXZdataBase]addshopXZ:model];
                [self.PHDataArr addObject:model];
            }
            NSLog(@" ZP加载后现在总请求到数据有%ld个",self.PHDataArr.count);
        }else{
            NSLog(@"300--拿不到数据啊");
            PHpage--;
           
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
            [self.Shopsitetableview.mj_footer endRefreshingWithNoMoreData];
        }
        
      
         [self.BGlab setHidden:YES];
         [self.Shopsitetableview .mj_footer endRefreshing];
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.Shopsitetableview reloadData];
        });
    }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"请求数据失败----%@",error);
             if (error.code == -999) {
              
                 NSLog(@"网络数据连接取消");
                 
             }else{
             
               
                 [self.BGlab setHidden:YES];
                 [self.Shopsitetableview .mj_footer endRefreshing];
               
                 [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~~"];
                 [YJLHUD dismissWithDelay:1];
             }
        }];
}

#pragma -mark - tableviewcell代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.PHDataArr.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        ShopsiteViewCell *site_cell         = [ShopsiteViewCell cellWithOrderTableView:tableView];
        site_cell.model =[self.PHDataArr objectAtIndex:indexPath.row];
        site_cell.selectionStyle        = UITableViewCellSelectionStyleNone;
        return site_cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd点击了一下",indexPath.row);
     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
//    CATransition * animation    = [CATransition animation];//初始化
//    animation.duration          = 0.5;    //  时间
//    animation.type              = kCATransitionMoveIn;//覆盖
//    animation.subtype           = kCATransitionFromRight;//右边开始
//    [self.view.window.layer addAnimation:animation forKey:nil];  //  添加动作
    //    获取店铺唯一id
    Shopsitemodel *model        = [self.PHDataArr objectAtIndex:indexPath.row];
    ShopsiteXQController *ctl   = [[ShopsiteXQController alloc]init];
    ctl.shopsubid               = model.Shopsitesubid;
    [self.navigationController pushViewController:ctl animated:YES];
     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会恢复正常显示。
}

-(void)dealloc{
    
    NSLog(@"消灭这个");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeCity" object:nil];
    [self.Shopsitetableview removeFromSuperview];
    self.Shopsitetableview = nil;
}

#pragma -mark创建一个头部
-(void)creatTopview{

    self.HeaderView = [[UIView alloc]init];
    self.HeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.HeaderView];
    [self.HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.view).with.offset(0);
        make.left.equalTo (self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight));
    }];
    
    self.ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 194)];
//    [self.ImageView setImage:[UIImage imageNamed:@"Shopsite"]];
     [self.ImageView setImage:[UIImage imageNamed:@"选址banner"]];
    [self.HeaderView addSubview:self.ImageView];
    
    //    返回
    self.BackBtn        = [UIButton buttonWithType:UIButtonTypeCustom];
    self.BackBtn.frame  = CGRectMake(0, 20, 44, 44);
    [self.BackBtn setImage:[UIImage imageNamed:@"heise_fanghui"] forState:UIControlStateNormal];
    [self.BackBtn addTarget:self action:@selector(Clickback) forControlEvents:UIControlEventTouchUpInside];
    [self.HeaderView addSubview:self.BackBtn];
    [self.HeaderView bringSubviewToFront:self.BackBtn];
    
    //    标题
    self.titlelab               = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth / 7, 20, KMainScreenWidth / 7 *5, 44)];
    self.titlelab.textAlignment = NSTextAlignmentCenter;
    self.titlelab.textColor     = [UIColor blackColor];
    self.titlelab.text          = @"商铺选址";
    [self.HeaderView addSubview:self.titlelab];
    [self.HeaderView bringSubviewToFront:self.titlelab];
    
    for (NSInteger i = 0; i<[[Cityarea shareCityData] getAllCityarea].count; i++){
        
        Cityareamodel *model  = [[[Cityarea shareCityData] getAllCityarea] objectAtIndex:i];
        [self.Regionaname addObject:model.Cityareaname];
        [self.Regionaid addObject:model.Cityareaid];
    }
    
    //    一级菜单name
    self.Rent   = @[@"租金选店",@"1千5以下",@"1千5-3千",@"3千-6千",@"6千-1万",@"1万-3万",@"3万以上"];
    self.Area    = @[@"合适面积",@"30m²以下",@"31～60m²",@"61～100m²",@"101～150m²",@"151～200m²",@"201～300m²",@"301～500m²",@"500m²以上"];
    self.Type    = @[@"经营行业",@"餐饮美食",@"美容美发",@"服饰鞋包",@"休闲娱乐",@"百货超市",@"生活服务",@"电子通讯",@"汽车服务",@"医疗保健",@"家居建材",@"教育培训",@"酒店宾馆"];
    //    一级菜单id
    self.Rentid =@[@"00000",@"0~1500",@"1501~3000",@"3001~6000",@"6001~10000",@"10001~30000",@"30001~500000",];
    self.Typeid = @[@"00000",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    self.Areaid =@[@"00000",@"0~30",@"31~60",@"61~100",@"101~150",@"151~200",@"201~300",@"301~500",@"501~50000000"];
    
    //    🔘位置
    yjlmenu = [[YJLMenu alloc] initWithOrigin:CGPointMake(0, 194 ) andHeight:50];
    yjlmenu.delegate = self;
    yjlmenu.dataSource = self;
    [self.HeaderView addSubview:yjlmenu];
    
    self.Fold = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.Fold setTitle:@"返回查看" forState:UIControlStateNormal];
    [self.Fold setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    [self.Fold addTarget:self action:@selector(Fold:) forControlEvents:UIControlEventTouchUpInside];
    [self.HeaderView addSubview:self.Fold];
    [self.Fold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo (self.HeaderView).with.offset(-10);
        make.left.equalTo (self.HeaderView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-20, 20));
    }];
}

-(void)Fold:(id)sender{
    NSLog(@"12131321321321");
    [self.Shopsitetableview setHidden:NO];
}

#pragma mark -创建tableview
-(void)creattableview{
    
    self.Shopsitetableview = [[UITableView alloc]init];
    self.Shopsitetableview.delegate = self;
    self.Shopsitetableview.dataSource = self;
    self.Shopsitetableview.tableFooterView = [UIView new];
    self.Shopsitetableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.Shopsitetableview];
    [self.Shopsitetableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo  (self.view).with.offset(244);
        make.left.equalTo (self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-244));
    }];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.Shopsitetableview addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:NO];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.Shopsitetableview);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

#pragma -mark - 菜单的代理方法
-(NSInteger )numberOfColumnsInMenu:(YJLMenu *)menu{
    return 4;
}

-(NSInteger )menu:(YJLMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    if (column == 0) {
        return _Regionaname.count;
    }
    if (column == 1) {
        return self.Rent.count;
    }
    if (column == 2) {
        return self.Type.count;
    }else{
        return self.Area.count;
    }
}

-(NSString *)menu:(YJLMenu *)menu titleForRowAtIndexPath:(YJLIndexPath *)indexPath{
      [self.Shopsitetableview setHidden:YES];//重要的特效点1
    if (indexPath.column  == 0) {
        return _Regionaname[indexPath.row];
    }else if (indexPath.column == 1){
        return self.Rent[indexPath.row];
    }else if (indexPath.column == 2){
        return self.Type[indexPath.row];
    }else{
        return self.Area[indexPath.row];
    }
}

- (void)menu:(YJLMenu *)menu didSelectRowAtIndexPath:(YJLIndexPath *)indexPath {
      [self.Shopsitetableview setHidden:NO];//重要的特效点1
    
    if (indexPath.item >= 0){   //有二级菜单
        NSLog(@"点击了 %ld列 - 第%ld栏（一级） - %ld栏（二级）",indexPath.column+1,indexPath.row + 1,indexPath.item+1);
    }
    
    //没有二级菜单
    else {
        NSLog(@"点击了 %ld列 - 第%ld栏（一级）",indexPath.column+1,indexPath.row+1);
        switch (indexPath.column+1){
            case 1:{
                valuestr1 = self.Regionaname[indexPath.row];
                valuestr1id = self.Regionaid[indexPath.row];
                NSLog(@"获取值区域 = %@",valuestr1);
                NSLog(@"获取值区域id = %@",valuestr1id);
            }
                break;
            case 2:{
                valuestr2 = self.Rent[indexPath.row];
                NSLog(@"获取值租金 = %@",valuestr2);
                valuestr2id = self.Rentid[indexPath.row];
                NSLog(@"获取值租金id = %@",valuestr2id);
            }
                break;
            case 3:{
                valuestr3 = self.Type[indexPath.row];
                NSLog(@"获取值行业 = %@",valuestr3);
                valuestr3id = self.Typeid[indexPath.row];
                NSLog(@"获取值行业id = %@",valuestr3id);
            }
                break;
            case 4:{
                valuestr4 = self.Area[indexPath.row];
                NSLog(@"获取值面积 = %@",valuestr4);
                valuestr4id = self.Areaid[indexPath.row];
                NSLog(@"获取值面积id = %@",valuestr4id);
            }
                break;
       }
#pragma -mark 显示当前点击多少项  那几项名称 id
        [self setup:valuestr1id :valuestr2id :valuestr3id :valuestr4id];

    }
}
#pragma -mark 显示当前点击多少项  那几项名称id 方法
-(void)setup:(NSString *)value1 :(NSString *)value2 : (NSString *)value3 :(NSString *)value4{
    
    NSLog(@"%@~~%@~~%@~~%@",value1,value2,value3,value4);
    if (value1.length<1) {
        value1 = @"00000";
    }
    if (value2.length<1) {
        value2 = @"00000";
    }
    if (value3.length<1) {
        value3 = @"00000";
    }
    if (value4.length<1) {
        value4 = @"00000";
    }
    
//http://192.168.1.106/chinapuhuang/PCPH/index.php/Zgphshop/Allhost/DelTarea?id=%@&page=%d
    
    _path = [NSString stringWithFormat:@"&upid=%@&rent=%@&leixing=%@&area=%@",value1,value2,value3,value4];
    NSLog(@"拼接字符串%@",_path);
    [self loaddataUPtodown];
}


#pragma -mark UIScrollViewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    CGFloat offset = scrollView.contentOffset.y;
//    NSLog(@"将要开始拖拽，手指已经放在view上并准备拖动的那一刻===%f",offset);
    if (scrollView == self.Shopsitetableview) {
        NSLog(@"2132132112321");
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.PHDataArr.count > 5) {  //由于cell高度只有95*5+70 < 667 这是不能进行 特效的
        
        CGFloat offset = scrollView.contentOffset.y;
//        NSLog(@"只要view有滚动=%f",offset);
        if (offset <=0 ) {
            
            [self.HeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(0);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight));
            }];
            
            [self.Shopsitetableview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(244);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-244));
            }];
            
        }else if(offset>0 &&offset < 174){
            
            [self.HeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(-174);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight+174));
            }];
            
            [self.Shopsitetableview mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo (self.view).with.offset(70);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-70));
                
            }];
        }
        
        else{
            
            NSLog(@"固定了吧");
            [self.HeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(-174);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight+174));
            }];
            
            [self.Shopsitetableview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(70);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-70));
            }];
        }
        
    }
    
    }
#pragma  -mark - 按钮返回
-(void)Clickback{
     [self backback];
}
#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    [self backback];
    
}
#pragma  -mark - 返回方法
-(void)backback{
    
    NSLog(@"点击了想回去");
    if(self.task) {
        
        [self.Shopsitetableview.mj_header endRefreshing];
        [self.task cancel];//取消当前界面的数据请求.
       
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    让导航栏不显示出来***********************************
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

@end
