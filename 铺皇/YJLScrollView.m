//
//  YJLScrollView.m
//  铺皇
//
//  Created by selice on 2017/9/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "YJLScrollView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation YJLScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self  =[super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setImageArr:(NSArray *)imageArr{
    
    _imageArr = imageArr;
    //滑动式图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*(self.imageArr.count+2), self.height);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentOffset = CGPointMake(kScreenWidth,0);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    
    //分页点
    self.pageCtrl  =[[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.pageCtrl.center = CGPointMake(kScreenWidth/2, self.bottom-20);
    self.pageCtrl.numberOfPages = self.imageArr.count;
    self.pageCtrl.currentPage = 0;
    self.pageCtrl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageCtrl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.pageCtrl addTarget:self action:@selector(pageCtrlAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageCtrl];
    
    //图片
    for (int i = 0; i<self.imageArr.count  + 2; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.masksToBounds = YES;
        if (i == 0) {
            
            imageView.image = [UIImage imageNamed:self.imageArr.lastObject];
            
        }else if (i == _imageArr.count+1){
            
            imageView.image = [UIImage imageNamed:self.imageArr.firstObject];
        }
        else{
            
            imageView.image = [UIImage imageNamed:[self.imageArr objectAtIndex:i-1]];
        }
        
        [self.scrollView addSubview:imageView];
    }
    
    //点击👍
    UITapGestureRecognizer  *GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GESAction:)];
    GES.numberOfTapsRequired = 1;
    GES.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:GES];
    
    //定时器
    self.time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}

-(void)GESAction:(UITapGestureRecognizer *)GES{
    
    if ([self.delegate respondsToSelector:@selector(yjlScrollViewDelegate:didSelectindex:)]) {
        [self.delegate yjlScrollViewDelegate:self didSelectindex:self.pageCtrl.currentPage];
    }
}
//page方法
-(void)pageCtrlAction:(UIPageControl *)page{
    
    //如有需要自己填写
}
//定时器方法
-(void)scrollTimer{
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + kScreenWidth, 0) animated:YES];
}

//2.滑动视图时,滑动时调用(实时调用)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.scrollView.contentOffset.x == 0) {
        self.scrollView.contentOffset = CGPointMake(self.imageArr.count * kScreenWidth , 0);
    }
    if (self.scrollView.contentOffset.x == self.scrollView.contentSize.width - kScreenWidth) {
        self.scrollView.contentOffset = CGPointMake(kScreenWidth , 0);
    }
    self.pageCtrl.currentPage = (self.scrollView.contentOffset.x-kScreenWidth)/kScreenWidth;
}

//已经结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"已经结束减速");
    if (self.time == nil) {
        self.time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    }
}

//改变偏移量的时候调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}
//手指将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"手指将要开始拖拽");
    
    [self.time invalidate];
    self.time = nil;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}
-(void)dealloc{
    [self.time invalidate];
}

@end
