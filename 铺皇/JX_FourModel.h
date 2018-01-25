//
//  JX_FourModel.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/24.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JX_FourModel : NSObject
@property (nonatomic,strong) NSString *JX_picture;//店铺图像
@property (nonatomic,strong) NSString *JX_title;  //店铺标题
@property (nonatomic,strong) NSString *JX_quyu;   //店铺区域所在
@property (nonatomic,strong) NSString *JX_time;   //店铺更新时间
@property (nonatomic,strong) NSString *JX_tag;    //店铺标签
@property (nonatomic,strong) NSString *JX_area;   //店铺面积
@property (nonatomic,strong) NSString *JX_rent;   //店铺租金

@property (nonatomic,strong) NSString *JX_subid;  //店铺唯一id
@end
