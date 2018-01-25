//
//  FeatureareaController.m
//  铺皇
//
//  Created by selice on 2017/9/21.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "FeatureareaController.h"
#import "ZYKeyboardUtil.h" //键盘处理
#define MARGIN_KEYBOARD 10
#import "YJLMenu.h"
#import "Featuremodel.h"
#import "FeaturerentCell.h"
#import "DetailedController.h"
#import "SearchrecordData.h"
#import "SiftacreageData.h"
#define fontCOLOR [UIColor colorWithRed:163/255.0f green:163/255.0f blue:163/255.0f alpha:1]
@interface FeatureareaController ()<YJLMenuDataSource,YJLMenuDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    int PHpage;
    UIBarButtonItem * rightButton;
}

@property (strong, nonatomic) ZYKeyboardUtil    *keyboardUtil;
@property (nonatomic,strong)  UITextField       *Searchfield;//搜索框
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@property (nonatomic,strong)NSMutableArray  *   searchHistory;
@property (nonatomic,strong)NSArray         *   myArray;//搜索记录的数组

@property(nonatomic,strong)UIView           *   navView;
@property(nonatomic,strong)UIButton         *   backBtn;

@property (nonatomic,copy  ) NSString       *   searchWord;
@property (nonatomic,assign) BOOL isCancel;
@property (nonatomic,assign) BOOL isSearch;

@property (nonatomic , strong) YJLMenu           * menu;
@property (nonatomic , strong) UITableView       * Acreagetableview;
@property (nonatomic , strong) UITableView       * Searchtableview;
@property (nonatomic , strong) UILabel     * BGlab;        //无网络提示语

@property (nonatomic, strong) NSArray           * Acreage; //面积选店
@property (nonatomic, strong) NSArray           * Type;    //类型选店
@property (nonatomic, strong) NSArray           * Browse;  //浏览量选店
@property (nonatomic, strong) NSArray           * Time;    //时间排序

@property (nonatomic, strong) NSArray           * Acreageid; //面积选店id
@property (nonatomic, strong) NSArray           * Typeid;    //类型选店id
@property (nonatomic, strong) NSArray           * Browseid;  //浏览量选店id
@property (nonatomic, strong) NSArray           * Timeid;    //时间排序id
@property (nonatomic, strong) NSString          * path; //入境

@property (nonatomic,strong) NSString           *keywordstr;//搜索关键字

@property(nonatomic,strong)NSURLSessionDataTask*task;

@end

@implementation FeatureareaController

- (void)viewDidLoad {
    [super viewDidLoad];
   
#pragma -mark   适配必要使用
    //    *_autoSizeScaleX
    //    *_autoSizeScaleY
    if(KMainScreenHeight < 667){                                 // 这里以(iPhone6)为准
        _autoSizeScaleX = KMainScreenWidth/375;
        _autoSizeScaleY = KMainScreenHeight/667;
    }else{
        _autoSizeScaleX = 1.0;
        _autoSizeScaleY = 1.0;
    }
    
   
    PHArr = [[NSMutableArray alloc]init];
    _keywordstr = [[NSString alloc]init];
    _keywordstr = @"";
    self.view.backgroundColor = kTCColor(255, 255, 255);
    NSLog(@"请求的城市 hostcityid===%@",self.hostcityid);
    _path           = [[NSString alloc]initWithFormat:@"&upid=00000&rent=00000&moneys=00000&area=00000&type=00000&views=00000&times=00000&keyword="];
    //    创建导航栏控件
    [self creatnavtitleview];
    
    //    创建列表table
    [self creattableview];
    
    //   加载数据控件
    [self refresh];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    //   接收首页的城市切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changevalue) name:@"ChangeCity" object:nil];
    
    // 是否是第一次进入该处
    [self isacreageFirstCome];

}
#pragma  -mark 切换城市进行判断并删除上一个城市数据
-(void)changevalue{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"acreageisFirstCome"    ];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[SiftacreageData      shareacreageData    ]deletedacreageData    ];
}

