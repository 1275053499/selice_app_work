//
//  Companyinformontroller.h
//  铺皇
//
//  Created by 铺皇网 on 2017/6/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  类型自定义
 */
typedef void (^ReturnValueBlock) (NSString *nameValue);

/**
 *  类型自定义
 */
typedef void (^ReturnValueBlockadd) (NSString *profileValue);

@interface Companyinformontroller : UIViewController
/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */

@property(nonatomic, copy) ReturnValueBlock returnValueBlockname;

/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */

@property(nonatomic, copy) ReturnValueBlockadd returnValueBlockpfofile;

//正向传值
@property(nonatomic, strong)NSString *nameValue;

//正向传值
@property(nonatomic, strong)NSString *profileValue;
@end
