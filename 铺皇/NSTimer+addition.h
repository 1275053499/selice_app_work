//
//  NSTimer+addition.h
//  铺皇
//
//  Created by 铺皇网 on 2017/7/1.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (addition)

- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

@end