-(void)isacreageFirstCome{
    
    NSString       * isFirstCome       = [[NSUserDefaults standardUserDefaults] objectForKey:@"acreageisFirstCome"];
    NSLog(@"YES OR NO                                                  ===%@",isFirstCome);
    if (![isFirstCome isEqualToString:@"YES"]){   //NO
        
        NSLog(@"区域是第一次请求");
#pragma -mark 网络检测
        [self reachability];
    }
    
    else{ //YES
       
        PHArr = [[SiftacreageData shareacreageData] getAllDatas];
        NSLog(@"有%ld个",PHArr.count);
        if (PHArr.count>0) {
#pragma -mark 网络检测
            [self.Acreagetableview reloadData];
            if (PHArr.count % 10>0) {
                PHpage = (int)PHArr.count/10;
            }else{
                PHpage = (int)PHArr.count/10-1;
            }
            
        }else{
            [self reachability];
        }
    }
}

#pragma mark 网络检测
-(void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi||status == AFNetworkReachabilityStatusReachableViaWWAN) {
            [self loadareaupData];
        }else{
            NSLog(@"未知网络错误");
        }
        NSLog(@"status=%ld",status);
    }];
}

#pragma mark - 刷新数据
- (void)refresh{
    
#pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadareaupData)];
    
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
    self.Acreagetableview.mj_header = header;
    
    //#pragma  -mark上拉加载获取网络数据
    self.Acreagetableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉刷新一下试试"           );
        NSLog(@"上一个第%d页",PHpage       );
        PHpage++;
        [self loadareadownData           ];
    }];
}

#pragma  -mark 下拉刷新
-(void)loadareaupData{
    
    PHpage = 0;
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    
    NSString  * str = [NSString stringWithFormat:@"%@?id=%@&page=%d%@%@",HostZRparticular,_hostcityid,PHpage,_path,_keywordstr];
    NSLog(@"精选～租金rent下拉刷新请求入境：%@",str);
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
 
   self.task = [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [[SiftacreageData shareacreageData]deletedacreageData];
        [PHArr removeAllObjects];
        //        NSLog(@"请求数据成功----%@",responseObject);
        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"可以拿到数据的");
            
            [YJLHUD showSuccessWithmessage:@"加载成功"];
            [YJLHUD dismissWithDelay:1];
            for (NSDictionary *dic in responseObject[@"values"]){
                
                Featuremodel *model = [[Featuremodel alloc]init];
                model.Featureimg        = dic[@"img"];
                model.Featuretitle      = dic[@"title"];
                model.Featurequyu       = dic[@"districter"];
                model.Featuretime       = dic[@"time"];
                model.Featuretype       = dic[@"type"];
                model.Featurecommit     = dic[@"area"];
                model.Featurehassee     = dic[@"views"];
                model.Featuresubid      = dic[@"subid"];
                [model setValuesForKeysWithDictionary:dic];
                //            添加到数据库
                [[SiftacreageData shareacreageData]addshopacreage:model];
                [PHArr addObject:model];
            }
            
            NSLog(@" 加载后现在总请求到数据有%ld个",PHArr.count);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"acreageisFirstCome"];//设置下一次不走这里了
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
            self.Acreagetableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.BGlab setHidden:YES];
            
          
        }
        else{
            
            
            [self.BGlab setHidden:NO];
            self.BGlab.text             = @"没有更多数据";
            [self.Acreagetableview .mj_header endRefreshing];
            self.Acreagetableview.separatorStyle = UITableViewCellSeparatorStyleNone;
          
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
        }
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.Acreagetableview reloadData];
        });
        [self.Acreagetableview.mj_header endRefreshing];
     
        
        
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if (error.code == -999) {
            NSLog(@"网络数据连接取消");
        }else{

        
     
        [self.BGlab setHidden:NO];
        self.BGlab.text      = @"网络数据连接超时了,稍等~~";
        [self.Acreagetableview .mj_header endRefreshing];
            [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~~"];
            [YJLHUD dismissWithDelay:1];
        }
    }];
}

