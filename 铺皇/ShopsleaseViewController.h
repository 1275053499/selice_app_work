//
//  ShopsleaseViewController.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopsleaseViewController : UIViewController{
   
    NSString       *valuestr1;      //当前点击的位置1 区域
    NSString       *valuestr2;      //当前点击的位置2 租金
    NSString       *valuestr3;      //当前点击的位置3 行业
    NSString       *valuestr4;      //当前点击的位置4 面积
    NSString       *valuestr1id;    //当前点击的位置1 区域id
    NSString       *valuestr2id;    //当前点击的位置2 租金id
    NSString       *valuestr3id;    //当前点击的位置3 行业id
    NSString       *valuestr4id;    //当前点击的位置4 面积id
}

@property(nonatomic,strong)NSString *hostcityid;
@end
