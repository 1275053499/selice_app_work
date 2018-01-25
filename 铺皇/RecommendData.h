//
//  RecommendData.h
//  铺皇
//
//  Created by selice on 2017/9/13.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "recomendcellmodel.h"
@interface RecommendData : NSObject

@property (nonatomic,strong)recomendcellmodel *model;

+(instancetype)sharerecommendData;

#pragma - mark 列表内容

/**
 *  添加娱乐类数据
 *
 */

- (void)addrecreationData:(recomendcellmodel *)Model;

/**
 *  添加生活类数据
 *
 */

- (void)addlifeData:(recomendcellmodel *)Model;

/**
 *  添加百货类数据
 *
 */

- (void)adddepartmentData:(recomendcellmodel *)Model;

/**
 *  删除娱乐类数据
 *
 */

-(void)deletedrecreationData;

/**
 *  删除生活数据
 *
 */

-(void)deletedlifeData;

/**
 *  删除百货数据
 *
 */

-(void)deleteddepartmentData;

/**
 *  获取娱乐类数据
 *
 */

- (NSMutableArray *)getrecreationAllDatas;

/**
 *  获取生活类数据
 *
 */

- (NSMutableArray *)getlifeAllDatas;

/**
 *  获取百货类数据
 *
 */

- (NSMutableArray *)getdepartmentAllDatas;

@end
