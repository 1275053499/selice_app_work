//
//  SerachViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/13.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SerachViewController.h"
#import "AppDelegate.h"
#import "UIBarButtonItem+Create.h"
#define fontCOLOR [UIColor colorWithRed:163/255.0f green:163/255.0f blue:163/255.0f alpha:1]
@interface SerachViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic,strong) UISearchBar *searchbar;
@property (nonatomic,strong) UIView      *searchbarbagview;
@property (nonatomic,strong) NSMutableArray *ZRArr;
@property (nonatomic,strong) NSMutableArray *CZArr;
@property (nonatomic,strong) NSMutableArray *XZArr;
@property (nonatomic,strong) NSMutableArray *ZPArr;
@property (nonatomic,strong) NSArray    * searchArr;//搜索记录的数组
@property (nonatomic,strong) NSString   * Serachword;//搜索关键字
@property (nonatomic,strong)UITableView * Historytableview;
@property(nonatomic,strong)UITableView  * Maintableview;
@property(nonatomic,strong)NSURLSessionDataTask*task;

@end


@implementation SerachViewController

- (NSArray *)searchArr {
    
    if(!_searchArr) {
        
        _searchArr = [NSMutableArray new];
    }
    
    return _searchArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    关键字搜索初始化
    _Serachword = [[NSString alloc]init];
    _Serachword = @"";
    _ZRArr        = [[NSMutableArray alloc]init];
    _CZArr        = [[NSMutableArray alloc]init];
    _XZArr        = [[NSMutableArray alloc]init];
    _ZPArr        = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClick)];
    self.navigationItem.leftBarButtonItem = backItm;
    //    创建一个搜索框
    [self creatSearchView];
    
    //  创建搜索记录table
    [self  creatsearchtableview];
    [self  creatmaintableview];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    [self refresh];
    
}
#pragma mark - 创建上下拉刷新数据
- (void)refresh{
    //#pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadData)];
    
    // Set title
    [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
    [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
    [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // Set textColor
    header.stateLabel.textColor             = kTCColor(161, 161, 161);
    header.lastUpdatedTimeLabel.textColor   = kTCColor(161, 161, 161);
    self.Maintableview.mj_header     = header;
    [self.Maintableview.mj_header beginRefreshing];
}

#pragma -mark 获取数据
-(void)LoadData{
    
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
     [_ZRArr removeAllObjects];
     [_CZArr removeAllObjects];
     [_XZArr removeAllObjects];
     [_ZPArr removeAllObjects];
     AFHTTPSessionManager * manager  = [AFHTTPSessionManager manager];
    manager.responseSerializer              = [AFJSONResponseSerializer serializer];
     ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
 
    NSString  * URL = [NSString stringWithFormat:@"%@?city=%@&keyword=%@",HostmainSerach,self.Cityid,self.Serachword];
    NSLog(@"下拉刷新请求入境：%@",URL);

  self.task = [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      
      [YJLHUD showSuccessWithmessage:@"加载成功"];
     [YJLHUD dismissWithDelay:0.2];
        NSLog(@"ZR请求数据成功----%@",responseObject[@"data"][@"zr"]);
        NSLog(@"CZ请求数据成功----%@",responseObject[@"data"][@"cz"]);
        NSLog(@"XZ请求数据成功----%@",responseObject[@"data"][@"xz"]);
        NSLog(@"ZP请求数据成功----%@",responseObject[@"data"][@"zp"]);
      
//        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            
            NSLog(@"可以拿到数据的");
          
                for (NSDictionary *dic in responseObject[@"data"][@"zr"]){//转让数据
                    
                    SerachModel *model  = [[SerachModel alloc]init];
                    model.SEAImgview    = dic[@"images" ];
                    model.SEAtitle      = dic[@"title"  ];
                    model.SEAquyu       = dic[@"dityour"];
                    model.SEAtime       = dic[@"time"   ];
                    model.SEAtype       = dic[@"type"   ];
                    model.SEAarea       = dic[@"area"   ];
                    model.SEAmoney      = dic[@"rent"   ];
                    model.SEAid         = dic[@"id"     ];
                    [model setValuesForKeysWithDictionary:dic];
                    [_ZRArr addObject:model];
                }
                NSLog(@" 加载后转让现在总请求到数据有%ld个",_ZRArr.count);
            
            for (NSDictionary *dic in responseObject[@"data"][@"cz"]){//出租数据
                
                SerachModel *model = [[SerachModel alloc]init];
                model.SEAImgview    = dic[@"image" ];
                model.SEAtitle      = dic[@"name"  ];
                model.SEAquyu       = dic[@"search"];
                model.SEAtime       = dic[@"time"  ];
                model.SEAtype       = dic[@"trade" ];
                model.SEAarea       = dic[@"area"  ];
                model.SEAmoney      = dic[@"rent"  ];
                model.SEAid         = dic[@"id"    ];
                [model setValuesForKeysWithDictionary:dic];
                [_CZArr addObject:model];
            }
            NSLog(@" 加载后出租现在总请求到数据有%ld个",_CZArr.count);
            
            for (NSDictionary *dic in responseObject[@"data"][@"xz"]){//选址数据

                SerachXZModel *model = [[SerachXZModel alloc]init];
                model.SEAXZtitle         = dic[@"title"];   //标题
                model.SEAXZsubtitle      = dic[@"detail"];  //描述
                model.SEAXZtype          = dic[@"type"];    //类型
                model.SEAXZquyu          = dic[@"search"];  //区域
                model.SEAXZmoney         = dic[@"rent"];    //价钱
                model.SEAXZarea          = dic[@"areas"];   //面积
                model.SEAXZid            = dic[@"id"];      //id
                [model setValuesForKeysWithDictionary:dic];
                [_XZArr addObject:model];
            }
            NSLog(@" 加载后选址现在总请求到数据有%ld个",_XZArr.count);

            for (NSDictionary *dic in responseObject[@"data"][@"zp"]){  //招聘数据

                SerachZPModel *model     = [[SerachZPModel alloc]init];
                model.SEAZPtitle         = dic[@"name"];        //标题
                model.SEAZPsubtitle      = dic[@"descript"];    //描述
                model.SEAZPquyu          = dic[@"dityour"];     //区域
                model.SEAZPage           = dic[@"experience"];  //经验
                model.SEAZPedu           = dic[@"edu"];         //学历
                model.SEAZPzalay         = dic[@"money"];       //工资
                model.SEAXZid            = dic[@"subid"];       //id
                [model setValuesForKeysWithDictionary:dic];
                [_ZPArr addObject:model];
            }
                NSLog(@" 加载后招聘现在总请求到数据有%ld个",_ZPArr.count);
        }else{
            
            //            500
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
        }
      

        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.Maintableview reloadData];
        });
        [self.Maintableview.mj_header endRefreshing];
      
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if (error.code == -999) {
            NSLog(@"网络数据连接取消");
        }else{
        
          
            [self.Maintableview .mj_header endRefreshing];
          
            [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
            [YJLHUD dismissWithDelay:1];
        }
    }];

}

