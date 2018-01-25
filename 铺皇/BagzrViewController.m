//
//  BagzrViewController.m
//  铺皇
//
//  Created by selice on 2017/10/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "BagzrViewController.h"
@interface BagzrViewController ()

@property   (nonatomic, strong) UILabel         *   BGlab;               //无网络提示语
@property   (nonatomic, strong) NSMutableArray  *  BagArr;               //存储数据

@end

@implementation BagzrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(Back:)];
    self.navigationItem.title = @"我的转让套餐";
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor whiteColor];
   
     _BagArr = [[NSMutableArray alloc]init];
     [self buildcollectionview];
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
    self.Bagzrcollectionview.mj_header  = header;
}

-(void)loadData{
    
    
    NSLog(@"加载数据中.....");
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
 
    NSDictionary *params =  @{
                                    @"id":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                             };
    [manager GET:Myservicezrbagpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        
        NSLog(@"请求成功咧");
        NSLog(@"数据:%@", responseObject[@"data"]);
        NSLog(@"数据状态:%@", responseObject[@"code"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            [_BagArr removeAllObjects];

            for (NSDictionary *dic in responseObject[@"data"]){

                Bagzrmodel *model            = [[Bagzrmodel alloc]init];
                model.service1               = dic[@"home_times"];
                model.service2               = dic[@"display_times"];
                model.servicetime            = dic[@"time"];
                
            if ([dic[@"home_times"] isEqualToString:@"0"]&&[dic[@"display_times"] isEqualToString:@"0"]) {
                
                NSLog(@"有空数据");
                }
                
            else{
                    [model setValuesForKeysWithDictionary:dic];
                    [_BagArr addObject:model];
                }
            }
            NSLog(@" 加载后现在总请求到数据有%ld个",_BagArr.count);
            [self.BGlab setHidden:YES];
        }

        else{

            //code 401
            NSLog(@"不可以拿到数据的");
            [self.BGlab setHidden:NO];
            self.BGlab.text     = @"未购买过套餐～";
           
            [YJLHUD showWithmessage:@"未购买过套餐～"];
            [YJLHUD dismissWithDelay:1];
        }

        [self.Bagzrcollectionview reloadData];
        [self.Bagzrcollectionview.mj_header endRefreshing];//停止刷新
        [YJLHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        NSLog(@"error=====%@",error);
        [self.BGlab setHighlighted:NO];
        [self.Bagzrcollectionview.mj_header endRefreshing];//停止刷新
        
        [YJLHUD showWithmessage:@"网络数据连接出现问题了,请检查一下"];
        [YJLHUD dismissWithDelay:1];
    }];
}

-(void)buildcollectionview{
    /**
     *  创建collectionView
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.Bagzrcollectionview   = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,KMainScreenWidth , KMainScreenHeight) collectionViewLayout:layout];
    self.Bagzrcollectionview.backgroundColor =[UIColor whiteColor];// kTCColor(228, 228, 228);
    // 隐藏垂直滚动条
    self.Bagzrcollectionview.showsVerticalScrollIndicator = NO;
    // 注册XIB
    [self.Bagzrcollectionview registerClass:[BagzrCollectionCell class] forCellWithReuseIdentifier:@"Cell"];
    self.Bagzrcollectionview.delegate    = self;
    self.Bagzrcollectionview.dataSource  = self;
    //自适应大小
    self.Bagzrcollectionview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.Bagzrcollectionview];
    
    //    无数据的提示
    self.BGlab                  = [[UILabel alloc]init];
    [self.Bagzrcollectionview addSubview:self.BGlab];
    self.BGlab.text             = @"未购买过套餐";
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:NO];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.Bagzrcollectionview);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}


#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _BagArr.count;
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    //案例
    BagzrCollectionCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = kTCColor2(161, 161, 161, 0.2);
    cell.layer.cornerRadius = 5.0f;
    cell.layer.borderWidth  = 0.5f;
    cell.layer.borderColor =kTCColor(161, 161, 161).CGColor;
    [cell sizeToFit];
    Bagzrmodel *model           = [_BagArr objectAtIndex:indexPath.row];
    
//    model.service1 首页
//    model.service2 地图

    if ([model.service1  integerValue]>5) {
        if ([model.service2 integerValue]>5) {
             cell.servicetitle.text      = [NSString stringWithFormat:@"首页展示服务:%@天\n信息展示&地图推荐服务:%@天",model.service1,model.service2];
        }
        else{
            cell.servicetitle.text      = [NSString stringWithFormat:@"首页展示服务:%@天",model.service1];
        }
    }
 else {
            cell.servicetitle.text      = [NSString stringWithFormat:@"信息展示&地图推荐服务:%@天",model.service2];
    }
    
    cell.servicetimes.text      = [NSString stringWithFormat:@"%@",model.servicetime];
    return cell;
}

#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"选择%ld",indexPath.item);
}

//根据cell不同 适配
- (CGSize)collectionView: (UICollectionView *)collectionView
                  layout: (UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath: (NSIndexPath *)indexPath{
    
      return CGSizeMake(KMainScreenWidth-20, 105);
}

//根据cell不同 cell宽边
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
      return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)Back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

@end
