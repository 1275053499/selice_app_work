//
//  MainsearchData.h
//  铺皇
//
//  Created by selice on 2017/11/14.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainsearchData : NSObject

//缓存搜索的数组
+(void)SearchText : (NSString *)text;

//清除缓存数组
+(void)removeAllArray;

@end
