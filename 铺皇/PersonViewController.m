//
//  PersonViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//
#import "PersonViewController.h"
#import "PersonhomeController.h"

#define BXAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
@interface PersonViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QYConversationManagerDelegate,QYSessionViewDelegate>{

//    图片放大背景变色
    UIView *background;
}

@property(nonatomic,strong)UIView      * headerview;        //信息头部视图
@property(nonatomic,strong)UIImageView * personimgview;     //个人头像
@property(nonatomic,strong)UIButton    * loginbtn;          //登录按钮
@property(nonatomic,strong)UILabel     * personnickname;    //个人昵称
@property(nonatomic,strong)UIImageView * authenticationimg; //认证图
@property(nonatomic,strong)UILabel     * personintegral;    //积分数
@property(nonatomic,strong)UIButton    * integralbtn;       //积分数btn
@property(nonatomic,strong)NSString * personimgStr;          //个人头像str
@property(nonatomic,strong)NSString * personnicknameStr;     //个人昵称str
@property(nonatomic,strong)NSString * personsignatureStr;    //个人签名str
@property(nonatomic,strong)NSString * personsexStr;          //个人性别str
@property(nonatomic,strong)NSString * personuserStr;         //个人账户str
@property(nonatomic,strong)NSString * personcityStr;         //个人城市str
@property(nonatomic,strong)NSString * personintegralStr;     //个人积分str
@property (nonatomic,strong)NSMutableArray *DataArr;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@property (nonatomic,strong) NSString *NSloginstate;//登录状态
@property (nonatomic,strong) NSString *NSeditstate; //编辑状态
@property (strong, nonatomic) YSFDemoBadgeView *badgeView;

@end

@implementation PersonViewController

-(NSMutableArray*)DataArr{
    if (_DataArr == nil) {
        _DataArr =[[NSMutableArray alloc]init];
        
    }
    return  _DataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightbarButtonItemWithImage:@"shezhi" highImage:nil target:self action:@selector(Setup)];
#pragma mark -    适配必要使用
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
#pragma mark - ************************************************************************************
    self.PersontableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    self.PersontableView.delegate   = self;
    self.PersontableView.dataSource = self;
#pragma mark -     滚动条
    self.PersontableView.showsVerticalScrollIndicator =NO;
    
#pragma mark -     头视图初始化
    self.headerview =[[UIView alloc]initWithFrame:CGRectMake(0 *_autoSizeScaleX, 64*_autoSizeScaleY, KMainScreenWidth, 160 *_autoSizeScaleY)];
    self.headerview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    
    //    cell添加头视图
    self.PersontableView.tableHeaderView = self.headerview;
    self.PersontableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.PersontableView];
    
    self.loginbtn                            = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginbtn.frame                      = CGRectMake(140 *_autoSizeScaleX, (160/2-15)*_autoSizeScaleY, 150*_autoSizeScaleX, 30*_autoSizeScaleY);
    [self.loginbtn setTitle:@"登录／注册" forState:UIControlStateNormal];
    [self.loginbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loginbtn.titleLabel.font            = [UIFont systemFontOfSize: 14.0];
    [self.loginbtn setBackgroundImage:[UIImage imageNamed:@"yuanjiao"] forState:UIControlStateNormal];
    [self.loginbtn addTarget:self action:@selector(clicklogin) forControlEvents:UIControlEventTouchUpInside];
    [self.loginbtn setHidden:YES];
    [self.headerview addSubview:self.loginbtn];
    
    //    初始化头像
    self.personimgview                          = [[UIImageView alloc]init];
    self.personimgview.autoresizingMask         = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.personimgview.frame                    = CGRectMake(10 *_autoSizeScaleX, 30 *_autoSizeScaleY, 100*_autoSizeScaleY, 100*_autoSizeScaleY);
    self.personimgview.layer.masksToBounds      = YES;
    self.personimgview.layer.cornerRadius       = 50.0 *_autoSizeScaleX;
    self.personimgview.layer.borderColor        = [UIColor whiteColor].CGColor;
    self.personimgview.layer.borderWidth        = 1.0f;
    self.personimgview.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.personimgview.layer.shouldRasterize    = YES;
    self.personimgview.clipsToBounds            = YES;
    [self.personimgview setUserInteractionEnabled:YES];
    [self.headerview addSubview:self.personimgview];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginheaderClick:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.personimgview setHidden:YES];
    [self.personimgview addGestureRecognizer:singleTap];
    
