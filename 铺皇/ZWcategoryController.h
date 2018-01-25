//
//  ZWcategoryController.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  类型自定义
 */
typedef void (^ReturnValueBlock) (NSString *strValue);

@protocol passValue <NSObject>
-(void)passedValue:(NSString *)inputValue1 :(NSString *)inputValue2;
@end


@interface ZWcategoryController : UIViewController
/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */



@property(nonatomic, copy) ReturnValueBlock returnValueBlock;


//正向传值
@property(nonatomic, strong)NSString *labvalue;
@property(nonatomic, strong)NSString *row1value;
@property(nonatomic, strong)NSString *row2value;


/**
 * 声明一个delegate属性
 */
@property(nonatomic, weak) id<passValue> delegate;


@end
