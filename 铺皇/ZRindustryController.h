//
//  ZRindustryController.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/25.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  类型自定义
 */
typedef void (^ReturnValueBlock) (NSString *strValue);
@interface ZRindustryController : UIViewController
/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
//正向传值
@property(nonatomic, strong)NSString *labvalue;
@end
