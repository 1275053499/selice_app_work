//
//  Detailedmodel.h
//  铺皇
//
//  Created by 铺皇网 on 2017/6/21.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Detailedmodel : NSObject
@property(nonatomic,strong)NSString  *Shopname;//商铺名称
@property(nonatomic,strong)NSString  *Shoptime;//商铺上线时间

@property(nonatomic,strong)NSString  *Shoprent;//商铺租金
@property(nonatomic,strong)NSString  *Shoparea;//商铺面积
@property(nonatomic,strong)NSString  *Shopprice;//商铺转让费

@property(nonatomic,strong)NSString  *Shopquyu;//商铺地址
@property(nonatomic,strong)NSString  *Shopfit;//商铺适合经营

@property(nonatomic,strong)NSString  *Shoping11;//商铺上下火
@property(nonatomic,strong)NSString  *Shoping12;//商铺可明火
@property(nonatomic,strong)NSString  *Shoping13;//商铺380v
@property(nonatomic,strong)NSString  *Shoping14;//商铺煤气管道
@property(nonatomic,strong)NSString  *Shoping15;//商铺排烟管道

@property(nonatomic,strong)NSString  *Shoping21;//商铺排污管道
@property(nonatomic,strong)NSString  *Shoping22;//商铺停车位
@property(nonatomic,strong)NSString  *Shoping23;//商铺产权
@property(nonatomic,strong)NSString  *Shoping24;//商铺证件齐全
@property(nonatomic,strong)NSString  *Shoping25;//商铺中央空调

@property(nonatomic,strong)NSString  *ShopXQrent;//商铺详情租金
@property(nonatomic,strong)NSString  *ShopXQarea;//商铺详情面积
@property(nonatomic,strong)NSString  *ShopXQtype;//商铺详情类型
@property(nonatomic,strong)NSString  *ShopXQquyu;//商铺详情区域
@property(nonatomic,strong)NSString  *ShopXQperson;//商铺详情联系人
@property(nonatomic,strong)NSString  *ShopXQnumber;//商铺详情电话
@property(nonatomic,strong)NSString  *ShopXQstate;//商铺详情经验状态
@property(nonatomic,strong)NSString  *ShopXQprice;//商铺详情转让费

@property(nonatomic,strong)NSString *ShopXQdescribe;//商铺描述

@property(nonatomic,strong)NSString *ShopDitu;          //商铺地图反编码名称
@property(nonatomic,strong)NSString *ShopDitudata;      //商铺地图经纬度

@property(nonatomic,strong)NSString *Shopcollect;      //商铺收藏状态

@end