#pragma -mark 上拉加载
-(void)loadareadownData{
    
    NSLog(@"上拉加载数组里面的数剧有%ld个",PHArr.count);
    NSLog(@"马上加载第%d页",PHpage);
 [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    NSString  * str = [NSString stringWithFormat:@"%@?id=%@&page=%d%@%@",HostZRparticular,_hostcityid,PHpage,_path,_keywordstr];
    NSLog(@"上拉加载请求入境：%@",str);
   
    AFHTTPSessionManager *manager                   = [AFHTTPSessionManager manager];
    manager.responseSerializer                      = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval       = 10.0;
    
  self.task =  [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //        NSLog(@"请求数据成功----%@",responseObject);
        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"可以拿到数据的");
            
            [YJLHUD dismissWithDelay:1];
            for (NSDictionary *dic in responseObject[@"values"]){
                Featuremodel *model = [[Featuremodel alloc]init];
                model.Featureimg        = dic[@"img"];
                model.Featuretitle      = dic[@"title"];
                model.Featurequyu       = dic[@"districter"];
                model.Featuretime       = dic[@"time"];
                model.Featuretype       = dic[@"type"];
                model.Featurecommit     = dic[@"area"];
                model.Featurehassee     = dic[@"views"];
                model.Featuresubid      = dic[@"subid"];
                [model setValuesForKeysWithDictionary:dic];
        //            添加到数据库
                [[SiftacreageData shareacreageData]addshopacreage:model];
                [PHArr addObject:model];
            }
            
            NSLog(@" 加载后现在总请求到数据有%ld个",PHArr.count);
            
            [self.BGlab setHidden:YES];
        }
        else{
                NSLog(@"不可以拿到数据的");
            
                PHpage--;
                [self.BGlab setHidden:YES];
                [YJLHUD showErrorWithmessage:@"没有更多数据"];
                [YJLHUD dismissWithDelay:1];
                [self.Acreagetableview.mj_footer endRefreshingWithNoMoreData];
           
        }
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self. Acreagetableview reloadData];
        });
        
        [self.Acreagetableview.mj_footer endRefreshing];
        
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if (error.code == -999) {
            NSLog(@"网络数据连接取消");
        }else{

            [self.BGlab setHidden:YES];
            [self.Acreagetableview .mj_footer endRefreshing];
           
            [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~~"];
            [YJLHUD dismissWithDelay:1];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.Searchtableview) {
        return 2;
    }else{
        return 1;
    }
}

