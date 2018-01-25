//
//  YJLHUD.m
//  铺皇精简版
//
//  Created by selice on 2017/12/7.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "YJLHUD.h"

@implementation YJLHUD


+(void)show{
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//显示图层灰黑色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//全屏半黑色
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];//圈
}


+(void)showWithmessage:(NSString *)message{
    
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//显示图层灰黑色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//全屏半黑色
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];//圈
}


+(void)showInfoWithmessage:(NSString *)message{
    
    [SVProgressHUD showInfoWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//显示图层灰黑色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//全屏半黑色
   
    
}


+(void)showSuccessWithmessage:(NSString *)message{
    
    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//显示图层灰黑色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//全屏半黑色
  
    
}


+(void)showErrorWithmessage:(NSString *)message{
    
    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//显示图层灰黑色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//全屏半黑色
}


+(void)showImage:(UIImage *) image message:(NSString *)message{

    [SVProgressHUD showImage:image status:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//显示图层灰黑色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//全屏半黑色
}

+(void)showMyselfBackgroundColor:(UIColor *)viewcolor ForegroundColor:(UIColor *)ringcolor BackgroundLayerColor:(UIColor *)layercolor{
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//显示图层灰黑色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//全屏半黑色
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];//圈
    if (viewcolor) {
        [SVProgressHUD setBackgroundColor:viewcolor];
    }if (ringcolor) {
        [SVProgressHUD setForegroundColor:ringcolor];
    }if (layercolor) {
        [SVProgressHUD setBackgroundLayerColor:layercolor];
    }
}


+(void)showMyselfBackgroundColor:(UIColor *)viewcolor ForegroundColor:(UIColor *)ringcolor BackgroundLayerColor:(UIColor *)layercolor message:(NSString *)message{
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//显示图层灰黑色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//全屏半黑色
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];//圈
    if (viewcolor) {
        [SVProgressHUD setBackgroundColor:viewcolor];
    }if (ringcolor) {
        [SVProgressHUD setForegroundColor:ringcolor];
    }if (layercolor) {
        [SVProgressHUD setBackgroundLayerColor:layercolor];
    }
}


+(void)dismiss{
    
    [SVProgressHUD dismiss];
}

+(void)dismissWithDelay:(NSTimeInterval)delay{
    
    [SVProgressHUD dismissWithDelay:delay];
    
}


@end
