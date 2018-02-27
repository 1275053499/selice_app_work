//
//  ReleaseZRController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ReleaseZRController.h"
#import "ZYKeyboardUtil.h"
#define MARGIN_KEYBOARD 10
#import "HXProvincialCitiesCountiesPickerview.h"
#import "HXAddressManager.h"

@interface ReleaseZRController ()<UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
    BOOL phoneRight;
    
    UIView *poprightview;
}

@property   (nonatomic, strong) UILabel             * BGlab;               //无网络提示语
@property   (nonatomic, strong) NSMutableArray      * PopArr;               //存储数据
@property (nonatomic,strong)UIButton *surebtn;    //选择套餐确定
@property (nonatomic,strong)UIButton *cancelbtn;  //选择套餐取消


@property (strong, nonatomic)   NSMutableArray      * titlesArray;
@property(nonatomic,strong)     UIImageView         * Licenseimgview;     //营业执照
@property(nonatomic,strong)     UIImageView         * Cardimgview;        //身份证复印件

@property (strong, nonatomic)   ZYKeyboardUtil      *   keyboardUtil;
@property (nonatomic,strong )   NSArray             * photosArr;
@property (nonatomic,strong )   HXProvincialCitiesCountiesPickerview *regionPickerView;
@property (nonatomic, strong)   UIImagePickerController *imagePickerVc;
@property (nonatomic, strong)   UICollectionView    * collectionView;
@property (nonatomic,strong)    UIBarButtonItem     * rightButton;
@property (nonatomic,strong)    UIBarButtonItem     * leftButton;

@property (nonatomic,strong)    UIView   *Headerview;

@property (nonatomic,strong)NSString        *XZaddess;
@property (nonatomic,strong)UITextField     *ZRname;//店名
@property (nonatomic,strong)UITextField     *ZRtransfer;//转让费
@property (nonatomic,strong)UILabel         *ZRtransfersub;//转让费单位
@property (nonatomic,strong)UITextField     *ZRarea;//面积
@property (nonatomic,strong)UILabel         *ZRareasub;//面积单位
@property (nonatomic,strong)UITextField     *ZRrent;//租金
@property (nonatomic,strong)UILabel         *ZRrentsub;//租金单位
@property (nonatomic,strong)UILabel         *ZRcitylab;//城市区域
@property (nonatomic,strong)UILabel         *ZRaddresslab;//具体地址
@property (nonatomic,strong)UILabel         *ZRdescribelab;//描述
@property (nonatomic,strong)UITextField     *ZRperson;//联系人
@property (nonatomic,strong)UITextField     *ZRnumber;//手机号码
@property (nonatomic,strong)UILabel         *ZRindustrylab;//行业
@property (nonatomic,strong)UILabel         *ZRturnlab;//空转
@property (nonatomic,strong)UILabel         *ZRManagementlab;//经营状态
@property (nonatomic,strong)UILabel         *ZRcontractlab;//合同剩余
@property (nonatomic,strong)UILabel         *ZRSupportlab;//配套设施
@property (nonatomic,strong)NSString        *ZRSupportid;//配套设施id
@property (nonatomic,strong)NSString        *Internetcheck;
@property (nonatomic,strong)NSString        *coordinate;//坐标
@property (nonatomic,strong)NSString        *Photochange; //认证照片切换选择

@property (nonatomic,strong)NSString        *licenseYES; //有认证照片
@property (nonatomic,strong)NSString        *cardYES;    //有身份证照片

@property (nonatomic,strong)NSString        *serviceID;    //选择的套餐🆔

@end

@implementation ReleaseZRController
-(NSArray*)photosArr{
    if (!_photosArr) {
       _photosArr = [[NSMutableArray alloc]init];
    }
    return _photosArr;
}

- (UIImagePickerController *)imagePickerVc {
    
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
     self.licenseYES = [NSString new];
     self.licenseYES = @"licenseNO";
     self.cardYES    = [NSString new];
     self.cardYES    = @"cardNO";
     _PopArr = [[NSMutableArray alloc]init];
     _serviceID = [NSString new];
//     设置基本
    [self CreatBase];
    
//   设置cellaccview
    [self creatcellUI];
    
//   创建上传照片位置
    [self creatphotoUI];
    [self configCollectionView];
    
    
//   创建Tableview
    [self creatTab];
    
//   创建通知
    [self ceatNoti];
    
//弹出试图
    [self buildPopview];
}

#pragma 套餐试图
-(void)buildPopview{
    
    poprightview = [[UIView alloc]initWithFrame:CGRectMake(0, KMainScreenHeight, KMainScreenWidth, KMainScreenHeight-64)];
    poprightview.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:poprightview];
    [self.view bringSubviewToFront:poprightview];
    
    self.surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.surebtn.frame     = CGRectMake(0, poprightview.frame.size.height-45, KMainScreenWidth/2, 40);
    [self.surebtn setTitle:@"发布" forState:UIControlStateNormal];
//    [self.surebtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    [self.surebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.surebtn addTarget:self action:@selector(popOutloadview) forControlEvents:UIControlEventTouchUpInside];
    self.surebtn.enabled = NO;
    [poprightview addSubview:self.surebtn];
    
    self.cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelbtn.frame     = CGRectMake(KMainScreenWidth/2, poprightview.frame.size.height-45, KMainScreenWidth/2, 40);
    [self.cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
//    [self.cancelbtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    [self.cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelbtn addTarget:self action:@selector(popOutview) forControlEvents:UIControlEventTouchUpInside];
    [poprightview addSubview:self.cancelbtn];

}

#pragma -mark 套餐选择界面弹出
-(void)popInview{
    
    self.rightButton.enabled = NO;
    [UIView animateWithDuration:.5f  //动画持续时间
                     animations:^{
                         //执行的动画
                         poprightview.frame = CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight-64);
                         poprightview.alpha = 1.0;
                         
                         self.FBtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, poprightview.frame.size.height-50)];
                         self.FBtableView.showsVerticalScrollIndicator      = NO;
                         self.FBtableView.delegate                          = self;
                         self.FBtableView.dataSource                        = self;
                         //    滚动条
                         self.FBtableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
                         //    当cell比较少时强制去掉多余的分割线
                         self.FBtableView.tableFooterView  =[[UIView alloc]init];//关键语句
                         [poprightview addSubview:self.FBtableView ];
                         
                         //        无数据的提示
                         self.BGlab                  = [[UILabel alloc]init];
                         [self.FBtableView addSubview:self.BGlab];
                         self.BGlab.text             = @"未购买过套餐";
                         self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
                         self.BGlab.textColor        = kTCColor(161, 161, 161);
                         self.BGlab.backgroundColor  = [UIColor clearColor];
                         self.BGlab.textAlignment    = NSTextAlignmentCenter;
                         [self.BGlab setHidden:NO];                              //隐藏提示
                         [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
                             make.center.equalTo(self.FBtableView);
                             make.size.mas_equalTo(CGSizeMake(100, 20));
                         }];
                         
                     }  completion:^(BOOL finished) {
                         //动画执行完毕后的操作
                         
//                         if ([self.Navtitle isEqualToString:@"发布转让"]){
                              [self loadZRData];
//                         }else{
//                              [self loadCZData];
//                         }
                         [self refresh];
                     }];
}


