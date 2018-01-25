//
//  InformaZZController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "InformaZZController.h"
@interface InformaZZController ()<UITableViewDelegate,UITableViewDataSource>{
    int  PHpage;
}
@property (nonatomic,strong) UITableView *InformaZZtableView;
@property   (nonatomic, strong) UILabel         *   BGlab;          //无网络提示语
@property   (nonatomic, strong) NSMutableArray  *   PHArr;          //存储数据


@end

@implementation InformaZZController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的出租发布";
    self.view.backgroundColor   =[UIColor whiteColor];
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
            
            [self loaddataCZ         ];
        }
        else{
            
             NSLog(@"网络繁忙");
        }
    }];
}


#pragma mark - 刷新数据
- (void)refresh{
//pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reachability)];
    
    // Set title
    [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
    [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
    [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
    // Set font
    header.stateLabel.font                  = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font        = [UIFont systemFontOfSize:14];
    
    // Set textColor
    header.stateLabel.textColor             = kTCColor(161, 161, 161);
    header.lastUpdatedTimeLabel.textColor   = kTCColor(161, 161, 161);
    self.InformaZZtableView.mj_header       = header;
      [self.InformaZZtableView.mj_header beginRefreshing];
    
#pragma  -mark上拉加载获取网络数据
    self.InformaZZtableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上一个第%d页",PHpage       );
        PHpage++;
        [self loaddatamoreCZ];
    }];
    
}

#pragma -mark 上啦加载新数据
-(void)loaddatamoreCZ{
    
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
        [_PHArr removeAllObjects];
        [YJLHUD showSuccessWithmessage:@"加载成功"];
        [YJLHUD dismissWithDelay:1];
        NSLog(@"请求成功咧");
        NSLog(@"数据:%@", responseObject[@"data"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            
            for (NSDictionary *dic in responseObject[@"data"]){
                
                informaZZmodel *model   = [[informaZZmodel alloc]init];
                model.InfoZZ_picture    = dic[@"images"];
                model.InfoZZ_title      = dic[@"name"];
                model.InfoZZ_time       = dic[@"time"];
                model.InfoZZ_subid      = dic[@"id"];
                model.InfoZZ_shenhe     = dic[@"shenhe"];
                [model setValuesForKeysWithDictionary:dic];
                [_PHArr addObject:model];
            }
            
            NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr.count);
            [self.BGlab setHidden:YES];
        }
        
        else{
            
            //code 305
            NSLog(@"不可以拿到数据的");
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
            PHpage --;
            [self.InformaZZtableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.InformaZZtableView reloadData];
        [self.InformaZZtableView.mj_header endRefreshing];//停止刷新
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error=====%@",error);
        [self.BGlab setHighlighted:YES];
        [self.InformaZZtableView.mj_header endRefreshing];//停止刷新
        
        [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:1];
    }];
}

#pragma  -mark下拉刷新
-(void)loaddataCZ{
    [self.InformaZZtableView.mj_footer resetNoMoreData];
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

    [manager POST:InformaCZpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Lsp～出租发布～ 🐷,赶紧加载数据啦");

         [YJLHUD showSuccessWithmessage:@"加载成功"];
         [YJLHUD dismissWithDelay:1];
        NSLog(@"请求成功咧");
        NSLog(@"数据:%@", responseObject[@"data"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            
            for (NSDictionary *dic in responseObject[@"data"]){
                
                informaZZmodel *model   = [[informaZZmodel alloc]init];
                model.InfoZZ_picture    = dic[@"images"];
                model.InfoZZ_title      = dic[@"name"];
                model.InfoZZ_time       = dic[@"time"];
                model.InfoZZ_subid      = dic[@"id"];
                model.InfoZZ_shenhe     = dic[@"shenhe"];
                [model setValuesForKeysWithDictionary:dic];
                [_PHArr addObject:model];
            }
            
            NSLog(@" 加载后现在总请求到数据有%ld个",_PHArr.count);
            [self.BGlab setHidden:YES];
        }
        
        else{
            
            //code 305
            NSLog(@"不可以拿到数据的");
            [self.BGlab setHidden:NO];
            self.BGlab.text = @"没有更多数据";
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
            [self.InformaZZtableView.mj_footer endRefreshingWithNoMoreData];
        }
         [self.InformaZZtableView.mj_header endRefreshing];//停止刷新
        [self.InformaZZtableView reloadData];
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error=====%@",error);
        [self.BGlab setHighlighted:NO];
        [self.InformaZZtableView.mj_header endRefreshing];//停止刷新
    
        [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:1];
    }];
}