#pragma mark - **********************************认证图片
    self.authenticationimg                      = [[UIImageView alloc]init];
    self.authenticationimg.frame                =CGRectMake(CGRectGetMaxX(_personimgview.frame)-35*_autoSizeScaleY, CGRectGetMaxY(_personimgview.frame)-20*_autoSizeScaleY, 15*_autoSizeScaleY, 15*_autoSizeScaleY);
    self.authenticationimg.image                = [UIImage imageNamed:@"geren_renzheng"];
    [self.authenticationimg setHidden:YES];
    [self.headerview addSubview:self.authenticationimg];
    
#pragma mark - **********************************积分值
    self.integralbtn                            = [UIButton buttonWithType:UIButtonTypeCustom];
    self.integralbtn.frame                      = CGRectMake(KMainScreenWidth-120*_autoSizeScaleY, 65*_autoSizeScaleY, 120*_autoSizeScaleY,  30*_autoSizeScaleY);
    self.integralbtn.titleLabel.font            =[UIFont systemFontOfSize:14.0f];
    self.integralbtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    //    圆角设置
    UIBezierPath *maskPathtag   = [UIBezierPath bezierPathWithRoundedRect:_integralbtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayertag  = [[CAShapeLayer alloc] init];
    maskLayertag.frame          = self.integralbtn.bounds;
    maskLayertag.path           = maskPathtag.CGPath;
    self.integralbtn.layer.mask = maskLayertag;
    [self.integralbtn setBackgroundColor:kTCColor2(227, 239, 252, 0.5)];
    [self.integralbtn addTarget:self action:@selector(inteclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.integralbtn setHidden:YES];
    [self.headerview  addSubview:self.integralbtn];
    
#pragma mark - **********************************个人昵称
    self.personnickname                 = [[UILabel alloc]init];
    self.personnickname.textColor       = [UIColor whiteColor];
    self.personnickname.backgroundColor  = [UIColor clearColor];
    //    根据文字长度适应label长width
    UIFont *font                    = [UIFont systemFontOfSize:18.0];
    self.personnickname.font            = font;
    self.personnickname.textAlignment   = NSTextAlignmentLeft;
    [self.headerview    addSubview:self.personnickname];
    [self.personnickname setHidden:YES];
    
    [self.personnickname mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.height.mas_equalTo(@20);
               make.centerY.equalTo(self.personimgview);
               make.right.equalTo(self.integralbtn.mas_left).with.offset(-5);
               make.left.equalTo(self.personimgview.mas_right).with.offset(5);
    }];
    
#pragma mark - 红数点
    self.badgeView = [[YSFDemoBadgeView alloc] initWithFrame:CGRectMake(0, 10, 50, 50)];
    
#pragma mark -添加刷新控件
    [self refreshperson];

    static NSString *tabBarDidSelectedNotification = @"tabBarDidSelectedNotification";
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSeleted) name:tabBarDidSelectedNotification object:nil];
}

// 接收到通知实现方法
- (void)tabBarSeleted {
    
    // 如果是连续选中2次, 直接刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && [self isShowingOnKeyWindow]) {
//        可以写刷新事件
    }
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
    
    //    为了推送找到tabbar 设置一个数据
//    NSLog(@"第几个:%ld",self.lastSelectedIndex);
//    NSLog(@"%ld",self.tabBarController.selectedIndex);
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",self.lastSelectedIndex] forKey:@"PUSHNUMBER"];
    
}

- (BOOL)isShowingOnKeyWindow{
    
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.view.frame fromView:self.view.superview];
    CGRect winBounds = keyWindow.bounds;
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return !self.view.isHidden && self.view.alpha > 0.01 && self.view.window == keyWindow && intersects;
}

