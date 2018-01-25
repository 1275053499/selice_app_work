//
//  ShoppingBtn.h
//  TDS
//
//  Created by 黎金 on 16/3/25.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIButtonStyle){
    UIButtonStyleButtom = 0,    //按钮标题在下，图片在上（默认）
    UIButtonStyleRight,         //按钮标题在右，图片在左
    UIButtonStyleLeft,          //按钮标题在左，图片在右
    UIButtonStyleTop,           //按钮标题在上，图片在下
};

@interface ShoppingBtn : UIButton
@property (nonatomic, assign) UIButtonStyle buttonStyle;
@property (nonatomic, assign) CGFloat spaceing;     //标题与图片间的间距,默认5
@property (nonatomic, assign) CGFloat imageSize;    //图片尺寸（默认按钮宽度的1/2）
//使用此方法初始化，并将三个参数传入即可实现想要的按钮布局效果
-(id)initWithFrame:(CGRect)frame buttonStyle:(UIButtonStyle)buttonStyle spaceing:(CGFloat)spaceing imagesize:(CGFloat)imagesize;  
@end