#pragma -mark 套餐选择界面 确认按钮 选择了回收
-(void)popOutloadview{

    //需要选择了一个套餐之后才能点击
    self.rightButton.enabled = YES;
    self.surebtn.enabled     = NO;
    [UIView animateWithDuration:.5f animations:^{
        
    } completion:^(BOOL finished) {
    
    }];
    
    [UIView animateWithDuration:.5f animations:^{
        poprightview.frame = CGRectMake(0, KMainScreenHeight, KMainScreenWidth, KMainScreenHeight-64);
        [self.FBtableView removeFromSuperview];
        [self.PopArr      removeAllObjects];
        [self reachability];
    }];
}

#pragma -mark 套餐选择界面回收 取消按钮
-(void)popOutview{
    
     self.rightButton.enabled = YES;
     self.surebtn.enabled     = NO;
    [UIView animateWithDuration:.5f animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:.5f animations:^{
        poprightview.frame = CGRectMake(0, KMainScreenHeight, KMainScreenWidth, KMainScreenHeight-64);
        [self.FBtableView removeFromSuperview];
        [self.PopArr removeAllObjects];
    }];
}

-(void)refresh{
    
#pragma  -mark下拉刷新获取网络数据
    
//    if ([self.Navtitle isEqualToString:@"发布转让"]){
         MJRefreshNormalHeader *header           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadZRData)];
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
        self.FBtableView.mj_header  = header;
//    }
//    else{
//
//        MJRefreshNormalHeader *header           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCZData)];
//        // Set title
//        [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
//        [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
//        [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
//        // Set font
//        header.stateLabel.font = [UIFont systemFontOfSize:15];
//        header.lastUpdatedTimeLabel.font        = [UIFont systemFontOfSize:14];
//        // Set textColor
//        header.stateLabel.textColor             = kTCColor(161, 161, 161);
//        header.lastUpdatedTimeLabel.textColor   = kTCColor(161, 161, 161);
//        self.FBtableView.mj_header  = header;
//    }
}

#pragma -mark 加载转让套餐数据看看
-(void)loadZRData{
    
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"查询套餐中...."];
    NSLog(@"加载数据中.....");
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSDictionary *params =  @{
                                  @"id":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                              };
    [manager GET:Myservicezrbagpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
        
        NSLog(@"请求成功咧");
        NSLog(@"数据:%@", responseObject[@"data"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            [_PopArr removeAllObjects];
            [YJLHUD showSuccessWithmessage:@"查询成功"];
            [YJLHUD dismissWithDelay:.5];
            for (NSDictionary *dic in responseObject[@"data"]){
                
                Popmodel *model = [[Popmodel alloc]init];
                model.service1               = dic[@"home_times"];
                model.service2               = dic[@"display_times"];
                model.servicetime            = dic[@"time"];
                model.serviceid              = dic[@"id"];
            
                if ([dic[@"home_times"] isEqualToString:@"0"]&&[dic[@"display_times"] isEqualToString:@"0"]) {
                    NSLog(@"有空数据");
                }
                
                else{
                    
                    [model setValuesForKeysWithDictionary:dic];
                    [_PopArr addObject:model];
                }
            }
            
//            NSLog(@" 加载后现在总请求到数据有%ld个",_PopArr.count);
            [self.BGlab setHidden:YES];
        }
        
        else{
            
            //code 401
            NSLog(@"不可以拿到数据的");
            [self.BGlab setHidden:NO];
            self.BGlab.text = @"未购买过套餐～";
           
            [YJLHUD showErrorWithmessage:@"未购买过套餐～"];
            [YJLHUD dismissWithDelay:.5];

    
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"是否需要购买套餐" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
               
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    TransferSetmealController *ctl =[[TransferSetmealController alloc]init];//套餐页面
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
                });
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
                NSLog(@"取消");
            }];
            
            [alertController addAction:commitAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        [self.FBtableView reloadData];
        [self.FBtableView.mj_header endRefreshing];//停止刷新
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
       
        [self.BGlab setHidden:NO];
        self.BGlab.text = @"网络连接错误";
        [self.FBtableView.mj_header endRefreshing];//停止刷新
        [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
        [YJLHUD dismissWithDelay:.5];
    }];
}

//#pragma -mark 加载出租套餐数据看看
//-(void)loadCZData{
//
//     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"查询套餐中...."];
//    NSLog(@"加载数据中.....");
//    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
//    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 10.0;
//    NSDictionary *params =  @{
//                                  @"id":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
//                              };
//    [manager GET:Myserviceczbagpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
//
//        NSLog(@"请求成功咧");
//        NSLog(@"数据:%@", responseObject[@"data"]);
//
//        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
//            NSLog(@"可以拿到数据的");
//            [_PopArr removeAllObjects];
//            [YJLHUD showSuccessWithmessage:@"查询成功"];
//            [YJLHUD dismissWithDelay:.5];
//            for (NSDictionary *dic in responseObject[@"data"]){
//
//                Popmodel *model = [[Popmodel alloc]init];
//                model.service1               = dic[@"home_times"];
//                model.service2               = dic[@"map_times"];
//                model.servicetime            = dic[@"time"];
//                model.serviceid              = dic[@"id"];
//
//                if ([dic[@"home_times"] isEqualToString:@"0"]&&[dic[@"display_times"] isEqualToString:@"0"]) {
//                    NSLog(@"有空数据");
//                }
//
//                else{
//
//                    [model setValuesForKeysWithDictionary:dic];
//                    [_PopArr addObject:model];
//                }
//
//            }
//
////            NSLog(@" 加载后现在总请求到数据有%ld个",_PopArr.count);
//            [self.BGlab setHidden:YES];
//        }
//
//        else{
//
//            //code 401
//            NSLog(@"不可以拿到数据的");
//            [self.BGlab setHidden:NO];
//            self.BGlab.text = @"未购买过套餐～";
//
//            [YJLHUD showErrorWithmessage:@"未购买过套餐～"];
//            [YJLHUD dismissWithDelay:.5];
//
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"是否需要购买套餐" preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
//                    RenttaocanController *ctl =[[RenttaocanController alloc]init];//套餐页面
//                    [self.navigationController pushViewController:ctl animated:YES];
//                     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
//
//                });
//
//            }];
//
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//
//                NSLog(@"取消");
//            }];
//
//            [alertController addAction:commitAction];
//            [alertController addAction:cancelAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//        }
//
//        [self.FBtableView reloadData];
//        [self.FBtableView.mj_header endRefreshing];//停止刷新
//
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"请求数据失败----%@",error);
//        self.BGlab.text = @"网络连接错误";
//        [self.BGlab setHighlighted:NO];
//        [self.FBtableView.mj_header endRefreshing];//停止刷新
//        [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
//        [YJLHUD dismissWithDelay:1];
//    }];
//}


-(void)ceatNoti{
#pragma  -mark 通知限制输入字数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZRarea:)                                          name:@"UITextFieldTextDidChangeNotification" object:self.ZRarea];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZRname:)
                                                 name:@"UITextFieldTextDidChangeNotification" object:self.ZRname];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZRrent:)
                                                 name:@"UITextFieldTextDidChangeNotification" object:self.ZRrent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZRtransfer:)
                                                 name:@"UITextFieldTextDidChangeNotification" object:self.ZRtransfer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZRperson:) name:@"UITextFieldTextDidChangeNotification" object:self.ZRperson];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZRnumber:) name:@"UITextFieldTextDidChangeNotification" object:self.ZRnumber];
}

-(void)creatTab{
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight-10)];
    tableView.showsVerticalScrollIndicator      = NO;
    tableView.delegate                          = self;
    tableView.dataSource                        = self;
    //    滚动条
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView = tableView;

    //    当cell比较少时强制去掉多余的分割线
    self.tableView.tableFooterView  =[[UIView alloc]init];//关键语句
    self.tableView.tableHeaderView  = _Headerview;
    [self.view addSubview:tableView];
}