#pragma mark - 刷新数据
- (void)refreshperson{

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadpersonData)];
    // Set title
    [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
    [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
    [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // Set textColor
    header.stateLabel.textColor                 = kTCColor(161, 161, 161);
    header.lastUpdatedTimeLabel.textColor       = kTCColor(161, 161, 161);
    self.PersontableView.mj_header              = header;
}

/*********************************** 登录时个人信息视图信息**************开始*****************************************/
#pragma mark - 登录时个人信息视图信息
-(void)YEScreatheader{
    
    [self.loginbtn           setHidden:YES]; //登录按钮
    [self.personnickname     setHidden:NO ]; //昵称
    [self.authenticationimg  setHidden:NO ]; //认证图
    [self.integralbtn        setHidden:NO ]; //积分按钮
    [self.personimgview      setHidden:NO];  //头像
    NSLog(@"服务器默认图片入境 = %@",_personimgStr);
    [self.personimgview sd_setImageWithURL:[NSURL URLWithString:_personimgStr] placeholderImage:nil];//店铺图片
    NSLog(@"积分==%@",self.personintegralStr);
    [self.integralbtn setTitle:[NSString stringWithFormat:@"积分值:%@",_personintegralStr] forState:UIControlStateNormal];
    NSLog(@"昵称==%@",self.personnicknameStr);
    self.personnickname.text            = self.personnicknameStr;
}

#pragma mark - 未登录时个人信息视图信息
-(void)NOcreatheader{

    [self.loginbtn       setHidden:NO];     //登录按钮
    _personimgview.image                = [UIImage imageNamed:@"people"];
    [_personnickname     setHidden:YES];    //昵称
    [_authenticationimg  setHidden:NO];     //认证图
    [_integralbtn        setHidden:YES];    //积分按钮
    [_personimgview      setHidden:NO];     //头像
}

#pragma -mark 积分点击
-(void)inteclick:(UIButton *)intebtn{
    NSLog(@"点击积分状态");
   if ([self.NSloginstate isEqualToString:@"loginyes"]){
       
       MyIntegralController *ctl     = [[MyIntegralController alloc]init];
       self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
       [self.navigationController pushViewController:ctl animated:YES];
       self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
       
       }else{
    
               UIAlertController *alertController   = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录账号" preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *commitAction          = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                   NSLog(@"点击了去登录");
               LoginController *ctl                 = [[LoginController alloc]init];
                   self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                   [self.navigationController pushViewController:ctl animated:YES];
                   self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                   
               }];
               UIAlertAction *cancelAction          = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                       NSLog(@"点击了取消");}];
               [alertController addAction:commitAction];
               [alertController addAction:cancelAction];
               [self presentViewController:alertController animated:YES completion:nil];
       }
}

