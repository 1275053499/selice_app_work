//
//  RecommendallData.h
//  铺皇
//
//  Created by selice on 2017/9/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JX_FourModel.h"

@interface RecommendallData : NSObject
@property (nonatomic,strong)JX_FourModel * DetaiModel;


+(instancetype)shareRecommendDataBase;

#pragma - mark 列表内容
/**
 *  添加数据
 *
 */
- (void)addRecommendalldata:(JX_FourModel *)dynamicModel;
/**
 *  删除数据
 *
 */

-(void)deletedRecommendalldata;

/**
 *  获取数据
 *
 */
- (NSMutableArray *)getAllDatas;


@end
