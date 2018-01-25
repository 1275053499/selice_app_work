//
//  ShopsrecruitViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsrecruitViewController.h"
#import "DOPDropDownMenu.h"
#import "ShopsrecruitModel.h"
#import "ShopsrecruitViewCell.h"
#import "ResumeXQController.h"
#import "RecruitData.h"
@interface ShopsrecruitViewController ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>{
    int  PHpage;
}

@property (nonatomic , strong) UILabel        *   BGlab;               //无网络提示语
@property (nonatomic , strong) UIImageView   *choseImageView;
@property (nonatomic , strong) UIButton      *choseBackBtn;
@property (nonatomic , strong) UILabel       *chosetitlelab;

@property (nonatomic , weak  ) DOPDropDownMenu   * ZPmenu;

@property (nonatomic, strong) NSArray       *ALL;       //四个分类
@property (nonatomic, strong) NSArray       *Category;  //类别
@property (nonatomic, strong) NSArray       *Category00;//类别
@property (nonatomic, strong) NSArray       *Category01;//类别
@property (nonatomic, strong) NSArray       *Category02;//类别
@property (nonatomic, strong) NSArray       *Category03;//类别
@property (nonatomic, strong) NSArray       *Category04;//类别
@property (nonatomic, strong) NSArray       *Category05;//类别
@property (nonatomic, strong) NSArray       *Category06;//类别

@property (nonatomic, strong) NSArray       *Salary;      //薪资
@property (nonatomic, strong) NSArray       *Experience;  //经验
@property (nonatomic, strong) NSArray       *Education;   //学历

@property (nonatomic, strong) NSString       *valuestr1;   //当前点击的位置1 类别
@property (nonatomic, strong) NSString       *valuestr2;   //当前点击的位置2 薪资
@property (nonatomic, strong) NSString       *valuestr3;   //当前点击的位置3 经验
@property (nonatomic, strong) NSString       *valuestr4;   //当前点击的位置4 学历
@property (nonatomic ,strong) UITableView    *Shopsrecruittableview;//列表
@property (nonatomic, strong) NSString       *path;        //入境

@property(nonatomic,strong)UIView            *HeaderView;  //滚动+菜单背景合一

@property(nonatomic,strong)NSURLSessionDataTask *   task;

@end

@implementation ShopsrecruitViewController


- (void)viewDidLoad {
    [super viewDidLoad];

     self.view.backgroundColor = kTCColor(255, 255, 255);
    _path           = [[NSString alloc]initWithFormat:@"&category=0&money=0&experience=0&edu=0"];
    PHArr = [[NSMutableArray alloc]init];
   
    [self creatChoiceTop];
    [self creattableview];
        //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
     [self refresh];
    
    //   接收首页的城市切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changevalue) name:@"ChangeCity" object:nil];
    
    // 是否是第一次进入该处
    [self isFirstCome];
    
    //    menu发来的通知用来取消隐藏tab
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowZP) name:@"ShowZP" object:nil];
}

#pragma -mark menu发来的通知用来取消隐藏tab
-(void)ShowZP{
    
    [self.Shopsrecruittableview setHidden:NO];
}

#pragma  -mark 切换城市进行判断并删除上一个城市数据
-(void)changevalue{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"ZPisFirstCome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[RecruitData sharerecruitData]deletedsrecruitData];
    NSLog(@"切换城市----招聘缓存的数据清理");
}



#pragma -mark 是否是第一次进入该处
-(void)isFirstCome{
    
    NSString       * isFirstCome       = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZPisFirstCome"];
    NSLog(@"YES OR NO                                                  ===%@",isFirstCome);
    if (![isFirstCome isEqualToString:@"YES"]){   //NO
        NSLog(@"是第一次请求");
#pragma -mark 网络检测
        [self reachability];
    }
    
    else{ //YES
        NSLog(@"不是第一次进来了");

        PHArr = [[RecruitData sharerecruitData]getAllDatas];
        if (PHArr.count>0) {
                [self.Shopsrecruittableview reloadData];
            if (PHArr.count%5>0) {
                PHpage = (int)PHArr.count/5;
            }else{
                PHpage = (int)PHArr.count/5-1;
            }
            
        }else{
            [self reachability];
        }
    }
}


