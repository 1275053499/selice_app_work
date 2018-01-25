//
//  ScrollHeadView.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.

#import <UIKit/UIKit.h>
#import "WeboneViewController.h"
#import "MBProgressHUD.h"
#import "Defination.h"
@interface ScrollHeadView : UIView
@property (nonatomic,strong)UINavigationController *nav;
-(instancetype)initWithFrame:(CGRect)frame arraySource:(NSMutableArray *)arraySource;

@end
