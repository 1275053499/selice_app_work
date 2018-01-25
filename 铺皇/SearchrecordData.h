//
//  SearchrecordData.h
//  铺皇
//
//  Created by selice on 2017/9/20.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchrecordData : NSObject

//缓存搜索的数组
+(void)SearchText :(NSString *)seaTxt;

//清除缓存数组
+(void)removeAllArray;

@end
