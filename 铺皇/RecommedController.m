//
//  RecommedController.m
//  铺皇
//
//  Created by selice on 2017/9/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RecommedController.h"
#import "YJLMenu.h"
#import "YJLScrollView.h"
#import "JX_FourCell.h"
#import "JX_FourModel.h"
#import "RecommendallData.h"//数据缓存数据库
#import "Cityareamodel.h"//城市区域model
#import "Cityarea.h"//城市区域数据库
@interface RecommedController ()<YJLScrollViewdelegate,UITableViewDelegate
,UITableViewDataSource,YJLMenuDelegate,YJLMenuDataSource>{
    int PHpage;
    YJLScrollView   *yjlScroll;
    YJLMenu         *yjlmenu;
}

@property float autoSizeScaleX;
@property float autoSizeScaleY;
//图片url string 数据
@property (nonatomic , strong) NSArray        *imageArr;
@property (nonatomic , strong) UIButton       *BackBtn;
@property (nonatomic , strong) UILabel        *titlelab;
@property (nonatomic , strong) UILabel        *BGlab;             //无网络提示语
@property (nonatomic , strong) UIImageView    *ImageView;
@property (nonatomic , strong) UITableView    *Recommendtableview;
@property (nonatomic,  strong) NSMutableArray *Regionaname;       //区域名字
@property (nonatomic,  strong) NSMutableArray *Regionaid;         //区域id
@property (nonatomic,  strong) NSArray        *Rent;              //租金选店
@property (nonatomic,  strong) NSArray        *Type;              //类型选店
@property (nonatomic,  strong) NSArray        *Area;              //面积选店
@property (nonatomic,  strong) NSArray        *Rentid;            //租金id
@property (nonatomic,  strong) NSArray        *Typeid;            //类型id
@property (nonatomic,  strong) NSArray        *Areaid;            //面积id
@property (nonatomic,  strong) NSString       *path;              //入境
@property (nonatomic , strong) NSMutableArray *PHDataArr;         //存储数据

@property(nonatomic,strong)UIView               *HeaderView;//滚动+菜单背景合一
@property(nonatomic,strong)UIButton             *Fold;        // 菜单返回

@property(nonatomic,strong)NSURLSessionDataTask*task;

@end

@implementation RecommedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSLog(@"城市id=%@",self.cityid);
    self.PHDataArr      = [[NSMutableArray alloc]init];
    self.Regionaname    = [[NSMutableArray alloc]init];
    self.Regionaid      = [[NSMutableArray alloc]init];
    self.path        =  [[NSString alloc]initWithFormat:@"&dityour=00000&rent=00000&type=00000&area=00000"];
    //    创建头部轮播图
    [self creatscrollow];
    //    创建列表table
    [self creattableview];
    //   加载数据控件
    [self refresh];
    
    //   接收首页的城市切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changevalue) name:@"ChangeCity" object:nil];
    
    // 是否是第一次进入该处
    [self isNewsFirstCome];
    
#pragma -mark右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
//    menu发来的通知用来取消隐藏tab
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowNO) name:@"ShowNO" object:nil];
    
}

#pragma -mark menu发来的通知用来取消隐藏tab
-(void)ShowNO{
    
    [self.Recommendtableview setHidden:NO];
}

#pragma  -mark 切换城市进行判断并删除上一个城市数据
-(void)changevalue{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"RecommendisFirstCome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[RecommendallData shareRecommendDataBase]deletedRecommendalldata];
}

