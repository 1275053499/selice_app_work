//
//  XZdataBase.h
//  铺皇
//
//  Created by 铺皇网 on 2017/8/25.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "Shopsitemodel.h"
@interface XZdataBase : NSObject

@property(nonatomic,strong)Shopsitemodel * DetaiModel;


+(instancetype)shareXZdataBase;

#pragma  -mark 列表内容

/**
 *  添加数据
 *
 */
- (void)addshopXZ:(Shopsitemodel *)dynamicModel;
/**
 *  删除数据
 *
 */

-(void)deletedXZdata;

/**
 *  获取数据
 *
 */
- (NSMutableArray *)getAllDatas;



@end
