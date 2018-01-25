//
//  UIScrollView+_DScrollView.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIScrollView (_DScrollView)
@property(nonatomic,assign)BOOL dScrollView;   // 当前属性设置位置必须位于添加子视图之后
@property(nonatomic,assign)NSUInteger pageNum;
@property(nonatomic,assign)CGFloat rightScale;
@property(nonatomic,assign)CGFloat leftScale;

- (void)make3Dscrollview; // 调用此方法实现3D效果


@end
