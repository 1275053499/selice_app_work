//
//  YJLHUD.h
//  铺皇精简版
//
//  Created by selice on 2017/12/7.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
@interface YJLHUD : UIView
//圈
+(void)show;

//圈+字
+(void)showWithmessage:(NSString *)message;

//警告信息+警告信息图片
+(void)showInfoWithmessage:(NSString *)message;

//成功信息+成功信息图片
+(void)showSuccessWithmessage:(NSString *)message;

//错误信息+错误信息图片
+(void)showErrorWithmessage:(NSString *)message;


/*自定义图片+文字信息
 
 自定义图片:image
 文字信息:message

 //警告信息+警告信息图片
 +(void)showInfoWithmessage:(NSString *)message;  升级版
 
 //成功信息+成功信息图片
 +(void)showSuccessWithmessage:(NSString *)message;  升级版
 
 //错误信息+错误信息图片
 +(void)showErrorWithmessage:(NSString *)message;  升级版
 
 */
+(void)showImage:(UIImage *) image message:(NSString *)message;

/*自定义
 遮罩的颜色:layercolor
 view的背景颜色:viewcolor
 view上面的旋转圈颜色:ringcolor
 
 +(void)show; 升级版
 
 */
+(void)showMyselfBackgroundColor:(UIColor *)viewcolor ForegroundColor:(UIColor *)ringcolor BackgroundLayerColor:(UIColor *)layercolor;

/*自定义
 遮罩的颜色:layercolor
 view的背景颜色:viewcolor
 view上面的旋转圈颜色:ringcolor
 提示文字：message
 
 +(void)showWithmessage:(NSString *)message; 升级版
 
 */
+(void)showMyselfBackgroundColor:(UIColor *)viewcolor ForegroundColor:(UIColor *)ringcolor BackgroundLayerColor:(UIColor *)layercolor message:(NSString *)message;


//立即消失
+(void)dismiss;

//几秒之后消失
+(void)dismissWithDelay:(NSTimeInterval )delay;

@end
