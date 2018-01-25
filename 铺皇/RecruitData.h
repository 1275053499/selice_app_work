//
//  RecruitData.h
//  铺皇
//
//  Created by selice on 2017/9/2.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ShopsrecruitModel.h"
@interface RecruitData : NSObject
@property(nonatomic,strong)ShopsrecruitModel * DetailModel;

+(instancetype)sharerecruitData;


#pragma - mark 列表内容

/**
 *  添加数据
 *
 */

- (void)addrecruit:(ShopsrecruitModel *)dynamicModel;

/**
 *  删除数据
 *
 */

-(void)deletedsrecruitData;

/**
 *  获取数据
 *
 */

- (NSMutableArray *)getAllDatas;

@end