#pragma -mark 是否是第一次进入该处
-(void)isNewsFirstCome{
    
    if (![ [[NSUserDefaults standardUserDefaults] objectForKey:@"RecommendisFirstCome"] isEqualToString:@"YES"]){   //NO
        
        NSLog(@"是第一次请求");
        [self  reachabilitydata];
    }
    
    else{ //YES
        self.PHDataArr = [[RecommendallData shareRecommendDataBase] getAllDatas];
        
        NSLog(@"资源%ld个数",self.PHDataArr.count);
        if (self.PHDataArr.count>0) {
            //    修改分割线颜色
            [ self.Recommendtableview setSeparatorColor : [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]];
             [_Recommendtableview reloadData];
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

#pragma mark - 创建上下拉刷新数据
- (void)refresh{
    
    //#pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddataUPtodown)];
    
    // Set title
    [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
    [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
    [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // Set textColor
    header.stateLabel.textColor             = kTCColor(161, 161, 161);
    header.lastUpdatedTimeLabel.textColor   = kTCColor(161, 161, 161);
    self.Recommendtableview.mj_header     = header;
    
    //#pragma  -mark上拉加载获取网络数据
    self.Recommendtableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉刷新一下试试"           );
        NSLog(@"上一个第%d页",PHpage       );
        PHpage++;
        [self loaddataDowntoup           ];
    }];
}

#pragma -mark 下拉刷新数据
-(void)loaddataUPtodown{

     [self. Recommendtableview .mj_footer resetNoMoreData];//开启刷新功能
    PHpage      =   0;
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    [self.BGlab setHidden:YES];
    NSLog(@"即将下拉刷新之前数组有%ld个数据",self.PHDataArr.count);
    NSString  * str = [NSString stringWithFormat:@"%@?cid=%@&page=%d%@",HostZRHomepath,_cityid,PHpage,_path];
    NSLog(@"下拉刷新请求入境：%@",str);
    
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    
  self.task =  [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.PHDataArr removeAllObjects];
      [YJLHUD showSuccessWithmessage:@"加载成功"];
      [YJLHUD dismissWithDelay:1];
        [[RecommendallData shareRecommendDataBase]deletedRecommendalldata];
        
        //        NSLog(@"请求数据成功----%@",responseObject);
        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"可以拿到数据的");
            for (NSDictionary *dic in responseObject[@"data"]){
                JX_FourModel *model = [[JX_FourModel alloc]init];
                model.JX_picture    = dic[@"images"];
                model.JX_title      = dic[@"title"];
                model.JX_quyu       = dic[@"districter"];
                model.JX_time       = dic[@"time"];
                model.JX_tag        = dic[@"type"];
                model.JX_area       = dic[@"area"];
                model.JX_rent       = dic[@"rent"];
                model.JX_subid      = dic[@"id"];
                [model setValuesForKeysWithDictionary:dic];
                //            得到的数据加入数据库
                [[RecommendallData shareRecommendDataBase]addRecommendalldata:model];
                [self.PHDataArr addObject:model];
          
            NSLog(@" 加载后现在总请求到数据有%ld个",self.PHDataArr.count);
            self.Recommendtableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"RecommendisFirstCome"];//设置下一次不走这里了
            [[NSUserDefaults standardUserDefaults] synchronize];
           [self.BGlab setHidden:YES];
           self.Recommendtableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                
           }
        }
        else{
            
//            500
            [self.BGlab setHidden:NO];
            self.BGlab.text             = @"没有更多数据";
        
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
            
            self.Recommendtableview.separatorStyle = UITableViewCellSeparatorStyleNone;

        }
    
        [self.Recommendtableview reloadData];
        [self.Recommendtableview.mj_header endRefreshing];
    }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"请求数据失败----%@",error);
             if (error.code == -999) {
                 NSLog(@"网络数据连接取消");
             }else{
                
                 [self.BGlab setHidden:NO];
                 self.BGlab.text      = @"网络数据连接超时了,稍等~~";
                 [self.Recommendtableview .mj_header endRefreshing];
                 [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~~"];
                 [YJLHUD dismissWithDelay:1];
             }
             
            
         }];
}

#pragma -mark 初始上拉加载
-(void)loaddataDowntoup{
    
    NSLog(@"上拉加载数组里面的数剧有%ld个",self.PHDataArr.count);
    NSLog(@"马上加载第%d页",PHpage);
 [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    
    NSString  * URL = [NSString stringWithFormat:@"%@?cid=%@&page=%d%@",HostZRHomepath,self.cityid,PHpage,self.path];
    NSLog(@"上拉加载请求入境：%@",URL);
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
   
   self.task = [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"请求数据成功----%@",responseObject);
        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"可以拿到数据的");
          
            [YJLHUD dismissWithDelay:1];
            for (NSDictionary *dic in responseObject[@"data"]){
                JX_FourModel *model = [[JX_FourModel alloc]init];
                model.JX_picture    = dic[@"images"];
                model.JX_title      = dic[@"title"];
                model.JX_quyu       = dic[@"districter"];
                model.JX_time       = dic[@"time"];
                model.JX_tag        = dic[@"type"];
                model.JX_area       = dic[@"area"];
                model.JX_rent       = dic[@"rent"];
                model.JX_subid      = dic[@"id"];
                [model setValuesForKeysWithDictionary:dic];
                [[RecommendallData shareRecommendDataBase]addRecommendalldata:model];
                [self.PHDataArr addObject:model];
            }
                NSLog(@" 加载后现在总请求到数据有%ld个",self.PHDataArr.count);
            
                [self.Recommendtableview.mj_footer endRefreshing];
            }
        else{
            
                [self.Recommendtableview.mj_footer endRefreshing];
                PHpage--;
            
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
            
                [self. Recommendtableview .mj_footer endRefreshingWithNoMoreData];//关闭刷新功能
        }
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self. Recommendtableview reloadData];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if (error.code == -999) {
            NSLog(@"网络数据连接取消");
        }else{
            
            [self.BGlab setHidden:NO];
            self.BGlab.text      = @"网络数据连接超时了,稍等~~";
            [self.Recommendtableview .mj_header endRefreshing];
            [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~~"];
            [YJLHUD dismissWithDelay:1];
        }
    }];
}

