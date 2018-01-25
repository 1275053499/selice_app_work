//
//  CollectionXZController.m
//  铺皇
//
//  Created by selice on 2017/9/28.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "CollectionXZController.h"

@interface CollectionXZController ()<UITableViewDelegate,UITableViewDataSource>

@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property   (nonatomic, strong) UITableView     *  CollectionXZtableView;
@property   (nonatomic, strong) UILabel         *   BGlab;          //无网络提示语
@property   (nonatomic, strong) NSMutableArray  *   PHArr; //存储数据

@end

@implementation CollectionXZController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    _PHArr             = [[NSMutableArray alloc]init];
    
    [self creattableview];
    [self refresh];

}




#pragma mark - 刷新数据
- (void)refresh{
#pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reachability)];
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
    self.CollectionXZtableView.mj_header = header;
    [self.CollectionXZtableView.mj_header beginRefreshing];
    
}


#pragma mark 网络检测
-(void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            [self loaddataUPtodown         ];
        }else{
            NSLog(@"无连接网络");
        }
        
        NSLog(@"status=%ld",status);
    }];
}
#pragma  -mark下拉刷新
-(void)loaddataUPtodown{
    
    NSLog(@"即将下来刷新数据数组当前有%ld个数据",_PHArr.count);
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
     ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    manager.requestSerializer.timeoutInterval = 10.0;
    NSDictionary *params = @{
                             @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                             };
    
    [manager POST: MycollectXZpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        NSLog(@"Lsp～选址收藏 ～ 🐷,赶紧加载数据啦");
        [_PHArr removeAllObjects];
        [YJLHUD showSuccessWithmessage:@"加载成功"];
        [YJLHUD dismissWithDelay:1];
        NSLog(@"请求成功咧");
        NSLog(@"数据:%@", responseObject[@"data"]);
        NSLog(@"数据:%@", responseObject[@"code"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            
            for (NSDictionary *dic in responseObject[@"data"]){
                
                InformaXZmodel *model = [[InformaXZmodel alloc]init];
                model.InfoXZ_title      = dic[@"title"      ];
                model.InfoXZ_time       = dic[@"time"       ];
                model.InfoXZ_quyu       = dic[@"city"       ];
                model.InfoXZ_type       = dic[@"type"       ];
                model.InfoXZ_area       = dic[@"area"       ];
                model.InfoXZ_rent       = dic[@"rent"       ];
                model.InfoXZ_subid      = dic[@"shopid"     ];
                [model setValuesForKeysWithDictionary:dic   ];
                //                将数据加入数据库中

                [_PHArr addObject:model];
                
            }
            NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr.count);
           

          [self.BGlab setHidden:YES];

        }
        else{
            //code 305
            NSLog(@"不可以拿到数据的");
            [self.BGlab setHidden:NO];
            self.BGlab.text = @"没有收藏过该类店铺";
            [YJLHUD showErrorWithmessage:@"没有收藏过该类店铺"];
            [YJLHUD dismissWithDelay:2];

        }
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.CollectionXZtableView reloadData];
        });
      
        [self.CollectionXZtableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error=====%@",error);
      
        [self.BGlab setHighlighted:NO];
        [self.CollectionXZtableView.mj_header endRefreshing];//停止刷新
        [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:2];
    }];
}

#pragma - mark 创建tabliview  & 无网络背景
- (void)creattableview{
    
    //    创建tableview列表
    self.CollectionXZtableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.CollectionXZtableView.delegate        = self;
    self.CollectionXZtableView.dataSource      = self;
    self.CollectionXZtableView.backgroundColor = [UIColor clearColor];
    self.CollectionXZtableView.tableFooterView = [UIView new];
    [self.view addSubview:self.CollectionXZtableView];
    
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.CollectionXZtableView addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.CollectionXZtableView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.CollectionXZtableView.frame = self.view.bounds;
}

#pragma mark - Tableviewdatasource代理
//几个段落Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//一个段落几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _PHArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //        自定义
    static NSString *cellID = @"cellname";
    InformaXZCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"InformaXZCell" owner:self options:nil]lastObject];
    }
    
    InformaXZmodel *model =[_PHArr objectAtIndex:indexPath.row];
    cell.InformaXZtitle.text = model.InfoXZ_title;
    cell.InformaXZtime.text  = [NSString stringWithFormat:@"收藏时间:%@", model.InfoXZ_time];
    cell.InformaXZquyu.text  = model.InfoXZ_quyu;
    cell.InformaXZtype.text  = [NSString stringWithFormat:@"%@",    model.InfoXZ_type];//model.InfoXZ_type;
    cell.InformaXZarea.text  = [NSString stringWithFormat:@"%@m²",  model.InfoXZ_area];//model.InfoXZ_area;
    cell.InformaXZrent.text  = [NSString stringWithFormat:@"%@元/月",model.InfoXZ_rent];//model.InfoXZ_rent;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第%ld大段==第%ld行",indexPath.section,indexPath.row);
    
    ShopsiteXQController *ctl =[[ShopsiteXQController alloc]init];
    InformaXZmodel *model =[_PHArr objectAtIndex:indexPath.row];
    ctl.shopsubid = model.InfoXZ_subid;
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

@end
