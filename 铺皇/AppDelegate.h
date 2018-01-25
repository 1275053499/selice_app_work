//
//  AppDelegate.h
//  铺皇
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LEEAlert.h"            //自定义推行信息弹框
#import "DetailedController.h"  //转让出租详情
#import "ShopsiteXQController.h"//选址详情
#import "ResumeXQController.h"  //招聘详情
#import "messagemodel.h"
#import "messagefmdb.h"
#import "DoubtController.h"     //七鱼推送信息处理界面

#import "PH_movieGuide.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *userInfo;

@property (nonatomic,strong) UITabBarController *tabbarCtl;

@property (readonly, strong) NSPersistentContainer *persistentContainer;


- (void)saveContext;


@end

