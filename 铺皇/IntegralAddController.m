//
//  IntegralAddController.m
//  铺皇
//
//  Created by selice on 2017/9/28.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "IntegralAddController.h"

@interface IntegralAddController ()<UITableViewDelegate,UITableViewDataSource>
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property   (strong, nonatomic) UITableView     *   IntegralAddtableView;//主控件
@property   (nonatomic, strong) UILabel         *   BGlab;               //无网络提示语
@property   (nonatomic, strong) NSMutableArray  *   interArr;            //存储数据

@end

@implementation IntegralAddController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(Back:)];
    self.navigationItem.title = @"增值记录";
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor whiteColor];

     _interArr = [[NSMutableArray alloc]init];
    [self buildtableview];
    [self refresh];
    [self loadData];
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
    self.IntegralAddtableView.mj_header       = header;
}

-(void)Back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)buildtableview{

    if (iOS11) {
        self.IntegralAddtableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    }else{
        self.IntegralAddtableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    }
    self.IntegralAddtableView.delegate   =self;
    self.IntegralAddtableView.dataSource = self;
    self.IntegralAddtableView.tableFooterView = [UIView new];
    [self.view addSubview:self.IntegralAddtableView];
    
//    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.IntegralAddtableView addSubview:self.BGlab];
    self.BGlab.text             = @"当前没有记录";
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:NO];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.IntegralAddtableView);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}

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
    [manager GET:Myintergalchargepath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
       
        NSLog(@"请求成功咧");
        NSLog(@"数据:%@", responseObject[@"data"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
             [_interArr removeAllObjects];
            for (NSDictionary *dic in responseObject[@"data"]){
                
                Addmoel*model = [[Addmoel alloc]init];
                model.Addtime            = dic[@"time"      ];
                model.Addtitle           = dic[@"type"      ];
                model.Addintegral        = dic[@"money"     ];
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
            self.BGlab.text = @"没有充值记录～";
            
             [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"没有消费过积分～"];
            [YJLHUD dismissWithDelay:1.f];
        }
        
        [self.IntegralAddtableView reloadData];
        [self.IntegralAddtableView.mj_header endRefreshing];//停止刷新
        [YJLHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        NSLog(@"error=====%@",error);
        [self.BGlab setHighlighted:NO];
        [self.IntegralAddtableView.mj_header endRefreshing];//停止刷新
    
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:1.f];
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
    IntegralAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell  = [[[NSBundle mainBundle]loadNibNamed:@"IntegralAddCell" owner:self options:nil]lastObject];
    }
    
    Addmoel *model      = [_interArr objectAtIndex:indexPath.row];
    if ([model.Addtitle isEqualToString:@"微信"]) {
        cell.Addtitle.textColor = kTCColor(83,201, 40);
    
    }else{
        cell.Addtitle.textColor= kTCColor(71, 152, 223);
    }
    cell.Addtitle.text      = [NSString stringWithFormat:@"%@充值:",model.Addtitle];
    cell.Addintegral.text   = [NSString stringWithFormat:@"%@积分",model.Addintegral];
    cell.Addtime.text       = [NSString stringWithFormat:@"充值时间:%@",model.Addtime];
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
