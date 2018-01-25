//
//  pershowData.h
//  铺皇
//
//  Created by selice on 2017/9/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "personshowmodel.h"
@interface pershowData : NSObject

@property(nonatomic,strong)personshowmodel *model;
+(instancetype)shareshowperData;

/**
 *  添加数据
 *
 */

- (void)addshowData:(personshowmodel *)Model;

/**
 *  删除数据
 *
 */

-(void)updateData:(personshowmodel *)Model;
/**
 *  更新数据
 *
 */
-(void)deletedData;

/**
 *  获取数据
 *
 */

- (NSMutableArray *)getAllDatas;

@end
