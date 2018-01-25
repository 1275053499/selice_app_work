//
//  AnliallViewCell.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnliallViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Anliimgview;//图片
@property (weak, nonatomic) IBOutlet UILabel    *Anlititle;//标题
@property (weak, nonatomic) IBOutlet UILabel    *Anliarea;//面积
@property (weak, nonatomic) IBOutlet UILabel    *Anlitage;//标签类型
@property (weak, nonatomic) IBOutlet UILabel    *Anliregin;//区域
@property (weak, nonatomic) IBOutlet UILabel    *Anlitime;//更新时间
@property (weak, nonatomic) IBOutlet UILabel    *Anliprice;//转让费

@end