#pragma -mark - tableviewcell代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"列表里面=%ld",self.PHDataArr.count);
    return self.PHDataArr.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *cellid = @"cell";
        
        JX_FourCell *JX_cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (JX_cell == nil){
            JX_cell =[[[NSBundle mainBundle]loadNibNamed:@"JX_FourCell" owner:self options:nil]lastObject];
        }
        
        NSLog(@"!!!!!%ld=????????%ld",self.PHDataArr .count,indexPath.row);
        JX_FourModel *model = [self.PHDataArr objectAtIndex:indexPath.row];
        JX_cell.BTlab.text                = model.JX_title;//标题
        JX_cell.QuYulab.text              = model.JX_quyu;//区域所在
        JX_cell.Timerlab.text             = model.JX_time;//更新时间
        JX_cell.Taglab.text               = model.JX_tag;//餐饮美食
        JX_cell.Arealab.text              = [NSString stringWithFormat:@"%@m²",model.JX_area];//店铺面积
        JX_cell.Pricelab.text             = [NSString stringWithFormat:@"%@元／月",model.JX_rent];//店铺转让费
        [JX_cell.PictureImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.JX_picture]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
        JX_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return JX_cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%zd点击了一下",indexPath.row);
     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    //    获取店铺唯一id
    JX_FourModel *model = [self.PHDataArr objectAtIndex:indexPath.row];
    DetailedController *ctl =[[DetailedController alloc]init];
    ctl.shopsubid = model.JX_subid;
    ctl.shopcode  = @"transfer";
    NSLog(@"店铺🆔%@",ctl.shopsubid);
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}


-(void)dealloc{
    
    NSLog(@"消灭这个");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeCity" object:nil];
    [_Recommendtableview removeFromSuperview];
    _Recommendtableview = nil;
}

#pragma -mark  创建头部  轮播图+菜单栏+标题+返回
-(void)creatscrollow{
    
    self.HeaderView = [[UIView alloc]init];
    self.HeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.HeaderView];
    [self.HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.view).with.offset(0);
        make.left.equalTo (self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight));
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//ios7 之后必写这句不然图片会跑出范围
    self.imageArr = @[@"餐饮美食",@"美容美发",@"服饰鞋包",@"休闲娱乐",@"百货超市",@"生活服务",@"电子通讯",@"汽车服务",@"医疗保健",@"家居建材",@"教育培训",@"酒店宾馆"];
    yjlScroll           = [[YJLScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 194)];
    yjlScroll.imageArr  = self.imageArr;
    yjlScroll.delegate  = self;
    [self.HeaderView addSubview:yjlScroll];
    
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
    self.titlelab.text          = @"推荐店铺";
    [self.HeaderView addSubview:self.titlelab];
    [self.HeaderView bringSubviewToFront:self.titlelab];
    
    for (NSInteger i = 0; i <[[Cityarea shareCityData] getAllCityarea].count; i++) {
        Cityareamodel *model  = [[[Cityarea shareCityData] getAllCityarea] objectAtIndex:i];
        [self.Regionaname addObject:model.Cityareaname];
        [self.Regionaid   addObject:model.Cityareaid];
    }
    //    一级菜单
    self.Rent       = @[@"租金选店",@"1千5以下",@"1千5-3千",@"3千-6千",@"6千-1万",@"1万-3万",@"3万以上"];
    self.Area       = @[@"合适面积",@"30m²以下",@"31～60m²",@"61～100m²",@"101～150m²",@"151～200m²",@"201～300m²",@"301～500m²",@"500m²以上"];
    self.Type       = @[@"经营行业",@"餐饮美食",@"美容美发",@"服饰鞋包",@"休闲娱乐",@"百货超市",@"生活服务",@"电子通讯",@"汽车服务",@"医疗保健",@"家居建材",@"教育培训",@"酒店宾馆"];
    
    self.Rentid =@[@"00000",@"0~1500",@"1500~3000",@"3000~6000",@"6000~100000",@"10000~30000",@"30000~500000",];
    self.Typeid = @[@"00000",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    self.Areaid =@[@"00000",@"0~30",@"30~60",@"60~100",@"100~150",@"150~200",@"200~300",@"300~500",@"500~50000"];
    
    //    🔘位置
    yjlmenu = [[YJLMenu alloc] initWithOrigin:CGPointMake(0, 194) andHeight:50];
    yjlmenu.delegate      = self;
    yjlmenu.dataSource    = self;
    [self.HeaderView  addSubview:yjlmenu];
    
    self.Fold = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.Fold setTitle:@"惊喜在这里哦" forState:UIControlStateNormal];

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
    [self.Recommendtableview setHidden:NO];
}

