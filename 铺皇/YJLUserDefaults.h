//
//  YJLUserDefaults.h
//  铺皇
//
//  Created by selice on 2017/12/2.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJLUserDefaults : NSObject

+(instancetype)shareObjet;
-(void)saveObject:(NSString *)Value forKey:(NSString *)key;
-(NSString *)getObjectformKey:(NSString *)key;
@end
