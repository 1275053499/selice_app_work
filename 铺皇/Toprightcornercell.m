//
//  Toprightcornercell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/8/28.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "Toprightcornercell.h"

@implementation Toprightcornercell

- (void)awakeFromNib {
    [super awakeFromNib];
    _shopquyu.layer.borderColor = [kTCColor(77, 166, 214) CGColor];
    _shopquyu.layer.borderWidth = 0.5f;
    _shopquyu.layer.cornerRadius= 4.0f;
    
    _shoptype.layer.borderColor  =  [kTCColor(214, 77, 77) CGColor];
    _shoptype.layer.borderWidth  = 0.5f;
    _shoptype.layer.cornerRadius = 4.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