#pragma mark 网络检测
-(void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        NSLog(@"status=%ld",status);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [self loaddataUPtodown];
        }
        else{
            NSLog(@"网络繁忙");
        }
        
    }];
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
    self.Shopsrecruittableview.mj_header = header;
    
#pragma  -mark上拉加载获取网络数据
    self.Shopsrecruittableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉刷新一下试试");
        NSLog(@"上一个第%d页",PHpage       );
        PHpage++;
        [self loaddataDowntoup];
    }];
}

#pragma -mark 初始下拉刷新
-(void)loaddataUPtodown{
    [self.Shopsrecruittableview.mj_footer resetNoMoreData];
    [self.BGlab setHidden:YES];
    PHpage=0;
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    NSLog(@"即将下拉刷新之前数组有%ld个数据",PHArr.count);
    NSString  * str = [NSString stringWithFormat:@"%@?cid=%@&page=%d%@",Hostrecruitpath,self.city,PHpage,_path];
    NSLog(@"下拉刷新请求入境：%@",str);
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
 self.task =    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
        [[RecruitData sharerecruitData]deletedsrecruitData];
        [PHArr removeAllObjects];
        [YJLHUD showSuccessWithmessage:@"加载成功"];
        [YJLHUD dismissWithDelay:1];
        
//        NSLog(@"请求数据成功----%@",responseObject);
//        NSLog(@"判断数据=======%@", responseObject[@"code"]);
         if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"可以拿到数据的");
             for (NSDictionary *dic in responseObject[@"data"]){
                 ShopsrecruitModel *model = [[ShopsrecruitModel alloc]init];
                 model.CompanyJobname    = dic[@"category"];
                 model.Companyname       = dic[@"name"];
                 model.CompanyArea       = dic[@"districter"];
                 model.CompanyTimers     = dic[@"time"];
                 model.CompanySuffer     = dic[@"experience"];
                 model.Companyeducation  = dic[@"edu"];
                 model.Companysalary     = dic[@"money"];
                 model.Companyid         = dic[@"id"];
                 [model setValuesForKeysWithDictionary:dic];
                 [[RecruitData sharerecruitData]addrecruit:model];
                 [PHArr addObject:model];
                 
             }
            NSLog(@" ZP加载后现在总请求到数据有%ld个",PHArr.count);
            self.Shopsrecruittableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.BGlab setHidden:YES];
             //  后台执行：
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ZPisFirstCome"];//设置下一次不走这里了
                 [[NSUserDefaults standardUserDefaults] synchronize];
             });
        }else{
            
            NSLog(@"300--拿不到数据啊");
            
            [self.BGlab setHidden:NO];
            self.BGlab.text             = @"没有更多数据";
            self.Shopsrecruittableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
            [self.Shopsrecruittableview.mj_footer endRefreshingWithNoMoreData];
        }
        
     
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self. Shopsrecruittableview reloadData];
        });
        [self.Shopsrecruittableview .mj_header endRefreshing];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if (error.code == -999) {
            NSLog(@"网络数据连接取消");
        }else{
            
            // 其他提示
            [self.BGlab setHidden:NO];
            [self.Shopsrecruittableview .mj_header endRefreshing];
           
            [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~~"];
            [YJLHUD dismissWithDelay:1];
        
        }
    }];
}