-(void)CreatBase{
    
    self.view.backgroundColor   = [UIColor whiteColor];
    self.title               = self.Navtitle;
    _selectedPhotos             = [NSMutableArray array];
    _selectedAssets             = [NSMutableArray array];
 
    _coordinate  =[[NSString alloc]init];

   self.leftButton = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackreleaseZR)];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    
    self.rightButton = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(choose)];
    self.rightButton.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma mark cell控件
-(void)creatcellUI{
    
#pragma mark    店名
    _ZRname                    = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-100, 40)];
    _ZRname.font               = [UIFont systemFontOfSize:12.0];
    _ZRname.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZRname.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _ZRname.textAlignment      = NSTextAlignmentRight;
    _ZRname.placeholder        = @"输入发布标题（20字以内";
    _ZRname.font               = [UIFont systemFontOfSize:12.0];
    _ZRname.delegate           = self;
    _ZRname.textColor          = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    
#pragma mark  店铺转让费
    _ZRtransfer                     = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-100, 40)];
    _ZRtransfer.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZRtransfer.textAlignment       = NSTextAlignmentRight;
    _ZRtransfer.clearButtonMode     = UITextFieldViewModeWhileEditing;
    _ZRtransfer.keyboardType        = UIKeyboardTypeNumberPad;
//    if ([self.Navtitle isEqualToString:@"发布转让"]){
        _ZRtransfer.placeholder         = @"转让费用";
//    }else{
//        _ZRtransfer.placeholder         = @"店铺押金";
//    }
    
    _ZRtransfer.font                = [UIFont systemFontOfSize:12.0];
    _ZRtransfer.delegate            = self;
    _ZRtransfer.textColor           = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    
    _ZRtransfersub                  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _ZRtransfersub.textColor        = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZRtransfersub.text             = @"万元";
    _ZRtransfersub.textAlignment    = NSTextAlignmentCenter;
    _ZRtransfersub.font             = [UIFont systemFontOfSize:12.0];
    _ZRtransfer.rightView           = _ZRtransfersub;
    _ZRtransfer.rightViewMode       = UITextFieldViewModeAlways;//左边视图显示模式
    
#pragma mark  店铺面积
    _ZRarea                     = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-100, 40)];
    _ZRarea.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZRarea.textAlignment       = NSTextAlignmentRight;
    _ZRarea.clearButtonMode     = UITextFieldViewModeWhileEditing;
    _ZRarea.keyboardType        = UIKeyboardTypeNumberPad;
    //    _XZarea.backgroundColor     = [UIColor redColor];
    _ZRarea.placeholder         = @"输入面积";
    _ZRarea.font                = [UIFont systemFontOfSize:12.0];
    _ZRarea.delegate            = self;
    _ZRarea.textColor           = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    
    _ZRareasub                  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _ZRareasub.textColor        = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZRareasub.text             = @"平方";
    _ZRareasub.textAlignment    = NSTextAlignmentCenter;
    _ZRareasub.font             = [UIFont systemFontOfSize:14.0];
    _ZRarea.rightView           = _ZRareasub;
    _ZRarea.rightViewMode       = UITextFieldViewModeAlways;//左边视图显示模式
 
#pragma mark  店铺租金
    _ZRrent                     = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-100, 40)];
    _ZRrent.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZRrent.textAlignment       = NSTextAlignmentRight;
    _ZRrent.clearButtonMode     = UITextFieldViewModeWhileEditing;
    _ZRrent.keyboardType        = UIKeyboardTypeNumberPad;
    _ZRrent.placeholder         = @"输入租金";
    _ZRrent.font                = [UIFont systemFontOfSize:12.0];
    _ZRrent.delegate            = self;
    _ZRrent.textColor           = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    
    _ZRrentsub                  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _ZRrentsub.textColor        = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZRrentsub.text             = @"元";
    _ZRrentsub.textAlignment    = NSTextAlignmentCenter;
    _ZRrentsub.font             = [UIFont systemFontOfSize:14.0];
    _ZRrent.rightView           = _ZRrentsub;
    _ZRrent.rightViewMode       = UITextFieldViewModeAlways;//左边视图显示模式
    
#pragma mark  城市区域
    _ZRcitylab                    = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZRcitylab.font               = [UIFont systemFontOfSize:12.0];
    _ZRcitylab.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];

    _ZRcitylab.textAlignment      = NSTextAlignmentRight;
    _ZRcitylab.text               = @"请填写信息";

#pragma mark  具体地址
    _ZRaddresslab                    = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZRaddresslab.font               = [UIFont systemFontOfSize:12.0];
    _ZRaddresslab.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _ZRaddresslab.textAlignment      = NSTextAlignmentRight;
    _ZRaddresslab.text               = @"请填写信息";

#pragma mark  描述
    _ZRdescribelab                    = [[UILabel alloc]init];
    _ZRdescribelab.font               = [UIFont systemFontOfSize:12.0];
    _ZRdescribelab.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _ZRdescribelab.textAlignment      = NSTextAlignmentRight;
    _ZRdescribelab.text               = @"请填写信息";
//    _ZRdescribelab.backgroundColor = [UIColor blueColor];
     _ZRdescribelab.frame = CGRectMake(80, 5, KMainScreenWidth-105,[self getContactHeight:_ZRdescribelab.text]);
    _ZRdescribelab.numberOfLines =  0;
    
#pragma mark  联系人
    _ZRperson                    = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZRperson.font               = [UIFont systemFontOfSize:12.0];
    _ZRperson.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _ZRperson.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _ZRperson.textAlignment      = NSTextAlignmentRight;
    _ZRperson.delegate           = self;
    _ZRperson.placeholder        = @"输入联系人";
    _ZRperson.textColor          = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    
#pragma mark  手机号码
    _ZRnumber                   = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZRnumber.font               = [UIFont systemFontOfSize:12.0];
    _ZRnumber.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _ZRnumber.textAlignment      = NSTextAlignmentRight;
    _ZRnumber.placeholder        = @"输入联系号码";
    _ZRnumber.delegate           = self;
    _ZRnumber.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _ZRnumber.keyboardType       = UIKeyboardTypeNumberPad;
    _ZRnumber.textColor          = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];

#pragma mark  行业
    _ZRindustrylab                    = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZRindustrylab.font               = [UIFont systemFontOfSize:12.0];
    _ZRindustrylab.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
//    _ZRindustrylab.backgroundColor   = [UIColor cyanColor];
    _ZRindustrylab.textAlignment     = NSTextAlignmentRight;
    _ZRindustrylab.text              = @"请填写信息";

#pragma mark  空转
    _ZRturnlab                    = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100,50)];
    _ZRturnlab.font               = [UIFont systemFontOfSize:12.0];
    _ZRturnlab.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
//    _ZRturnlab.backgroundColor   = [UIColor cyanColor];
    _ZRturnlab.textAlignment     = NSTextAlignmentRight;
    _ZRturnlab.text              = @"请填写信息";

#pragma mark  经营状态
    _ZRManagementlab                    = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZRManagementlab.font               = [UIFont systemFontOfSize:12.0];
    _ZRManagementlab.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
//    _ZRManagementlab.backgroundColor   = [UIColor cyanColor];
    _ZRManagementlab.textAlignment     = NSTextAlignmentRight;
    _ZRManagementlab.text              = @"请填写信息";

