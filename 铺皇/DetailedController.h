//
//  DetailedController.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/24.
//  Copyright © 2017年 中国铺皇. All rights reserved.

#import <UIKit/UIKit.h>
#import "Detailedmodel.h"
#import "DetailedViewCell.h"
#import "GesbackController.h"
@interface DetailedController : UIViewController{
    
    UITableView         * tableView;
    NSMutableArray      * dataArr;//存储数据
}

@property (nonatomic,strong)NSString *shopsubid;
@property (nonatomic,strong)NSString *shopcode;

@end
