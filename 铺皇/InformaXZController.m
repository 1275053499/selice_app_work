//
//  InformaXZController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "InformaXZController.h"
@interface InformaXZController ()<UITableViewDelegate,UITableViewDataSource>{
    int  PHpage;
}
@property   (nonatomic, strong) UITableView     *   InformaXZtableView;
@property   (nonatomic, strong) UILabel         *   BGlab;          //无网络提示语
@property   (nonatomic, strong) NSMutableArray  *   PHArr; //存储数据

@end

@implementation InformaXZController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor   = [UIColor whiteColor];
    _PHArr              = [[NSMutableArray alloc]init];
    self.title = @"我的选址发布";
    [self creattableview];
    [self refresh];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
}



#pragma mark 网络检测
-(void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
//        NSLog(@"status=%ld",status);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [self loaddataXZ         ];
        }
        else{
            NSLog(@"网络繁忙");
        }
    }];
  
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
    self.InformaXZtableView.mj_header = header;
     [self.InformaXZtableView.mj_header beginRefreshing];
#pragma  -mark上拉加载获取网络数据
    self.InformaXZtableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上一个第%d页",PHpage       );
        PHpage++;
        [self loaddatamoreXZ];
    }];
    
}

#pragma -mark 上啦加载新数据
-(void)loaddatamoreXZ{
    
    [self.BGlab setHighlighted:YES];
    NSLog(@"即将下来刷新数据数组当前有%ld个数据",_PHArr.count);
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSDictionary *params = @{
                             @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                             @"page":[NSString stringWithFormat:@"%d",PHpage]
                             };
    
    [manager POST:InformaCZpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Lsp～出租发布～ 🐷,赶紧加载数据啦");
        [YJLHUD dismissWithDelay:1];
        NSLog(@"请求成功咧");
        NSLog(@"数据:%@", responseObject[@"data"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            
            for (NSDictionary *dic in responseObject[@"data"]){
                
                InformaXZmodel *model = [[InformaXZmodel alloc]init];
                model.InfoXZ_title      = dic[@"title"      ];
                model.InfoXZ_time       = dic[@"time"       ];
                model.InfoXZ_quyu       = dic[@"search"     ];
                model.InfoXZ_type       = dic[@"type"       ];
                model.InfoXZ_area       = dic[@"areas"      ];
                model.InfoXZ_rent       = dic[@"rent"       ];
                model.InfoXZ_subid      = dic[@"id"         ];
                model.InfoXZ_shenhe     = dic[@"shenhe"];
                [model setValuesForKeysWithDictionary:dic   ];
                [_PHArr addObject:model];
            }
            
            NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr.count);
            [self.BGlab setHidden:YES];
        }
        
        else{

            //code 305
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
             [self.InformaXZtableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.InformaXZtableView reloadData];
        [self.InformaXZtableView.mj_header endRefreshing];//停止刷新
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error=====%@",error);
        [self.BGlab setHighlighted:NO];
        [self.InformaXZtableView.mj_header endRefreshing];//停止刷新
        
        [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:1];
    }];
}

