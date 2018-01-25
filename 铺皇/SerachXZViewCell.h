//
//  SerachXZViewCell.h
//  铺皇
//
//  Created by selice on 2017/11/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerachXZViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *SEAXZcheck;//按钮
@property (weak, nonatomic) IBOutlet UILabel *SEAXZtitle;//标题
@property (weak, nonatomic) IBOutlet UILabel *SEAXZsubtitle;//描述
@property (weak, nonatomic) IBOutlet UILabel *SEAXZtype;//类型
@property (weak, nonatomic) IBOutlet UILabel *SEAXZquyu;//区域
@property (weak, nonatomic) IBOutlet UILabel *SEAXZarea;//面积
@property (weak, nonatomic) IBOutlet UILabel *SEAXZmoney;//价钱
@property (weak, nonatomic) IBOutlet UILabel *SEAXZerror;

@end