#pragma mark - 登陆头像 点击进入 个人详情
-(void)loginheaderClick:(UITapGestureRecognizer *)tap{

    if ([ self.NSloginstate  isEqualToString:@"loginyes"])//有过登录状态
    {
        NSLog(@"个人详情页面");
        
        PersonhomeController *ctl = [[PersonhomeController alloc]init];
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        [self.navigationController pushViewController:ctl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
    }
    else{
        
        NSLog(@"登录去....");
        LoginController *ctl        = [[LoginController alloc]init];
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        [self.navigationController pushViewController:ctl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
    }
}

#pragma mark - 注册登录
-(void)clicklogin{
    
        NSLog(@"注册登录一下呗");
        LoginController *ctl        = [[LoginController alloc]init];
        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
        [self.navigationController pushViewController:ctl animated:YES];
        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
}

#pragma mark - 设置
-(void)Setup{

    NSLog(@"点击设置按钮");
    SetupController *ctl        = [[SetupController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
}

#pragma mark - Tableviewdatasource代理
//几个段落Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

//一个段落几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 2;
    }
    else{
    return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"oneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"我的积分";
                    cell.imageView.image =  [UIImage imageNamed:@"geren_mianshi"];
                    break;
                case 1:
                    cell.textLabel.text = @"我的服务";
                    cell.imageView.image =  [UIImage imageNamed:@"fuwu"];
                    break;
                case 2:
                    cell.textLabel.text = @"我的收藏";
                    cell.imageView.image =  [UIImage imageNamed:@"shouc"];
                    break;
                default:
                    cell.textLabel.text = @"我的发布";
                    cell.imageView.image =  [UIImage imageNamed:@"fabu"];
                    break;
            }
            break;
            
         case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text  = @"联系客服";
                    cell.imageView.image =  [UIImage imageNamed:@"kefu"];
                    cell.accessoryView   = _badgeView;
                    break;
                default:
                    cell.textLabel.text = @"分享好友";
                    cell.imageView.image =  [UIImage imageNamed:@"fenxiang"];
                    break;
            }
            
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


//  段与段之间间隔
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*_autoSizeScaleY;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSLog(@"点击了第%ld段,第%ld个cell信息",indexPath.section,indexPath.row);
    switch (indexPath.section){
//            第一段
        case 0:{
            switch (indexPath.row){
                case 0:
                        NSLog(@"我的积分");{
                            
                           if ([self.NSloginstate isEqualToString:@"loginyes"]){
//
                    
                               MyIntegralController *ctl = [[MyIntegralController alloc]init];
                               self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                               [self.navigationController pushViewController:ctl animated:YES];
                               self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                           }else{
                               
                               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                   NSLog(@"点击了去登录");
                                   LoginController *ctl = [[LoginController alloc]init];
                                   self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                   [self.navigationController pushViewController:ctl animated:YES];
                                   self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                                   
                               }];
                               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                   NSLog(@"点击了取消");}];
                               [alertController addAction:commitAction];
                               [alertController addAction:cancelAction];
                               [self presentViewController:alertController animated:YES completion:nil];
                           }

                        }
                break;
                case 1:
                        NSLog(@"我的服务");{
                            
                            if ([self.NSloginstate isEqualToString:@"loginyes"]){
//
                      
                                MyServiceController *ctl = [[MyServiceController alloc]init];
                                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                [self.navigationController pushViewController:ctl animated:YES];
                                self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                            
                            }else{
                            
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                    NSLog(@"点击了去登录");
                                    LoginController *ctl = [[LoginController alloc]init];
                                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                    [self.navigationController pushViewController:ctl animated:YES];
                                    self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                                    
                                }];
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                    NSLog(@"点击了取消");}];
                                [alertController addAction:commitAction];
                                [alertController addAction:cancelAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }

                        }
                break;
                case 2:
                        NSLog(@"我的收藏");{
                            
                            if ([self.NSloginstate isEqualToString:@"loginyes"]){
                                
                                MyCollectionController *ctl = [[MyCollectionController alloc]init];
                                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                [self.navigationController pushViewController:ctl animated:YES];
                                self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                            }else{
                            
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                    NSLog(@"点击了去登录");
                                    LoginController *ctl = [[LoginController alloc]init];
                                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                    [self.navigationController pushViewController:ctl animated:YES];
                                    self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                                    
                                }];
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                    NSLog(@"点击了取消");}];
                                [alertController addAction:commitAction];
                                [alertController addAction:cancelAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                        }
                    break;
                default:
                        NSLog(@"我的发布");{
                            if ([self.NSloginstate isEqualToString:@"loginyes"]){
                                
                                MyReleaseController *ctl = [[MyReleaseController alloc]init];
                                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                [self.navigationController pushViewController:ctl animated:YES];
                                self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                            }else{
                    
                                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                                NSLog(@"点击了去登录");
                                                LoginController *ctl = [[LoginController alloc]init];
                                                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                [self.navigationController pushViewController:ctl animated:YES];
                                                self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                                                
                                            }];
                                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                                NSLog(@"点击了取消");}];
                                            [alertController addAction:commitAction];
                                            [alertController addAction:cancelAction];
                                            [self presentViewController:alertController animated:YES completion:nil];
                                }
                        }
                break;
            }
        }
            break;
