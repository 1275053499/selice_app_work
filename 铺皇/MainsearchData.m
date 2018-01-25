//
//  MainsearchData.m
//  铺皇
//
//  Created by selice on 2017/11/14.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "MainsearchData.h"

@implementation MainsearchData

+(void)SearchText:(NSString *)text{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    
    //读取数组NSArray类型的数据
    NSArray *myArray = [userDefaultes arrayForKey:@"MainArray"];
    if (myArray.count > 0) {//先取出数组，判断是否有值，有值继续添加，无值创建数组
        
    }else{
        myArray = [NSArray array];
    }
    
    // NSArray --> NSMutableArray
    NSMutableArray *searTXT = [myArray mutableCopy];
    [searTXT addObject:text];
    
    if(searTXT.count > 7){
        
        [searTXT removeObjectAtIndex:0];
    }
    
    //将上述数据全部存储到NSUserDefaults中
    [userDefaultes setObject:searTXT forKey:@"MainArray"];
    [userDefaultes synchronize];
    
}


+(void)removeAllArray{
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"MainArray"];
    [userDefaults synchronize];
}

@end
