//
//  Cityarea.h
//  铺皇
//
//  Created by selice on 2017/11/21.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "Cityareamodel.h"
@interface Cityarea : NSObject

@property (nonatomic,strong)Cityareamodel    * Model;

+(instancetype)shareCityData;

#pragma - mark 菜单内容
-(void)addCityarea:(Cityareamodel *)Model;

-(void)deletedCityarea;

-(NSMutableArray *)getAllCityarea;



@end
