//
//  IntegralReduceController.m
//  铺皇
//
//  Created by selice on 2017/9/28.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "IntegralReduceController.h"

@interface IntegralReduceController ()<UITableViewDelegate,UITableViewDataSource>

@property   (strong, nonatomic) UITableView     *   IntegralReducetableView;//主控件
@property   (nonatomic, strong) UILabel         *   BGlab;                  //无网络提示语
@property   (nonatomic, strong) NSMutableArray  *   interArr;               //存储数据

@end

@implementation IntegralReduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(Back:)];
    self.navigationItem.title = @"消费记录";
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor whiteColor];
    _interArr = [[NSMutableArray alloc]init];
   
    
    [self buildtableview];
    [self loadData];
    [self refresh];
}

-(void)refresh{
    
#pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // Set title
    [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
    [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
    [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font        = [UIFont systemFontOfSize:14];
    // Set textColor
    header.stateLabel.textColor             = kTCColor(161, 161, 161);
    header.lastUpdatedTimeLabel.textColor   = kTCColor(161, 161, 161);
    self.IntegralReducetableView.mj_header  = header;

}


-(void)Back:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)buildtableview{
    if (iOS11) {
         self.IntegralReducetableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    }else{
         self.IntegralReducetableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    }
   
    self.IntegralReducetableView.delegate   =self;
    self.IntegralReducetableView.dataSource = self;
    self.IntegralReducetableView.tableFooterView = [UIView new];
    [self.view addSubview:self.IntegralReducetableView];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.IntegralReducetableView addSubview:self.BGlab];
    self.BGlab.text             = @"当前没有记录";
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:NO];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.IntegralReducetableView);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}

//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    self.IntegralReducetableView.frame = self.view.bounds;
//}

#pragma mark 加载数据
-(void)loadData{
    
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
    NSLog(@"加载数据中.....");
    
        AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
        manager.responseSerializer          = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
       
        
        NSDictionary *params = @{
                                     @"user_id": [[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                                 };
        [manager GET:Myintergalredusepath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
            
            NSLog(@"请求成功咧");
            NSLog(@"数据:%@", responseObject[@"data"]);
            
            if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                NSLog(@"可以拿到数据的");
                 [_interArr removeAllObjects];
                for (NSDictionary *dic in responseObject[@"data"]){
                    
                    Redusemodel *model = [[Redusemodel alloc]init];
                    model.Reducetime            = dic[@"time"];
                    model.Reducetitle           = dic[@"type"      ];
                    model.Reduceintegral        = dic[@"vip_integral"];
                    [model setValuesForKeysWithDictionary:dic];
                    [_interArr addObject:model];
                }
                NSLog(@" 加载后现在总请求到数据有%ld个",_interArr.count);
                [self.BGlab setHidden:YES];
            }
            
            else{
                //code 305
                NSLog(@"不可以拿到数据的");
                [self.BGlab setHidden:NO];
                self.BGlab.text = @"没有消费过积分～";
               
                [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"没有消费过积分～"];
                [YJLHUD dismissWithDelay:2.0f];
            }
            
            [self.IntegralReducetableView reloadData];
            [self.IntegralReducetableView.mj_header endRefreshing];//停止刷新
             [YJLHUD dismiss];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"请求数据失败----%@",error);
            NSLog(@"error=====%@",error);
            [self.BGlab setHighlighted:NO];
            [self.IntegralReducetableView.mj_header endRefreshing];//停止刷新
            [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"网络数据连接失败"];
             [YJLHUD dismissWithDelay:2.0f];
        }];
   
}

#pragma mark - Tableviewdatasource代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _interArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell";
    IntegralReduceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        
        cell  = [[[NSBundle mainBundle]loadNibNamed:@"IntegralReduceCell" owner:self options:nil]lastObject];
    }
    
    Redusemodel *model      = [_interArr objectAtIndex:indexPath.row];
    if ([model.Reducetitle isEqualToString:@"商铺转让"]) {
        cell.Reducetitle.textColor= [UIColor redColor];
        
    }
    else if ([model.Reducetitle isEqualToString:@"商铺出租"]){
        cell.Reducetitle.textColor= [UIColor blueColor];
        
    }else{
        cell.Reducetitle.textColor= [UIColor purpleColor];
    }
    
    cell.Reducetitle.text   = [NSString stringWithFormat:@"%@:",model.Reducetitle];
    cell.Reduceintegral.text= [NSString stringWithFormat:@"%@积分",model.Reduceintegral];
    cell.Reducetime.text    = [NSString stringWithFormat:@"消费时间:%@",model.Reducetime];
    cell.selectionStyle     = UITableViewCellEditingStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

@end
