//
//  Introduce_Guide.m
//  铺皇
//
//  Created by selice on 2017/11/20.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "Introduce_Guide.h"
#define MainScreen_width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_height [UIScreen mainScreen].bounds.size.height//高
@interface Introduce_Guide ()<UIScrollViewDelegate>{
    
    UIScrollView    *_bigScrollView;
    NSMutableArray  *_imageArray;
    UIPageControl   *_pageControl;
}

@end
@implementation Introduce_Guide

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray =[@[@"引导页_1@2x",@"引导页_2@2x",@"引导页_3@2x"]mutableCopy];
        
        UIScrollView *scrollView    = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height)];
        scrollView.contentSize      = CGSizeMake((_imageArray.count + 1)*MainScreen_width, MainScreen_height);
        //设置反野效果，不允许反弹，不显示水平滑动条，设置代理为自己
        scrollView.pagingEnabled    = YES;//设置分页
        scrollView.bounces          = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate         = self;
        [self addSubview:scrollView];
        _bigScrollView              = scrollView;
        
        for (int i = 0; i < _imageArray.count; i++) {
            
            UIImageView *imageView  = [[UIImageView alloc]init];
            imageView.frame         = CGRectMake(i * MainScreen_width, 0, MainScreen_width, MainScreen_height);
            UIImage     *image          = [UIImage imageNamed:_imageArray[i]];
            imageView.image         = image;
            [scrollView addSubview:imageView];
        }
        
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreen_width/2, MainScreen_height - 69, 0, 40)];
        pageControl.numberOfPages                   = _imageArray.count;
        pageControl.backgroundColor                 = [UIColor clearColor];
        pageControl.currentPageIndicatorTintColor   = kTCColor(153,244,198);
        pageControl.pageIndicatorTintColor          = [UIColor whiteColor];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        
        //添加手势
        UITapGestureRecognizer *singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapFrom)];
        singleRecognizer.numberOfTapsRequired = 1;
        [scrollView addGestureRecognizer:singleRecognizer];
    }
    
    return self;
}

-(void)handleSingleTapFrom{
    
    if (_pageControl.currentPage == 2) {
        
        self.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == (_imageArray.count) *MainScreen_width) {
        self.hidden = YES;

    }
    
    CGPoint offSet = scrollView.contentOffset;
    //    NSLog(@"%f",offSet.x);
    
    if (0<= offSet.x && offSet.x<MainScreen_width/2) {//190
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor  = kTCColor(153,244,198);
        _pageControl.pageIndicatorTintColor         = [UIColor whiteColor];
        
    }
    if (MainScreen_width/2 <= offSet.x && offSet.x<MainScreen_width/2*3) {//190<X<190*3
        
        _pageControl.currentPage = 1;
        _pageControl.currentPageIndicatorTintColor  = kTCColor(250,183,96);
        _pageControl.pageIndicatorTintColor         = [UIColor whiteColor];
        
    }
    if (offSet.x>=MainScreen_width/2*3) {//190*3<X
        
        _pageControl.currentPage = 2;
        _pageControl.currentPageIndicatorTintColor  = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor         = [UIColor clearColor];
    }
}

@end