#pragma mark  合同剩余
    _ZRcontractlab                    = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZRcontractlab.font               = [UIFont systemFontOfSize:12.0];
    _ZRcontractlab.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _ZRcontractlab.textAlignment     = NSTextAlignmentRight;
    _ZRcontractlab.text              = @"请填写信息";
    
#pragma mark  配套设施
    _ZRSupportlab                       = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZRSupportlab.font                   = [UIFont systemFontOfSize:12.0];
    _ZRSupportlab.textColor             = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _ZRSupportlab.textAlignment         = NSTextAlignmentRight;
    _ZRSupportlab.text                  = @"请填写信息";
    _ZRSupportlab.numberOfLines = 0;
//    键盘处理
    [self configKeyBoardRespond];
    
    self.Licenseimgview                          = [[UIImageView alloc]init];
    self.Licenseimgview.contentMode = UIViewContentModeScaleAspectFit;
    self.Licenseimgview.frame                    = CGRectMake(KMainScreenWidth-150, 10, 140, 180);
    self.Licenseimgview.image                    = [UIImage imageNamed:@"Ac_bg"];
   
    
    self.Cardimgview                             = [[UIImageView alloc]init];
     self.Cardimgview.contentMode = UIViewContentModeScaleAspectFit;
    self.Cardimgview.frame                       = CGRectMake(KMainScreenWidth-150, 10, 140, 180);
    self.Cardimgview.image                       = [UIImage imageNamed:@"Ac_bg"];
    
}

//在这里创建一个路径，用来在照相的代理方法里作为照片存储的路径
-(NSString *)getImageSavelicePath{
    
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath  = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath  = [documentPath stringByAppendingPathComponent:@"licePhotoFile"];
    return imageDocPath;
}

//在这里创建一个路径，用来在照相的代理方法里作为照片存储的路径
-(NSString *)getImageSavecardPath{
    
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath  = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath  = [documentPath stringByAppendingPathComponent:@"cardPhotoFile"];
    return imageDocPath;
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak ReleaseZRController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.ZRname, weakSelf.ZRtransfer, weakSelf.ZRarea, weakSelf.ZRrent,weakSelf.ZRperson,weakSelf.ZRnumber, nil];
    }];
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.ZRname resignFirstResponder];
    [self.ZRtransfer resignFirstResponder];
    [self.ZRarea resignFirstResponder];
    [self.ZRrent resignFirstResponder];
    [self.ZRperson resignFirstResponder];
    [self.ZRnumber resignFirstResponder];
    return YES;
}

#pragma mark - UITextFieldDelegate 限制店名字数
-(void)textFiledEditChangedZRname:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 > 20 && toBeString.length>1){
        
        textField.text = [toBeString substringToIndex:21];
    }
}

#pragma mark - UITextFieldDelegate 限制面积字数
-(void)textFiledEditChangedZRarea:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 > 4 && toBeString.length>1){
        
        textField.text = [toBeString substringToIndex:5];
    }
}

#pragma mark - UITextFieldDelegate 限制租金字数
-(void)textFiledEditChangedZRrent:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 > 7 && toBeString.length>1){
        
        textField.text = [toBeString substringToIndex:8];
    }
}

#pragma mark - UITextFieldDelegate 限制转让费字数
-(void)textFiledEditChangedZRtransfer:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 > 4 && toBeString.length>1){
        
        textField.text = [toBeString substringToIndex:5];
    }
}

#pragma mark - UITextFieldDelegate 限制联系电话字数
-(void)textFiledEditChangedZRnumber:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 > 11 && toBeString.length>1){
        
        textField.text = [toBeString substringToIndex:12];
    }
}

#pragma mark - UITextFieldDelegate 限制联系人字数
-(void)textFiledEditChangedZRperson:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 > 10 && toBeString.length>1){
        
        textField.text = [toBeString substringToIndex:11];
    }
}

#pragma mark -创建一些cell上面的小控间
-(void)creatphotoUI{
    
    //    CGFloat rgb = 244 / 255.0;
    _Headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 180)];
    _Headerview.backgroundColor = [UIColor cyanColor];
}

- (void)configCollectionView{
    
#pragma mark 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (KMainScreenWidth - 3 * _margin - 4) / 4 - _margin;
    layout.itemSize                = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing      = _margin;
    _collectionView                = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, _itemWH*2+_margin +12) collectionViewLayout:layout];
    CGFloat rgb = 244 / 255.0;
    
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor     = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset        = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource          = self;
    _collectionView.delegate            = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [_Headerview addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];

}

#pragma -mark 段头文字
-(NSMutableArray *)titlesArray{
    if (_titlesArray == nil){
        
        _titlesArray = [[NSMutableArray alloc]initWithObjects:@"认证信息",@"店铺信息",@"其他信息",nil];
    }
    return _titlesArray;
}

#pragma mark - Tableviewdatasource  代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.FBtableView) {
        return 1;
    }
    else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.FBtableView) {
        return _PopArr.count;
    }
    else{
        
        if (section == 0) {
                  return 2;
         }
         else{
                 return 7;
       }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.FBtableView) {
        return 110;
    }
    else{
        
    switch (indexPath.section) {
        case 0:{
            return 200;
        }
            break;
        case 1:{
            
            if (indexPath.row == 6) {

                return  [self getContactHeight:_ZRdescribelab.text]+10;
            }else{
                return 50;
            }
        }
            break;
        default:{
            return 50;
        }
            break;
    }
  }
}

-(float)getContactHeight:(NSString*)contact{
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:12.0]};
    CGSize maxSize = CGSizeMake(KMainScreenWidth-100, MAXFLOAT);
    
    // 计算文字占据的高度
    CGSize size = [contact boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

    if (size.height<50) {
        return 50;
    }else{
        return size.height;
    }
}

//  段与段之间间隔
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    
if (tableView == self.FBtableView) {
        return 0;
        }
