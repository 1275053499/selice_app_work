//
//  ShopsiteXQController.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/8.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopsiteXQController : UIViewController
{
    UITableView * _tableView;
    NSMutableArray * dataArr;//存储数据
}
@property(nonatomic,strong)NSString *shopsubid;
@end
