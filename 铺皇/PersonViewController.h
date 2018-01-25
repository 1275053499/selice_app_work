//
//  PersonViewController.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YJLbigimgview.h"           //图片放大
#import "SetupController.h"         //设置
#import "MyIntegralController.h"    //我的积分
#import "MyServiceController.h"     //我的服务
#import "MyCollectionController.h"  //我的收藏
#import "MyReleaseController.h"     //我的发布
#import "LEEAlert.h"                //联系客服弹出

#import "LoginController.h"         //登录界面
#import "RegisterController.h"      //注册界面

#import "pershowData.h"
#import "personshowmodel.h"




@interface PersonViewController : UIViewController{
    UIButton      *GUIDbtn;
    UIImageView   *GUIDimgview;
    int            GUInum;
    UIView        *GUIDbackview;
}
@property (nonatomic, strong) UITableView *PersontableView;
@end