//            第二段
        case 1:{
            
            switch (indexPath.row) {
                case 0:
                        NSLog(@"联系客服");{
                            
                            //加强版本
                            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                                        cancelTitle:@"取消"
                                                                                   destructiveTitle:nil
                                                                                        otherTitles:@[@"App在线客服", @"QQ客服咨询", @"电话客服咨询"]
                                                                                        otherImages:nil
                                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                                      NSLog(@"%zd", index);
                                                                                      
                                                                                      switch (index) {
                                                                                          case 0://在线客服
                                                                                          {
                                                                                              
                                                                                              if ([[[YJLUserDefaults shareObjet] getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
                                                                                                  
                                                                                                  //    获取用户头像信息
                                                                                                  personshowmodel *model = [[[pershowData shareshowperData]getAllDatas] objectAtIndex:0];
                                                                                                  //    设置头像
                                                                                                  [[QYSDK sharedSDK]customUIConfig].customerHeadImageUrl= model.personimage;
                                                                                                  
                                                                                                  QYSource *source = [[QYSource alloc]init];
                                                                                                  source.title   =@"铺皇小助手";
                                                                                                  source.urlString  =@"http://www.chinapuhuang.com";
                                                                                                  
                                                                                                  QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
                                                                                                  sessionViewController.delegate      = self;
                                                                                                  sessionViewController.sessionTitle  = @"铺皇小助手";
                                                                                                  sessionViewController.source        = source;
                                                                                                  sessionViewController.openRobotInShuntMode      = YES;
                                                                                                  [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
                                                                                                  
                                                                                                  //    sessionViewController.groupId       = g_groupId;
                                                                                                  //    sessionViewController.staffId       = g_staffId;
                                                                                                  //    sessionViewController.commonQuestionTemplateId  = g_questionId;
                                                                                                  //    sessionViewController.openRobotInShuntMode      = g_openRobotInShuntMode;
                                                                                                  
                                                                                                  //    //集成方式二
                                                                                                  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
                                                                                                  sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
                                                                                                  [self presentViewController:nav animated:YES completion:nil];
                                                                                                  
                                                                                                  if ([[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite == NO) {
                                                                                                      sessionViewController.navigationController.navigationBar.translucent = NO;
                                                                                                      NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
                                                                                                      sessionViewController.navigationController.navigationBar.titleTextAttributes = dict;
                                                                                                      [sessionViewController.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];
                                                                                                  }
                                                                                                  
                                                                                                  else {
                                                                                                      sessionViewController.navigationController.navigationBar.translucent = YES;
                                                                                                      NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
                                                                                                      sessionViewController.navigationController.navigationBar.titleTextAttributes = dict;
                                                                                                      [sessionViewController.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
                                                                                                  }
                                                                                                  
                                                                                              }else{
                                                                                                  
                                                                                                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                                                                                                  UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                                                                                      NSLog(@"点击了去登录");
                                                                                                      LoginController *ctl = [[LoginController alloc]init];
                                                                                                      self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                                                                                      [self.navigationController pushViewController:ctl animated:YES];
                                                                                                      self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                                                                                                      
                                                                                                  }];
                                                                                                  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                                                                                      NSLog(@"点击了取消");}];
                                                                                                  [alertController addAction:commitAction];
                                                                                                  [alertController addAction:cancelAction];
                                                                                                  [self presentViewController:alertController animated:YES completion:nil];
                                                                                              }
                                                                                              
                                                                                          }
                                                                                              break;
                                                                                          case 1://QQ咨询
                                                                                          {
                                                                                              //是否安装QQ
                                                                                              if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
                                                                                              {
                                                                                                  //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
                                                                                                  NSString *QQ = @"3433796671";
                                                                                                  //调用QQ客户端,发起QQ临时会话
                                                                                                  NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
                                                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                                                                              }
                                                                                          }
                                                                                              break;
                                                                                              
                                                                                          case 2://TEL咨询
                                                                                          {
                                                                                              [LEEAlert alert].config
                                                                                              
                                                                                              .LeeAddTitle(^(UILabel *label) {
                                                                                                  
                                                                                                  label.text = @"联系客服";
                                                                                                  
                                                                                                  label.textColor = [UIColor blackColor];
                                                                                              })
                                                                                              .LeeAddContent(^(UILabel *label) {
                                                                                                  
                                                                                                  label.text = @"TEL:0773-23212184";
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
                                                                                                      
                                                                                                      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://15302626641"]];
                                                                                                      
                                                                                                  };
                                                                                              })
                                                                                              .LeeHeaderColor(kTCColor(255, 255, 255))
                                                                                              .LeeShow();
                                                                                              
                                                                                          }
                                                                                              break;
                                                                                              
                                                                                          default://TEL咨询
                                                                                          {
                                                                                              
                                                                                          }
                                                                                              break;
                                                                                      }
                                                                                  }];
                            actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
                            [actionSheet show];

                        }
                    break;
                default:
                        {
                        NSLog(@"分享一下打大啊");
                                        //    UMSocialPlatformType_Sina              = 0, //新浪
                                        //    UMSocialPlatformType_WechatSession      = 1, //微信聊天
                                        //    UMSocialPlatformType_WechatTimeLine     = 2, //微信朋友圈
                                        //    UMSocialPlatformType_QQ                 = 4, //QQ聊天页面
                                        //    UMSocialPlatformType_Qzone              = 5, //qq空间
                                        //    @(UMSocialPlatformType_WechatTimeLine)]
                                        //      设置分享平台的顺序。如果没有择出现很多不需要的
                            
                                        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
                    
                                        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo){
                                            
                                            [self shareWebPageToPlatformType:platformType];
                                            
                                        }];
                                    }
                    break;
            }
        }
            break;
//            第三段
        default:{
            switch (indexPath.row) {
                case 0:{

                }
                    break;
                    
                default:{
                    
                }
                    break;
            }
        }
            break;
    }
}

