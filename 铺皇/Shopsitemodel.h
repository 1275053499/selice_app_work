//
//  Shopsitemodel.h
//  铺皇
//
//  Created by 铺皇网 on 2017/6/23.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shopsitemodel : NSObject
@property (strong, nonatomic) NSString *Shopsitetitle;      //店铺标题
@property (strong, nonatomic) NSString *Shopsitedescribe;   //店铺描述
@property (strong, nonatomic) NSString *Shopsitetype;       //店铺类型
@property (strong, nonatomic) NSString *Shopsitearea;       //店铺面积
@property (strong, nonatomic) NSString *Shopsiterent;      //店铺租金
@property (nonatomic, strong) NSString *Shopsitequyu;      //店铺区域
@property (nonatomic, strong) NSString *Shopsitesubid;      //店铺id

@end