#pragma -mark - tableviewcell代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.Searchtableview) {
        if (section==0) {
            if (_myArray.count>0) {
                return _myArray.count+1+1;
            }
            else{
                return 1;
            }
        }
        
        else{
            return 0;
        }
        
    }
    
    else{
        
        return PHArr.count;
    }
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.Searchtableview) {
        
        if (indexPath.section==0) {
            
            if(indexPath.row ==0)
            {
                UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
                cell.textLabel.text = @"历史搜索";
                cell.textLabel.textColor = fontCOLOR;
                return cell;
            }
            
            else if (indexPath.row == _myArray.count+1){
                UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
                cell.textLabel.text = @"清除历史记录";
                cell.textLabel.textColor = fontCOLOR;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                return cell;
            }
            
            else{
                
                UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
                NSArray* reversedArray = [[_myArray reverseObjectEnumerator] allObjects];
                cell.textLabel.text = reversedArray[indexPath.row-1];
                return cell;
            }
        }
        
        
        else{
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            return cell;
        }
    }
    
    else{
        
        if (PHArr.count == 0)
        {
            NSLog(@"555");
            return nil;
        }
        
        
        else{
            static NSString *cellid = @"cellID";
            
            FeaturerentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil)
            {
                cell =[[[NSBundle mainBundle]loadNibNamed:@"FeaturerentCell" owner:self options:nil]lastObject];
            }
            
            //            NSLog(@"!!!!!%ld=????????%ld",PHArr.count,indexPath.row);
            Featuremodel *model = [PHArr objectAtIndex:indexPath.row];
            cell.Featuretitle.text             = model.Featuretitle;  //标题
            cell.Featurequyu.text              = model.Featurequyu;   //区域所在
            if (model.Featurequyu.length>3)
            {
                cell.FeaturequyuWidth.constant = 50;
            }else{
                cell.FeaturequyuWidth.constant = 40;
            }
            
            cell.Featuretime.text              = model.Featuretime;   //更新时间
            cell.Featuretype.text              = model.Featuretype;    //餐饮美食
            cell.Featurecommit.text            = [NSString stringWithFormat:@"%@m²",model.Featurecommit];//店铺面积
            cell.Featurehassee.text            = [NSString stringWithFormat:@"浏览数:%@",model.Featurehassee];//店铺浏览量
            //            NSLog(@"222222%@",model.Featureimg);
            [cell.Featureimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.Featureimg]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.Searchtableview) {
        if (section==0) {
            return 0;
        }else{
            return 10;
        }
    }
    
    else{
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.Searchtableview) {
        
        self.Searchtableview.estimatedRowHeight = 44.0f;
        
        return UITableViewAutomaticDimension;
    }
    else{
        
        return 120;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.Searchtableview)
    {
        
        [self.Searchtableview deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.row == _myArray.count+1)
        {    //清除所有历史记录
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除历史记录" message:@"" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                           {
                                               [SearchrecordData removeAllArray];
                                               _myArray = nil;
                                               [self.Searchtableview reloadData];
                                           }];
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        else if(indexPath.row == 0)
        {
            NSLog(@"历史记录");
        }
        else
        {
            NSLog(@"点击了%ld行",indexPath.row);
            NSLog(@"记录缓存：%@",_myArray[_myArray.count-indexPath.row]);
            [_Searchfield resignFirstResponder];
            [self.Searchtableview setHidden:YES];
            [self.Acreagetableview    setHidden:NO];
            
           _keywordstr  =[[NSString stringWithFormat:@"%@",_myArray[_myArray.count-indexPath.row]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            _Searchfield.text = [NSString stringWithFormat:@"%@",_myArray[_myArray.count-indexPath.row]];
            rightButton.enabled = NO;
            //        获取并刷新数据
            [self loadareaupData];
            
        }
    }
    
    else{
        
        NSLog(@"%zd点击了一下",indexPath.row);
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        //    获取店铺唯一id
        Featuremodel *model = [PHArr objectAtIndex:indexPath.row];
        DetailedController *ctl =[[DetailedController alloc]init];
        ctl.shopsubid = model.Featuresubid;
        NSLog(@"店铺🆔%@",ctl.shopsubid);
        [self.navigationController pushViewController:ctl animated:YES];
         self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
    }
}

#pragma  - mark 创建导航栏控件
-(void)creatnavtitleview{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];
    UIBarButtonItem *leftbackItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(clickback:)];
    self.navigationItem.leftBarButtonItem  = leftbackItm;
    
    rightButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    rightButton.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    rightButton.enabled=NO;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _Searchfield =[[UITextField alloc]initWithFrame:CGRectMake(0, 27, KMainScreenWidth-88, 30)];
    _Searchfield.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_left"]];
    _Searchfield.leftViewMode    = UITextFieldViewModeAlways;        //文本框固定左视图
    _Searchfield.placeholder     = @"输入搜索关键字";                   //预文本内容
    _Searchfield.keyboardType    = UIKeyboardTypeDefault;            //键盘样式
    _Searchfield.font            = [UIFont systemFontOfSize:14.0f];  //文字字体大小
    _Searchfield.textColor       = [UIColor blackColor];             //文字颜色
    _Searchfield.adjustsFontSizeToFitWidth = YES;                    //是否适应字体
    _Searchfield.minimumFontSize = 10.0;                             //最小适应字体
    _Searchfield.textAlignment   = NSTextAlignmentLeft;              //文字居左
    _Searchfield.returnKeyType   = UIReturnKeySearch;                //renturn改变
    _Searchfield.backgroundColor = kTCColor(234,235,237);            //背景色
    _Searchfield.layer.cornerRadius = 15.0f;                         //圆角
    _Searchfield.clearButtonMode = UITextFieldViewModeAlways;        //清空按钮一直出现
    _Searchfield.delegate        = self;
    self.navigationItem.titleView  = _Searchfield;
    
    
    
    [self configKeyBoardRespond];
    
    self.Acreage   = @[@"合适面积",@"30m²以下",@"31～60m²",@"61～100m²",@"101～150m²",@"151～200m²",@"201～300m²",@"301～500m²",@"500m²以上"];
    self.Acreageid = @[@"00000",@"0~30",@"31~60",@"61~100",@"101~150",@"151~200",@"201~300",@"301~500",@"501~50000000"];
    self.Type    = @[@"经营行业",@"餐饮美食",@"美容美发",@"服饰鞋包",@"休闲娱乐",@"百货超市",@"生活服务",@"电子通讯",@"汽车服务",@"医疗保健",@"家居建材",@"教育培训",@"酒店宾馆"];
    self.Typeid = @[@"00000",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    self.Browse = @[@"浏览量不限",@"浏览量由少到多",@"浏览量由多到少"];
    self.Browseid = @[@"00000",@"1",@"2"];
    
    self.Time =@[@"时间排序",@"时间由近到远",@"时间由远到近"];
    self.Timeid=@[@"00000",@"2",@"1"];
    
#pragma -mark 创建条件选择视图
    _menu = [[YJLMenu alloc] initWithOrigin:CGPointMake(0, 64 ) andHeight:50];
    _menu.delegate   = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
}

