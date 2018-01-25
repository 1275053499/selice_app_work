//
//  YJLbigimgview.h
//  铺皇
//
//  Created by selice on 2017/10/17.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YJLbigimgview : NSObject
/*
 * 将实现细节封装为一个类方法
 *
 * @param imageView : 需要进行图片放大的imageView
 */
+ (void)showImageBrowserWithImageView :(UIImageView *)imageView;
@end