- (void)onBack:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [[QYSDK sharedSDK] logout:^{
    //        NSLog(@"推出在线客服");
    //    }];
}

#pragma mark 分享调用
//分享网页链接
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //    如果分享的url中含有中文字符，需要将中文部分进行url转码后可正常分享。 如：https://www.umeng.com/U-Share分享 需要将「分享」二字进行url转码放在链接中再进行分享，如下： https://www.umeng.com/U-Share%E5%88%86%E4%BA%AB
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象  主标题+副标题+图片
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"铺皇竭诚为您服务" descr:@"用心办事，让客户满意" thumImage:[UIImage imageNamed:@"Applogo"]];
    
    //设置网页地址 放置店铺URL
    shareObject.webpageUrl = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/%@/id1315260303?l=zh&ls=1&mt=8",[@"铺皇" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]; //@" https://itunes.apple.com/us/app/铺皇/id1315260303?l=zh&ls=1&mt=8";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //                              调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }
            else{
                
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

#pragma mark 分享错误提示
-(void)alertWithError:(NSError *)error{
    NSLog(@"分享事件的错误信息=%@",error);
    if (!error) {
       
        [YJLHUD showSuccessWithmessage:@"分享成功"];
         [YJLHUD dismissWithDelay:1];
    }else{
        
        
         [YJLHUD showErrorWithmessage:[NSString stringWithFormat:@"%@",error]];
         [YJLHUD dismissWithDelay:1];
    }
}
#pragma mark 红色信息提示
- (void)configBadgeView{
    
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [_badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    [_badgeView setBadgeValue:value];
}

- (void)onUnreadCountChanged:(NSInteger)count{
    
    [self configBadgeView];
}

#pragma -mark 视图即将消失
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

#pragma -mark 视图即将出现
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    在线客服
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self configBadgeView];
   
    
    self.NSeditstate       =[[YJLUserDefaults shareObjet]getObjectformKey:YJLEditchange];
    self.NSloginstate      =[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate];
    NSLog(@"登录状态%@", self.NSloginstate );
    NSLog(@"信息更改状态%@", self.NSeditstate);
    
    if ([ self.NSloginstate  isEqualToString:@"loginyes"])//有过登录状态
    {
        if ([ self.NSeditstate isEqualToString:@"YES"])//编辑了个人信息
        {
            [self LoadpersonData];
            //  本地存数据 账号密码
            [[YJLUserDefaults shareObjet]saveObject:@"NO" forKey:YJLEditchange];
        }
        
    else{//没有编辑个人信息
        
            [self Ishasdata];
        }
    }
    
    else{ //没有有过登录状态
//        使用未登陆头部
        [self NOcreatheader];
    }
    

    GUInum = 1;
#pragma -mark 指导页出现 ？不出现
    if ( [[NSUserDefaults standardUserDefaults]boolForKey:@"firstCouponBoard_iPhone4"]) {
        NSLog(@"加载过了指导页，不能加载第二次了");
        
    }else{
        NSLog(@"没有加载过指导页，马上加载第1次了");
        
        GUIDbackview                     =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        GUIDbackview.layer.masksToBounds = YES;
        GUIDbackview.backgroundColor     = [UIColor colorWithWhite:0 alpha:0];
        
        GUIDimgview        = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        GUIDimgview.center = GUIDbackview.center;
        GUIDimgview.layer.masksToBounds        = YES;
        GUIDimgview.image  = [UIImage imageNamed:@"teach_3"];
        NSLog(@"%@----%@",GUIDimgview,GUIDbackview);
        [GUIDbackview addSubview:GUIDimgview];
    
        GUIDbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [GUIDbtn setImage:[UIImage imageNamed:@"teach_btn"] forState:UIControlStateNormal];
        [GUIDbtn addTarget:self action:@selector(sureTapClick:) forControlEvents:UIControlEventTouchUpInside];
        [GUIDbackview addSubview:GUIDbtn];
        [GUIDbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(GUIDbackview).with.offset(153);
            make.bottom.equalTo(GUIDbackview).with.offset(-390);
            make.size.mas_equalTo(CGSizeMake(90, 35));
        }];
        
        [[UIApplication sharedApplication].delegate.window addSubview:GUIDbackview];
        [UIView animateWithDuration:1.0 delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            GUIDbackview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
            
        } completion:^(BOOL finished) {
            NSLog(@"动画结束");
        }];
    }
}

