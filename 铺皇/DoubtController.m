//
//  DoubtController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/28.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "DoubtController.h"
//判断设备是否是iPad
#define iPadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define YSFRGB(rgbValue) YSFRGBA(rgbValue, 1.0)
@interface DoubtController ()<UITableViewDelegate,UITableViewDataSource,QYSessionViewDelegate,QYConversationManagerDelegate>
{
    UITableView *doubttabview;
}

@property float autoSizeScaleX;
@property float autoSizeScaleY;

@property (strong, nonatomic)NSMutableArray *   dataArray;
@property (strong, nonatomic)NSMutableArray *   titlesArray;
@property (strong, nonatomic)UIView         *   Topview;
@property (strong, nonatomic)UIImageView    *   lineimage;

@property (nonatomic, assign) BOOL isHide;

@property (strong, nonatomic) YSFDemoBadgeView *badgeView;

@end

@implementation DoubtController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"常见服务问题";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatBase];// 基本信息构建
    [self creatview];// 创建头部客服联系
}

#pragma  - mark 基本信息构建
-(void)creatBase{
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
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma  -mark 创建头部客服联系
-(void)creatview{

    _Topview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 150*_autoSizeScaleY)];
    _Topview.backgroundColor = [UIColor whiteColor];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:tableView];
    doubttabview = tableView;
    doubttabview.tableFooterView = [[UIView alloc]init];
    doubttabview.tableHeaderView = _Topview;
    
    doubttabview.sectionIndexColor = [UIColor blackColor];//索引字体色
    doubttabview.sectionIndexTrackingBackgroundColor = [UIColor clearColor];//索引点击背景色
    doubttabview.sectionIndexBackgroundColor = [UIColor clearColor];//索引始终背景色
    
//    按钮创建
    FSCustomButton *buttonA = [[FSCustomButton alloc] initWithFrame:CGRectMake(_Topview.frame.size.width/2/3, _Topview.frame.size.height/2-40*_autoSizeScaleY, KMainScreenWidth/2/3, 80*_autoSizeScaleY)];
    buttonA.adjustsTitleTintColorAutomatically = YES;
    [buttonA setTintColor:kTCColor(27, 31, 35)];
    buttonA.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [buttonA setTitle:@"在线客服" forState:UIControlStateNormal];
//    buttonA.backgroundColor = kTCColor(222, 234, 214);
    buttonA.backgroundColor = kTCColor(255, 255, 255);
    [buttonA setImage:[UIImage imageNamed:@"wdfw_zaixianfwu"] forState:UIControlStateNormal];
    buttonA.layer.cornerRadius = 4;
    buttonA.buttonImagePosition = FSCustomButtonImagePositionTop;
    buttonA.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [buttonA addTarget:self action:@selector(Online) forControlEvents:UIControlEventTouchUpInside];
    [_Topview addSubview:buttonA];

//竖线创建
    _lineimage = [[UIImageView alloc]initWithFrame:CGRectMake(_Topview.frame.size.width/2-0.5, 0, 1, _Topview.frame.size.height)];
    _lineimage.image = [UIImage imageNamed:@"wdfw_shuxian@2x"];
    [_Topview addSubview:_lineimage];
    
    
    FSCustomButton *buttonB = [[FSCustomButton alloc] initWithFrame:CGRectMake(_Topview.frame.size.width/6*4, _Topview.frame.size.height/2-40*_autoSizeScaleY, KMainScreenWidth/6, 80*_autoSizeScaleY)];
    buttonB.adjustsTitleTintColorAutomatically = YES;
    [buttonB setTintColor:kTCColor(27, 31, 35)];
    buttonB.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [buttonB setTitle:@"客服热线" forState:UIControlStateNormal];
//    buttonB.backgroundColor = kTCColor(222, 234, 214);
    buttonB.backgroundColor = kTCColor(255, 255, 255);
    
    [buttonB setImage:[UIImage imageNamed:@"wdfw_dianhua"] forState:UIControlStateNormal];
    buttonB.layer.cornerRadius = 4;
    buttonB.buttonImagePosition = FSCustomButtonImagePositionTop;
    buttonB.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [buttonB addTarget:self action:@selector(Tel) forControlEvents:UIControlEventTouchUpInside];
    [_Topview addSubview:buttonB];
}