#pragma -mark 图片点击事件
-(void)yjlScrollViewDelegate:(YJLScrollView *)faceview didSelectindex:(NSInteger)index{
    
    NSLog(@"第%ld个图",index);
}

#pragma -mark创建tableview
-(void)creattableview{
    
    self.Recommendtableview               = [[UITableView alloc]init];
    self.Recommendtableview.delegate      = self;
    self.Recommendtableview.dataSource    = self;
    self.Recommendtableview.backgroundColor   = [UIColor whiteColor];
    self.Recommendtableview.tableFooterView   = [UIView new];
    [self.view addSubview:self.Recommendtableview];
    [self.Recommendtableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.top.equalTo (self.view).with.offset(244);
            make.left.equalTo (self.view).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-244));
    }];
    
    //    无数据的提示
    self.BGlab                  = [[UILabel alloc]init  ];
    [self.Recommendtableview addSubview:self.BGlab      ];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor   ];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES                           ];        //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.Recommendtableview);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

#pragma -mark UIScrollViewdelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.Recommendtableview) {
       
    CGFloat offset = scrollView.contentOffset.y;
//    NSLog(@"只要view有滚动=%f",offset);
        if (offset <= 0) {
            
            [self.HeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo (self.view).with.offset(0);
                make.left.equalTo (self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight));
            }];
            
            [self.Recommendtableview mas_remakeConstraints:^(MASConstraintMaker *make) {
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
            
            [self.Recommendtableview mas_remakeConstraints:^(MASConstraintMaker *make) {
                
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
        
        [self.Recommendtableview mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo (self.view).with.offset(70);
            make.left.equalTo (self.view).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-70));
        }];
      }
    }else{
        
        NSLog(@"广告图广告图广告图广告图广告图广告图广告图");
    }
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
    
    [self.Recommendtableview setHidden:YES];//重要的特效点1
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

- (void)menu:(YJLMenu *)menu didSelectRowAtIndexPath:(YJLIndexPath *)indexPath{
    
  [self.Recommendtableview setHidden:NO];//重要的特效点2
    if (indexPath.item >= 0)   //有二级菜单
    {
        NSLog(@"点击了 %ld列 - 第%ld栏（一级） - %ld栏（二级）",indexPath.column+1,indexPath.row + 1,indexPath.item+1);
    }
    //没有二级菜单
    else {
        NSLog(@"点击了 %ld列 - 第%ld栏（一级）",indexPath.column+1,indexPath.row+1);
        switch (indexPath.column+1){
            case 1:{
                valuestr1   = self.Regionaname[indexPath.row];
                valuestr1id = self.Regionaid[indexPath.row];
                NSLog(@"获取值区域 = %@",valuestr1);
                NSLog(@"获取值区域id = %@",valuestr1id);
            }
                break;
            case 2:{
                valuestr2   = self.Rent[indexPath.row];
                NSLog(@"获取值租金 = %@",valuestr2);
                valuestr2id = self.Rentid[indexPath.row];
                NSLog(@"获取值租金id = %@",valuestr2id);
            }
                break;
            case 3:{
                valuestr3   = self.Type[indexPath.row];
                NSLog(@"获取值行业 = %@",valuestr3);
                valuestr3id = self.Typeid[indexPath.row];
                NSLog(@"获取值行业id = %@",valuestr3id);
            }
                break;
                
            case 4:{
                valuestr4   = self.Area[indexPath.row];
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
    
    _path = [NSString stringWithFormat:@"&dityour=%@&rent=%@&type=%@&area=%@",value1,value2,value3,value4];
    NSLog(@"拼接字符串%@",_path);
    [self loaddataUPtodown];
   
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    [self backback];
}

#pragma -mark  返回
- (void)Clickback{
    [self backback];
}

#pragma  -mark - 返回方法
-(void)backback{
    
    NSLog(@"点击了想回去");
    if(self.task) {
        [self.Recommendtableview.mj_header endRefreshing];
        [self.task cancel];//取消当前界面的数据请求.
       
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma mark 当前导航栏出现？不出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

}

@end
