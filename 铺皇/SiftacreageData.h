//
//  SiftacreageData.h
//  铺皇
//
//  Created by selice on 2017/8/31.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "Featuremodel.h"
@interface SiftacreageData : NSObject

@property (nonatomic,strong)Featuremodel * DetaiModel;

+(instancetype)shareacreageData;

#pragma - mark 列表内容
/**
 *  添加数据
 *
 */
- (void)addshopacreage:(Featuremodel *)dynamicModel;
/**
 *  删除数据
 *
 */
-(void)deletedacreageData;
/**
 *  获取数据
 *
 */
- (NSMutableArray *)getAllDatas;

@end