#pragma -mark 在线客服
-(void)Online{
    
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
        sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
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
            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了取消");}];
        [alertController addAction:commitAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [[QYSDK sharedSDK] logout:^{
//        NSLog(@"推出在线客服");
//    }];
}

#pragma -mark 电话客服
-(void)Tel{
    
    NSLog(@"电话客服");{
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label){
            label.text = @"联系客服";
            label.textColor = [UIColor blackColor];
        })
        .LeeAddContent(^(UILabel *label){
            label.text = @"TEL:0755-23212184";
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        })
        .LeeAddAction(^(LEEAction *action){
            
            action.type = LEEActionTypeCancel;
            action.title = @"取消";
            action.titleColor = kTCColor(255, 255, 255);
            action.backgroundColor = kTCColor(174, 174, 174);
            action.clickBlock = ^{
                // 取消点击事件Block
            };
        })
        .LeeAddAction(^(LEEAction *action){
            action.type = LEEActionTypeDefault;
            action.title = @"呼叫";
            action.titleColor = kTCColor(255, 255, 255);
            action.backgroundColor = kTCColor(77, 166, 214);
            action.clickBlock = ^{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://0755-23212184"]];
            };
        })
        .LeeHeaderColor(kTCColor(255, 255, 255))
        .LeeShow();
    }
}

#pragma -mark 常见问题小标题（列表文字）
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"收费问题",@"服务问题",@"积分问题"],@[@"贵公司转店是如何操作的呢？",@"贵公司转店时间上如何控制？",@"贵公司转店为何要收费？",@"贵公司转店服务费为何那么高？比其它的公司都要高出许多！",@"贵公司实力真有说的那么厉害？不会说骗人的吧！",@"贵公司不是虚假的吧，交了服务费，你们跑了怎么办？"],@[@"签订合同几天能帮忙上线？",@"上线之后我怎么查看自己的店铺信息"],@[@"跟贵公司合作后续是跟贵公司业务员联系吗？",@"跟贵公司合作这么久都没有业务员带人来看店？"],@[@"公司简介",@"公司地址",@"公司联系方式",@"进入公司官网"],@[@"商铺转让",@"商铺选址",@"商铺出租",@"商铺推广",@"商铺租赁",@"房地产信息"],@[@"支付方式"],@[@"可否私下交易服务"], nil];
    }
    
    return _dataArray;
}

#pragma -mark 段头文字
-(NSMutableArray *)titlesArray{
    if (_titlesArray == nil){
        
        _titlesArray = [[NSMutableArray alloc]initWithObjects:@"热门问题",@"商铺转让问题",@"上线服务问题",@"售后服务问题",@"公司品牌",@"公司产品",@"支付模式问题",@"其它服务项问题",nil];
    }
    return _titlesArray;
}

#pragma -mark UItableViewcell代理方法
//拥有多少段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
//每段拥有的列表数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *dataarray = self.dataArray[section];
    return dataarray.count;
}