#pragma -mark 键盘处理
- (void)configKeyBoardRespond {
    
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak FeatureareaController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.Searchfield,  nil];
    }];
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

#pragma  - mark UItextfield 代理方法 start
-(BOOL)textFieldShouldReturn:(UITextField *)textField{//搜索方法
    
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起[textField resignFirstResponder];
    //查一下resign这个单词的意思就明白这个方法了
    
    NSLog(@"点击return");
    if (textField.text.length > 0) {
        
        [SearchrecordData SearchText:textField.text];//缓存搜索记录
        [self readNSUserDefaults];
        
        [self.Searchtableview setHidden:YES];
        [self.Acreagetableview setHidden:NO];
         _keywordstr  =[ [NSString stringWithFormat:@"%@",textField.text] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        _Searchfield.text = [NSString stringWithFormat:@"%@",textField.text];
        //        获取数据
        [self loadareaupData];
        //    键盘下去
        [_Searchfield resignFirstResponder];
        rightButton.enabled = NO;
        
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入查找内容" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           NSLog(@"Lspispig");
                                       }];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSLog(@"请输入查找内容");
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"即将开始了编辑");
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    [self.Searchtableview setHidden:NO ];
    [self.Acreagetableview   setHidden:YES];
    
    rightButton.enabled=YES;
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"结束了编辑");
    //开始编辑时触发，文本字段将成为first responder
    [self.Searchtableview setHidden:NO];
    [self.Acreagetableview setHidden:YES];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"即将结束了编辑");
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    //要想在用户结束编辑时阻止文本字段消失，可以返回NO
    //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
    return YES;
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    //这对于想要加入撤销选项的应用程序特别有用
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    //要防止文字被改变可以返回NO
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    return YES;
}

#pragma  - mark UItextfield 代理方法 end

#pragma -mark - 菜单的代理方法 start
-(NSInteger )numberOfColumnsInMenu:(YJLMenu *)menu{
    
    return 4;
}

-(NSInteger )menu:(YJLMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    
    if (column == 0) {
        return self.Acreage.count;
    }
    if (column == 1) {
        return self.Type.count;
    }
    if (column == 2) {
        return self.Browse.count;
    }else{
        return self.Time.count;
    }
}

-(NSString *)menu:(YJLMenu *)menu titleForRowAtIndexPath:(YJLIndexPath *)indexPath{
    
    if (indexPath.column  == 0) {
        
        return self.Acreage[indexPath.row];
    }else if (indexPath.column == 1){
        
        return self.Type[indexPath.row];
    }else if (indexPath.column == 2){
        
        return self.Browse[indexPath.row];
    }else{
        
        return self.Time[indexPath.row];
    }
}