#pragma - mark 创建tabliview
- (void)creattableview{
    
    self.InformaZZtableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.InformaZZtableView.delegate = self;
    self.InformaZZtableView.dataSource = self;
    self.InformaZZtableView.backgroundColor = [UIColor clearColor];
    self.InformaZZtableView.tableFooterView = [UIView new];
    [self.view addSubview:self.InformaZZtableView];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.InformaZZtableView addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.InformaZZtableView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.InformaZZtableView.frame = self.view.bounds;
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
    InformaZZCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"InformaZZCell" owner:self options:nil]lastObject];
    }
    
    informaZZmodel *model = [_PHArr objectAtIndex:indexPath.row];
    [cell.InformaZZimgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.InfoZZ_picture]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
    cell.InformaZZtitle.text    = model.InfoZZ_title;
    cell.InformaZZtime.text     =[NSString stringWithFormat:@"发布时间:%@",model.InfoZZ_time];
    
    switch ([model.InfoZZ_shenhe integerValue]) {
        case 0:{
            cell.InformaZZshenhe.text = @"审核中";
            cell.InformaZZshenhe.textColor = kTCColor(255, 0, 0);
        }
            break;
        case 1:{
            cell.InformaZZshenhe.text = @"服务中";
            cell.InformaZZshenhe.textColor = kTCColor(77, 166, 214);
        }
            break;
        case 2:{
            cell.InformaZZshenhe.text = @"推荐";
            cell.InformaZZshenhe.textColor = kTCColor(214, 79, 149);
        }
            break;
        case 3:{
            cell.InformaZZshenhe.text = @"成交";
            cell.InformaZZshenhe.textColor = kTCColor(51, 51, 51);
        }
            break;
        case 4:{
            cell.InformaZZshenhe.text = @"审核失败";
            cell.InformaZZshenhe.textColor = kTCColor(255, 0, 0);
        }
            break;
        case 5:{
            cell.InformaZZshenhe.text = @"下架产品";
            cell.InformaZZshenhe.textColor = kTCColor(153, 153, 153);
        }
            break;
    }
    cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第%ld大段==第%ld行",indexPath.section,indexPath.row);
    informaZZmodel *model = [_PHArr objectAtIndex:indexPath.row];
    NSLog(@"店铺🆔:%@",model.InfoZZ_subid);
    switch ([model.InfoZZ_shenhe integerValue]) {
        case 0:{
#pragma -mark    "审核中";
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
                                                                              ctl.shopsubid =model.InfoZZ_subid;
                                                                              ctl.shopcode = @"rentout";
                                                                             
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
                                                                                                           @"shopid":model.InfoZZ_subid
                                                                                                       };
                                                                              NSLog(@"店铺🆔:%@",model.InfoZZ_subid);
                                                                              [manager GET: InformaZRDEpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                  
                                                                                  NSLog(@"数据:%@", responseObject);
                                                                                  
                                                                                  if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                                                                                      NSLog(@"成功删除");
                                                                                      
                                                                                       [YJLHUD showSuccessWithmessage:@"删除成功"];
                                                                                      [YJLHUD dismissWithDelay:2];
                                                                                    
                                                                                      [self.InformaZZtableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
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
      #pragma -mark            "服务中";
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
                                                                                  ctl.shopsubid =model.InfoZZ_subid;
                                                                                  ctl.shopcode = @"rentout";
                                                                              
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                              
                                                                          case 1:{
                                                                              
                                                                              NSLog(@"查看服务");
                                                                              
                                                                              OpenczController *ctl =[[OpenczController alloc]init];
                                                                              ctl.shopczid = model.InfoZZ_subid;
                                                                             
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                              
                                                                          }
                                                                              break;
                                                                              
                                                                          case 2:{
                                                                              
                                                                              NSLog(@"下架信息");
                                                                              [LEEAlert alert].config
                                                                              
                                                                              .LeeAddTitle(^(UILabel *label) {
                                                                                  
                                                                                  label.text = @"警告信息";
                                                                                  
                                                                                  label.textColor = [UIColor blackColor];
                                                                              })
                                                                              .LeeAddContent(^(UILabel *label) {
                                                                                  
                                                                                  label.text = @"用户需知:店铺下架成功会清空套餐时间，您可以在我的服务中查看或者续约店铺";
                                                                                  label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
                                                                              })
                                                                              
                                                                              .LeeAddAction(^(LEEAction *action) {
                                                                                  
                                                                                  action.type = LEEActionTypeCancel;
                                                                                  
                                                                                  action.title = @"下架";
                                                                                  
                                                                                  action.titleColor = kTCColor(255, 255, 255);
                                                                                  
                                                                                  action.backgroundColor = kTCColor(174, 174, 174);
                                                                                  
                                                                                  action.clickBlock = ^{
                                                                                      
                                                                                          [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"下架中..."];                                                               AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                                                                                                                                                                    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                                                                                                                                                                    manager.requestSerializer.timeoutInterval = 10.0;
                                                                                      
                                                                                                                                                                NSDictionary *params = @{
                                                                                                                                                                                             @"shopid":model.InfoZZ_subid
                                                                                                                                                                                             };
                                                                                                                                                                    NSLog(@"店铺🆔:%@",model.InfoZZ_subid);
                                                                                                                                                                    [manager GET: InformaCZoverpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                      
                                                                                                                                                                        NSLog(@"数据:%@", responseObject);
                                                                                      
                                                                                                                                                                        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                                                                                                                                                                            NSLog(@"下架成功～");
                                                                                                                                                                            
                                                                                                 [YJLHUD showSuccessWithmessage:@"下架成功"];
                                                                                                                                                                            [YJLHUD dismissWithDelay:2];
                                                                                                                                                                            
                                                                                                                                                                [self.InformaZZtableView.mj_header beginRefreshing];
                                                                                      
                                                                                                                                                                        }
                                                                                      
                                                                                                                                                                        else{
                                                                                      
                                                                                                                                                                            //code 305
                                                                                                                                                                            NSLog(@"下架失败～");
                                                                                                                                                                            
                                                                                                                                                                            [YJLHUD showErrorWithmessage:@"下架失败"];
                                                                                                                                                                            [YJLHUD dismissWithDelay:2];
                                                                                                                                                                        }
                                                                                      
                                                                                                                                                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                      
                                                                                                                                                                        NSLog(@"error=====%@",error);
                                                                                                                                                                        
                                                                                                                                                                        [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
                                                                                                                                                                        [YJLHUD dismissWithDelay:2];
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
                                                                              ctl.shopsubid =model.InfoZZ_subid;
                                                                              ctl.shopcode = @"rentout";
                                                                              
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
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
                                                                              ctl.shopsubid =model.InfoZZ_subid;
                                                                              ctl.shopcode = @"rentout";
                                                                              
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
      #pragma -mark           "审核失败";
            
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
                                                                              ctl.shopsubid =model.InfoZZ_subid;
                                                                              ctl.shopcode = @"rentout";
                                                                             
                                                                              self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                              [self.navigationController pushViewController:ctl animated:YES];
                                                                              self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                                                          }
                                                                              break;
                                                                              
                                                                          case 1:{
                                                                              
                                                                              NSLog(@"删除信息");
                                                                               [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"删除中..."];
                                                                              AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                                                                              manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                                                                              manager.requestSerializer.timeoutInterval = 10.0;
                                                                             
                                                                              
                                                                              NSDictionary *params = @{
                                                                                                           @"shopid":model.InfoZZ_subid
                                                                                                       };
                                                                              NSLog(@"店铺🆔:%@",model.InfoZZ_subid);
                                                                              [manager GET: InformaCZDEpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                  
                                                                                  NSLog(@"数据:%@", responseObject);
                                                                                  
                                                                                  if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                                                                                      NSLog(@"成功删除");
                                                                                        [YJLHUD showSuccessWithmessage:@"删除成功"];
                                                                                      [YJLHUD dismissWithDelay:2];
                                                                                     
                                                                                      //                                                                                      删除成功刷新页面
                                                                                      [_PHArr removeObjectAtIndex:indexPath.row];
                                                                                      [self.InformaZZtableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
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
        case 5:{
  #pragma -mark            "下架产品";
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
                                                                              ctl.shopsubid =model.InfoZZ_subid;
                                                                              ctl.shopcode = @"rentout";
                                                                             
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
    }
   
}



@end
