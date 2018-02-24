//
//  AppDelegate.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h" //首页
#import "SecondViewController.h"//发布
#import "ThirdViewController.h" //信息
#import "PersonViewController.h"//我的

#import <CoreLocation/CoreLocation.h>

//友盟分享appkey
#define USHARE_DEMO_APPKEY @"590990a7734be462ee0014de"
#import <UMSocialCore/UMSocialCore.h>

//SMSSDK官网公共key 短信
#define SMSSDKappkey        @"1dfc7676b0c8c"
#define SMSSDKapp_secrect   @"6c60bd99e9cfb5a0084b12f8ab441aea"
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/SMSSDK.h>

//友盟推送
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#define UserNotificationkey     @"590990a7734be462ee0014de"
#define UserNotificationSecret  @"zwxip06x9rek1pa5sveow9mqcbfiwplr"
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>

//高德Key
#define GaodeAPIKey @"4b4878d3c67a3a9816ad997a7cdf8326"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

//网易七鱼客服
#import "QYSDK.h"
#import "NSDictionary+YSF.h"

//微信支付
#import "WXApi.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>

#define MainScreen_width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_height [UIScreen mainScreen].bounds.size.height//高

@interface AppDelegate ()<CLLocationManagerDelegate,UNUserNotificationCenterDelegate,UITabBarControllerDelegate,UIApplicationDelegate,WXApiDelegate>{
   
    UITabBarController  * tabBarController;
}

@property(nonatomic,strong) UIView * launchView;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@end

@implementation AppDelegate

- (void)configureAPIKey{
    
        [AMapServices sharedServices].apiKey = GaodeAPIKey;

}

#pragma  - mark tabbar 设置属性方法
- (void)controller:(UIViewController *)controller Title:(NSString *)title tabBarItemImage:(NSString *)image tabBarItemSelectedImage:(NSString *)selectedImage{
    
    controller.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:image];
    // 设置 tabbarItem 选中状态的图片(不被系统默认渲染,显示图像原始颜色)
    UIImage     *imageHome  = [UIImage imageNamed:selectedImage];
    imageHome               = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setSelectedImage:imageHome];
    // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:kTCColor(77, 166, 214) forKey:NSForegroundColorAttributeName];
    [controller.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
}

#pragma -mark 创建自定义tabbar
-(void)buildtabbar{
    
//          创建一个带导航的根控制器
    UINavigationController *nav1  = [[UINavigationController alloc] initWithRootViewController:[[FirstViewController alloc] init]];
    UINavigationController *nav2  = [[UINavigationController alloc] initWithRootViewController:[[SecondViewController alloc] init]];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:[[ThirdViewController alloc] init]];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:[[PersonViewController alloc] init]];
//          调用设置属性的方法
    [self controller:nav1 Title:@"首页" tabBarItemImage:@"Home_2" tabBarItemSelectedImage:@"Home_1" ];
    [self controller:nav2 Title:@"发布" tabBarItemImage:@"Issue_2" tabBarItemSelectedImage:@"Issue_1"];
    [self controller:nav3 Title:@"消息" tabBarItemImage:@"New_2" tabBarItemSelectedImage:@"New_1"  ];
    [self controller:nav4 Title:@"我的" tabBarItemImage:@"Mine_2" tabBarItemSelectedImage:@"Mine_1" ];
    
//          添加到tabbar控制器
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nav1,nav2,nav3,nav4];
    self.window.rootViewController = tabBarController;
    tabBarController.delegate = self;
   
}

#pragma -mark UITabBarController代理方法 点击刷新数据使用
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    static NSString *tabBarDidSelectedNotification = @"tabBarDidSelectedNotification";
    [[NSNotificationCenter defaultCenter] postNotificationName:tabBarDidSelectedNotification object:nil userInfo:nil];
//测试 看看
    if (tabBarController.selectedIndex ==0) {
        NSLog(@"首页  tabBar 获取响应");
    }
    
    else if (tabBarController.selectedIndex == 1){
        
         NSLog(@"发布  tabBar 获取响应");
    }
    
    else if (tabBarController.selectedIndex == 2){
        NSLog(@"消息  tabBar 获取响应");
    }
    else
    {
        NSLog(@"我的  tabBar 获取响应");
    }

}

