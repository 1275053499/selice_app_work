//
//  AFAppDotNetAPIClient.m
//  铺皇
//
//  Created by selice on 2018/3/21.
//  Copyright © 2018年 中国铺皇. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"
#import "AFHTTPSessionManager.h"
@implementation AFAppDotNetAPIClient
+ (AFHTTPSessionManager *)sharedClient {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        
    });
    
    return manager;
}
@end
