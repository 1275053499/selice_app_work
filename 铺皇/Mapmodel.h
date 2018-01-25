//
//  Mapmodel.h
//  铺皇
//
//  Created by selice on 2017/11/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Mapmodel : NSObject

@property (nonatomic,strong) NSString *Mapimg;    //店铺图像
@property (nonatomic,strong) NSString *Maptitle;  //店铺标题
@property (nonatomic,strong) NSString *Mapdistrict;   //店铺具体区域
@property (nonatomic,strong) NSString *MapCoordinateLongitude;   //店铺经度
@property (nonatomic,strong) NSString *MapCoordinateLatitude;    //店铺纬度
@property (nonatomic,strong) NSString *Maptime;   //店铺更新时间
@property (nonatomic,strong) NSString *Maptype;    //店铺标签
@property (nonatomic,strong) NSString *Maparea;   //店铺面积
@property (nonatomic,strong) NSString *Maprent;   //店铺租金
@property (nonatomic,strong) NSString *Mapsubid;  //店铺唯一id
@property (nonatomic,strong) NSString *Mapuser;   //店铺主人
@property (nonatomic,strong) NSString *Mapdityour;   //店铺区域
@property (nonatomic,strong) NSString *Mapphone;   //店铺联系号码
@property (nonatomic,strong) NSString *Mapmoneys;   //店铺费用

@property(nonatomic,strong)NSString *Mapdistinction;//区分是什么类型（转让 出租）

@end