//初始化cell并赋值
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = kTCColor(161, 161, 161);
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    NSArray *data = self.dataArray[indexPath.section];
    cell.textLabel.text = data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"    itles=%@",self.titlesArray[section]);
    return _titlesArray[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]initWithObjects:@"热门",@"转让",@"上线",@"售后",@"品牌",@"产品",@"支付",@"其它",nil];
    return arr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了第%ld段,第%ld个cell信息",indexPath.section,indexPath.row);
    switch (indexPath.section)
    {
#pragma  -mark 热门问题
        case 0:
        {
//            热门
            switch (indexPath.row)
            {
                case 0:
                {
                    NSLog(@"热门0");

                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"如何收取服务费";//客户问题
                    ctl.Answer   = @"公司服务项目，具体分为四大模块，每一个模块的都是按照套餐模式消费服务积分，积分比例：RMB1元:1积分。具体套餐情况，请您前往[我的服务]中查看具体是由。";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:
                {
                     NSLog(@"如何服务店铺？");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Question = @"如何提供服务？";//客户问题
                    ctl.Answer   = @"您可以在公司的app[铺皇]中，选择需要服务的项目，使用积分购买适合套餐类型进行发布您的服务信息，公司工作人员收到了您的店铺信息，会在1-3日内进行店铺审核(一旦发现您的店铺信息有误，不会消费您的套餐使用)，通过的信息会服务在我么相应的套餐服务中，在线下我们安排了专属客服为您搜寻对应的老板辅助您转(找)店,招聘员工等";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。

                }
                    break;
                case 2:{
                    
                    NSLog(@"热门2");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"如何购买服务";//客户问题
                    ctl.Answer   = @"对于不同的用户，有不同的服务选择，您可以在[我的服务]中进行选择所需要的服务项目，然后选择对应的服务内容，服务期限，通过消耗个人账号积分的情况购买到自己需要的服务套餐，只有拥有套餐的用户才能够发布服务信息。";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }
                    break;
                case 3:
                {
                    NSLog(@"热门3");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Question = @"你们公司是如何服务转店的呢？有什么特色么？你给我说说看吧！33333333333";//客户问题
                    ctl.Answer   = @"如果您确定合作，我们会派专业的市场顾问实体考察你的店铺，将您的店铺进行拍照，店铺环境进行包装，在我梦到官网以及各大网站进行推广展示（例如：58，赶集，百度，百姓网）提高您的店铺的宣传力度和普光率，让找店的客户，可以第一时间找到你的店铺，而且我们线下】也会有专业的客服帮助您进行客户匹配，会匹配能够接手您的店铺的找店老板，直接到您的店铺看店，大大提升您的店铺的转店效率，您和我们合作后，您只需要在店铺里面接待看店客户就可以了";//客服回答
                    
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }
                    break;
                case 4:
                {
                    NSLog(@"热门4");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"你们公司是如何服务转店的呢？有什么特色么？你给我说说看吧！444444444444";//客户问题
                    ctl.Answer   = @"如果您确定合作，我们会派专业的市场顾问实体考察你的店铺，将您的店铺进行拍照，店铺环境进行包装，在我梦到官网以及各大网站进行推广展示（例如：58，赶集，百度，百姓网）提高您的店铺的宣传力度和普光率，让找店的客户，可以第一时间找到你的店铺，而且我们线下】也会有专业的客服帮助您进行客户匹配，会匹配能够接手您的店铺的找店老板，直接到您的店铺看店，大大提升您的店铺的转店效率，您和我们合作后，您只需要在店铺里面接待看店客户就可以了";//客服回答
                    
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }
                    break;
                default:
                {
                     NSLog(@"热门====");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"你们公司是如何服务转店的呢？有什么特色么？你给我说说看吧！555555555555";//客户问题
                    ctl.Answer   = @"如果您确定合作，我们会派专业的市场顾问实体考察你的店铺，将您的店铺进行拍照，店铺环境进行包装，在我梦到官网以及各大网站进行推广展示（例如：58，赶集，百度，百姓网）提高您的店铺的宣传力度和普光率，让找店的客户，可以第一时间找到你的店铺，而且我们线下】也会有专业的客服帮助您进行客户匹配，会匹配能够接手您的店铺的找店老板，直接到您的店铺看店，大大提升您的店铺的转店效率，您和我们合作后，您只需要在店铺里面接待看店客户就可以了";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。

                }
                    break;
            }
        }
            break;
            
#pragma -mark 转让问题
         case 1:
        {
//            转让
            switch (indexPath.row)
            {
                case 0:
                {
                    NSLog(@"转让操作");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"请问贵公司转店是如何操作的呢？能否给我说说详情？";//客户问题
                    ctl.Answer   = @"  如果您确定合作，我们公司会派专业的市场顾问实体考察你的店铺，将您的店铺进行拍照，店铺环境进行包装，在我梦到官网以及各大网站进行推广展示（例如：58，赶集，百度，百姓网）提高您的店铺的宣传力度和普光率，让找店的客户，可以第一时间找到你的店铺，而且我们线下】也会有专业的客服帮助您进行客户匹配，会匹配能够接手您的店铺的找店老板，直接到您的店铺看店，大大提升您的店铺的转店效率，您和我们合作后，您只需要在店铺里面接待看店客户就可以了。\n\n\n 如果您还是不了解，可直接联系客服人员咨询详情！";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:
                {
                    NSLog(@"转让效率");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Question = @"请问贵公司是服务转店效率如何？";//客户问题
                    ctl.Answer   = @"  我们公司的服务效果这点您可以完全放心，因为我们公司在深圳做了9年，我们转出去的店铺都有上万家的，我们这边找店是免费的，公司做了9年，有大量的找店客户资源，能不能转出去主要是有没找店的资源，再说，我们收了您的服务费用，只有帮您把店铺转出去之后，我们才收的到尾款，因为没有转出去的话，我们保证金到期是要退给您的，那公司前期给您做的服务和推广的费用都是公司自己承担的，没有转出去公司也是亏损的，既然我们能够接您的店，就一定会在规定的时间内帮您把店铺转出去，不然公司也是亏损的，您是做生意的，我们也是做生意的，我们公司也是要把您的店铺转出去之后才会有盈利，所以我们真正合作后，您完全可以放心。最后想问您一句，您觉得深圳有转不去的店吗？ \n\n\n 如果您还是不了解，可直接联系客服人员咨询详情！";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    
                    break;
                case 2:
                {
                    NSLog(@"转让收费");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Answer   = @"  相信您也接到过其他平台的电话，平台帮助您转店，前期不交费是不可能的，也不会有公司前期不收费会帮助您转店的。我们前期收了您的保证金，也会在规定的期限内帮您把店铺转出去的，转出去之后您再付后续的尾款，我们市场顾问过去，也会带着合同过去，实体考察了您的店铺，确实符合我们的接店标准，我们会当面给您详细讲解我们的合同条款及服务内容，并且规定的期限也会详细的写在合同里面的，这个您就放心好了，而且，我们合同上面也有明文规定，如果在规定的期限内不管出现任何原因，导致您的店铺没有转出去，我们前期收的保证金也是会退还给到您的，您这边是不用承担任何风险的。  \n\n\n 如果您还是不了解，可直接联系客服人员咨询详情！";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                    
                case 3:{
                    
                    NSLog(@"转让收费太高");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Question = @"请问贵公司转店服务费为何那么高？比其它的公司都要高出许多！";//客户问题
                    ctl.Answer   = @"  我们的收费在同行业确实会相对高一些，但是我们的服务和效果您是可以看得见的，我们是会在规定的时间内帮您把店铺转出去，同时，我相信您和我们合作，目的也是为了把店铺转出去，如果我们合作的话，我们是可以给到您想要的结果，就是把店转出去，其他平台费用再便宜，但是不能把您店铺转出去说什么都没用，您说对吧！另外，由于我没有看到您店铺的实际情况，我现在给您的报价是我们的全国统一收费价，也是一个初步套餐价，具体的话，还是需要我们的市场顾问亲自到您店铺实地考察后，会详细的给您讲解我们的收费和合作细节。  \n\n\n 如果您还是不了解，可直接联系客服人员咨询详情！";//客服回答
                    
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                    
                case 4:{
                    
                    NSLog(@"不相信公司实力");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Answer   = @"  您应该是第一次通过平台转店吧，您不了解我们公司也可以理解，我们公司在深圳做了九年的转店服务，总公司在龙华新区的良基大厦，西乡分公司我们在一年之内建立起来，就在西乡客运站这边，而且分公司正在往全国各大城市扩展，2017年8月，广州白云区又确定建立起了分公司，这个您也可以到网上去查一下的，现在都是互联网时代了，什么都可以到网上查到的，信息都是非常透明的，再说了，我们这么大的公司，也不可能为了您这点钱影响我们公司的声誉对吧，我们做了九年的公司 ，靠的就是信誉度和口碑，您自己也是做生意的，您应该也清楚，我们帮您转的好，我相信您也会给我们介绍客户的。  \n\n\n 如果您还是不了解，可直接联系客服人员咨询详情！";//客服回答
                    
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                    
                case 5:{
                    
                    NSLog(@"不相信公司存在");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Question = @"请问贵公司真实存在么？我一旦缴费了，你们不会都消失不见了吧？";//客户问题
                    ctl.Answer   = @"  您真会开玩笑，您之前对我们不了解没关系，这次让您好好了解一下我们公司，另外您做生意需要谨慎点是对的，但是我们中国铺皇网这么大的公司在深圳这边也做了9年的时间了，我们不可能为咱们一个店铺几千块钱的事去跑了吧，再有我们这边主要是以服务商铺为主，要是我们这样做的话，怎么可能长期生存下去，如何发展壮大呢，最主要是咱们做生意的也要图来回的持续合作啊。再有我们公司总部就在龙华您也可以随时过去考察参观的，我也希望这次的合作能够帮到您解决问题，下次您再介绍您朋友过来。  \n\n\n 如果您还是不了解，可直接联系客服人员咨询详情已经当天转店信息！";//客服回答
                    
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;

                    
                    
                default:{
                    
                }
                    break;
            }
        }
            break;
            
#pragma  -mark 上线问题
        case 2:
        {
            //            上线
            switch (indexPath.row)
            {
                case 0:
                {
                    NSLog(@"上线1");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Question = @"问：请问签完合同几天能上线？";//客户问题
                    ctl.Answer   = @"答：签完合同我们会在三个工作日之内上线，（例周日公司休息然后推一天）。";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:
                {
                    NSLog(@"上线2");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"问：请问我怎么看上线后的店铺信息呢？";//客户问题
                    ctl.Answer   = @"答：技术部上线完转交给我们的客服部门，客服部门人员拿到资料会第一时间以电话等方式通知我们合作的客户，并且指导我们客户如何查看店铺信息。";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                default:
                {
                    NSLog(@"上线====");
                }
                    break;
            }

            
        }
            break;
#pragma  -mark 售后问题
        case 3:
        {
            //            售后
            switch (indexPath.row)
            {
                case 0:
                {
                    NSLog(@"售后1");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"问：跟贵公司合作后续是跟贵公司业务员联系吗？";//客户问题
                    ctl.Answer   = @"答：合作后店铺信息会上传到我们官方网站，资料会交接到中国铺王客服部，客服部将找店客户做匹配、删选、推荐给合作的转店客户，所以合作后的客户可以直接跟客服联系，电话是（0755）232122184  也可将急需咨询问题留言给业务，由业务转达给客服部即可。";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:
                {
                    NSLog(@"售后2");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"问：请问我怎么看上线后的店铺信息呢？";//客户问题
                    ctl.Answer   = @"答：技术部上线完转交给我们的客服部门，客服部门人员拿到资料会第一时间以电话等方式通知我们合作的客户，并且指导我们客户如何查看店铺信息。";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                default:
                {
                    NSLog(@"售后====");
                }
                    break;
            }

            
        }
            break;

            
#pragma  -mark 公司品牌问题
        case 4:
        {
            //            公司品牌
            switch (indexPath.row)
            {
                case 0:
                {
                    NSLog(@"公司品牌1");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Question = @"问：贵公司实力行不行啊，我很说担心把店铺交给你们！";//客户问题
                    ctl.Answer   = @"答：铺皇集团旗下拥有中低端商铺平台中国铺王网、高端商铺服务、商铺投资平台中国铺皇网，两大商铺服务平台，秉承“为全国生意人保驾护航”的理念，9年来专注为商家实现“低成本、智能化”的电子商务化产品服务，降低商家“互联网+”门槛，倡导技术为核心，产品为导向，平台为基础，服务为价值，客户为根本的理念，创建 “服务第一”的实体商家、个体、加盟商一站式产品服务，通过十多年来的技术产品研发及上千家全国服务渠道体系的构建，实现对数千万家商家的全面服务。\n\n  19年互联网实践积累、15年B2B资源积累、千万级流量2C数据、10亿条数据索引、30万+随时可调度客户端、数十个创新系统有机结合，形成一个强大的“自思考学习系统”支撑着铺皇企业服务平台以及数十个企业服务产品。10余年锐意进取，铺皇（控股）集团始终以开拓者的姿态，专注于商家一站式产品服务，并以不断超越的创新精神，助力商家轻松拥抱互联网。\n\n  铺皇创立至今已积累9年的服务商家互联网服务经验，此外，集团还运营着庞大的商业网站群，包括中国铺王网、拥有强大的B2B资源积累。铺王平台的研发历经两年，整整24个月，根据商家需求，技术员深入市场，上百人的技术外包团队，投入千万资产投入产品研发。";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:
                {
                    NSLog(@"公司地址");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    
                    ctl.Question = @"问：贵公司的办公地址在哪里啊？";//客户问题
                    ctl.Answer   = @"答：铺皇（控股）集团在深圳已经开了2家分公司，武汉，广州，北京，天津...各大城市的分公司正在一步步磨合加急组建，您可以放心我们都是实体公司模式！\n\n  1.深圳总部地址：深圳市龙华新区东环一路良基大厦520室。\n\n  2.深圳分公司：深圳市宝安区西乡街道共和工业路国汇通商务中心502室。\n\n  3.广州分公司：广州市白云区增槎路787号睿晟国际5楼503A。\n\n ";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 2:
                {
                    NSLog(@"公司联系方式");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"问：那我们要合作该如何联系贵公司？";//客户问题
                    ctl.Answer   = @"答：\n    铺皇客服部联系方式：\n                    客服专线：0755-23212184\n\n    铺皇产品服务联系方式：\n                      卢经理：15994741808 \n\n";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                    
                case 3:
                {
                    NSLog(@"进入公司官网");
                   
                    WebsetController *ctl = [[WebsetController alloc]init];
//                    ctl.url = @"http://chinapuhuang.com";
                    ctl.url = @"http://www.zhongguopuwang.com";
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
            }
        }
            break;
#pragma  -mark 公司产品
        case 5:
        {
            //            公司产品
            switch (indexPath.row)
            {
                case 0:
                {
                    NSLog(@"公司产品1商铺转让");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"问：贵公司的服务项目：商铺转让是怎么一个模式？";//客户问题
                    ctl.Answer   = @"答：铺皇集团旗下拥有中低端商铺平台中国铺王网、高端商铺服务、商铺投资平台中国铺皇网，两大商铺服务平台，秉承“为全国生意人保驾护航”的理念，9年来专注为商家实现“低成本、智能化”的电子商务化产品服务，降低商家“互联网+”门槛，倡导技术为核心，产品为导向，平台为基础，服务为价值，客户为根本的理念，创建 “服务第一”的实体商家、个体、加盟商一站式产品服务，通过十多年来的技术产品研发及上千家全国服务渠道体系的构建，实现对数千万家商家的全面服务。\n\n  商铺转让只是我们公司的其中一种服务类型：我们需要按照流程为您提供服务：\n\n    1.评估策划：合作之前我们公司都会派遣团队对商家的店铺进行价值评估，进行最大化的价值优化，同时制定详细的转店策划方案。\n\n  2.线上展示：线上全网推广。转店信息会发布到中国铺王网官方网站进行推广，同时会发布到百度贴吧，微信公众号，本地找店服务资源群，微信资源群，以及58同城，赶集网，搜狗网，百度知道，360问答，网易，新浪，百姓网等10大网站进行大力推广服务。\n\n  3.人工客服辅助：线下客服辅助，对找店和转店客户进行匹配，同时为每个客户进行信息反馈，及时汇报店铺转让工作进度。\n\n\n如果您的问题尚未解决，可联系客服咨询！";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }
                    break;
                case 1:
                {
                    NSLog(@"公司产品2商铺选址");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                   
                    ctl.Question = @"问：贵公司的服务项目：商铺选址是怎么一个模式？";//客户问题
                    ctl.Answer   = @"答：铺皇集团旗下拥有中低端商铺平台中国铺王网、高端商铺服务、商铺投资平台中国铺皇网，两大商铺服务平台，秉承“为全国生意人保驾护航”的理念，9年来专注为商家实现“低成本、智能化”的电子商务化产品服务，降低商家“互联网+”门槛，倡导技术为核心，产品为导向，平台为基础，服务为价值，客户为根本的理念，创建 “服务第一”的实体商家、个体、加盟商一站式产品服务，通过十多年来的技术产品研发及上千家全国服务渠道体系的构建，实现对数千万家商家的全面服务。\n\n  商铺选址只是我们公司的其中一种服务类型：公司选址服务项目是完全免费的，作为找店客户，您只需要将您的找店要求向我们的客服部门专业人士联系，三天之内客服部人员会根据您的需求到我们的转让店铺的资源备案中精准匹配适合的店铺并立即联系到客户进行沟通。如果比较满意，直接沟通双方老板进行面谈沟通具体事宜，在完成店铺交接之前，客服人员会时刻跟踪服务。\n\n\n如果您的问题尚未解决，可联系客服咨询！";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 2:
                {
                    NSLog(@"公司产品3商铺出租");
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提醒"] message:@"商铺出租服务项目资源正在维护整理中，您可以直接联系客服咨询" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                NSLog(@"取消");
                            }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                NSLog(@"联系");
                                [self Offsetorigin];//列表上啦
                            }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:commitAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                    break;
                case 3:
                {
                    NSLog(@"公司产品4商铺推广");
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提醒"] message:@"商铺推广服务项目资源正在维护整理中，您可以直接联系客服咨询" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"取消");
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"联系");
                        [self Offsetorigin];//列表上啦
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:commitAction];
                    [self presentViewController:alertController animated:YES completion:nil];

                }
                    break;
                    
                case 4:
                {
                    NSLog(@"公司产品5商铺租赁");
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提醒"] message:@"商铺租赁服务项目资源正在维护整理中，您可以直接联系客服咨询" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"取消");
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"联系");
                        [self Offsetorigin];//列表上啦
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:commitAction];
                    [self presentViewController:alertController animated:YES completion:nil];

                }
                    break;
                    
                default:
                {
                    NSLog(@"公司产品=房地产信息");
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提醒"] message:@"房地产信息服务项目资源正在维护整理中，您可以直接联系客服咨询" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"取消");
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"联系");
                        [self Offsetorigin];//列表上啦
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:commitAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                    break;
            }

            
        }
            break;
#pragma  -mark 支付问题
        case 6:
        {
//            支付问题
            switch (indexPath.row)
            {
                case 0:
                {
                    NSLog(@"支付方式");
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    
                    ctl.Question = @"问：与贵公司合作如何交付服务费用？";//客户问题
                    
                    ctl.Answer   = @"答：公司现如今支持微信，支付宝，信用卡刷卡三种支付模式:\n\n  1.支付宝：\n    a.扫码支付:通过扫公司官方微信二维码付款。\n    b.间接支付：先交易到业务员业务微信号，业务员回到公司交付到财务部确认。\n\n    c.公司考察支付：客户有考察公司需求的可以到公司考察后再进行合作交付服务费用。\n\n\n  2.微信支付：\n    a.扫码支付:通过扫公司官方支付宝二维码付款。\n    b.间接支付：先交易到业务员业务支付宝账号，业务员回到公司交付到财务部确认。\n\n    c.公司考察支付：客户有考察公司需求的可以到公司考察后再进行合作交付服务费用。\n\n\n 3.刷卡支付：\n   由于少部分商铺老板有刷卡支付需求，故公司也已经开通了刷卡支付功能，如果您有该支付方式需求，需要跟业务员提前进行沟通好。\n    a.公司将会派遣专业人员上门服务。\n\n    b.客户到公司考察了进行刷卡支付。\n\n\n如果您的问题尚未解决，可联系客服咨询！";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }
                    break;
                case 1:
                {
                    NSLog(@"支付问题2");
                }
                    break;
                default:
                {
                    NSLog(@"支付问题====");
                }
                    break;
            }

            
        }
            break;
#pragma  -mark 其它问题
        case 7:
        {
//            其它服务问题
            switch (indexPath.row)
            {
                case 0:
                {
                    NSLog(@"其它服务问题1");
                    
                    DoubtaskerController *ctl = [[DoubtaskerController alloc]init];
                    ctl.Question = @"问：不知道可否进行私下转店，到时转出去了多给你一笔服务费！";//客户问题
                    ctl.Answer   = @"答：  您真会说笑，不是我不愿意这样做，您也知道咱们公司主要做的就是商铺转让，这也是公司的主要盈利点，公司的找店资源是由商务资源部门负责的，我们私底下手上根本就没有找店资源，我如果不借助公司团队的力量也没办法帮您快速转让店铺，如果我答应您的话，那也会耽误您的转店进度对不对！再有公司在这方面是有严格规定的，转店涉及到一系列的后续服务，也需要各个部门之间的相互配合，比如：私下交易您这个店铺的信息不能在我们的官网上展示，另外客服也不能进行条件匹配，这非常不利于您的店铺在短期内转出去。像您自己做生意的，相信您也非常反感您自己的员工背着您，做一些对您不利的事情，也希望您的理解，对您而言现在最重要的是快速的把店铺转出去，并且转一个好的价格，您说对吗？ \n\n\n 如果您还是不了解，可直接联系客服人员咨询详情";//客服回答
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:
                {
                    NSLog(@"其它服务问题2");
                }
                    break;
                default:
                {
                    NSLog(@"其它服务问题====");
                }
                    break;
            }

        }
            break;
    
#pragma  -mark 额外的
        default:
        {
            NSLog(@"000000000");
        }
            break;
    }
}

#pragma  -mark 回到头部
-(void)Offsetorigin{
    
    [doubttabview setContentOffset:CGPointMake(0, -64) animated:YES];
}

//#pragma -mark  cell加入3D动画
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //设置Cell的动画效果为3D效果
//    //设置x和y的初始值为0.1；
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    //x和y的最终值为1
//    [UIView animateWithDuration:1 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}
#pragma  -mark - 返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}



- (void)configBadgeView
{
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [_badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    [_badgeView setBadgeValue:value];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[[QYSDK sharedSDK] conversationManager ] setDelegate:self];
    [self configBadgeView];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
}

@end