#pragma -mark 初始上拉加载
-(void)loaddataDowntoup{
    
     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    NSLog(@"即将下拉刷新之前数组有%ld个数据",PHArr.count);
    NSString  * str = [NSString stringWithFormat:@"%@?cid=%@&page=%d%@",Hostrecruitpath,self.city,PHpage,self.path];
    NSLog(@"下拉刷新请求入境：%@",str);
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
     ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
  
   self.task =  [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
//        NSLog(@"请求数据成功----%@",responseObject);
//        NSLog(@"判断数据=======%@", responseObject[@"code"]);
         if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
//            NSLog(@"可以拿到数据的");
             
             [YJLHUD dismissWithDelay:1];
            for (NSDictionary *dic in responseObject[@"data"]){
                ShopsrecruitModel *model = [[ShopsrecruitModel alloc]init];
                model.CompanyJobname    = dic[@"category"];
                model.Companyname       = dic[@"name"];
                model.CompanyArea       = dic[@"districter"];
                model.CompanyTimers     = dic[@"time"];
                model.CompanySuffer     = dic[@"experience"];
                model.Companyeducation  = dic[@"edu"];
                model.Companysalary     = dic[@"money"];
                model.Companyid         = dic[@"id"];
                [model setValuesForKeysWithDictionary:dic];
                [[RecruitData sharerecruitData]addrecruit:model];
                [PHArr addObject:model];
            }
            NSLog(@" ZP加载后现在总请求到数据有%ld个",PHArr.count);
            
           [self.Shopsrecruittableview.mj_footer endRefreshing];
            
        }else{
            
            NSLog(@"300--拿不到数据啊");
             PHpage--;
            [self.BGlab setHidden:YES];
           
            [self.Shopsrecruittableview.mj_footer endRefreshing];
          
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
            
            [self.Shopsrecruittableview.mj_footer endRefreshingWithNoMoreData];
        }
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
             [self. Shopsrecruittableview reloadData];
        });
    }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"请求数据失败----%@",error);
             if (error.code == -999) {
                 NSLog(@"网络数据连接取消");
             }else{
                
                 [self.BGlab setHidden:YES];
                 [self.Shopsrecruittableview .mj_footer endRefreshing];
                 [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~~"];
                 [YJLHUD dismissWithDelay:1];
            }
         }];
}

#pragma -mark - tableviewcell 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return PHArr.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cell";
    ShopsrecruitViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ShopsrecruitViewCell" owner:self options:nil]lastObject];
    }

    NSLog(@"!!!!!%ld=????????%ld",PHArr.count,indexPath.row);
    ShopsrecruitModel *model = [PHArr objectAtIndex:indexPath.row];
    cell.CompanyJobname.text = [NSString stringWithFormat:@"职位:%@",model.CompanyJobname];
    cell.CompanyTimers.text  = [NSString stringWithFormat:@"更新时间:%@",model.CompanyTimers];
    cell.Companyname.text    = [NSString stringWithFormat:@"店名:%@",model.Companyname];
    cell.CompanyArea.text    = [NSString stringWithFormat:@"%@",model.CompanyArea];
    cell.CompanySuffer.text  = [NSString stringWithFormat:@"%@",model.CompanySuffer];
    cell.Companyeducation.text = [NSString stringWithFormat:@"%@",model.Companyeducation];
    cell.Companysalary.text  = [NSString stringWithFormat:@"%@/月",model.Companysalary];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd点击了一下",indexPath.row);
    
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    ResumeXQController *ctl =[[ResumeXQController alloc]init];
    //    获取店铺唯一id
    ShopsrecruitModel *model    = [PHArr objectAtIndex:indexPath.row];
    ctl.shopsubid               = model.Companyid;
    [self.navigationController pushViewController:ctl animated:YES];
     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

#pragma mark - 创建tableview
-(void)creattableview{
    
    self.Shopsrecruittableview = [[UITableView alloc]init];
    self.Shopsrecruittableview.delegate     = self;
    self.Shopsrecruittableview.dataSource   = self;
    self.Shopsrecruittableview.backgroundColor = [UIColor whiteColor];
    self.Shopsrecruittableview.tableFooterView = [UIView new];
    [self.view addSubview:self.Shopsrecruittableview];
    [self.Shopsrecruittableview mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo  (self.view).with.offset(230);
        make.left.equalTo (self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-230));
    }];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.Shopsrecruittableview addSubview:self.BGlab];
    self.BGlab.text             = @"服务器开小差了，稍等~~";
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.Shopsrecruittableview);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

