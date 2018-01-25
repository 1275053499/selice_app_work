//
//  MyAnnptation.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnptation : NSObject<MKAnnotation>

// 标题
@property (nonatomic, copy) NSString *title;
// 副标题
@property (nonatomic, copy) NSString *subtitle;
//城市
@property (nonatomic,strong)NSString *locality;
//区域
@property (nonatomic,strong)NSString *subLocality;
//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//id
@property (nonatomic, assign) NSString *subid;



@end
