//
//  CZfinishController.m
//  铺皇
//
//  Created by selice on 2017/11/3.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "CZfinishController.h"

@interface CZfinishController ()<UITableViewDelegate,UITableViewDataSource>
@property   (nonatomic, strong) UITableView        *   CZfinishtableView;
@property   (nonatomic, strong) UILabel            *   BGlab;          //无网络提示语
@property   (nonatomic, strong) NSMutableArray     *   PHArr;          //存储数据

@end

@implementation CZfinishController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor =[UIColor whiteColor];
    _PHArr              = [[NSMutableArray alloc]init];
    [self creattableview];
    [self refresh];

}

#pragma mark 网络检测
-(void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        NSLog(@"status=%ld",status);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [self loaddataCZ];
        }
        else{
            NSLog(@"网络繁忙");
        }
    }];
}
#pragma mark - 刷新数据
- (void)refresh{
    
#pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reachability)];
    
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
    self.CZfinishtableView.mj_header       = header;
    [self.CZfinishtableView.mj_header beginRefreshing];
}

#pragma  -mark下拉刷新
-(void)loaddataCZ{
    
    [self.BGlab setHighlighted:YES];
    NSLog(@"即将下来刷新数据数组当前有%ld个数据",_PHArr.count);
     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    NSDictionary *params = @{
                             
                                 @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                             
                             };
    [manager GET: MyCZfinishpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"入境:%@",MyCZfinishpath);
        [_PHArr removeAllObjects];
        NSLog(@"请求成功咧");
        //      NSLog(@"数据:%@", responseObject[@"data"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            [YJLHUD showWithmessage:@"数据获取成功"];
            [YJLHUD dismissWithDelay:1];
            for (NSDictionary *dic in responseObject[@"data"]){
            
                    Topmodel *model = [[Topmodel alloc]init      ];
                    model.shopquyu           = dic[@"dityour"    ];
                    model.shopid             = dic[@"id"         ];
                    model.shopmainimage      = dic[@"img"        ];
                    model.shopmoneys         = dic[@"moneys"     ];
                    model.shoptime           = dic[@"time"       ];
                    model.shopname           = dic[@"title"      ];
                    model.shoptype           = dic[@"type"       ];
                    [model setValuesForKeysWithDictionary:dic    ];
                    [_PHArr addObject:model                      ];
            }
        }
        
        else{
            
            //code 300
            NSLog(@"不可以拿到数据的");
            [self.BGlab setHidden:NO];
            self.BGlab.text = @"没有更多数据哦～";
          
            [YJLHUD showErrorWithmessage:@"没有更多数据哦"];
            [YJLHUD dismissWithDelay:1];
            
        }
        
        [self.CZfinishtableView reloadData];
        [self.CZfinishtableView.mj_header endRefreshing];//停止刷新
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.BGlab setHidden:NO];
        self.BGlab.text = @"网络数据连接出现问题了,请检查一下";
        [self.CZfinishtableView.mj_header endRefreshing];//停止刷新

        [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
        [YJLHUD dismissWithDelay:1];
        
    }];
}

#pragma - mark 创建tabliview  & 无网络背景
- (void)creattableview{
    
    //    创建tableview列表
    self.CZfinishtableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.CZfinishtableView.delegate        = self;
    self.CZfinishtableView.dataSource      = self;
    self.CZfinishtableView.backgroundColor = [UIColor clearColor];
    self.CZfinishtableView.tableFooterView = [UIView new];
    self.CZfinishtableView.showsVerticalScrollIndicator =
    NO;
    [self.view addSubview:self.CZfinishtableView];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.CZfinishtableView addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                           //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.CZfinishtableView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.CZfinishtableView.frame = self.view.bounds;
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
    //    自定义
    static NSString *cellID = @"cellname";
    Toprightcornercell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"Toprightcornercell" owner:self options:nil]lastObject];
    }
    
    Topmodel *model = [_PHArr objectAtIndex:indexPath.row];
    cell.shopname.text      = model.shopname;
    cell.shoptime.text      = [NSString stringWithFormat:@"发布时间:%@",model.shoptime];
    cell.shopmoneys.text    = [NSString stringWithFormat:@"%@元/月",model.shopmoneys];
    cell.shopquyu.text      = model.shopquyu;
    cell.shoptype.text      = model.shoptype;
    [cell.shopmainimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shopmainimage]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"第%ld大段==第%ld行",indexPath.section,indexPath.row);
        Topmodel *model = [_PHArr objectAtIndex:indexPath.row];
         NSLog(@"店铺🆔:%@",model.shopid);
    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                cancelTitle:@"取消"
                                                           destructiveTitle:nil
                                                                otherTitles:@[@"查看详情",@"续约"]
                                                                otherImages:nil
                                                          selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                              NSLog(@"%zd", index);
                                                              switch (index) {
                                                                  case 0:{
                                                                      
                                                                     
                                                                      DetailedController *ctl =[[DetailedController alloc]init];
                                                                                                                                                    ctl.shopsubid =model.shopid;
                                                                      ctl.shopcode = @"rentout";
                                                                      
                                                                      self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                      [self.navigationController pushViewController:ctl animated:YES];
                                                                      self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                  }
                                                                      break;
                                                                      
                                                                  case 1:{
                                                                      
                                                                      NSLog(@"续约信息");
                                                                      
                                                                      OpenczController *ctl =[[OpenczController alloc]init];
                                                                      ctl.shopczid = model.shopid;
                                                                     
                                                                      self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                      [self.navigationController pushViewController:ctl animated:YES];
                                                                      self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                      
                                                                  }    break;
                                                              }
                                                          }];
    [actionSheet show];
}


@end
