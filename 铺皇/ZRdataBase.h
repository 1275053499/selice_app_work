//
//  ZRdataBase.h
//  铺皇
//
//  Created by 铺皇网 on 2017/8/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "JX_FourModel.h"

@interface ZRdataBase : NSObject

@property (nonatomic,strong)JX_FourModel * DetaiModel;


+(instancetype)shareZRdataBase;

#pragma - mark 列表内容
/**
 *  添加数据
 *
 */
- (void)addshopZR:(JX_FourModel *)dynamicModel;
/**
 *  删除数据
 *
 */

-(void)deletedZRdata;

/**
 *  获取数据
 *
 */
- (NSMutableArray *)getAllDatas;






@end