#pragma mark - 创建一个头部🔘
-(void)creatChoiceTop{
    
    self.HeaderView = [[UIView alloc]init];
    self.HeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.HeaderView];
    [self.HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.view).with.offset(0);
        make.left.equalTo (self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 551));//194 banner高度   365菜单需要高度 300+36+21
    }];
    
//    宣传图
    self.choseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 194)];
    [self.choseImageView setImage:[UIImage imageNamed:@"zpzx_banner"]];
    [self.HeaderView addSubview:self.choseImageView];
//    返回按钮
    _choseBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _choseBackBtn.frame = CGRectMake(0, 20, 44, 44);
    [_choseBackBtn setImage:[UIImage imageNamed:@"heise_fanghui"] forState:UIControlStateNormal];
    [_choseBackBtn addTarget:self action:@selector(Clickback) forControlEvents:UIControlEventTouchUpInside];
    [self.HeaderView addSubview:self.choseBackBtn];
    [self.HeaderView bringSubviewToFront:self.choseBackBtn];
//    标题
    self.chosetitlelab               = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth / 7, 20, KMainScreenWidth / 7 *5, 44)];
    self.chosetitlelab.textAlignment = NSTextAlignmentCenter;
    self.chosetitlelab.textColor     = [UIColor blackColor];
    self.chosetitlelab.text = @"招聘中心";
    [self.HeaderView addSubview:self.chosetitlelab];
    [self.HeaderView bringSubviewToFront:self.chosetitlelab];
    
