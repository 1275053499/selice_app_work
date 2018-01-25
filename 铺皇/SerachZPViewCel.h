//
//  SerachZPViewCel.h
//  铺皇
//
//  Created by selice on 2017/11/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerachZPViewCel : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *SEAZPcheck;//按钮
@property (weak, nonatomic) IBOutlet UILabel *SEAZPtitle;//标题
@property (weak, nonatomic) IBOutlet UILabel *SEAZPsubtitle;//副标题
@property (weak, nonatomic) IBOutlet UILabel *SEAZPquyu;//区域
@property (weak, nonatomic) IBOutlet UILabel *SEAZPage;//经验
@property (weak, nonatomic) IBOutlet UILabel *SEAZPedu;//学历
@property (weak, nonatomic) IBOutlet UILabel *SEAZPzalay;//工资
@property (weak, nonatomic) IBOutlet UILabel *SEAZPerror;//错误提示

@end
