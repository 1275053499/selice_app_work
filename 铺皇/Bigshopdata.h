//
//  Bigshopdata.h
//  铺皇
//
//  Created by selice on 2017/9/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bigdatamodel.h"
@interface Bigshopdata : NSObject
@property (nonatomic,strong)Bigdatamodel *model;

+(instancetype)sharebigData;


/**
 *  添加数据
 *
 */

- (void)addbignewData:(Bigdatamodel *)Model;

/**
 *  删除类数据
 *
 */

-(void)deletedbignewData;

/**
 *  获取数据
 *
 */

- (NSMutableArray *)getbignewData;




@end
