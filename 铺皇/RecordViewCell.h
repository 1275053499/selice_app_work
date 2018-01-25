//
//  RecordViewCell.h
//  铺皇精简版
//
//  Created by selice on 2017/12/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecordModel;

static NSString *recordIndentifier = @"recordcell";
@interface RecordViewCell : UITableViewCell

@property(nonatomic,strong) RecordModel *recordModel;

-(CGFloat)rowHeightWithCellModel:(RecordModel *)model;

@end
