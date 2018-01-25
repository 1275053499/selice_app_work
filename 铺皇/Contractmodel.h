//
//  Contractmodel.h
//  铺皇
//
//  Created by selice on 2017/11/2.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contractmodel : NSObject
@property (nonatomic,strong) NSString *Contract;

@property (nonatomic,strong) NSString *SYSYtime;         //首页剩余时间
@property (nonatomic,strong) NSString *SYTC;             //首页套餐
@property (nonatomic,strong) NSString *SYTCstart;        //首页套餐开始时间
@property (nonatomic,strong) NSString *SYTCend;          //首页套餐结束时间


@property (nonatomic,strong) NSString *XXTCtime;    //信息剩余时间
@property (nonatomic,strong) NSString *XXTC;        //信息套餐
@property (nonatomic,strong) NSString *XXTCstart;   //信息套餐开始时间
@property (nonatomic,strong) NSString *XXTCend;     //信息套餐结束时间


@property (nonatomic,strong) NSString *TTID; //套餐id

@end
