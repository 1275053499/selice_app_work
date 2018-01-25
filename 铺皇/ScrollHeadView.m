//
//  ScrollHeadView.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.

#import "ScrollHeadView.h"
#import "UIScrollView+_DScrollView.h"
#import "UIImageView+WebCache.h"
@interface ScrollHeadView()<UIScrollViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)NSMutableArray *arraySource;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIPageControl *pageControl;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,assign)NSInteger lastPage;

@end

@implementation ScrollHeadView


-(instancetype)initWithFrame:(CGRect)frame arraySource:(NSMutableArray *)arraySource{
    
    if (self=[super initWithFrame:frame]) {
        
        _arraySource=arraySource;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createScrollView];
            
        });
    }
    return self;
}

- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    [self addSubview:_scrollView];
    
    if (_arraySource.count == 0 || _arraySource == nil) {
        return;
    }
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*(_arraySource.count), CGRectGetHeight(self.bounds));
    
    for (int i = 0 ; i<_arraySource.count; i++) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)*i, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
//        图片标签  
        imageV.tag = 100*i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [imageV addGestureRecognizer:tap];
        imageV.userInteractionEnabled = YES;
        
//         图片是从网络上加载的
//         注意此时数组中存的应该是图片正确的下载网址否则不可用,并且需要导入第三方库(SDWebImage),及其头文件(#import "UIImageView+WebCache.h")否则无法使用网络资源
         [imageV sd_setImageWithURL:[NSURL URLWithString:_arraySource[i]]];
        
        //本地图片加载的方法
        imageV.image = [UIImage imageNamed:_arraySource[i]];
        
        [_scrollView addSubview:imageV];
        
    }
    
    [_scrollView make3Dscrollview];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.center.x-100, CGRectGetHeight(self.bounds) - 30, 200, 30)];
    _pageControl.numberOfPages = _arraySource.count-2;
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pageControl];
    _lastPage = _arraySource.count - 1;
    
    [self timerOn];
}
#pragma mark 该方法是添加的tap事件当点击不同的图片会执行不同的命令
- (void)tap:(UITapGestureRecognizer*)tap{
    NSLog(@"%ld",tap.view.tag);
//    if (tap.view.tag==100) {
    
//        NSLog(@"点击1张图片");
//        WeboneViewController *webCtl =[[WeboneViewController alloc]init];
//         [self.nav pushViewController:webCtl animated:YES];
       
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.nav.view animated:YES];
//
//        // Set the label text.
//        hud.label.text = NSLocalizedString(@"暂不支持该功能", @"HUD loading title");
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
////            菊花转动时间
//            [self doSomeWork];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES];
//            });
//        });
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.nav.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"暂不支持该功能";
//        // 隐藏时候从父控件中移除
//        hud.removeFromSuperViewOnHide = YES;
//        // 1秒之后再消失
//        [hud hide:YES afterDelay:1.5];
//
//    }if (tap.view.tag==200) {
//
//        NSLog(@"点击2张图片");
//        WeboneViewController *webCtl =[[WeboneViewController alloc]init];
//        [self.nav pushViewController:webCtl animated:YES];
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.nav.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"暂不支持该功能";
//        // 隐藏时候从父控件中移除
//        hud.removeFromSuperViewOnHide = YES;
//        // 1秒之后再消失
//        [hud hide:YES afterDelay:1.5];
//
        
//    }
//
//    if (tap.view.tag==300){
    
//        NSLog(@"点击3张图片");
//        WeboneViewController *webCtl =[[WeboneViewController alloc]init];
//       [self.nav pushViewController:webCtl animated:YES];
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.nav.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"暂不支持该功能";
//        // 隐藏时候从父控件中移除
//        hud.removeFromSuperViewOnHide = YES;
//        // 1秒之后再消失
//        [hud hide:YES afterDelay:1.5];    }
   
}

#pragma mark     菊花转动时间
//- (void)doSomeWork {
//    // Simulate by just waiting.
//    sleep(1.5);
//}

#pragma mark -定时器方法
- (void)onTimer
{
    int index = _scrollView.contentOffset.x/CGRectGetWidth(self.bounds);
    index++;
    
    if (index == _lastPage) {
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*_lastPage, 0) animated:YES];
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        _pageControl.currentPage = 0;

    }else{
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*index, 0) animated:YES];
        _pageControl.currentPage = _scrollView.contentOffset.x/CGRectGetWidth(self.bounds);
        
    }
}

#pragma mark -UIPageControl绑定方法
- (void)pageControlClick:(UIPageControl *)sender{
    [_scrollView setContentOffset:CGPointMake((sender.currentPage+1)*CGRectGetWidth(self.bounds), 0) animated:YES];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self timerOff];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x/CGRectGetWidth(self.bounds) == _lastPage) {
        //当显示第7个位置的图片时(第1张图片) _pageControl对应应该显示第0页 滑动视图对应应该移动偏移量到第2个位置的图片(第1张图片)
        _pageControl.currentPage = 0;
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
    }else if(scrollView.contentOffset.x/CGRectGetWidth(self.bounds) == 0){
        _pageControl.currentPage = _lastPage-2;
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*(_lastPage-1), 0)];
    }else{
        _pageControl.currentPage = scrollView.contentOffset.x/CGRectGetWidth(self.bounds)-1;
    }
    [self timerOn];
}

#pragma mark开启定时器
-(void)timerOn{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}


#pragma mark关闭定时器
-(void)timerOff{
    
    [_timer invalidate];
    _timer = nil;
}

@end
