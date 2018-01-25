//
//  PishumToastViewController.m
//  PishumToast
//
//  Created by Pishum on 16/1/26.
//  Copyright © 2016年 Pishum. All rights reserved.
//

#import "PishumToast.h"

@interface PishumToast ()

@end

@implementation PishumToast

static UIView *toastView = nil;
static UIView *parentView = nil;

+ (UIView*)ToastView{
    return toastView;
}


+ (void)showToastWithMessage:(NSString*)mesage Length:(TOAST_LENGTH)length ParentView:(UIView*)view
{
    
    CGRect rect = view.bounds;
    rect.size.width = rect.size.width;
    rect.size.height = 40;
    rect.origin.x = 0;
    CGPoint centerPoint =  view.center;
    centerPoint.y = 84;
    UILabel *label = [[UILabel alloc]init];
    label.text = mesage;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth =YES;
    label.textColor = kTCColor(77, 166, 214);
    label.backgroundColor = kTCColor(255, 255, 255);
    label.alpha = 0.9;
    label.textAlignment = NSTextAlignmentCenter;
    
    
    [label setFrame:rect];
    [label setCenter:centerPoint];
    
//    label.layer.cornerRadius = 5;
//    label.layer.borderWidth = 4;
    
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=12.0f; //设置为图片宽度的一半出来为圆形
    label.layer.borderWidth=1.0f; //边框宽度
    label.layer.borderColor=[kTCColor(161, 161, 161) CGColor];//
    
    [view addSubview:label];
    
    CGFloat timerLong = 2.5f;
    
    switch (length) {
        case 1:
            timerLong = 1.5f;
            break;
        case 2:
            timerLong = 2.5f;
            break;
        case 3:
            timerLong = 3.5f;
            break;
        default:
            break;
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:timerLong target:self selector:@selector(TimerOver:) userInfo:label repeats:NO];

}

+ (void)TimerOver:(NSTimer*)sender{
    UILabel *view = (UILabel*)[sender userInfo];
    [view removeFromSuperview];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
