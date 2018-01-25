//
//  RecordModel.h
//  铺皇精简版
//
//  Created by selice on 2017/12/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject
@property (nonatomic,copy)NSString * nick;//名称
@property (nonatomic,copy)NSString * record;//记录内容
@property (nonatomic,copy)NSString * times;//记录时间

@property (nonatomic,assign)CGFloat cellHeight;//单元格的高度

@property (nonatomic, strong) NSArray *image;

@end
