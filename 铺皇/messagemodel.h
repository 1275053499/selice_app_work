//
//  messagemodel.h
//  铺皇
//
//  Created by selice on 2017/11/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messagemodel : NSObject
@property(nonatomic,strong)NSString *body;      //内容
@property(nonatomic,strong)NSString *subtitle;  //副标题
@property(nonatomic,strong)NSString *title;     //标题
@property(nonatomic,strong)NSString *type;      //推送类型 转让zr 出租cz 选址xz 招聘zp
@property(nonatomic,strong)NSString *shopid;    //店铺id
@property(nonatomic,strong)NSString *code;      //或者数据判断
@property(nonatomic,strong)NSString *time;      //推送时间
@end