//    菜单栏目
    //    一级菜单
    self.Category   = @[@"职位类别",@"餐饮类",@"酒店类",@"美容美发类",@"家政类",@"百货类",@"物流仓储类"];
    //    2级菜单
        self.Category00 = @[@"职位类别"];
        self.Category01 = @[@"服务员",@"厨师",@"学徒",@"配送员",@"传菜员"];
        self.Category02 = @[@"大堂经理",@"酒店领班",@"酒店安保",@"面点师",@"行政主厨",@"酒店厨师",@"厨师长",@"厨师助理",@"配菜员",@"酒店服务员",@"迎宾(接待)",@"酒店洗碗员",@"餐饮管理",@"后厨",@"茶艺师"];
        self.Category03 = @[@"发型师",@"美发助理",@"洗头工",@"美容导师",@"美容师",@"化妆师",@"美甲师",@"宠物美容",@"美容店长",@"瘦身顾问",@"形象设计师",@"彩妆设计师",@"美体师"];
        self.Category04 = @[@"保洁员",@"保姆",@"月嫂",@"育婴师",@"洗衣工",@"钟点工",@"保安",@"护工",@"送水工",@"家电维修"];
        self.Category05 = @[@"收银员",@"促销员",@"营业员",@"理货员",@"防损员",@"卖场经理",@"卖场店长",@"招商经理",@"督导",@"品类管理"];
        self.Category06 = @[@"物流专员",@"调度员",@"快递员",@"仓库管理员",@"搬运工",@"分拣员"];

    self.Salary         = @[@"基本薪资",@"1～3K", @"3～5K",@"5～8K",@"8～10K",@"10K以上",@"面议"];
    self.Experience     = @[@"工作经验",@"应届毕业生",@"1～3年",@"3～5年",@"5～10年",@"10年以上"];
    self.Education      = @[@"学历要求",@"不限",@"初中",@"高中",@"大专",@"本科",@"硕士"];
    
    
    // 添加下拉菜单
    DOPDropDownMenu * menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0,194) andHeight:36];
    menu.delegate = self;
    menu.dataSource = self;
    self.ZPmenu = menu;
    [self.HeaderView addSubview:self.ZPmenu];
    //当下拉菜单收回时的回调，用于网络请求新的数据
    
    self.ZPmenu.finishedBlock=^(DOPIndexPath *indexPath){
        
         [self.Shopsrecruittableview setHidden:NO];
        
        if (indexPath.item >= 0){

            switch (indexPath.row) {
                case 0:{
                    _valuestr1 =_Category00[indexPath.item];
                    NSLog(@"获取值类别=%@",_valuestr1);
                }
                    break;
                case 1:{

                    _valuestr1 =_Category01[indexPath.item];
                    NSLog(@"获取值餐饮类=%@",_valuestr1);
                }
                    break;
                case 2:{

                    _valuestr1 =_Category02[indexPath.item];
                    NSLog(@"获取值酒店=%@",_valuestr1);
                }
                    break;
                case 3:{

                    _valuestr1 =_Category03[indexPath.item];
                    NSLog(@"获取值美容美发=%@",_valuestr1);
                }
                    break;
                case 4:{

                    _valuestr1 =_Category04[indexPath.item];
                    NSLog(@"获取值家政类=%@",_valuestr1);
                }
                    break;
                case 5:{

                    _valuestr1 =_Category05[indexPath.item];
                    NSLog(@"获取值百货类=%@",_valuestr1);
                }
                    break;
                case 6:{

                    _valuestr1 =_Category06[indexPath.item];
                    NSLog(@"获取值物流仓储类=%@",_valuestr1);
                }
                    break;

                default:{
                    NSLog(@"铺皇网6666");
                }
                    break;
            }
        }

        else {//indexPath.item 不存在

            switch (indexPath.column){
                case 1:{

                    for (int i =0; i < self.Salary.count; i++){

                        if ([self.Salary[indexPath.row] isEqualToString:self.Salary[i]]){

                            _valuestr2 = [NSString stringWithFormat:@"%d",i];
                        }
                    }
                        NSLog(@"获取值薪资 = %@",_valuestr2);
                }
                    break;
                case 2:{

                    for (int i =0; i < self.Experience.count; i++){

                        if ([self.Experience[indexPath.row] isEqualToString:self.Experience[i]]){

                            _valuestr3 = [NSString stringWithFormat:@"%d",i];
                        }
                    }
                    NSLog(@"获取值经验 = %@",_valuestr3);
                }
                    break;

                case 3:{

                    for (int i =0; i < self.Education.count; i++){

                        if ([self.Education[indexPath.row] isEqualToString:self.Education[i]]){
                            _valuestr4 = [NSString stringWithFormat:@"%d",i];
                        }
                    }
                    NSLog(@"获取值学历 = %@",_valuestr4);
                }
                    break;
            }
                NSLog(@"收起:点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        }

        [self setup:_valuestr1 :_valuestr2 :_valuestr3 :_valuestr4];
    };

    //     创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    //    [menu selectDefalutIndexPath];
    [menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:0]];
}

#pragma -mark UIScrollViewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    CGFloat offset = scrollView.contentOffset.y;
//    NSLog(@"将要开始拖拽，手指已经放在view上并准备拖动的那一刻===%f",offset);
    if (scrollView == self.Shopsrecruittableview) {
//        NSLog(@"2132132112321");
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (PHArr.count > 5) {  //由于cell高度只有95*5+70 < 667 这是不能进行 特效的
        
        CGFloat offset = scrollView.contentOffset.y;
//        NSLog(@"只要view有滚动=%f",offset);
        if (offset <=0 ) {
            
            [self.HeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(0);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 551));
            }];
            
            [self.Shopsrecruittableview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(230);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-230));
            }];
            
        }else if(offset>0 &&offset < 174){
            
            [self.HeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(-174);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight+174));
            }];
            
            [self.Shopsrecruittableview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(56);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-56));
                
            }];
        }
        
        else{
            
//            NSLog(@"固定了吧");
            [self.HeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(-174);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight+174));
            }];
            
            [self.Shopsrecruittableview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(56);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-56));
            }];
        }
        
    }
    
}


