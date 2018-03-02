//
//  RegisterController.h
//  铺皇
//
//  Created by 铺皇网 on 2017/7/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebsetController.h"
//自定义类型
typedef void (^ returnvalue) (NSString * uservalue,NSString * passwordvalue);

@interface RegisterController : UIViewController

@property (nonatomic,copy) returnvalue value;

//方法
-(void)result:(returnvalue)value;


@end
