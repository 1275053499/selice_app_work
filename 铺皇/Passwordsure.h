//
//  Passwordsure.h
//  铺皇
//
//  Created by 铺皇网 on 2017/8/4.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Passwordsure : UIView

@property(nonatomic,copy)void (^passWordText)(NSString *text);

@property(nonatomic,copy)void (^passWordTextConfirm)(NSString *text);
@property (nonatomic,strong) UITextField *inputTextField;//密码输入框

//***********密码框*****************//

-(instancetype)initSingleBtnView;//单选按钮密码框

-(void)show;
@end
