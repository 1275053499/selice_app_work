//
//  YJLUserDefaults.m
//  铺皇
//
//  Created by selice on 2017/12/2.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "YJLUserDefaults.h"
#define YJLuser                @"user"         //账号信息
#define YJLpassword            @"password"     //账号密码
#define YJLuserid              @"userid"       //账号ID
#define YJLloginstate          @"loginstate"   //账号登录状态
#define YJLregisterstate       @"registerstate"//账号注册状态
#define YJLEditchange          @"Editchange"    //账号//个人信息跟替
#define YJLPaymentpassword     @"Paymentpassword"//个人支付密码
#define YJLPaymentpasswordopen @"Paymentpasswordopen"//个人支付密码验证
#define YJLTouchIDneed         @"TouchIDneed"       //是否开启指纹验证

static YJLUserDefaults *seleiceuser = nil;
@implementation YJLUserDefaults


+(instancetype)shareObjet{
    if (seleiceuser == nil) {
        seleiceuser = [[YJLUserDefaults alloc]init];
    }
    return seleiceuser;
}

-(NSString *)getObjectformKey:(NSString *)key{
    
    NSString *object = [NSString new];
    NSUserDefaults *getUser = [NSUserDefaults standardUserDefaults];
    object = [getUser objectForKey:key];
    return object;
}


#pragma -mark 保存数据
-(void)saveObject:(NSString *)Value forKey:(NSString *)key{
    
    NSUserDefaults *saveUser = [NSUserDefaults standardUserDefaults];
    [saveUser setObject:Value forKey:key];
    [saveUser synchronize];//写完别忘记了同步
}
@end
