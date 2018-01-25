//
//  ShoppingBtn.m
//  TDS
//
//  Created by 黎金 on 16/3/25.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "ShoppingBtn.h"

@implementation ShoppingBtn

-(id)initWithFrame:(CGRect)frame buttonStyle:(UIButtonStyle)buttonStyle spaceing:(CGFloat)spaceing imagesize:(CGFloat)imagesize{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode      =   UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment   = NSTextAlignmentLeft;
        _buttonStyle    = buttonStyle;
        _spaceing       = spaceing;
        _imageSize      = imagesize;
    }
    return self;
}

#pragma mark 根据父类的rect设定并返回文本label的rect
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat width= 0;    //标题宽度
    CGFloat height= 0;   //标题高度
    CGFloat originX= 0;  //标题起始x坐标
    CGFloat originY= 0;  //标题起始y坐标
    
    //判断按钮属于什么类型
    if (_buttonStyle == UIButtonStyleButtom) {
        originX = 0;
        originY = _spaceing + _imageSize;
        width = self.frame.size.width;
        height = self.frame.size.height - _spaceing - _imageSize;
    }
    
    else if(_buttonStyle == UIButtonStyleLeft){
        originX = 0;
        originY = 0;
        width = self.frame.size.width - _imageSize - _spaceing;
        height = self.frame.size.height;
    }
    
    else if (_buttonStyle == UIButtonStyleRight){
        originX =  _spaceing + _imageSize;
        originY = 0;
        width = self.frame.size.width - _spaceing - _imageSize;
        height = self.frame.size.height;
    }
    
    else{
        originX = 0;
        originY = 0;
        width = self.frame.size.width;
        height = self.frame.size.height - _spaceing - _imageSize;
    }
    contentRect=(CGRect){{originX,originY},{width,height}};
    return contentRect;
}

#pragma  mark根据父类的rect设定并返回Image的rect
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat width= 0;     //图片宽度
    CGFloat height= 0;    //图片高度
    CGFloat originX= 0;   //图片起始x坐标
    CGFloat originY= 0;   //图片起始y坐标

    //判断按钮属于什么类型
    if (_buttonStyle == UIButtonStyleButtom) {
        originX = (self.frame.size.width - _imageSize)/2;
        originY = 0;
        width   = _imageSize;
        height  = _imageSize;
    }else if(_buttonStyle == UIButtonStyleLeft){
        originX = self.frame.size.width - _imageSize;
        originY = (self.frame.size.height - _imageSize)/2;
        width   = _imageSize;
        height  = _imageSize;
    }else if (_buttonStyle == UIButtonStyleRight){
        originX = 0;
        originY = (self.frame.size.height - _imageSize)/2;
        width   = _imageSize;
        height      = _imageSize;
        
    }else{
        originX = (self.frame.size.width- _imageSize)/2;
        originY = self.frame.size.height - _imageSize;
        width = _imageSize;
        height = _imageSize;
    }
    
    contentRect=(CGRect){{originX,originY},{width,height}};
    return contentRect;
}

@end