else{
        if (section == 0) {
                return 0;
            }
            return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.FBtableView) {
        
        PopviewCell * cell = [[PopviewCell alloc]init];
        cell.selectedBackgroundView                 = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = kTCColor2(85, 85, 85,0.5);
        [cell sizeToFit];
        Popmodel *model = [_PopArr objectAtIndex:indexPath.row];
        if ([model.service1  integerValue]>5) {
            if ([model.service2 integerValue]>5) {
                cell.serviceName.text      = [NSString stringWithFormat:@"首页展示服务:%@天\n信息展示&地图推荐服务:%@天",model.service1,model.service2];
            }
            else{
                
                cell.serviceName.text      = [NSString stringWithFormat:@"首页展示服务:%@天",model.service1];
            }
        }
        else {
            cell.serviceName.text      = [NSString stringWithFormat:@"信息展示&地图推荐服务:%@天",model.service2];
        }
        
        cell.serviceTime.text      = [NSString stringWithFormat:@"%@",model.servicetime];
        return cell;
    }
    
    else{
            UITableViewCell *cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                        cell.textLabel.text = @"身份证照片(选填)";
                        [cell.contentView addSubview:self.Cardimgview];
                 }
                break;
                
            default:{
                        cell.textLabel.text = @"店铺营业执照";
                        cell.detailTextLabel.text =   @"店铺租赁合同(选填)";
                        cell.detailTextLabel.textColor = [UIColor blackColor];
                        [cell.contentView addSubview:self.Licenseimgview];
            }
                break;
        }
    }
    
   else if (indexPath.section == 1){
        switch (indexPath.row){
                //         列0
            case 0:{
                cell.textLabel.text =@"店铺名称";
                cell.accessoryView  =_ZRname;
            }
                break;
                //         列1
            case 1:{
//                if ([self.Navtitle isEqualToString:@"发布转让"]){
                    cell.textLabel.text=@"转让费用";
//                }else{
//                     cell.textLabel.text=@"店铺押金";
//                }
                cell.accessoryView = _ZRtransfer;
            }
                break;
                //         列2
            case 2:{
                cell.textLabel.text=@"店铺面积";
                cell.accessoryView =_ZRarea;
            }
                
                break;
            case 3:{
                cell.textLabel.text=@"店铺租金";
                cell.accessoryView  =_ZRrent;
            }
                break;
                //         列5
            case 4:{
                cell.textLabel.text =@"城市区域";
                [cell.contentView addSubview:_ZRcitylab];
                
            }
                break;
                //         列6
            case 5:{
                cell.textLabel.text=@"具体地址";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.contentView addSubview:_ZRaddresslab];
            }
                break;
                
            case 6:{
                
                cell.textLabel.text=@"店铺描述";
                [cell.contentView addSubview:_ZRdescribelab];
                cell.contentView.height = [self getContactHeight:_ZRdescribelab.text];
                 _ZRdescribelab.frame = CGRectMake(80, 5, KMainScreenWidth-105, [self getContactHeight:_ZRdescribelab.text]);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
    }
}
            //   *ZRnamelab;//店名
            //   *ZRrentlab;//租金
            //   *ZRtransferlab;//转让费
            //  *ZRturnlab;//空转
            //   *ZRManagementlab;//经营状态
            //   *ZRcontractlab;//合同剩余
    else{
        switch (indexPath.row){
                case 0:{
                         cell.textLabel.text=@"可联系人";
                         [cell.contentView addSubview:_ZRperson];
                     }
                break;
                    //         列1
                case 1:{
                        cell.textLabel.text=@"手机号码";
                        [cell.contentView addSubview:_ZRnumber];
                    }
                break;
                    //         列2
                case 2:{
                     
                        cell.textLabel.text=@"店铺行业";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        [cell.contentView addSubview:_ZRindustrylab];
                    }
                break;
                    //         列3
                case 3:{
                        cell.textLabel.text=@"可否空转";
                        [cell.contentView addSubview:_ZRturnlab];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    break;
                    //         列4
                case 4:{
                        cell.textLabel.text=@"经营状态";
                        [cell.contentView addSubview:_ZRManagementlab];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                break;
                    //         列5
                case 5:{
                        cell.textLabel.text=@"合同期限";
                        [cell.contentView addSubview:_ZRcontractlab];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                break;
                    //         列6
                default:{
                            cell.textLabel.text=@"配套设施";
                            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            [cell.contentView addSubview:_ZRSupportlab];
                    }
                break;
        }
    }
//    cell无色
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"第%ld段---第%ld行",indexPath.section,indexPath.row);
    
    if (tableView == self.FBtableView) {
        _surebtn.enabled = YES;//按钮可点击了
        
        Popmodel*model = [_PopArr objectAtIndex:indexPath.row];
        NSString *service1 = [NSString  stringWithFormat:@"%@",model.service1];
        NSString *service2 = [NSString  stringWithFormat:@"%@",model.service2];
        self.serviceID = [NSString  stringWithFormat:@"%@",model.serviceid];
        NSLog(@"首页:%@天=地图:%@天=套餐id：%@",service1,service2,self.serviceID);
    }
    else{
        
    [_ZRname        resignFirstResponder];
    [_ZRarea        resignFirstResponder];
    [_ZRrent        resignFirstResponder];
    [_ZRtransfer    resignFirstResponder];
    [_ZRperson      resignFirstResponder];
    [_ZRnumber      resignFirstResponder];
    [tableView      deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"第%ld段---第%ld行",indexPath.section,indexPath.row);

    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    
                    NSLog(@"身份证");
                    self.Photochange = [NSString new];
                    self.Photochange = @"card";
                    [self usephoto];
                }
                    break;
                default:{
                    
                    NSLog(@"营业执照");
                    self.Photochange = [NSString new];
                    self.Photochange = @"lice";
                    [self usephoto];
                }
                    break;
            }
        }
            break;
        case 1:{
            switch (indexPath.row){
                    //         列0
                case 0:{
                    
#pragma mark - block传值 店铺名称
                    NSLog(@"店铺名称");
                    NSLog(@"%@",cell.textLabel.text);
                    
                }
                    break;
                    //         列1
                case 1:{
                    
                    NSLog(@"转让费用");
                    NSLog(@"%@",cell.textLabel.text);
#pragma mark - block传值 转让费用
                    
                }
                    break;
                    //         列2
                case 2:{
                    
                    NSLog(@"店铺面积");
                    NSLog(@"%@",cell.textLabel.text);
#pragma mark - block传值 面积
                }
                    break;
                    //         列4
                case 3:{
                    
                    NSLog(@"店铺租金");
                    NSLog(@"%@",cell.textLabel.text);
#pragma mark - block传值 租金
                }
                    break;
                    //         列5
                case 4:{
                    
                    NSLog(@"城市区域");
                    NSLog(@"%@",cell.textLabel.text);
                    
#pragma mark - block传值 城市区域
                    
                    if ([_ZRcitylab.text isEqualToString:@"请填写信息"]) {
                        _XZaddess = @"广东 深圳 宝安区";
                    }else{
                        _XZaddess = _ZRcitylab.text;
                    }
                    
                    NSArray * array =[_XZaddess componentsSeparatedByString:@" "];
                    NSString *province = @"";//省
                    NSString *city = @"";//市
                    NSString *county = @"";//县
                    if (array.count > 2) {
                        province = array[0];
                        city = array[1];
                        county = array[2];
                    } else if (array.count > 1) {
                        province = array[0];
                        city = array[1];
                    } else if (array.count > 0) {
                        province = array[0];
                    }
#pragma  -mark 城市选择 调用
                    
                    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];
                }
                    break;
                    //         列6
                case 5:{
                    NSLog(@"具体地址");
                    NSLog(@"%@",cell.textLabel.text);
                    NSLog(@"%@",_ZRarea.text);
                    
                    //                    限制区域未填写不允许进入
                    if ([_ZRcitylab.text isEqualToString:@"请填写信息"]||_ZRcitylab.text.length<1) {
                        NSLog(@"无理取闹");
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请注意" message:@"必须填写城市区域" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                            NSLog(@"点击了确认");
                        }];
                        [alertController addAction:commitAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    else{
                        //                    具体地址
                        ZRaddessController *ctl = [[ZRaddessController alloc]init];
                        ctl.labvalue =_ZRaddresslab.text;
                        ctl.quyuvalue = _ZRcitylab.text;
#pragma mark - block传值 地址
                        ctl.returnValueBlock = ^(NSString *strValue){
                            
                            NSLog(@"传值过来后的内容%@",strValue);
                            
                            _ZRaddresslab.text = strValue;
                            _ZRaddresslab.lineBreakMode = NSLineBreakByTruncatingMiddle;
                            _ZRaddresslab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
                        };
                        
                        ctl.returnValueBlockcoo=^(NSString *strValue){
                            NSLog(@"传值过来后经纬度%@",strValue);
                            _coordinate = strValue;
                        };
                        
                        [self enter:ctl];
                    }
                }
                    break;
                case 6:{
                    //                    店铺描述
                    NSLog(@"店铺描述");
                    NSLog(@"%@",cell.textLabel.text);
                    ZRdescribeController *ctl = [[ZRdescribeController alloc]init];
                    ctl.labvalue =_ZRdescribelab.text;
#pragma mark - block传值 店铺描述
                    ctl.returnValueBlock = ^(NSString *strValue){
                        
                        NSLog(@"传值过来后的内容%@",strValue);
                        _ZRdescribelab.text     = strValue;
                        _ZRdescribelab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
                      
                        if (_ZRdescribelab.text.length % 22 > 0 && _ZRdescribelab.text.length>22) {
                            _ZRdescribelab.textAlignment = NSTextAlignmentLeft;
                        }else{
                            _ZRdescribelab.textAlignment = NSTextAlignmentRight;
                        }
                        [self.tableView reloadData];
                    };
                    
                    [self enter:ctl];
                    
                }
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    
                    NSLog(@"可联系人");
                }
                    break;
                case 1:{
                    NSLog(@"手机号码");
                    NSLog(@"%@",cell.textLabel.text);
                }
                    break;
                    //         列2
                case 2:{
                    //                行业
                    NSLog(@"店铺行业");
                    NSLog(@"%@",cell.textLabel.text);
                    ZRindustryController *ctl = [[ZRindustryController alloc]init];
                    ctl.labvalue =_ZRindustrylab.text;
#pragma mark - block传值 店铺行业
                    ctl.returnValueBlock = ^(NSString *strValue) {
                        NSLog(@"传值过来后的内容%@",strValue);
                        _ZRindustrylab.text = strValue;
                        _ZRindustrylab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
                    };
                    
                    [self enter:ctl];
                }
                    break;
                    //         列3
                case 3:{
                    
                    NSLog(@"可否空装");
                    NSLog(@"%@",cell.textLabel.text);
                    ZRturnController *ctl = [[ZRturnController alloc]init];
                    ctl.labvalue =_ZRturnlab.text;
#pragma mark - block传值 可否空转
                    ctl.returnValueBlock = ^(NSString *strValue){
                        
                        NSLog(@"传值过来后的内容%@",strValue);
                        
                        _ZRturnlab.text = strValue;
                        _ZRturnlab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
                    };
                    
                    [self enter:ctl];
                }
                    break;
                    //         列4
                case 4:{
    
                    NSLog(@"经营状态");
                    NSLog(@"%@",cell.textLabel.text);
                    ZRManagementController *ctl = [[ZRManagementController alloc]init];
                    ctl.labvalue =_ZRManagementlab.text;
#pragma mark - block传值 经营状态
                    ctl.returnValueBlock = ^(NSString *strValue){
                        
                        _ZRManagementlab.text = strValue;
                        _ZRManagementlab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
                    };
                    
                    [self enter:ctl];
                }
                    break;
                    //         列5
                case 5:{
                    
                    NSLog(@"剩余合同");
                    NSLog(@"%@",cell.textLabel.text);
                    ZRcontractController *ctl = [[ZRcontractController alloc]init];
                    ctl.labvalue =_ZRcontractlab.text;
#pragma mark - block传值 合同
                    ctl.returnValueBlock = ^(NSString *strValue){
                        
                        NSLog(@"传值过来后的内容%@",strValue);
                        _ZRcontractlab.text = strValue;
                        _ZRcontractlab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
                    };
                    
                    [self enter:ctl];
                }
                    break;
                    //         列6
                default:{
                    
                    NSLog(@"配套设施");
                    NSLog(@"%@",cell.textLabel.text);
                    ZRfacilityController *ctl = [[ZRfacilityController alloc]init];
#pragma mark - block传值 设施
                    ctl.returnValueBlock = ^(NSString *strValue){
                        NSLog(@"传值过来后的内容%@",strValue);
                        _ZRSupportlab.text = strValue;
                        _ZRSupportlab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
                    };
                    
                    ctl.returnValueBlockid=^(NSString *strValue){
                        NSLog(@"传值过来后的内容ID=%@",strValue);
                        _ZRSupportid = strValue;
                    };
                    
                    [self enter:ctl];
                }
                    break;
            }
        }
            break;
        default:{
            NSLog(@"备用");
        }
            break;
       }
    }
}

