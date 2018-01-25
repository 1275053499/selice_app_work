//
//  ShopsmapsiteViewController.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapmodel.h"
#import "MyAnnptation.h"
@interface ShopsmapsiteViewController : UIViewController{
    NSString       *valuerent1;     //当前点击的位置1 租金
    NSString       *valuemoney2;    //当前点击的位置2 转让费
    NSString       *valuearea3;     //当前点击的位置3 面积
    NSString       *valuetype4;     //当前点击的位置4 类型
    
    NSString       *valuerent1id;   //当前点击的位置1 租金id
    NSString       *valuemoney2id;  //当前点击的位置2 转让费id
    NSString       *valuearea3id;   //当前点击的位置3 面积id
    NSString       *valuetype4id;   //当前点击的位置4 类型id
}
@property(nonatomic,strong)NSString * cityname;
@property(nonatomic,strong)NSString * cityid;
@end
