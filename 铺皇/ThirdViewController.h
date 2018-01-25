//
//  ThirdViewController.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsController.h"
#import "DetailedController.h"  //转让出租详情
#import "ShopsiteXQController.h"//选址详情
#import "ResumeXQController.h"  //招聘详情
#import "LoginController.h"
#import "messagemodel.h"
#import "messagefmdb.h"


@interface ThirdViewController : UIViewController{
    
        NSMutableArray * messageArr;
      
}
@property (nonatomic, strong) UITableView *MessagetableView;
@property (nonatomic, strong) NSString *  shopid;

-(void)Onmessage;
@end
