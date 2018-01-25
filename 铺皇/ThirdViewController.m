//
//  ThirdViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ThirdViewController.h"
#import "UIBarButtonItem+Create.h"
#import "UIView+YSF.h"
#import "QYPOPSDK.h"
#import "QYDemoBadgeView.h"
@interface ThirdViewController ()<UITableViewDataSource, UITableViewDelegate,QYConversationManagerDelegate,QYSessionViewDelegate>
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@property (strong, nonatomic) YSFDemoBadgeView *badgeView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
   
    //    在线客服入口按钮
    UIButton *contactButton = [[UIButton alloc]initWithFrame:CGRectZero];
    contactButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [contactButton setTitle:@"在线客服" forState:UIControlStateNormal];
    [contactButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(Onmessage) forControlEvents:UIControlEventTouchUpInside];
    [contactButton sizeToFit];
    contactButton.ysf_frameTop = 8;
    UIButton *rightButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    [rightButtonView addSubview:contactButton];
    _badgeView = [[YSFDemoBadgeView alloc] initWithFrame:CGRectMake(-20, 3, 50, 50)];
    [rightButtonView addSubview:_badgeView];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
//    滚动条
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    [self.view addSubview:tableView];
    self.MessagetableView = tableView;
//    当cell比较少时强制去掉多余的分割线
    self.MessagetableView.tableFooterView=[[UIView alloc]init];//关键语句
    
    [self refreshmessage];
    
    static NSString *tabBarDidSelectedNotification = @"tabBarDidSelectedNotification";
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSeleted) name:tabBarDidSelectedNotification object:nil];
    
}

// 接收到通知实现方法
- (void)tabBarSeleted {
    
    // 如果是连续选中2次, 直接刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && [self isShowingOnKeyWindow]) {
        
        //直接写刷新代码
        NSLog(@"消息       在此刷新");
    }
    
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
    
//    为了推送找到tabbar 设置一个数据
    NSLog(@"第几个:%ld",self.lastSelectedIndex);
     NSLog(@"%ld",self.tabBarController.selectedIndex);
    
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
- (void)refreshmessage{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadmessageData)];
    
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
    self.MessagetableView.mj_header = header;
//    [self.MessagetableView.mj_header beginRefreshing];
}

-(void)loadmessageData{
    
    messageArr  = [[NSMutableArray alloc]init];
    messageArr =  [[messagefmdb sharemessageData]getdatas];//获取数据库中保存的推送信息
    NSLog(@"数组:%@",messageArr);
    [self.MessagetableView reloadData];
    [self.MessagetableView.mj_header endRefreshing];//停止刷新
}

#pragma mark - Tableviewdatasource
//几个段落Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

//一个段落几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return messageArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    右上角的视图
    UILabel *datalab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    datalab.font = [UIFont systemFontOfSize:10];
    datalab.textColor= [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    
    static NSString *ID = @"oneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    switch (indexPath.section) {
        case 0:{
            //    主标题
            cell.textLabel.text = @"系统消息";
            cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            //    主图片
            cell.imageView.image = [UIImage imageNamed:@"logo40"];
            //    右角标题
            cell.accessoryView  = datalab;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *datenow = [NSDate date];
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            datalab.text = currentTimeString;
            //    副标题
            cell.detailTextLabel.text =@"欢迎来到[铺皇]！";//副标题
            cell.detailTextLabel.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
        }
            break;
        case 1:{
            
            messagemodel * model = [messageArr objectAtIndex:indexPath.row];
            //    主标题
            cell.textLabel.text = model.title;
            cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            //    主图片
            cell.imageView.image = [UIImage imageNamed:@"hyldph_logo"];
            //    右角标题
            cell.accessoryView  = datalab;
            datalab.text = model.time;
            //    副标题
            cell.detailTextLabel.text =model.body;
            cell.detailTextLabel.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
        }
            break;
        default:
            break;
    }

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    else{
        return  2;
    }
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld个cell信息",indexPath.row);

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
        {
            
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            NewsController *ctl = [[NewsController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
            self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
            
        default:{
            
            messagemodel *model = [messageArr objectAtIndex:indexPath.row];
            if ([model.type isEqualToString:@"zr"]) {
                DetailedController *ctl  =   [[DetailedController alloc]init];
                ctl.shopsubid            = model.shopid;
                ctl.shopcode             =  model.code;
                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                [self.navigationController pushViewController:ctl animated:YES];
                self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
            }
            else if ([model.type isEqualToString:@"cz"])
            {
                DetailedController *ctl =[[DetailedController alloc]init];
                ctl.shopcode            = model.code;
                ctl.shopsubid           = model.shopid;
                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                [self.navigationController pushViewController:ctl animated:YES];
                self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
            }
            else  if ([model.type isEqualToString:@"xz"]){
                ShopsiteXQController *ctl=[[ShopsiteXQController alloc]init];
                ctl.shopsubid=model.shopid;
                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                [self.navigationController pushViewController:ctl animated:YES];
                self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
            }
            
            else if ([model.type isEqualToString:@"zp"]){
                
                ResumeXQController *ctl =  [[ResumeXQController alloc]init];
                ctl.shopsubid           =  model.shopid;
                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                [self.navigationController pushViewController:ctl animated:YES];
                self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
            }
            else{
            }
        }
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self configBadgeView];
   
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSLog(@"消息导航栏%@",self.navigationController);
    
}

#pragma mark - 事件处理
- (void)Onmessage{
    
    
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
        
        if ([[pershowData shareshowperData]getAllDatas].count>0) {
            //    获取用户头像信息
            personshowmodel *model = [[[pershowData shareshowperData]getAllDatas] objectAtIndex:0];
            //    设置头像
            [[QYSDK sharedSDK]customUIConfig].customerHeadImageUrl= model.personimage;
        }else{
            NSLog(@"七鱼么有头像啊");
        }
    
    
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
                 self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                 
             }];
             
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                 NSLog(@"点击了取消");}];
             [alertController addAction:commitAction];
             [alertController addAction:cancelAction];
             [self presentViewController:alertController animated:YES completion:nil];
         }
}

- (void)onBack:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    [[QYSDK sharedSDK] logout:^{
    //        NSLog(@"推出在线客服");
    //    }];
}

- (void)configBadgeView {
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [_badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    [_badgeView setBadgeValue:value];
}

- (void)onUnreadCountChanged:(NSInteger)count
{
    [self configBadgeView];
}

-(void)viewWilldisAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
}

@end
