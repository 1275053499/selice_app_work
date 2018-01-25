//
//  RecordModel.m
//  铺皇精简版
//
//  Created by selice on 2017/12/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RecordModel.h"
#import "RecordViewCell.h"
@implementation RecordModel

//惰性初始化是这样写的
-(CGFloat)cellHeight{
    
    if (!_cellHeight) {
        
        RecordViewCell *cell = [[RecordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordIndentifier];
        NSLog(@"计算高度");
        _cellHeight = [cell rowHeightWithCellModel:self];
    }
    NSLog(@"model:%.1lf",_cellHeight);
    return _cellHeight;
}

@end
