//
//  Anlimodel.h
//  铺皇
//
//  Created by 铺皇网 on 2017/6/20.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Anlimodel : NSObject

@property (nonatomic,strong) NSString *Anli_picture;//高清图
@property (nonatomic,strong) NSString *anlismall_picture;//低清图
@property (nonatomic,strong) NSString *Anli_title;
@property (nonatomic,strong) NSString *Anli_quyu;
@property (nonatomic,strong) NSString *Anli_time;
@property (nonatomic,strong) NSString *Anli_tag;
@property (nonatomic,strong) NSString *Anli_area;
@property (nonatomic,strong) NSString *Anli_price;
@property (nonatomic,strong) NSString *Anli_subid;

@property (nonatomic,strong) NSString *originalImage;

@end
