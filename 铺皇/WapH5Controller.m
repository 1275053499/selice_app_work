//
//  WapH5Controller.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/13.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "WapH5Controller.h"

@interface WapH5Controller ()

@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (nonatomic,strong)NSString *Internetcheck;////- [x] 网络检测
@property (nonatomic,strong)UIWebView * Web;////- [x] 网络检测
@property (nonatomic,strong)UIImageView *interimg;////无网络提醒图片
@end

@implementation WapH5Controller



-(NSString *)Internetcheck{
    if (!_Internetcheck) {
        _Internetcheck = [NSString new];
    }
    return _Internetcheck
    ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"H5制作";
    //    适配必要使用
    //    *_autoSizeScaleX
    //    *_autoSizeScaleY
    if(KMainScreenHeight < 667){                                 // 这里以(iPhone6)为准
        _autoSizeScaleX = KMainScreenWidth/375;
        _autoSizeScaleY = KMainScreenHeight/667;
    }else{
        _autoSizeScaleX = 1.0;
        _autoSizeScaleY = 1.0;
    }
    
    NSLog(@"X比例=%f,Y比例=%f",_autoSizeScaleX,_autoSizeScaleY);
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickcooperation)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    

    _interimg = [[UIImageView alloc]initWithFrame:CGRectMake((KMainScreenWidth-100*_autoSizeScaleX)/2, (KMainScreenHeight-100*_autoSizeScaleY)/2, 100*_autoSizeScaleX, 100*_autoSizeScaleY)];
    _interimg.image = [UIImage imageNamed:@"Nointernet"];
    [self.view addSubview:_interimg];
    _interimg.hidden = YES;
    
    
    
    _Web = [[UIWebView alloc]init];
    _Web.frame = CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight-64);
    [self.view addSubview:_Web];
    _Web.hidden = YES;

    #pragma mark 网络检测
    [self reachability];
}

#pragma mark 网络检测
-(void)reachability
{
    //    网络检测
    //    AFNetworkReachabilityStatusUnknown              = -1, 未知信号
    //    AFNetworkReachabilityStatusNotReachable         = 0,  无连接网络
    //    AFNetworkReachabilityStatusReachableViaWWAN     = 1,  3G网络
    //    AFNetworkReachabilityStatusReachableViaWiFi     = 2,  WIFI网络
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
//        NSLog(@"status=%ld",status);
    
        switch (status)
        {
            case 0:
            {
                NSLog(@"无连接网络");
//                _Internetcheck  =@"0";
#pragma -mark 未知网络或者无网络连接做事情
                [self startview];
                 [PishumToast showToastWithMessage:@"无连接网络" Length:TOAST_LONG ParentView:self.view];
            }
                break;
                
            case 1:
            {
                NSLog(@"3G网络");
//                _Internetcheck  =@"1";
                
#pragma -mark Wi-Fi或者3G网络做事情
                    [self starttitle:self.titlestr starturl:self.url];
                [PishumToast showToastWithMessage:@"3G网络" Length:TOAST_LONG ParentView:self.view];
            }
                break;
                
            case 2:
            {
                NSLog(@"WIFI网络");
//                _Internetcheck  =@"2";

#pragma -mark Wi-Fi或者3G网络做事情

               [self starttitle:self.titlestr starturl:self.url];
                [PishumToast showToastWithMessage:@"WIFI网络" Length:TOAST_LONG ParentView:self.view];

            }
                break;
                
            default:
            {
                NSLog(@"未知网络错误");
//                _Internetcheck  =@"-1";

#pragma -mark 未知网络或者无网络连接做事情
                [self startview];
                [PishumToast showToastWithMessage:@"未知网络错误" Length:TOAST_LONG ParentView:self.view];

            }
                break;
        }
        
    }];
}


#pragma -mark Wi-Fi或者3G网络做事情 代理
-(void)starttitle:(NSString *)titlestr starturl:(NSString *)urlstr{
    _interimg.hidden = YES;
    _Web.hidden = NO;
    self.title = titlestr;//导航栏标题
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    [_Web loadRequest:request];
    
}

#pragma -mark 未知网络或者无网络连接做事情 代理
-(void)startview{
    _interimg.hidden = NO;
    _Web.hidden = YES;
    self.title = @"H5制作"; //导航栏标题
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@""]];
    [_Web loadRequest:request];
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
   [self starttitle:self.titlestr starturl:self.url];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了关闭声音我要返回");
}

- (void)BackButtonClickcooperation{

    [self starttitle:self.titlestr starturl:self.url];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了关闭声音我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
