//
//  InformaZRController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "InformaZRController.h"

@interface InformaZRController ()<UITableViewDelegate,UITableViewDataSource>{
       int  PHpage;
}
@property   (strong, nonatomic) UITableView     *   InformaZRtableView;
@property   (nonatomic, strong) UILabel         *   BGlab;          //无网络提示语
@property   (nonatomic, strong) NSMutableArray  *   PHArr;          //存储数据

@end

@implementation InformaZRController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的转让发布";
    self.view.backgroundColor =[UIColor whiteColor];
    _PHArr              = [[NSMutableArray alloc]init];

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
        NSLog(@"status=%ld",status);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [self loaddataZR];
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
    self.InformaZRtableView.mj_header       = header;
    [self.InformaZRtableView.mj_header beginRefreshing];
    
#pragma  -mark上拉加载获取网络数据
    self.InformaZRtableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上一个第%d页",PHpage       );
        PHpage++;
        [self loaddatamoreZR];
    }];
}

#pragma -mark 上啦加载新数据
-(void)loaddatamoreZR{
    
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
    [manager POST: InformaZRpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"入境:%@",InformaZRpath);
    
        [YJLHUD dismissWithDelay:1];
//        NSLog(@"请求成功咧");
//        NSLog(@"数据:%@", responseObject[@"data"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            
            for (NSDictionary *dic in responseObject[@"data"]){
                
                informaZRmodel *model = [[informaZRmodel alloc]init];
                model.InfoZR_picture    = dic[@"images"];
                model.InfoZR_title      = dic[@"title"      ];
                model.InfoZR_time       = dic[@"time"       ];
                model.InfoZR_subid      = dic[@"id"         ];
                model.InfoZR_shenhe     = dic[@"shenhe"];
                [model setValuesForKeysWithDictionary:dic];
                [_PHArr addObject:model];
            }
            
//            NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr.count);
            [self.BGlab setHidden:YES];
             [self.InformaZRtableView.mj_footer endRefreshing];//停止刷新
        }
        
        else{
            
            //code 309
            NSLog(@"不可以拿到数据的");
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:2];
             PHpage --;
            [self.InformaZRtableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.InformaZRtableView reloadData];
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.InformaZRtableView.mj_header endRefreshing];//停止刷新
        [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:2];
    }];
}

#pragma  -mark下拉刷新
-(void)loaddataZR{
    [self.InformaZRtableView.mj_footer resetNoMoreData];
    PHpage = 0;
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
  [manager POST: InformaZRpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
      NSLog(@"入境:%@",InformaZRpath);
//      NSLog(@"Lsp～转让发布～ 🐷,赶紧加载数据啦");
      [_PHArr removeAllObjects];
      [YJLHUD showSuccessWithmessage:@"加载成功"];
      [YJLHUD dismissWithDelay:1];
//      NSLog(@"请求成功咧");
//      NSLog(@"数据:%@", responseObject[@"data"]);
      if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
          NSLog(@"可以拿到数据的");
          
          for (NSDictionary *dic in responseObject[@"data"]){
                      
                      informaZRmodel *model = [[informaZRmodel alloc]init];
                      model.InfoZR_picture    = dic[@"images"];
                      model.InfoZR_title      = dic[@"title"      ];
                      model.InfoZR_time       = dic[@"time"       ];
                      model.InfoZR_subid      = dic[@"id"         ];
                      model.InfoZR_shenhe     = dic[@"shenhe"];
                      [model setValuesForKeysWithDictionary:dic];
                      [_PHArr addObject:model];
                  }
      
//                  NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr.count);
                  [self.BGlab setHidden:YES];
              }
      
              else{
                  
                  //code 309
                  NSLog(@"不可以拿到数据的");
                  [self.BGlab setHidden:NO];
                  self.BGlab.text = @"没有更多数据";
                  [YJLHUD showErrorWithmessage:@"没有更多数据"];
                  [YJLHUD dismissWithDelay:2];
                  [self.InformaZRtableView.mj_footer endRefreshingWithNoMoreData];
              }
      
          [self.InformaZRtableView reloadData];
          [self.InformaZRtableView.mj_header endRefreshing];//停止刷新
      
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
      NSLog(@"error=====%@",error);
      [self.BGlab setHidden:NO];
       self.BGlab.text = @"网络数据连接失败";
      [self.InformaZRtableView.mj_header endRefreshing];//停止刷新
      [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
      [YJLHUD dismissWithDelay:2];
  }];
}