#pragma mark - 创建搜索框视图
-(void)creatSearchView{
    
   _searchbarbagview = [[UIView alloc] init];
    _searchbarbagview.frame = CGRectMake(0, 0, KMainScreenWidth-70, 30);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:_searchbarbagview.bounds];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.showsCancelButton = NO;//是否显示取消按钮，默认为NO，
    searchBar.tintColor      = [UIColor redColor];//设置这个颜色值会影响搜索框中的光标的颜色
    searchBar.searchBarStyle = UISearchBarStyleMinimal;//不显示背景
    searchBar.translucent = YES;//设置是否半透明
    searchBar.placeholder = @"搜索号码、店名试试看";
    searchBar.delegate = self;
    self.searchbar = searchBar;
    [_searchbarbagview addSubview:self.searchbar];
    self.navigationItem.titleView = _searchbarbagview;
}

#pragma -mark -UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    将要开始编辑时的回调，返回为NO，则不能编辑
    NSLog(@"将要开始编辑时的回调，返回为NO，则不能编辑");
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    已经开始编辑时的回调
    NSLog(@"已经开始编辑时的回调");
    
    if(self.task) {
        [self.Maintableview.mj_header endRefreshing];
        [self.task cancel];//取消当前界面的数据请求.
        
    }
    
    searchBar.showsCancelButton     = YES; //取消按钮显示
    [self.Historytableview setHidden:NO]; //搜索列表隐藏
    [self.Maintableview setHidden:YES];    //主列表隐藏
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    将要结束编辑时的回调
    NSLog(@"将要结束编辑时的回调");
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    已经结束编辑的回调
    NSLog(@"已经结束编辑的回调");
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    编辑文字改变的回调
    NSLog(@" 编辑文字改变的回调");
    
       [self.Historytableview setHidden:NO];    //搜索列表隐藏
        [self.Maintableview setHidden:YES];     //主列表隐藏
        NSLog(@"内容:%@",searchText);
    
    if (searchText.length <1) {
        
        self.Serachword = @"";
    }
    
        NSLog(@"搜索内容改变....");
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    编辑文字改变前的回调，返回NO则不能加入新的编辑文字
    NSLog(@" 编辑文字改变前的回调，返回NO则不能加入新的编辑文字");
    return YES;
}

