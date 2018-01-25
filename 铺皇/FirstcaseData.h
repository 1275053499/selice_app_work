//
//  FirstcaseData.h
//  铺皇
//
//  Created by selice on 2017/9/13.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "casecellmodel.h"
#import "Anlimodel.h"
@interface FirstcaseData : NSObject
@property (nonatomic,strong)casecellmodel *model;
@property (nonatomic,strong)Anlimodel     *allmodel;

+(instancetype)sharecaseData;

#pragma - mark 首页6个案例内容

/**
 *  添加首页案例数据
 *
 */

- (void)addcaseData:(casecellmodel *)Model;

/**
 *  删除首页案例类数据
 *
 */

-(void)deletedcaseData;

/**
 *  获取首页案例数据
 *
 */

- (NSMutableArray *)getcaseAllDatas;


#pragma - mark 首页6个案例内容

/**
 *  添加全部案例数据
 *
 */

- (void)addallcaseData:(Anlimodel *)Model;

/**
 *  删除全部案例类数据
 *
 */

-(void)deletedallcaseData;

/**
 *  获取全部案例数据
 *
 */

- (NSMutableArray *)getcaseallAllDatas;


@end
