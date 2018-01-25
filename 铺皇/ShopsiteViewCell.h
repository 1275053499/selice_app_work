//
//  ShopsiteViewCell.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/8.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopsiteViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Shopsitetitle;//标题
@property (weak, nonatomic) IBOutlet UILabel *Shopsitedescribe;//描述
@property (weak, nonatomic) IBOutlet UILabel *Shopsitetype;//类型
@property (weak, nonatomic) IBOutlet UILabel *Shopsitequyu;//面积
@property (weak, nonatomic) IBOutlet UILabel *Shopsiterent;//租金
@property (weak, nonatomic) IBOutlet UILabel *Shopsitearea;//区域
@property (nonatomic, strong)       NSString *Shopsitesubid;//店铺id



@end
