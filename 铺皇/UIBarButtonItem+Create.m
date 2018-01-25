//
//  TCAddresSelectViewController.m
//  铺皇
//  Created by 中国铺皇 on 2017/4/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
// /*快速创建BarButton*/

#import "UIBarButtonItem+Create.h"

@implementation UIBarButtonItem (Create)
#pragma - mark 左边按钮
+ (instancetype)barButtonItemWithImage:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
        button.bounds = CGRectMake(0, 0, 44, 44);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -20,0, 0);
        button.imageEdgeInsets   = UIEdgeInsetsMake(0, -15,0, 0);
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma - mark 右边按钮
+ (instancetype)rightbarButtonItemWithImage:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 44, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 20,0, 0);
    button.imageEdgeInsets   = UIEdgeInsetsMake(0, 0, 0, 0);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma - mark 标题形式
+(instancetype)barButtonItemWithName:(NSString *)titleName highImage:(NSString *)highImageName target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0){
            button.bounds = CGRectMake(0, 0, 44, 44);
            button.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
            button.imageEdgeInsets =UIEdgeInsetsMake(0, -15,0, 0);

    }else{
        button.bounds = CGRectMake(0, 0, 44, 44);
    
    }
    [button setTitle:[NSString stringWithFormat:@"%@", titleName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
    
}



@end
