//
//  CZdataBase.h
//  铺皇
//
//  Created by 铺皇网 on 2017/8/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "JX_FourModel.h"

@interface CZdataBase : NSObject

@property(nonatomic,strong)JX_FourModel *DetaiModel;


+(instancetype)shareCZdataBase;

#pragma - mark 列表内容
/**
 *  添加数据
 *
 */

-(void)addshopCZ:(JX_FourModel *)dynamicModel;
/**
 *  删除数据
 *
 */

-(void)deletedCZdata;
/**
 *  获取数据
 *
 */

-(NSMutableArray *)getAllDatas;


@end