#pragma -mark 显示当前点击多少项  那几项名称
-(void)setup:(NSString *)valuestr1 :(NSString *)valuestr2 : (NSString *)valuestr3 :(NSString *)valuestr4{

    NSLog(@"入境加入条件:%@~~%@~~%@~~%@",valuestr1,valuestr2,valuestr3,valuestr4);
    if (valuestr1.length<1) {
        valuestr1 = @"0";
    }
    if (valuestr2.length<1) {
        valuestr2 = @"0";
    }
    if (valuestr3.length<1) {
        valuestr3 = @"0";
    }
    if (valuestr4.length<1) {
        valuestr4 = @"0";
    }

    if ([valuestr1 isEqualToString:@"职位类别"]) {
        valuestr1 = @"0";
    }

    valuestr1  =[valuestr1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    _path         = [[NSString alloc]initWithFormat:@"&category=%@&money=%@&experience=%@&edu=%@",valuestr1,valuestr2,valuestr3,valuestr4];
     NSLog(@"拼接字符串%@",_path);

    [self loaddataUPtodown];
}


- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 4;
}


- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    if (column == 0) {      //222
        return self.Category.count;
    }else if (column == 1){
        return self.Salary.count;
    }else if (column == 2){
        return self.Experience.count;
    }else {
        return self.Education.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    [self.Shopsrecruittableview setHidden:YES];
    if (indexPath.column == 0) {//222
        return self.Category[indexPath.row];
    }
    else if (indexPath.column == 1){
        return self.Salary[indexPath.row];
    }
    else if (indexPath.column == 2){
        return self.Experience[indexPath.row];
    }
    else {
        return self.Education[indexPath.row];
    }
}



- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
//222222 //333
    if (column == 0) {
        if (row == 0){
            return self.Category00.count;
        }
        else if (row == 1){
            return self.Category01.count;
        }
        else if (row == 2){
            return self.Category02.count;
        }
        else if (row == 3){
            return self.Category03.count;
        }
        else if (row == 4){
            return self.Category04.count;
        }
        else if (row == 5){
            return self.Category05.count;
        }
        else if (row == 6){
            return self.Category06.count;
        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
//222
    if (indexPath.column == 0) {
        if (indexPath.row == 0){
            return self.Category00[indexPath.item];
        }
        else if (indexPath.row == 1){
            return self.Category01[indexPath.item];
        }
        else if (indexPath.row == 2){
            return self.Category02[indexPath.item];
        }
        else if (indexPath.row == 3){
            return self.Category03[indexPath.item];
        }
        else if (indexPath.row ==4){
            return self.Category04[indexPath.item];
        }
        else if (indexPath.row == 5){
            return self.Category05[indexPath.item];
        }
        else if (indexPath.row == 6){
            return self.Category06[indexPath.item];
        }
    }
    return nil;
}

// new datasource 加图片的

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath{
    //    if (indexPath.column == 0 || indexPath.column == 1) {
    //        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.row];
    //    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    //    if (indexPath.column == 0 && indexPath.item >= 0) {
    //        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.item];
    //    }
    return nil;
}

// new datasource
- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath{
    //    if (indexPath.column < 2) {
    //        return [@(arc4random()%1000) stringValue];
    //    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    //    return [@(arc4random()%1000) stringValue];
    return nil;
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    if(self.task) {
        
        [self.Shopsrecruittableview.mj_header endRefreshing];
        [self.task cancel];//取消当前界面的数据请求.
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma mark - 返回点击
- (void)Clickback{
    if(self.task) {
        
        [self.Shopsrecruittableview.mj_header endRefreshing];
        [self.task cancel];//取消当前界面的数据请求.
       
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"选好了我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}






@end
