//
//  messagefmdb.h
//  铺皇
//
//  Created by selice on 2017/11/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "messagemodel.h"

@interface messagefmdb : NSObject
@property(nonatomic,strong)messagemodel *model;

+(instancetype)sharemessageData;

-(void)adddata:(messagemodel *)model;

-(void)deledata:(messagemodel *)model;

-(NSMutableArray *)getdatas;

@end
