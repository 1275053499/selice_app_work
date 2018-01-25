//
//  JXButton.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.

#import "JXButton.h"

@implementation JXButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * 0.7;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageH = contentRect.size.height * 0.6;
    return CGRectMake(0, 0, imageW, imageH);
}

@end