-(void)takelocaCamera{
    
    //    AVAuthorizationStatusNotDetermined = 0,没有询问是否开启相机
    //    AVAuthorizationStatusRestricted    = 1,未授权，家长限制
    //    AVAuthorizationStatusDenied        = 2,//未授权
    //    AVAuthorizationStatusAuthorized    = 3,玩家授权
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
    }];
    
    //判断相机是否能够使用
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    if (status == AVAuthorizationStatusAuthorized) {
        /**********   已经授权 可以打开相机   ***********/
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        /**********   已经授权 可以打开相机   ***********/
    }else if (status == AVAuthorizationStatusNotDetermined){
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                //第一次用户接受
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                //用户拒绝
            }
        }];
        
    }else if (status == AVAuthorizationStatusRestricted){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的相机权限受限" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addAction:cancleAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }else if (status == AVAuthorizationStatusDenied){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (iOS8) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                NSURL *privacyUrl;
                
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                    [[UIApplication sharedApplication] openURL:privacyUrl];
                } else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"取消");
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alertController addAction:cancleAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }
}

-(void)takelocaPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    //相册的权限
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {
        
        NSLog(@"Authorized");
        [self presentViewController:picker animated:YES completion:nil];
        
    }else if (photoAuthorStatus == PHAuthorizationStatusDenied){
        
        NSLog(@"Denied");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (iOS8) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                NSURL *privacyUrl;
                
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                    [[UIApplication sharedApplication] openURL:privacyUrl];
                } else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"取消");
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alertController addAction:cancleAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
        
    }else if (photoAuthorStatus == PHAuthorizationStatusNotDetermined){
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"Authorized");
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                NSLog(@"Denied or Restricted");
            }
        }];
        NSLog(@"not Determined");
        
    }else if (photoAuthorStatus == PHAuthorizationStatusRestricted){
        
        NSLog(@"Restricted");
    }
}

#pragma 上传照片 弹框
-(void)usephoto{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请上传合理的照片，避免不必要的麻烦，谢谢合作!" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"个性拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照");
            [self takelocaCamera];
            
        }];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"相册/图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"相册");
            [self takelocaPhoto];

        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [alertController addAction:saveAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    });
}

#pragma -mark 统一的进入下一页
-(void)enter:(UIViewController *)ctl{
    
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
    
}

#pragma  -mark 城市选择调用方法
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            self.ZRcitylab.text = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,countyName];
           self.ZRcitylab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}
#pragma mark 网络检测
-(void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"status=%ld",status);
        switch (status) {
            case 0:{
                NSLog(@"无连接网络");
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于您的网络错误，信息发布失败" preferredStyle:UIAlertControllerStyleAlert];
                
                                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
                                    NSLog(@"点击了确认");
                
                                }];
                
                                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    NSLog(@"点击了设置");
        
                                    if (iOS10) {
                
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                    }
                                    else{
                //                        ios6
                                         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                    }
                                }];
                
                                [alertController addAction:cancleAction];
                                [alertController addAction:commitAction];
                                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case 1:{
                
                NSLog(@"3G网络");
                 [self upload];
            }
                break;
            case 2:{
                
                NSLog(@"WIFI网络");
                 [self upload];
            }
                break;
            default:{
                
                NSLog(@"未知网络错误");
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误，请检查网络状态" preferredStyle:UIAlertControllerStyleAlert];
                
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    NSLog(@"点击了设置");
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                
                                }];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    NSLog(@"点击了取消");
                                }];
                
                                [alertController addAction:commitAction];
                                 [alertController addAction:cancleAction];
                                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
        }
    }];
}
#pragma  -mark 选择按钮点击
-(void)choose{
#pragma -mark 弹出套餐记录文本列表
    [_ZRname        resignFirstResponder];
    [_ZRarea        resignFirstResponder];
    [_ZRrent        resignFirstResponder];
    [_ZRtransfer    resignFirstResponder];
    [_ZRperson      resignFirstResponder];
    [_ZRnumber      resignFirstResponder];
    [self popInview];
    NSLog(@"测试POPview");
}