#pragma -mark 搜索按钮点击的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    
//    搜索按钮点击的回调
    NSLog(@"搜索按钮点击的回调");
    searchBar.showsCancelButton     = NO; //取消按钮不显示
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length>0) {
        
        self.Serachword  = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSLog(@"搜索吧，我的铺皇   %@",self.Serachword);
        [MainsearchData SearchText:searchBar.text];//缓存搜索记录
        [self readNSUserDefaults];
        [self.Historytableview   setHidden:YES];    //搜索列表隐藏
        [self.Maintableview      setHidden:NO];     //主列表显示
        //        获取并刷新数据
            [self LoadData];
        
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
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    取消按钮点击的回调
    NSLog(@"取消按钮点击的回调");
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton     = NO; //取消按钮不显示
    [self.Historytableview   setHidden:YES];    //搜索列表隐藏
    [self.Maintableview      setHidden:NO];     //主列表显示
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
//    搜索结果按钮点击的回调
    NSLog(@"搜索结果按钮点击的回调");
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
//    书本按钮点击的回调
    NSLog(@"书本按钮点击的回调");
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
//    搜索栏的附加试图中切换按钮触发的回调
    NSLog(@"搜索栏的附加试图中切换按钮触发的回调");
}

#pragma -mark - tableviewcell代理
#pragma -mark section 大段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.Historytableview) {
        return 2;
    }else{
        return 4;
    }
}
#pragma -mark section 列
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.Historytableview) {
        if (section==0) {
            if (_searchArr.count>0) {
                return _searchArr.count+1+1;
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
//        maintableview
        return 1;
    }
}

//头部试图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

//头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.Maintableview) {
        if (section == 0) {
            return 0;
        }
        else{
            
            return 5;
        }
        
    }else{
        
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.Maintableview) {
            return 10;
    }else{
        
        return 5;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.Historytableview) {
        
        self.Historytableview.estimatedRowHeight = 44.0f;
        return UITableViewAutomaticDimension;
    }
    
    else{
        
        switch (indexPath.section) {
            case 0:{
                
                return 130;
            }
                break;
            case 1:{
                
                return 130;
            }
                break;
            case 2:{
            
                return 140;
            }
                break;
                
            default:{
                
                return 145;
            }
                  break;
        }
    }
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
if (tableView == self.Historytableview) {
    
        if(indexPath.row ==0){
            
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            cell.textLabel.text = @"历史搜索";
            cell.textLabel.textColor = fontCOLOR;
            return cell;
        }
        
        else if (indexPath.row == _searchArr.count+1){
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            cell.textLabel.text = @"清除历史记录";
            cell.textLabel.textColor = fontCOLOR;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
        
        else{
            
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            NSArray* reversedArray = [[_searchArr reverseObjectEnumerator] allObjects];
            cell.textLabel.text = reversedArray[indexPath.row-1];
            return cell;
        }
    }
    
    else{

        switch (indexPath.section) {
            case 0:{
                
                static NSString *identifier = @"ZR";
                SerachViewCell *cell = [self.Maintableview dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"SerachViewCell" owner:self options:nil]lastObject];
                }
                cell.SEAsection.text = @"店铺转让";
                if (_ZRArr.count < 1) {
                    
                    cell.SEAImgview.hidden  =YES;
                    cell.SEAtitle.hidden    =YES;
                    cell.SEAquyu.hidden     =YES;
                    cell.SEAtime.hidden     =YES;
                    cell.SEAtype.hidden     =YES;
                    cell.SEAarea.hidden     =YES;
                    cell.SEAmoney.hidden    =YES;
                    cell.SEAerror.hidden    =NO;
                }
                else{
                    cell.SEAImgview.hidden =NO;
                    cell.SEAtitle.hidden   =NO;
                    cell.SEAquyu.hidden    =NO;
                    cell.SEAtime.hidden    =NO;
                    cell.SEAtype.hidden    =NO;
                    cell.SEAarea.hidden    =NO;
                    cell.SEAmoney.hidden   =NO;
                    cell.SEAerror.hidden   =YES;
                    [cell.CheckAll addTarget:self action:@selector(checkzr:) forControlEvents:UIControlEventTouchUpInside];
                   
                    SerachModel * model = [_ZRArr objectAtIndex:0];
                    [cell.SEAImgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.SEAImgview]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
                    cell.SEAtitle.text = model.SEAtitle;
                    cell.SEAquyu.text  = model.SEAquyu;
                    cell.SEAtime.text  = model.SEAtime;
                    cell.SEAtype.text  = model.SEAtype;
                    cell.SEAarea.text  = [NSString stringWithFormat:@"%@m²",model.SEAarea   ];
                    cell.SEAmoney.text = [NSString stringWithFormat:@"%@元/月",model.SEAmoney];
                }
                
                cell.selectionStyle  = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 1:{
                
                static NSString *identifier = @"CZ";
                SerachViewCell *cell = [self.Maintableview dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"SerachViewCell" owner:self options:nil]lastObject];
                }
                cell.SEAsection.text = @"店铺出租";
                 if (_CZArr.count < 1) {
                    cell.SEAImgview.hidden  =YES;
                    cell.SEAtitle.hidden    =YES;
                    cell.SEAquyu.hidden     =YES;
                    cell.SEAtime.hidden     =YES;
                    cell.SEAtype.hidden     =YES;
                    cell.SEAarea.hidden     =YES;
                    cell.SEAmoney.hidden    =YES;
                    cell.SEAerror.hidden    =NO;
                 }
                 else{
                     cell.SEAImgview.hidden =NO;
                     cell.SEAtitle.hidden   =NO;
                     cell.SEAquyu.hidden    =NO;
                     cell.SEAtime.hidden    =NO;
                     cell.SEAtype.hidden    =NO;
                     cell.SEAarea.hidden    =NO;
                     cell.SEAmoney.hidden   =NO;
                     cell.SEAerror.hidden   =YES;
                     [cell.CheckAll addTarget:self action:@selector(checkcz:) forControlEvents:UIControlEventTouchUpInside];
                    
                     SerachModel * model = [_CZArr objectAtIndex:0];
                     [cell.SEAImgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.SEAImgview]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
                     cell.SEAtitle.text = model.SEAtitle;
                     cell.SEAquyu.text  = model.SEAquyu;
                     cell.SEAtime.text  = model.SEAtime;
                     cell.SEAtype.text  = model.SEAtype;
                     cell.SEAarea.text  = [NSString stringWithFormat:@"%@m²",model.SEAarea];
                     cell.SEAmoney.text = [NSString stringWithFormat:@"%@元/月",model.SEAmoney];
                 }
                
                cell.selectionStyle  = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 2:{
                
                static NSString *identifier = @"XZ";
                SerachXZViewCell *cell = [self.Maintableview dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"SerachXZViewCell" owner:self options:nil]lastObject];
                }
                
                 if (_XZArr.count < 1) {

                    cell.SEAXZtitle.hidden  = YES;  //标题
                    cell.SEAXZsubtitle.hidden = YES;//描述
                    cell.SEAXZtype.hidden   = YES;  //类型
                    cell.SEAXZquyu.hidden   = YES;  //区域
                    cell.SEAXZarea.hidden   = YES;  //面积
                    cell.SEAXZmoney.hidden  = YES;  //价钱
                    cell.SEAXZerror.hidden  = NO;
                     
                 }else{
                
                     cell.SEAXZtitle.hidden  = NO;  //标题
                     cell.SEAXZsubtitle.hidden = NO;//描述
                     cell.SEAXZtype.hidden   = NO;  //类型
                     cell.SEAXZquyu.hidden   = NO;  //区域
                     cell.SEAXZarea.hidden   = NO;  //面积
                     cell.SEAXZmoney.hidden  = NO;  //价钱
                     cell.SEAXZerror.hidden  = YES;
                     [cell.SEAXZcheck addTarget:self action:@selector(checkxz:) forControlEvents:UIControlEventTouchUpInside];
                     
                     SerachXZModel  *model = [_XZArr objectAtIndex:0];
                     cell.SEAXZtitle.text = model.SEAXZtitle;
                     cell.SEAXZsubtitle.text = model.SEAXZsubtitle;
                     cell.SEAXZtype.text = model.SEAXZtype;
                     cell.SEAXZquyu.text = model.SEAXZquyu;
                     cell.SEAXZarea.text  = [NSString stringWithFormat:@"%@m²",model.SEAXZarea];
                     cell.SEAXZmoney.text = [NSString stringWithFormat:@"%@元/月",model.SEAXZmoney];
                     
                     
                 }
                
                cell.selectionStyle  = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
                
            default:{
                
                static NSString *identifier = @"ZP";
                SerachZPViewCel *cell = [self.Maintableview dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"SerachZPViewCel" owner:self options:nil]lastObject];
                }