#pragma  -mark下拉刷新
-(void)loaddataXZ{
    [self.InformaXZtableView.mj_footer resetNoMoreData];
    PHpage = 0;
    [self.BGlab setHighlighted:YES];
//    NSLog(@"即将下来刷新数据数组当前有%ld个数据",_PHArr.count);
    
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSDictionary *params = @{
                                     @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser]
                             };
    
    [manager POST:InformaXZpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Lsp～选址发布～ 🐷,赶紧加载数据啦3333333");
        [_PHArr removeAllObjects];
        [YJLHUD showSuccessWithmessage:@"加载成功"];
        [YJLHUD dismissWithDelay:1];
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
      
            for (NSDictionary *dic in responseObject[@"data"]){

                InformaXZmodel *model = [[InformaXZmodel alloc]init];
                model.InfoXZ_title      = dic[@"title"      ];
                model.InfoXZ_time       = dic[@"time"       ];
                model.InfoXZ_quyu       = dic[@"search"     ];
                model.InfoXZ_type       = dic[@"type"       ];
                model.InfoXZ_area       = dic[@"areas"      ];
                model.InfoXZ_rent       = dic[@"rent"       ];
                model.InfoXZ_subid      = dic[@"id"         ];
                model.InfoXZ_shenhe     = dic[@"shenhe"];
                [model setValuesForKeysWithDictionary:dic   ];
                [_PHArr addObject:model];

            }
//            NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr.count);
            [self.BGlab setHidden:YES];
        }
        else{
            
            //code 305
            NSLog(@"不可以拿到数据的");
            [self.BGlab setHidden:NO];
            self.BGlab.text = @"没有更多数据哦～";
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
             [self.InformaXZtableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.InformaXZtableView reloadData];
        [self.InformaXZtableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误信息:%@",error);
        NSLog(@"错误码:%ld",error.code);

        [self.BGlab setHighlighted:NO];
        [self.InformaXZtableView.mj_header endRefreshing];//停止刷新
        [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:1];
    }];
}