#pragma -mark 数据上传后台吧
-(void)upload{
    
//    NSLog(@"标题：%@",self.ZRname.text);
//    NSLog(@"转让费：%@",self.ZRtransfer.text);
//    NSLog(@"面积：%@",self.ZRarea.text);
//    NSLog(@"租金：%@",self.ZRrent.text);
//    NSLog(@"城市区域：%@",self.ZRcitylab.text);
//    NSLog(@"具体地址：%@",self.ZRaddresslab.text);
//    NSLog(@"具体坐标：%@",self.coordinate);
//
//    NSLog(@"描述:%@",self.ZRdescribelab.text);
//    NSLog(@"联系人:%@",self.ZRperson.text);
//    NSLog(@"号码：%@",self.ZRnumber.text);
//    NSLog(@"行业：%@",self.ZRindustrylab.text);
//    NSLog(@"空转：%@",self.ZRturnlab.text);
//    NSLog(@"经营：%@",self.ZRManagementlab.text);
//    NSLog(@"合同：%@",self.ZRcontractlab.text);
//    NSLog(@"配套ID：%@",self.ZRSupportid);
    
    [self isMobileNumber:_ZRnumber.text];
    //电话号码正确
    if (phoneRight != 0){
        
   [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"发布服务中..."];
//    文字填写不完全
    if(_selectedPhotos.count<=0||
        self.ZRname.text.length<1||
        self.ZRtransfer.text.length<1||
        self.ZRarea.text.length<1||
        self.ZRrent.text.length<1||
        self.ZRperson.text.length<1||
        self.ZRnumber.text.length<1||
        [self.ZRcitylab.text isEqualToString:@"请填写信息"]||[self.ZRcitylab.text isEqualToString:@"您尚未填写信息"]||
        [self.ZRaddresslab.text isEqualToString:@"请填写信息"]||[self.ZRaddresslab.text isEqualToString:@"您尚未填写信息"]||
        [self.ZRdescribelab.text isEqualToString:@"请填写信息"]||[self.ZRdescribelab.text isEqualToString:@"您尚未填写信息"]||
        [self.ZRindustrylab.text isEqualToString:@"请填写信息"]||[self.ZRindustrylab.text isEqualToString:@"您尚未填写信息"]||
        [self.ZRturnlab.text isEqualToString:@"请填写信息"]||[self.ZRturnlab.text isEqualToString:@"您尚未填写信息"]||
        [self.ZRManagementlab.text isEqualToString:@"请填写信息"]||[self.ZRManagementlab.text isEqualToString:@"您尚未填写信息"]||
        [self.ZRcontractlab.text isEqualToString:@"请填写信息"]||[self.ZRcontractlab.text isEqualToString:@"您尚未填写信息"]||
        [self.ZRSupportlab.text isEqualToString:@"请填写信息"]||[self.ZRSupportlab.text isEqualToString:@"您尚未填写信息"]){
        
        [YJLHUD dismiss];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"好像漏掉了什么信息，需要check一下" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"完善信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了确认");
        }];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

//    文字全部填写
    else{
    NSLog(@"点击上传多个图片数据");
         [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"发布服务中..."];
//        if ([self.Navtitle isEqualToString:@"发布转让"]) {
            NSDictionary *params =  @{
                                          @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                          @"zrid":self.serviceID
                                      };
            NSLog(@"账号字典内容 = %@",params);
            
            #pragma - marl     发布转让信息
            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 10.0;
    
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
            [manager POST:HostTareaupload parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                NSLog(@"%@",HostTareaupload);
                for(NSInteger i = 0; i < _selectedPhotos.count; i++){
                    
                    NSData *imageData = UIImageJPEGRepresentation(_selectedPhotos[i], 0.5);
                    
                    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                    // 要解决此问题，
                    // 可以在上传时使用当前的系统事件作为文件名
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置时间格式
                    [formatter setDateFormat:@"yyyyMMddHHmmss"];
                    NSString *dateString = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString  stringWithFormat:@"%@%ld.jpg", dateString,i];
                    NSLog(@"图片名字：%@",fileName);
                    /*
                     *该方法的参数
                     1. appendPartWithFileData：要上传的照片[二进制流]
                     2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                     3. fileName：要保存在服务器上的文件名
                     4. mimeType：上传的文件的类型
                     */
   
                    [formData appendPartWithFileData:imageData name:@"image[]" fileName:fileName mimeType:@"image/jpeg"];
                    NSLog(@"上传照片image%ld",i);
                    
                    
                     if ([self.licenseYES isEqualToString: @"licenseYES"]) {
//                            身份证信息
                    NSDateFormatter *formattercord1      = [[NSDateFormatter alloc] init];
                    formattercord1.dateFormat            = @"ddMMyyyyHHmmss";
                    NSString *fileNamecord1              = [NSString stringWithFormat:@"%@.png", [formattercord1 stringFromDate:[NSDate date]]];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(_Cardimgview.image, 0.1) name:@"card" fileName:fileNamecord1 mimeType:@"image/png"];
                    NSLog(@"身份证图片名字：%@",fileNamecord1);
                     }
                    
                     if ([self.cardYES isEqualToString:@"cardYES"]) {
                    //        营业执照
                    NSDateFormatter *formatterlice1      = [[NSDateFormatter alloc] init];
                    formatterlice1.dateFormat            = @"yyyyMMddHHmmss";
                    NSString *fileNamelice1              = [NSString stringWithFormat:@"%@.png", [formatterlice1 stringFromDate:[NSDate date]]];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(_Licenseimgview.image, 0.1) name:@"license" fileName:fileNamelice1 mimeType:@"image/png"];
                    NSLog(@"营业执照图片名字：%@",fileNamelice1);
                     }
                    //    名称
                    [formData appendPartWithFormData:[self.ZRname.text dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
                    //    转让费
                    [formData appendPartWithFormData:[self.ZRtransfer.text dataUsingEncoding:NSUTF8StringEncoding] name:@"moneys"];
                    //    租金
                   [formData appendPartWithFormData:[self.ZRrent.text dataUsingEncoding:NSUTF8StringEncoding] name:@"rent"];
                    //    面积
                    [formData appendPartWithFormData:[self.ZRarea.text dataUsingEncoding:NSUTF8StringEncoding] name:@"area"];
                    //    区域+具体地址
                    NSString *citystr = [self.ZRcitylab.text stringByReplacingOccurrencesOfString:@" " withString:@","];//替换字符
                    [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@,%@",citystr,self.ZRaddresslab.text] dataUsingEncoding:NSUTF8StringEncoding] name:@"district"];

                    //    坐标
                    [formData appendPartWithFormData:[self.coordinate dataUsingEncoding:NSUTF8StringEncoding] name:@"coordinate"];

                    //    描述
                    [formData appendPartWithFormData:[self.ZRdescribelab.text dataUsingEncoding:NSUTF8StringEncoding] name:@"descript"];
                    //    联系人
                    [formData appendPartWithFormData:[self.ZRperson.text dataUsingEncoding:NSUTF8StringEncoding] name:@"users"];

                    //    联系电话
                    [formData appendPartWithFormData:[self.ZRnumber.text dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];

                    //    行业
                    NSArray *industryarr = @[@"餐饮美食",@"美容美发",@"服饰鞋包",@"休闲娱乐",@"百货超市",@"生活服务",@"电子通讯",@"汽车服务",@"医疗保健",@"家居建材",@"教育培训",@"酒店宾馆"];
                    NSString *industystr = [[NSString alloc]init];
                    for (int i =0; i < industryarr.count; i++){
                        if ([self.ZRindustrylab.text isEqualToString:industryarr[i]]){
                            industystr = [NSString stringWithFormat:@"%d",i+1];
                        }
                    }
                    NSLog(@"数字是多少？？？%@",industystr);
                    [formData appendPartWithFormData:[industystr dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];

                    //    空转
                    if ([self.ZRturnlab.text isEqualToString:@"允许 空转"]) {
                        [formData appendPartWithFormData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding] name:@"zhears"];
                    }else if([self.ZRturnlab.text isEqualToString:@"允许 整转"]){
                        [formData appendPartWithFormData:[[NSString stringWithFormat:@"1"] dataUsingEncoding:NSUTF8StringEncoding] name:@"zhears"];
                    }else{
                        [formData appendPartWithFormData:[[NSString stringWithFormat:@"2"] dataUsingEncoding:NSUTF8StringEncoding] name:@"zhears"];
                    }

                    //    经营状态
                    if ([self.ZRManagementlab.text isEqualToString:@"正在营业"]){
                        [formData appendPartWithFormData:[[NSString stringWithFormat:@"1"] dataUsingEncoding:NSUTF8StringEncoding] name:@"states"];
                    }
                    else{
                        [formData appendPartWithFormData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding] name:@"states"];
                    }

                    //    合同
                    [formData appendPartWithFormData:[self.ZRcontractlab.text dataUsingEncoding:NSUTF8StringEncoding] name:@"suit"];

                    //    配套设施id
                    [formData appendPartWithFormData:[self.ZRSupportid dataUsingEncoding:NSUTF8StringEncoding] name:@"facilty"];
                }
            }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       [YJLHUD dismiss];
                      NSLog(@"请求成功=%@",responseObject);
                      //                  上传成功提示信息
                      [self aleartwin:[NSString stringWithFormat:@"%@",responseObject[@"code"]]:[NSString stringWithFormat:@"%@",responseObject[@"massign"]]];
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      [YJLHUD dismiss];
                      [self aleartfaile];
                      NSLog(@"请求失败=%@",error);
                  }];
    }
}
//    电话号码出错
    else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的号码为空号，请修改" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确认");
        }];

        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma -mark上传成功提示信息