-(void)buildmovie{
    
    PH_movieGuide *movieView = [[PH_movieGuide alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    [self.window.rootViewController.view addSubview:movieView];
    
    [UIView animateWithDuration:0.01 animations:^{
        movieView.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma -mark 不能加入2个main启动视图windows 不然分享功能有问题 start
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
#pragma -mark 不能加入2个main启动视图windows 不然分享功能有问题 end
    
//友盟分享 start
/* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
/* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    [self configUSharePlatforms];
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
//友盟分享 end

//    地图
    [self configureAPIKey];
    
#pragma  - mark    创建自定义tabbar 先创建 tab
    [self buildtabbar];
        
#pragma  - mark    创建视频引导页
     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Gifcanshow" ];//防止未进入页面转圈出现
     [self buildmovie];
    
#pragma  - mark//******************************友盟推送********start
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:@"590990a7734be462ee0014de" launchOptions:launchOptions httpsEnable:YES]; //适配https方法
    //注册通知
    [UMessage registerForRemoteNotifications];

//iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
                NSLog(@"允许了通知");
            
        } else {
            
            //点击不允许
                NSLog(@"不允许了通知");
        }
    }];
    

#pragma  - mark********************************友盟推送********end
    
#pragma  - mark ****************************************客服推送消息的处理
    //推送消息相关处理
    [[QYSDK sharedSDK] registerAppId:@"f89b6e40c3760e426f179d9da054f435" appName:@"铺皇"];
    
        //   //注册 APNS
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
        {
            UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    
        else
        {
            UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeBadge;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
        }
    
        NSDictionary *remoteNotificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotificationInfo) {
            [self showChatViewController:remoteNotificationInfo];
        }
    
#pragma  - mark  ****************************************客服推送消息的处理
    
    
#pragma  - mark ********************** 短信
    [SMSSDK registerApp:SMSSDKappkey
             withSecret:SMSSDKapp_secrect];
    [SMSSDK enableAppContactFriends:YES];
    
#pragma  - mark  *********************短信

  #pragma  - mark延迟启动页的跳转
    [NSThread sleepForTimeInterval:0.5];

#pragma  - mark***************************注册微信支付APPLEID
    [WXApi registerApp:@"wx9f7d4b17e069bbd4"];
    NSLog(@"微信注册states:%d",[WXApi registerApp:@"wx9f7d4b17e069bbd4"]);
    return YES;
}

#pragma mark 远程推送
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
   
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    
    //    客服绑定标志符
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    
    NSLog(@"deviceToken:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
            NSLog(@"register remote notification failed %@",error);
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
   
    NSLog(@"ios10以下:s数据:%@",userInfo);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
       
        //    客服接收到推送信息
        NSLog(@"ios10以下后台推送信息格式:%@",userInfo);
        
        if ([userInfo[@"nim"] isEqualToString:@"1"]) {
            NSLog(@"七鱼信息");
            NSLog(@"看看客服推送了什么:%@",userInfo);
            
            [self showChatViewController:userInfo];
        }
        else{
            
            //应用处于前台时的远程推送接受
            //关闭友盟自带的弹出框
            [UMessage setAutoAlert:NO];
            //必须加这句代码
            NSLog(@"友盟信息");
            [UMessage didReceiveRemoteNotification:userInfo];
            
            [self pushAction:userInfo];
        }
    }
}

#pragma -mark 七鱼客服的推送事件处理
- (void)showChatViewController:(NSDictionary *)remoteNotificationInfo{
    
    id object = [remoteNotificationInfo objectForKey:@"nim"]; //含有“nim”字段，就表示是七鱼的消息
    if (object){

        NSLog(@"推送消息");
        NSString *PUSHNUMBER = [[NSUserDefaults standardUserDefaults]objectForKey:@"PUSHNUMBER"];
        UINavigationController *nav = tabBarController.viewControllers[PUSHNUMBER.intValue];
        [nav popToRootViewControllerAnimated:NO];
        DoubtController *ctl =[[DoubtController alloc]init]; ;
        [nav pushViewController:ctl animated:YES];
        [ctl Online];
    }
}

//iOS10新增：友盟处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    self.userInfo = userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        //        自定义弹出框
        NSLog(@"ios10以上前台推送信息格式:%@",userInfo);
  
        if ([userInfo[@"nim"] isEqualToString:@"1"]) {
            NSLog(@"七鱼信息");
            [self showChatViewController:userInfo];
        }
        else{
            
            //应用处于前台时的远程推送接受
            //关闭友盟自带的弹出框
            [UMessage setAutoAlert:NO];
            //必须加这句代码
             NSLog(@"友盟信息");
            [UMessage didReceiveRemoteNotification:userInfo];
            [self pushAction:userInfo];
        }
    }
    
    else{
        
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    self.userInfo = userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
         NSLog(@"ios10以上后台推送信息格式:%@",userInfo);
        
        if ([userInfo[@"nim"] isEqualToString:@"1"]) {
            NSLog(@"七鱼信息");
             [self showChatViewController:userInfo];
        }
        else{
        
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
            NSLog(@"友盟信息");
        [UMessage didReceiveRemoteNotification:userInfo];
        [self pushAction:userInfo];
        }
        
    }
    else{
        
        //应用处于后台时的本地推送接受
    }
}


#pragma  -mark 友盟推送的信息事件处理
-(void)pushAction:(NSDictionary *)userInfo{
    
    messagemodel  *model = [[messagemodel alloc]init        ];
    model.body       =  userInfo[@"aps"][@"alert"][@"body"  ];
    model.subtitle   =  userInfo[@"aps"][@"alert"][@"subtitle"];
    model.title      =  userInfo[@"aps"][@"alert"][@"title" ];
    model.type       =  userInfo[@"type"    ];
    model.shopid     =  userInfo[@"shopid"  ];
    model.code       =  userInfo[@"code"    ];
    model.time       =  userInfo[@"time"    ];
    
    [[messagefmdb sharemessageData]adddata:model]; //添加推送信息到数据库

    NSLog(@"body:       %@",userInfo[@"aps"][@"alert"][@"body"]);
    NSLog(@"subtitle:   %@",userInfo[@"aps"][@"alert"][@"subtitle"]);
    NSLog(@"title:      %@",userInfo[@"aps"][@"alert"][@"title"]);
    NSLog(@"type:       %@",userInfo[@"type"]);
    NSLog(@"shopid:     %@",userInfo[@"shopid"]  );
    NSLog(@"code:       %@",userInfo[@"code"]);
    NSLog(@"time:       %@",userInfo[@"time"]);
    
    NSLog(@"动作中的%@",userInfo);
            [LEEAlert alert].config
    
            .LeeAddTitle(^(UILabel *label) {
    
                label.text = @"铺皇系统信息";
    
                label.textColor = [UIColor blackColor];
            })
            .LeeAddContent(^(UILabel *label) {
    
                label.text = @"尊敬的用户，您当前有一条信息是否需要前往查看";
                label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
            })
    
            .LeeAddAction(^(LEEAction *action) {
    
                action.type = LEEActionTypeCancel;
    
                action.title = @"稍等";
    
                action.titleColor = kTCColor(255, 255, 255);
    
                action.backgroundColor = kTCColor(174, 174, 174);
    
                action.clickBlock = ^{
    
                    // 取消点击事件Block
                };
            })
    
            .LeeAddAction(^(LEEAction *action) {
    
                action.type = LEEActionTypeDefault;
    
                action.title = @"前往";
    
                action.titleColor = kTCColor(255, 255, 255);
    
                action.backgroundColor = kTCColor(77, 166, 214);
    
                action.clickBlock = ^{
    
                    NSString *PUSHNUMBER = [[NSUserDefaults standardUserDefaults]objectForKey:@"PUSHNUMBER"];
                    UINavigationController *nav = tabBarController.viewControllers[PUSHNUMBER.intValue];
                    NSString *type=[userInfo valueForKey:@"type"];
                
                    if ([type isEqualToString:@"zr"]) {
    
                        DetailedController *ctl  =   [[DetailedController alloc]init];
                        ctl.shopsubid            =  [userInfo valueForKey:@"shopid"];
                        ctl.shopcode             =  [userInfo valueForKey:@"code"];
                        [nav pushViewController:ctl animated:YES];
                    }
                    else if ([type isEqualToString:@"cz"])
                    {
                        DetailedController *ctl =[[DetailedController alloc]init];
                        ctl.shopcode            = [userInfo valueForKey:@"code"];
                        ctl.shopsubid           = [userInfo valueForKey:@"shopid"];
                        [nav pushViewController:ctl animated:YES];
                    }
                  else  if ([type isEqualToString:@"xz"]){
                        ShopsiteXQController *ctl=[[ShopsiteXQController alloc]init];
                        ctl.shopsubid=[userInfo valueForKey:@"shopid"];
                        [nav pushViewController:ctl animated:YES];
                    }
                    
                   else if ([type isEqualToString:@"zp"]){
    
                        ResumeXQController *ctl =  [[ResumeXQController alloc]init];
                        ctl.shopsubid           =  [userInfo valueForKey:@"shopid"];
                        [nav pushViewController:ctl animated:YES];
                    }
                   else{

                       
                   }
    
                };
            })
    
            .LeeHeaderColor(kTCColor(255, 255, 255))
            .LeeShow();
}

#pragma mark 以下的
-(NSString *)stringDevicetoken:(NSData *)deviceToken{

    NSString *token     = [deviceToken description];
    NSString *pushToken = [[[token stringByReplacingOccurrencesOfString:@"<"withString:@""]stringByReplacingOccurrencesOfString:@">"withString:@""]stringByReplacingOccurrencesOfString:@" "withString:@""];
    return pushToken;
}

//当用户点击允许或者不允许后，会执行如下代理方法，我们把处理逻辑在其中实现
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
//        [self addLocalNotification];
    }
}

#pragma mark 本地推送
//-(void)addLocalNotification{
//    //定义本地通知对象
//    UILocalNotification *notification=[[UILocalNotification alloc]init];
//    //设置调用时间
//    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:10];//立即触发
//    //设置通知属性
//    notification.alertBody=@"尊敬的铺皇客户，您好，您有一条消息可以查看！"; //通知主体
//    notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
//    notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
//    notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
//    //调用通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//}


#pragma mark 分享～～～配置分享应用
- (void)configUSharePlatforms{
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可
     *
     *  设置平台的appkey
     *
     *  @param platformType 平台类型 @see UMSocialPlatformType
     *  @param appKey       第三方平台的appKey（QQ平台为appID）
     *  @param appSecret    第三方平台的appSecret（QQ平台为appKey）
     *  @param redirectURL  redirectURL
     */
    
/* 设置QQ平台的appID*/
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106302644"  appSecret:@"5J1EDxfvsUQvtQaF" redirectURL:@"http://mobile.umeng.com/social"];
    
/* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9f7d4b17e069bbd4" appSecret:@"af61dda1692cf78e47e0065d5d55e4e4" redirectURL:@"http://mobile.umeng.com/social"];
    
/* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1159789512"  appSecret:@"86d88221ce8a4e2b71d2bc61325c78b1" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
//    http://dev.umeng.com/social/ios/quick-integration#3 可以用到的分享应用
;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSLog(@"url---%@",url);//url---wb3348473715://response?id=EB0C8865-D57C-4625-8C78-5C155F137F3D&sdkversion=2.5

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
  
    if (!result) {
        
//            其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

                NSLog(@"result 111333 = %@",resultDic);
            }];
        }else{

            return [WXApi handleOpenURL:url delegate:self];
        }
        return YES;
    }
    return result;
}

#pragma mark 其他
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    NSLog(@"url---%@",url);//url---wb3348473715://response?id=EB0C8865-D57C-4625-8C78-5C155F137F3D&sdkversion=2.5
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    
    if (!result) {
        
           // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result 11144444 = %@",resultDic);
            }];
        }else{
         return [WXApi handleOpenURL:url delegate:self];
        }
        
        return YES;
    }
    return result;
}

// NOTE: 9.0以后使用新API接口
//设置系统回调----授权或分享之后就会执行下面的方法
//回调。iOS10.0以上使用
// 当用户通过其它应用启动本应用时，会回调这个方法，url参数是其它应用调用openURL:方法时传过来的。
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    NSLog(@"option------%@",options);
    //options------{
    //    UIApplicationOpenURLOptionsOpenInPlaceKey = 0;
    //    UIApplicationOpenURLOptionsSourceApplicationKey = "com.sina.weibo";
    //}
    NSLog(@"url---%@",url);//url---wb3348473715://response?id=EB0C8865-D57C-4625-8C78-5C155F137F3D&sdkversion=2.5
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
   
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result 1112222 = %@",resultDic);
                #pragma mark 支付宝支付结果返回 处理方法调用
                [self AlipayResp:resultDic[@"resultStatus"]];
                
            }];
        }else{
            return [WXApi handleOpenURL:url delegate:self];
        }
        
        return YES;
    }
    return result;
}

#pragma mark 支付宝支付结果返回来 处理方法实现
-(void)AlipayResp:(NSString *)Alipayresp{
     //发出通知 从支付宝回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳
                    switch (Alipayresp.integerValue) {
                        case 9000:
                        {// 支付成功，向后台发送消息
                            NSLog(@"订单支付成功");
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"Ali_PaySuccess" object:nil];
                           
                        }
                            break;
    
                        case 4000:{
                             NSLog(@"订单支付失败");
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"Ali_PayFail" object:nil];
                        }
                            break;
    
                        case 6001:
                        {
                            NSLog(@"用户中途取消");
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"Ali_PayCancel" object:nil];
    
                        }
                            break;
    
                        default:{
                            
                            NSLog(@"其它支付错误");
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"Ali_Payother" object:nil];
                        }
                            break;
                    }
}

#pragma mark 微信支付结果返回来看看
-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                NSLog(@"支付成功！！！！！！");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
                //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳
            }
                break;
                
            case WXErrCodeUserCancel:{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PayCancel" object:nil];
            }
                  break;
                
            case WXErrCodeUnsupport:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_Paysupport" object:nil];
                
            }
                break;
                
            default:{
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PayFail" object:nil];
            }
                 break;
        }
    }
}

#pragma mark 其他
- (void)applicationWillResignActive:(UIApplication *)application {
  
}

#pragma -mark 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    NSLog(@"进入后台");
}

#pragma -mark 进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application{
    
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
    NSLog(@"进入前台");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
       [self saveContext];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"__"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
@end