- (void)menu:(YJLMenu *)menu didSelectRowAtIndexPath:(YJLIndexPath *)indexPath {
    
    if (indexPath.item >= 0)   //有二级菜单
    {
        NSLog(@"点击了 %ld列 - 第%ld栏（一级） - %ld栏（二级）",indexPath.column+1,indexPath.row + 1,indexPath.item+1);
    }
    else {
        NSLog(@"点击了 %ld列 - 第%ld栏（一级）",indexPath.column+1,indexPath.row+1);
        switch (indexPath.column+1){
            case 1:{
                
                valuearea1 = self.Acreage[indexPath.row];
                valuearea1id = self.Acreageid[indexPath.row];
                NSLog(@"获取值区域 = %@",valuearea1);
                NSLog(@"获取值区域id = %@",valuearea1id);
            }
                break;
                
            case 2:{
                
                valuetype2 = self.Type[indexPath.row];
                NSLog(@"获取值租金 = %@",valuetype2);
                valuetype2id = self.Typeid[indexPath.row];
                NSLog(@"获取值租金id = %@",valuetype2id);
            }
                break;
                
            case 3:{
                
                valuebrose3 = self.Browse[indexPath.row];
                NSLog(@"获取值行业 = %@",valuebrose3);
                valuebrose3id = self.Browseid[indexPath.row];
                NSLog(@"获取值行业id = %@",valuebrose3id);
            }
                break;
                
            case 4:{
                
                valuetime4 = self.Time[indexPath.row];
                NSLog(@"获取值面积 = %@",valuetime4);
                valuetime4id = self.Timeid[indexPath.row];
                NSLog(@"获取值面积id = %@",valuetime4id);
            }
                break;
        }
#pragma -mark 显示当前点击多少项  那几项名称 id
        [self setup:valuearea1id :valuetype2id :valuebrose3id :valuetime4id];
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
    
    //http://192.168.1.106/chinapuhuang/PCPH/index.php/Zgphshop/Allhost/DelTarea?id=%@&page=%d
    _path = [NSString stringWithFormat:@"&upid=00000&rent=00000&moneys=00000&area=%@&type=%@&views=%@&times=%@&keyword=",value1,value2,value3,value4];
    NSLog(@"拼接字符串%@",_path);
    
    [self loadareaupData];
}

#pragma -mark - 菜单的代理方法 end

#pragma -mark - 创建tableview
-(void)creattableview{

    self.Acreagetableview = [[UITableView alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_menu.frame), KMainScreenWidth, KMainScreenHeight-114)];
    self.Acreagetableview.delegate   = self;
    self.Acreagetableview.dataSource = self;
    [self.Acreagetableview setHidden:NO];
    self.Acreagetableview.backgroundColor = [UIColor clearColor];
    self.Acreagetableview.tableFooterView = [UIView new];
     self.Acreagetableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.Acreagetableview];
  
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.Acreagetableview addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.Acreagetableview);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

#pragma -mark - 搜索取消按钮
-(void)cancel:(UIButton *)btn{
    NSLog(@"取消搜索");

    [_Searchfield endEditing:YES];
    [_Searchfield resignFirstResponder];
    rightButton.enabled = NO;
    [self.Searchtableview setHidden:YES];
    [self.Acreagetableview setHidden: NO];
    _Searchfield.text = nil;
    _keywordstr = @"";
}

#pragma -mark -返回上页
-(void)clickback:(UIButton *)btn{
    NSLog(@"返回");
    if(self.task) {
        [self.Acreagetableview.mj_header endRefreshing];
        [self.task cancel];//取消当前界面的数据请求.
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    if(self.task) {
        [self.Acreagetableview.mj_header endRefreshing];
        [self.task cancel];//取消当前界面的数据请求.
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //  创建搜索记录table
    [self creatsearchtableview];
}

- (void)viewWillDisappear:(BOOL)animated {
  
    [super viewWillDisappear:animated];
    
}

#pragma -mark 创建搜索记录table
-(void)creatsearchtableview{
    
    self.Searchtableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight)];
    self.Searchtableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.Searchtableview setHidden:YES];
    self.Searchtableview.delegate   =self;
    self.Searchtableview.dataSource =self;
    [self.view addSubview:self.Searchtableview];
    [self readNSUserDefaults];
}
#pragma -mark //取出缓存的数据
-(void)readNSUserDefaults{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray * myArray = [userDefaultes arrayForKey:@"myArray"];
    self.myArray = myArray;
    [self.Searchtableview reloadData];
    NSLog(@"myArray======%@",myArray);
}

@end
