//
//  YJLScrollView.h
//  铺皇
//
//  Created by selice on 2017/9/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
@class YJLScrollView;
@protocol YJLScrollViewdelegate <NSObject>
//点击第几个图片
-(void)yjlScrollViewDelegate:(YJLScrollView *)faceview didSelectindex:(NSInteger )index;

@end

@interface YJLScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
//定时器
@property (nonatomic,strong)NSTimer * time;

//点
@property (nonatomic ,strong)UIPageControl *pageCtrl;

//图片url string 数据
@property (nonatomic,strong)NSArray *imageArr;

//代理
@property (nonatomic,weak) id<YJLScrollViewdelegate> delegate;

@end