//
                if (_ZPArr.count < 1) {
                    NSLog(@"无数据！！！");
                    cell.SEAZPtitle.hidden   = YES;//标题
                    cell.SEAZPsubtitle.hidden= YES;//副标题
                    cell.SEAZPquyu.hidden    = YES;//区域
                    cell.SEAZPage.hidden     = YES;//经验
                    cell.SEAZPedu.hidden     = YES;//学历
                    cell.SEAZPzalay.hidden   = YES;//工资
                    cell.SEAZPerror.hidden   = NO;//错误提示
                }else{
                    cell.SEAZPtitle.hidden   = NO;//标题
                    cell.SEAZPsubtitle.hidden= NO;//副标题
                    cell.SEAZPquyu.hidden    = NO;//区域
                    cell.SEAZPage.hidden     = NO;//经验
                    cell.SEAZPedu.hidden     = NO;//学历
                    cell.SEAZPzalay.hidden   = NO;//工资
                    cell.SEAZPerror.hidden   = YES;//错误提示
                    [cell.SEAZPcheck addTarget:self action:@selector(checkzp:) forControlEvents:UIControlEventTouchUpInside];
                    
                    SerachZPModel  *model = [_ZPArr objectAtIndex:0];
                    cell.SEAZPtitle.text = model.SEAZPtitle;
                    cell.SEAZPsubtitle.text = model.SEAZPsubtitle;
                    cell.SEAZPquyu.text = model.SEAZPquyu;
                    cell.SEAZPage.text = model.SEAZPage;
                    cell.SEAZPedu.text  = model.SEAZPedu;
                    cell.SEAZPzalay.text = [NSString stringWithFormat:@"%@元/月",model.SEAZPzalay];
                }
               
                cell.selectionStyle     = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.Historytableview){
        
        [self.Historytableview deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.row == _searchArr.count+1){    //清除所有历史记录
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除历史记录" message:@"" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                           {
                                               [MainsearchData removeAllArray];
                                               _searchArr = nil;
                                               [self.Historytableview reloadData];
                                           }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        else if(indexPath.row == 0){
            
            NSLog(@"历史记录");
        }
        else{
            
            NSLog(@"点击了%ld行",indexPath.row);
             self.searchbar.showsCancelButton  = NO; //取消按钮不显示
            NSLog(@"记录缓存：%@",_searchArr[_searchArr.count-indexPath.row]);
            self.searchbar.text = [NSString stringWithFormat:@"%@",_searchArr[_searchArr.count-indexPath.row]];
             self.Serachword  =[[NSString stringWithFormat:@"%@",_searchArr[_searchArr.count-indexPath.row]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self.Historytableview setHidden:YES];
            [self.Maintableview    setHidden:NO ];
            [self.searchbar resignFirstResponder];
            //        获取并刷新数据
            [self LoadData];
        }
    }
    
    else{
        
        NSLog(@"第几段%ld==第几列%ld",indexPath.section,indexPath.row);
        
        switch (indexPath.section) {
            case 0:{
                
                if (_ZRArr.count < 1) {
                    NSLog(@"无数据不能进去！！！");
                }else{
                    //    获取店铺唯一id
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    SerachModel *model = [_ZRArr objectAtIndex:0];
                    DetailedController *ctl =[[DetailedController alloc]init];
                    ctl.shopsubid = model.SEAid;
                    ctl.shopcode  = @"transfer";
                    NSLog(@"店铺🆔%@",ctl.shopsubid);
                    [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
                }
            }
                break;
            case 1:{
                if (_CZArr.count < 1) {
                    NSLog(@"无数据不能进去！！！");
                }else{
                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
//                        获取店铺唯一id
                    SerachModel *model = [_CZArr objectAtIndex:0];
                    DetailedController *ctl =[[DetailedController alloc]init];
                    ctl.shopsubid = model.SEAid;
                    ctl.shopcode  = @"rentout";
                    NSLog(@"店铺🆔%@",ctl.shopsubid);
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
                }
            }
                
                break;
            case 2:{
                if (_XZArr.count < 1) {
                    NSLog(@"无数据不能进去！！！");
                }else{
                
                   self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    //    获取店铺唯一id
                    SerachXZModel *model        = [_XZArr objectAtIndex:0];
                    ShopsiteXQController *ctl   = [[ShopsiteXQController alloc]init];
                    ctl.shopsubid               = model.SEAXZid;
                    [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
                }
            }
                
                break;
            case 3:{
                
                if (_ZPArr.count < 1) {
                    NSLog(@"无数据不能进去！！！");
                }else{
                    
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    ResumeXQController *ctl =[[ResumeXQController alloc]init];
                    //    获取店铺唯一id
                    SerachZPModel *model    = [_ZPArr objectAtIndex:0];
                    ctl.shopsubid               = model.SEAXZid;
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
                }
            }
                break;
        }
    }
}

#pragma mark 查看转让全部数据
-(void)checkzr:(UIButton *)ZRbtn{
    NSLog(@"转让查看全部");
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    SeacheckZRController *ctl =[[SeacheckZRController alloc]init];
    ctl.Searchword_ZR  = self.Serachword;
    ctl.Searchcity_ZR  = self.Cityid;
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
    
}
#pragma mark 查看出租全部数据
-(void)checkcz:(UIButton *)CZbtn{
    NSLog(@"出租查看全部");
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    SeacheckCZController *ctl =[[SeacheckCZController alloc]init];
    ctl.Searchword_CZ  = self.Serachword;
    ctl.Searchcity_CZ  = self.Cityid;
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}
#pragma mark 查看选址全部数据
-(void)checkxz:(UIButton *)XZbtn{
    NSLog(@"选址查看全部");
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    SeacheckXZController *ctl =[[SeacheckXZController alloc]init];
    ctl.Searchword_XZ  = self.Serachword;
    ctl.Searchcity_XZ  = self.Cityid;
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}
#pragma mark 查看招聘全部数据
-(void)checkzp:(UIButton *)ZPbtn{
    NSLog(@"招聘查看全部");
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    SeacheckZPController *ctl =[[SeacheckZPController alloc]init];
    ctl.Searchword_ZP   = self.Serachword;
    ctl.Searchcity_ZP   = self.Cityid;
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
}

#pragma -mark 创建搜索主页table
-(void)creatmaintableview{
    if (iOS11) {
        
        self.Maintableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight+64)];
    }else{
        self.Maintableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight-64)];
    }
    
    self.Maintableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.Maintableview setHidden:NO];
    self.Maintableview.delegate   =self;
    self.Maintableview.dataSource =self;
    self.Maintableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.Maintableview];
}

