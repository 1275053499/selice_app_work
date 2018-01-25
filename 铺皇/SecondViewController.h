//
//  SecondViewController.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/17.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"

#import "DetailedController.h"  //转让出租详情
#import "ShopsiteXQController.h"//选址详情
#import "ResumeXQController.h"  //招聘详情
@interface SecondViewController : UIViewController{
    UIButton      *GUIDbtn;
    UIImageView   *GUIDimgview;
    UIView        *GUIDbackview;
}
@property (nonatomic, strong) UITableView *tableView;




@end
