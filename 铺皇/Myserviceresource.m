//
//  Myserviceresource.m
//  铺皇
//
//  Created by selice on 2017/10/30.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "Myserviceresource.h"

@interface Myserviceresource ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *ServicesourcetabView;
}

@property   (nonatomic, strong) NSMutableArray  *  DataArray;               //存储数据
@property       (nonatomic, strong) UILabel          *   BGlab;          //无网络提示语

@end

@implementation Myserviceresource


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
     _DataArray = [[NSMutableArray alloc]init];
    
    //    返回
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    self.title =self.serviceCode;
    
    [self creatTabliview];
    [self reachability];
    [self refresh];
    
}


#pragma mark 网络检测
-(void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
//        NSLog(@"status=%ld",status);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [self loaddata];
        }
        else{
//            NSLog(@"网络繁忙");
        }
    }];
}



#pragma mark - 刷新数据
- (void)refresh{
    
#pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata)];
    
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
    ServicesourcetabView.mj_header       = header;
    
}

-(void)creatTabliview{
    
    ServicesourcetabView                   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    ServicesourcetabView.delegate          = self;
    ServicesourcetabView.dataSource        = self;
    ServicesourcetabView.backgroundColor   = [UIColor clearColor];
    ServicesourcetabView.tableFooterView   = [UIView new];
    [self.view addSubview:ServicesourcetabView];
    
    //    无数据的提示
    self.BGlab                  = [[UILabel alloc]init];
    [ServicesourcetabView addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:NO];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ServicesourcetabView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

#pragma  -mark下拉刷新
-(void)loaddata{

    if ([self.serviceCode isEqualToString:@"转让资源"]) {
        
         [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
        
        AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
        manager.responseSerializer          = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
     
        NSDictionary *params = @{
                                     @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                                 };
        [manager GET:MyZRpushpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
            
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
//                NSLog(@"可以拿到数据的");
                [_DataArray removeAllObjects];
//            NSLog(@"请求数据成功----%@",responseObject);
            for (NSDictionary *dic in responseObject[@"data"]) {
                servicesourcemodel *model = [[servicesourcemodel alloc]init];
                 model.Phonename = dic[@"person"];
                 model.Phonenumber = dic[@"phone"];
                 model.Phonetime = dic[@"time"];
                 [model setValuesForKeysWithDictionary:dic];
                 [_DataArray addObject:model];
            }
            
            [YJLHUD showImage:nil message:[NSString stringWithFormat:@"您当前拥有找店老板资源%ld个，赶紧联系吧!",_DataArray.count]];
             [YJLHUD dismissWithDelay:1];
            
        }else{
            NSLog(@"不可以拿到数据的");
            [self.BGlab setHidden:NO];
            self.BGlab.text     = @"未购买过套餐～";
           
             [YJLHUD showErrorWithmessage:@"未购买过套餐"];
             [YJLHUD dismissWithDelay:1];
        }
            
//             NSLog(@"%ld",_DataArray.count);
            [ServicesourcetabView  reloadData];
            [ServicesourcetabView.mj_header endRefreshing];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"请求数据失败----%@",error);
            [self.BGlab setHighlighted:NO];
            [ServicesourcetabView.mj_header endRefreshing];//停止刷新
    
            [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
            [YJLHUD dismissWithDelay:1];
        }];
    }
    
    else{
        
         [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
        AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
        manager.responseSerializer          = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
        NSDictionary *params = @{
                                     @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                                 };
        [manager GET:MyCZpushpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
            
//            NSLog(@"请求数据成功----%@",responseObject);
            
            if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
//                NSLog(@"可以拿到数据的");
                [_DataArray removeAllObjects];
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                servicesourcemodel *model = [[servicesourcemodel alloc]init];
                model.Phonename = dic[@"person"];
                model.Phonenumber = dic[@"phone"];
                model.Phonetime = dic[@"time"];
                [model setValuesForKeysWithDictionary:dic];
                [_DataArray addObject:model];
            }
                
                [YJLHUD showImage:nil message:[NSString stringWithFormat:@"您当前拥有找店老板资源%ld个，赶紧联系吧!",_DataArray.count]];
                [YJLHUD dismissWithDelay:1];
                
            }else{
                NSLog(@"不可以拿到数据的");
                [self.BGlab setHidden:NO];
                self.BGlab.text     = @"未购买过套餐～";
                [YJLHUD showErrorWithmessage:@"未购买过套餐"];
                [YJLHUD dismissWithDelay:1];
            }
            
            NSLog(@"%ld",_DataArray.count);
            [ServicesourcetabView  reloadData];
            [ServicesourcetabView.mj_header endRefreshing];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"请求数据失败----%@",error);
            [self.BGlab setHighlighted:NO];
            [ServicesourcetabView.mj_header endRefreshing];//停止刷新
            [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
            [YJLHUD dismissWithDelay:1];
        }];
    }
}

#pragma mark - Tableviewdatasource代理
//几个段落Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//一个段落几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _DataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    MyserviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyserviceCell" owner:self options:nil]lastObject];
    }
    
    servicesourcemodel *model = [_DataArray objectAtIndex:indexPath.row];
    cell.Phonenumber.text =[NSString stringWithFormat:@"%@",model.Phonenumber];
    cell.Phonename.text =[NSString stringWithFormat:@"%@",model.Phonename];
    cell.Phonetime.text =[NSString stringWithFormat:@"%@",model.Phonetime];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"第%ld段--第%ld列",indexPath.section,indexPath.row);
    
    servicesourcemodel *model =  [_DataArray objectAtIndex:indexPath.row];

    [LEEAlert alert].config
    
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = model.Phonename;
        
        label.textColor = [UIColor blackColor];
    })
    
    .LeeAddContent(^(UILabel *label) {
        
        label.text = model.Phonenumber;
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    })
    
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = @"取消";
        
        action.titleColor = kTCColor(255, 255, 255);
        
        action.backgroundColor = kTCColor(174, 174, 174);
        
        action.clickBlock = ^{
            
            // 取消点击事件Block
        };
    })
    
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = @"呼叫";
        
        action.titleColor = kTCColor(255, 255, 255);
        
        action.backgroundColor = kTCColor(77, 166, 214);
        
        action.clickBlock = ^{
            
            NSString * TEL =[NSString stringWithFormat:@"tel://%@",model.Phonenumber];
            NSLog(@"电话:%@",TEL);
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:TEL]];
            
        };
    })
    .LeeHeaderColor(kTCColor(255, 255, 255))
    .LeeShow();
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 返回
-(void)back{
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   

}

@end