#pragma -mark 创建搜索记录table
-(void)creatsearchtableview{
    if (iOS11) {
        self.Historytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight)];
    }else{
    self.Historytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    }
    
    self.Historytableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.Historytableview setHidden:YES];
    self.Historytableview.delegate   =self;
    self.Historytableview.dataSource =self;
    [self.view addSubview:self.Historytableview];
    [self readNSUserDefaults];
}

#pragma -mark //取出缓存的数据
-(void)readNSUserDefaults{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray * mainArray = [userDefaultes arrayForKey:@"MainArray"];
    self.searchArr = mainArray;
    [self.Historytableview reloadData];
    NSLog(@"搜索缓存数据:%@",mainArray);
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    [self.searchbar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    if(self.task) {
        
      
        [self.task cancel];//取消当前界面的数据请求.
    }
    NSLog(@"已经看过了我要返回");
}

- (void)BackButtonClick{
    if(self.task) {
        
       
        [self.task cancel];//取消当前界面的数据请求.
    }
    [self.searchbar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
   
    [super viewWillDisappear:animated];
}

#pragma -mark 触摸历史记录列表 推出的全部搜索事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    判断滑动到是Mainscrollow
    if (scrollView == _Historytableview){
        
        self.searchbar.showsCancelButton = NO;
        [self.searchbar resignFirstResponder];
        
    }else{
//        NSLog(@"触摸main列表");
    }
}

@end
