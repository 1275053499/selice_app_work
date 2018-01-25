//
//  personshowmodel.h
//  铺皇
//
//  Created by selice on 2017/9/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personshowmodel : NSObject


@property (nonatomic,strong) NSString *personimage;     //头像
@property (nonatomic,strong) NSString *personnickname;  //昵称
@property (nonatomic,strong) NSString *personsex;       //性别
@property (nonatomic,strong) NSString *personphone;     //账号
@property (nonatomic,strong) NSString *personcity;      //城市
@property (nonatomic,strong) NSString *personsignature; //签名
@property (nonatomic,strong) NSString *personintegral;  //积分
@property (nonatomic,strong) NSString *personid;        //唯一的id

@end