#pragma -mark 指导页推出
- (void)sureTapClick:(id)sender{
    
    if (GUInum>=3) {
        
        NSLog(@"指导页推出去了");
        [UIView animateWithDuration:0.1 animations:^{
            
            GUIDbackview.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            
        } completion:^(BOOL finished) {
            
            [GUIDbackview removeFromSuperview];
        }];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstCouponBoard_iPhone4"];
    }
    
    else{
        
        if (GUInum==1) {
            
            GUIDimgview.image = [UIImage imageNamed:@"teach_4"];
            [GUIDbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(GUIDbackview).with.offset(147);
                make.top.equalTo(GUIDbackview).with.offset(104);
                make.size.mas_equalTo(CGSizeMake(90, 35));
            }];
            
        }else{
            
            GUIDimgview.image = [UIImage imageNamed:@"teach_5"];
            [GUIDbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(GUIDbackview).with.offset(141);
                make.bottom.equalTo(GUIDbackview).with.offset(-200);
                make.size.mas_equalTo(CGSizeMake(90, 35));
            }];
            
        }
    }
    GUInum  ++ ;
}


-(void)Ishasdata{
    
    //        数据库取数据
    _DataArr = [[pershowData shareshowperData]getAllDatas];
    
    if (_DataArr.count == 0){
        
        //        获取网络的
        [self LoadpersonData];
    }
    else{
        //   转圈开始
        //        加载本地的
        NSLog(@"数据库有个人信息数据");
        personshowmodel *model = [_DataArr objectAtIndex:0];
        _personimgStr          = model.personimage;
        _personnicknameStr     = model.personnickname;
        _personintegralStr     = model.personintegral;
    
        //        使用登录头部
        [self YEScreatheader];

    }
    //         结束刷新
    [self.PersontableView.mj_header endRefreshing];
}

-(void)LoadpersonData{
    
    if ([ self.NSloginstate  isEqualToString:@"loginyes"])//有过登录状态
    {
        //         删除数据库
        [[pershowData shareshowperData]deletedData];
        NSLog(@"刷新信息数据 删除了本地数据 ");
        AFHTTPSessionManager *manager           = [AFHTTPSessionManager manager];
        manager.responseSerializer              = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
        NSDictionary *params =   @{
                                     @"phone": [[YJLUserDefaults shareObjet]getObjectformKey:YJLuser]
                                  };
        //    13163241430 徐静
        [manager POST:Personshowpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"返---%@",responseObject);
           
             [[YJLUserDefaults shareObjet]saveObject:responseObject[@"data"][@"paypassword"] forKey:YJLPaymentpassword];//支付密码
             [[YJLUserDefaults shareObjet]saveObject:responseObject[@"data"][@"phone"] forKey:YJLuser];//账号信息
        
            _personimgStr              = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"image"]]    ];
            _personnicknameStr         = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"nickname"]] ];
            _personintegralStr         = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"vip_integral"]]  ];
            personshowmodel *model     = [[personshowmodel alloc]init];
            model.personimage          = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"image"]]    ];
            model.personnickname       = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"nickname"]] ];
            model.personsignature      = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"signature"]]];
            model.personsex            = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"sex"]]      ];
            model.personcity           = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"city"]]     ];
            model.personphone          = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]]    ];
            model.personintegral       = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"vip_integral"]]];
            
            [model setValuesForKeysWithDictionary:responseObject[@"data"]];
            
//            NSLog(@"%@", model.personimage     );
//            NSLog(@"%@", model.personnickname  );
//            NSLog(@"%@", model.personsignature );
//            NSLog(@"%@", model.personsex       );
//            NSLog(@"%@", model.personcity      );
//            NSLog(@"%@", model.personphone     );
//            NSLog(@"积分%@",model.personintegral);
            //         存入数据库
            [[pershowData shareshowperData]addshowData:model];
            NSLog(@"存入数据库..");
            //        使用登录头部
            [self YEScreatheader];
            NSLog(@"登录成功的转圈消失");
             [self.PersontableView.mj_header endRefreshing];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"信息失败----%@",error);
             [self.PersontableView.mj_header endRefreshing];
        }];
    }
    
    else{
        
        NSLog(@"登录先去");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"去登录才能刷新" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    NSLog(@"Lspispig");
             [self.PersontableView.mj_header endRefreshing];
                }];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



@end