#pragma - mark 创建tabliview  & 无网络背景
- (void)creattableview{
    
    //    创建tableview列表
    self.InformaXZtableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.InformaXZtableView.delegate        = self;
    self.InformaXZtableView.dataSource      = self;
    self.InformaXZtableView.backgroundColor = [UIColor clearColor];
    self.InformaXZtableView.tableFooterView = [UIView new];
    [self.view addSubview:self.InformaXZtableView];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.InformaXZtableView addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.InformaXZtableView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.InformaXZtableView.frame = self.view.bounds;
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
    cell.InformaXZtitle.text= model.InfoXZ_title;
    cell.InformaXZtime.text = [NSString stringWithFormat:@"发布时间:%@", model.InfoXZ_time];
    cell.InformaXZquyu.text = model.InfoXZ_quyu;
    cell.InformaXZtype.text = [NSString stringWithFormat:@"%@",    model.InfoXZ_type];//model.InfoXZ_type;
    cell.InformaXZarea.text = [NSString stringWithFormat:@"%@m²",  model.InfoXZ_area];//model.InfoXZ_area;
    cell.InformaXZrent.text = [NSString stringWithFormat:@"%@元/月",model.InfoXZ_rent];//model.InfoXZ_rent;
    switch ([model.InfoXZ_shenhe integerValue]) {
            
        case 0:{
            cell.InformaXZshenhe.text = @"审核中";
            cell.InformaXZshenhe.textColor = kTCColor(255, 0, 0);
        }
            break;
        case 1:{
            cell.InformaXZshenhe.text = @"服务中";
            cell.InformaXZshenhe.textColor = kTCColor(77, 166, 214);
        }
            break;
        case 2:{
            cell.InformaXZshenhe.text = @"审核失败";
            cell.InformaXZshenhe.textColor = kTCColor(255, 0, 0);
        }
            break;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"第%ld大段==第%ld行",indexPath.section,indexPath.row);
    InformaXZmodel *model = [_PHArr objectAtIndex:indexPath.row];
    NSLog(@"店铺🆔:%@",model.InfoXZ_subid);
    switch ([model.InfoXZ_shenhe integerValue]) {
        case 0:{
        #pragma mark -       "审核中";
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情",@"删除信息"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                              
                                                                              
                                                                              ShopsiteXQController *ctl =[[ShopsiteXQController alloc]init];
                                                                              InformaXZmodel *model =[_PHArr objectAtIndex:indexPath.row];
                                                                              ctl.shopsubid = model.InfoXZ_subid;
                                                                              
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                              
                                                                          case 1:{
                                                                              
                                                                              NSLog(@"删除信息");
                                                                              [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"删除信息中..."];
                                                                              AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                                                                              manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                                                                              manager.requestSerializer.timeoutInterval = 10.0;
                                                                            
                                                                              
                                                                              NSDictionary *params = @{
                                                                                                           @"shopid":model.InfoXZ_subid
                                                                                                       };
                                                                              NSLog(@"店铺🆔:%@",model.InfoXZ_subid);
                                                                              [manager GET: InformaXZDEpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                  
                                                                                  NSLog(@"数据:%@", responseObject);
                                                                                  
                                                                                  if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                                                                                      NSLog(@"成功删除");
                                                                                    
                                                                                      [YJLHUD showSuccessWithmessage:@"删除成功"];
                                                                                      [YJLHUD dismissWithDelay:2];
                                                                                      [_PHArr removeObjectAtIndex:indexPath.row];
                                                                                  
                                                                                      [self.InformaXZtableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                                                                                  }
                                                                                  else{
                                                                                      
                                                                                      //code 305
                                                                                      NSLog(@"失败删除");
                                                                                     
                                                                                      [YJLHUD showErrorWithmessage:@"删除失败"];
                                                                                      [YJLHUD dismissWithDelay:2];
                                                                                  }
                                                                                  
                                                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                  
                                                                                  NSLog(@"error=====%@",error);
                                                                                 
                                                                                  [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
                                                                                  [YJLHUD dismissWithDelay:2];
                                                                                  
                                                                              }];
                                                                          }
                                                                              break;
                                                                              
                                                                      }
                                                                  }];
            [actionSheet show];
            
        }
            
            break;
        case 1:{
          #pragma mark -   "服务中";
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                              
                                                                             
                                                                              ShopsiteXQController *ctl =[[ShopsiteXQController alloc]init];
                                                                              InformaXZmodel *model =[_PHArr objectAtIndex:indexPath.row];
                                                                              ctl.shopsubid = model.InfoXZ_subid;
                                                                            
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                              
                                                                         
                                                                      }
                                                                  }];
            [actionSheet show];
            
        }
            break;
       
        case 2:{
            //           "审核失败";
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情",@"删除信息"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                    
                                                                              ShopsiteXQController *ctl =[[ShopsiteXQController alloc]init];
                                                                              InformaXZmodel *model =[_PHArr objectAtIndex:indexPath.row];
                                                                              ctl.shopsubid = model.InfoXZ_subid;
                                                                             
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                              
                                                                          case 1:{
                                                                              
                                                                              NSLog(@"删除信息");
                                                                             [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"删除信息中..."];
                                                                              AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                                                                              manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                                                                              manager.requestSerializer.timeoutInterval = 10.0;
                                                                            
                                                                              
                                                                              NSDictionary *params = @{
                                                                                                       @"shopid":model.InfoXZ_subid
                                                                                                       };
                                                                              NSLog(@"店铺🆔:%@",model.InfoXZ_subid);
                                                                              [manager GET: InformaXZDEpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                  
                                                                                  NSLog(@"数据:%@", responseObject);
                                                                                  
                                                                                  if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                                                                                      NSLog(@"成功删除");
                                                                                     
                                                                                    
                                                                                      [YJLHUD showSuccessWithmessage:@"删除成功"];
                                                                                      [YJLHUD dismissWithDelay:2];
                                                                                      //                                                                                      删除成功刷新页面
                                                                                      [_PHArr removeObjectAtIndex:indexPath.row];
                                                                                      [self.InformaXZtableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                                                                                  }
                                                                                  else{
                                                                                      
                                                                                      //code 305
                                                                                      NSLog(@"失败删除");
                                                                                     
                                                                                      [YJLHUD showErrorWithmessage:@"删除失败"];
                                                                                      [YJLHUD dismissWithDelay:2];
                                                                                  }
                                                                                  
                                                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                  
                                                                                  NSLog(@"error=====%@",error);
                                                                                 
                                                                                  [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
                                                                                  [YJLHUD dismissWithDelay:2];
                                                                                  
                                                                              }];
                                                                              
                                                                          }
                                                                              break;
                                                                      }
                                                                  }];
            [actionSheet show];
        }
            break;
 

    }
}

@end