#pragma - mark 创建tabliview  & 无网络背景
- (void)creattableview{
    
//    创建tableview列表
    self.InformaZRtableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.InformaZRtableView.delegate        = self;
    self.InformaZRtableView.dataSource      = self;
    self.InformaZRtableView.backgroundColor = [UIColor clearColor];
    self.InformaZRtableView.tableFooterView = [UIView new];
    [self.view addSubview:self.InformaZRtableView];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.InformaZRtableView addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                           //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.InformaZRtableView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.InformaZRtableView.frame = self.view.bounds;
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
    InformaZRCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"InformaZRCell" owner:self options:nil]lastObject];
    }
    
    /*
     0 待审核中
     1 审核通过 （显示）
     2 推荐
     3 成交
     4 审核失败
     5 下架
     */
    informaZRmodel *model = [_PHArr objectAtIndex:indexPath.row];
    [cell.InformaZRimgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.InfoZR_picture]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
    cell.InformaZRtitle.text = [NSString stringWithFormat:@"%@",model.InfoZR_title];
    cell.InformaZRtime.text =  [NSString stringWithFormat:@"发布时间:%@",model.InfoZR_time];
    switch ([model.InfoZR_shenhe integerValue]) {
        case 0:{
            cell.InformaZRshenhe.text = @"审核中";
            cell.InformaZRshenhe.textColor = kTCColor(255, 0, 0);
        }
            break;
        case 1:{
            cell.InformaZRshenhe.text = @"服务中";
             cell.InformaZRshenhe.textColor = kTCColor(77, 166, 214);
        }
            break;
        case 2:{
            cell.InformaZRshenhe.text = @"推荐";
            cell.InformaZRshenhe.textColor = kTCColor(214, 79, 149);
        }
            break;
        case 3:{
            cell.InformaZRshenhe.text = @"成交";
            cell.InformaZRshenhe.textColor = kTCColor(51, 51, 51);
        }
            break;
        case 4:{
            cell.InformaZRshenhe.text = @"审核失败";
             cell.InformaZRshenhe.textColor = kTCColor(255, 0, 0);
        }
            break;
        case 5:{
            cell.InformaZRshenhe.text = @"下架产品";
            cell.InformaZRshenhe.textColor = kTCColor(153, 153, 153);
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"第%ld大段==第%ld行",indexPath.section,indexPath.row);
    informaZRmodel *model = [_PHArr objectAtIndex:indexPath.row];
     NSLog(@"店铺🆔:%@",model.InfoZR_subid);
    switch ([model.InfoZR_shenhe integerValue]) {
        case 0:{
#pragma -mark       "审核中";
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情",@"删除信息"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                              
                                                                             
                                                                              DetailedController *ctl =[[DetailedController alloc]init];
                                                                              ctl.shopsubid =model.InfoZR_subid;
                                                                              ctl.shopcode = @"transfer";
                                                                             
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                              
                                                                          case 1:{
                                                                              
                                                                              NSLog(@"删除信息");
                                                                        
                                                                              [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"正在删除～"];
                                                                              
                                                                            
                                                                              
                                                                              AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                                                                              manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                                                                              manager.requestSerializer.timeoutInterval = 10.0;
                                                                              
                                                                              NSDictionary *params = @{
                                                                                                           @"shopid":model.InfoZR_subid
                                                                                                       };
                                                                              NSLog(@"店铺🆔:%@",model.InfoZR_subid);
                                                                              [manager GET: InformaZRDEpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                             
                                                                                  NSLog(@"数据:%@", responseObject);
                                                                                  
                                                                                  if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                                                                                      NSLog(@"成功删除");
                                                                                      
                                                                                          [YJLHUD showSuccessWithmessage:@"删除成功"];
                                                                                      
                                                                            [YJLHUD dismissWithDelay:2.0];
                                                                                      
                                                                                      [_PHArr removeObjectAtIndex:indexPath.row];
                                                                                      
                                                                                      //    [self.tableView reloadData];
                                                                                      [self.InformaZRtableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                                                                                      
                                                                                  }
                                                                                  else{
                                                                                      
                                                                                      //code 305
                                                                                      NSLog(@"失败删除");
                                                                                      [YJLHUD showErrorWithmessage:@"删除失败"];
                                                                                      [YJLHUD dismissWithDelay:2.0f];
                                                                                  
                                                                                  }
                                                                                  
                                                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                  
                                                                                  NSLog(@"error=====%@",error);
                                                                                 
                                                        
                                                                                  [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
                                                                                  [YJLHUD dismissWithDelay:2.0f];
                                                                              }];
                                                                          }
                                                                              break;
                                                                              
                                                         
                                                                      }
                                                                  }];
            [actionSheet show];
        }
            
            break;
        case 1:{
#pragma -mark  "服务中";
//            0 待审核中
//            1 审核通过 （显示）
//            2 推荐
//            3 成交
//            4 审核失败
//            5 下架
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情",@"服务状态",@"下架信息"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                              
                                                                              
                                                                              DetailedController *ctl =[[DetailedController alloc]init];
                                                                              ctl.shopsubid =model.InfoZR_subid;
                                                                              ctl.shopcode = @"transfer";
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                              
                                                                          case 1:{
                                                                              
                                                                              NSLog(@"查看服务");
                                                                             
                                                                              OpenController *ctl =[[OpenController alloc]init];
                                                                              ctl.shopid = model.InfoZR_subid;
                                                                              
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                              
                                                                          }
                                                                              break;
                                                                          case 2:{
                                                                              [LEEAlert alert].config
                                                                              
                                                                              .LeeAddTitle(^(UILabel *label) {
                                                                                  
                                                                                  label.text = @"警告信息";
                                                                                  
                                                                                  label.textColor = [UIColor blackColor];
                                                                              })
                                                                              .LeeAddContent(^(UILabel *label) {
                                                                                  
                                                                                  label.text = @"用户需知:店铺下架成功会清空套餐时间，您可以在我的服务-服务记录中查看或者续约店铺";
                                                                                  label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
                                                                              })
                                                                              
                                                                              .LeeAddAction(^(LEEAction *action) {
                                                                                  
                                                                                  action.type = LEEActionTypeCancel;
                                                                                  
                                                                                  action.title = @"下架";
                                                                                  
                                                                                  action.titleColor = kTCColor(255, 255, 255);
                                                                                  
                                                                                  action.backgroundColor = kTCColor(174, 174, 174);
                                                                                  
                                                                                  action.clickBlock = ^{
                                                                                      
                                                                   [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"正在下架"];
                                                                                      AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                                                                                                                                                                    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                                                                                                                                                                    manager.requestSerializer.timeoutInterval = 10.0;
                                                                                
                                                                                                                                                            NSDictionary *params = @{
                                                                                                                                                                                             @"shopid":model.InfoZR_subid
                                                                                                                                                                                             };
                                                                                                                                                                    NSLog(@"店铺🆔:%@",model.InfoZR_subid);
                                                                                                                                                                    [manager GET: InformaZRoverpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                                                                     NSLog(@"数据:%@", responseObject);
                                                                                      
                                                                                                            if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                                                                                                                                                                            NSLog(@"下架成功～");
                                                                                                                
                                                                                  [YJLHUD showSuccessWithmessage:@"下架成功"];
                                                                                                                [YJLHUD dismissWithDelay:2.0];
                                                                                                                
                                                                                                                                                                            //                                                                                      下载成功刷新页面
                                                                                                            [self loaddataZR];
                                                         }
                                                                                                          else{
                                                                                                          //code 305
                                                                                                                                                            NSLog(@"失败下架");
                                                                                                              [YJLHUD showErrorWithmessage:@"下架失败"];
                                                                                                              [YJLHUD dismissWithDelay:2.0];
                                                                                                              
                                                                                                                                                                        }
                                                                                      
                                                                                                                                                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                      
                                                                                                                                                                        NSLog(@"error=====%@",error);
                                                                                                                                                                        [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
                                                                                                                                                                        [YJLHUD dismissWithDelay:2.0];
                                                                                                                                                                        
                                                                                                }];
                                                                                  };
                                                                              })
                                                                              
                                                                              .LeeAddAction(^(LEEAction *action) {
                                                                                  
                                                                                  action.type = LEEActionTypeDefault;
                                                                                  
                                                                                  action.title = @"取消";
                                                                                  
                                                                                  action.titleColor = kTCColor(255, 255, 255);
                                                                                  
                                                                                  action.backgroundColor = kTCColor(77, 166, 214);
                                                                                  
                                                                                  action.clickBlock = ^{
                                                                                      
                                                                                  };
                                                                              })
                                                                              .LeeHeaderColor(kTCColor(255, 255, 255))
                                                                              .LeeShow();
                                                                              
                                                                          }
                                                                              break;
                                                                      }
                                                                  }];
            [actionSheet show];
        }
            break;
        case 2:{
            #pragma -mark    推荐;
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                              
                                                                              
                                                                              DetailedController *ctl =[[DetailedController alloc]init];
                                                                              ctl.shopsubid =model.InfoZR_subid;
                                                                              ctl.shopcode = @"transfer";
                                                                             
                                                                          }
                                                                              break;
                                                                      }
                                                                  }];
            [actionSheet show];
            
        }break;
            
        case 3:{
            #pragma -mark    成交;
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                              
                                                                              DetailedController *ctl =[[DetailedController alloc]init];
                                                                              ctl.shopsubid =model.InfoZR_subid;
                                                                              ctl.shopcode = @"transfer";
                                                                              
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                      }
                                                                  }];
            [actionSheet show];
            
        }break;
            
        case 4:{
#pragma -mark    "审核失败";
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情",@"删除信息"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                              
                                                                             
                                                                              DetailedController *ctl =[[DetailedController alloc]init];
                                                                              ctl.shopsubid =model.InfoZR_subid;
                                                                              ctl.shopcode = @"transfer";
                                                                              
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                              
                                                                          case 1:{
                                                                              
                                                                              NSLog(@"删除信息");
                                                                             [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"删除信息"];
                                                                              AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                                                                              manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                                                                              manager.requestSerializer.timeoutInterval = 10.0;
                                                                        
                                                                              
                                                                              NSDictionary *params = @{
                                                                                                       @"shopid":model.InfoZR_subid
                                                                                                       };
                                                                              NSLog(@"店铺🆔:%@",model.InfoZR_subid);
                                                                              [manager GET: InformaZRDEpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                  
                                                                                  NSLog(@"数据:%@", responseObject);
                                                                                  
                                                                                  if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                                                                                      NSLog(@"成功删除");
                                                                                      [YJLHUD showSuccessWithmessage:@"删除成功～"];
                                                                                      [YJLHUD dismissWithDelay:2];
//                                                                                      删除成功刷新页面
                                                                                      [_PHArr removeObjectAtIndex:indexPath.row];
                                                                                      [self.InformaZRtableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                                                                                  }
                                                                                  
                                                                                  else{
                                                                                      
                                                                                      //code 305
                                                                                      NSLog(@"失败删除");
                                                                                      [YJLHUD showErrorWithmessage:@"删除失败～"];
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
        case 5:{
#pragma -mark 下架产品
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"查看详情"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      NSLog(@"%zd", index);
                                                                      switch (index) {
                                                                          case 0:{
                                                                              
                                                                              DetailedController *ctl =[[DetailedController alloc]init];
                                                                              ctl.shopsubid =model.InfoZR_subid;
                                                                              ctl.shopcode = @"transfer";
                                                                              
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                      }
                                                                  }];
            [actionSheet show];
            
        }break;
            
        default:{
            
        }
            break;
    }
    
}


@end
