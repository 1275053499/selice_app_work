//
//  WLWebProgressLayer.h
//  铺皇
//
//  Created by 铺皇网 on 2017/7/1.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


@interface WYWebProgressLayer : CAShapeLayer

- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;

@end