-(void)aleartwin:(NSString *)code :(NSString *)massign{
    
    NSLog(@"%@-%@",code,massign);
    if ([code isEqualToString:@"200"]) {
        
        //        @"您的信息发布成功，可以到您的个人中心查看"
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功" message:@"待审核通过即可服务，您可以去前往发布中心查看服务状态" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消");
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确认");
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            MyReleaseController *ctl = [MyReleaseController new];
            [self.navigationController pushViewController:ctl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
        }];
        
        [alertController addAction:cancleAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else{//305 307
        
          [self aleartfaile];

    }
}
#pragma -mark上传失败提示信息
-(void)aleartfaile{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的信息发布失败，是否继续发布？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确认");
        [self upload];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self sureback];
}

#pragma  back
-(void)BackreleaseZR{
    
    [self sureback];
}

-(void)sureback{

    self.rightButton.enabled = YES;
    self.surebtn.enabled     = NO;
    [UIView animateWithDuration:.5f animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:.5f animations:^{
        poprightview.frame = CGRectMake(0, KMainScreenHeight, KMainScreenWidth, KMainScreenHeight-64);
        [self.FBtableView removeFromSuperview];
        [self.PopArr removeAllObjects];
    }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您真的要放弃发布信息了么？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了取消");
    }];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了确认");
    
        [self popOutview];
        
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"已经看过了我要返回");
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
  
}

#pragma mark UICollectionView    下面全部是图片获取的方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"fabuzhr_xiangji"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册配图", nil];
        [sheet showInView:self.view];
    }
    
    else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = YES;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
        }
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
#pragma 上传照片最大数量
            imagePickerVc.maxImagesCount = 5;
            
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 3) / 4 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
#pragma 上传照片最大数量 以及相册里面每行排列数量
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:5 delegate:self pushPhotoPickerVc:YES];

#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    #pragma mark    最小上传图片量
    imagePickerVc.minImagesCount = 3;
    imagePickerVc.alwaysEnableDoneBtn = YES;
    
//     imagePickerVc.minPhotoWidthSelectable = 3000;
//     imagePickerVc.minPhotoHeightSelectable = 2000;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto,NSArray<NSDictionary *> *infos) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - Private
/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        }
   else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }

        NSLog(@"图片名字:%@",fileName);
    }
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    
//    AVAuthorizationStatusNotDetermined = 0,
//    AVAuthorizationStatusRestricted    = 1,
//    AVAuthorizationStatusDenied        = 2,
//    AVAuthorizationStatusAuthorized    = 3,
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {//1 3
        // 无相机权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

#pragma mark - 图片选择器的方法

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([self.Photochange isEqualToString:@"lice"]) {
        NSLog(@"获取到照片到信息===%@",info);
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.Licenseimgview.image = image;
        NSString *imageDocPath = [self getImageSavelicePath];//保存
       
        self.licenseYES = @"licenseYES";
        NSLog(@"imageDocPath == %@", imageDocPath);
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
    }else if([self.Photochange isEqualToString:@"card"]) {
        NSLog(@"获取到照片到信息===%@",info);
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.Cardimgview.image = image;
        NSString *imageDocPath = [self getImageSavecardPath];//保存
        self.cardYES = @"cardYES";
        NSLog(@"imageDocPath == %@", imageDocPath);
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    
    else{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];
                        [_collectionView reloadData];
                    }];
                }];
            }
        }];
    }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
    NSLog(@"cancel");
}

//显示图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    NSLog(@"显示图片=%@",_selectedPhotos);
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 3) / 4 ) * (_margin + _itemWH));
    // 1.打印图片名字
    [self printAssetsName:assets];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
    // open this code to send video / 打开这段代码发送视频
//     [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
//     NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
////     Export completed, send video here, send by outputPath or NSData
////     导出完成，在这里写上传代码，通过路径或者通过NSData上传
//    
//     }];
    [_collectionView reloadData];
     _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 3) / 4 ) * (_margin + _itemWH));
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma -mark 验证号码的正确性
- (BOOL)isMobileNumber:(NSString *)mobileNum{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[014-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     14         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189          181
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";//增加181号码
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    
    NSString * THPHS = @"^0(10|2[0-9]|\\d{3})\\d{7,8}$";
    
    /**
     29         * 大陆地区4位固话
     30         * 区号：0755 0733
     31         * 号码：八位
     32         */
    NSString * FOPHS = @"^0([1-9][0-9][0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestTHPHS  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", THPHS];
    NSPredicate *regextestFOPHS  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", FOPHS];
    
    //    电话号码是可用的
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)||([regextestTHPHS evaluateWithObject:mobileNum])==YES||([regextestFOPHS evaluateWithObject:mobileNum])==YES){
        phoneRight = 1;
        return YES;
    }
    else{
        
        phoneRight = 0;
        return NO;
    }
}
@end
