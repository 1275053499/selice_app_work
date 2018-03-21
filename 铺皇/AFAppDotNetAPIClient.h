//
//  AFAppDotNetAPIClient.h
//  铺皇
//
//  Created by selice on 2018/3/21.
//  Copyright © 2018年 中国铺皇. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager
+(AFHTTPSessionManager *)sharedClient;
@end
