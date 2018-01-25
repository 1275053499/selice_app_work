//
//  ShopsiteViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/8.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsiteViewCell.h"

@implementation ShopsiteViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _Shopsitetype.layer.cornerRadius = 4.0f;
    _Shopsitetype.layer.borderColor = kTCColor(210, 54, 50).CGColor;
    _Shopsitetype.layer.borderWidth = 0.5f;
    
    _Shopsitearea.layer.cornerRadius = 4.0f;
    _Shopsitearea.layer.borderColor  =kTCColor(255, 191, 0).CGColor;
    _Shopsitearea.layer.borderWidth  = 0.5f;

    _Shopsitequyu.layer.cornerRadius = 4.0f;
    _Shopsitequyu.layer.borderColor = kTCColor(77, 166, 214).CGColor;
    _Shopsitequyu.layer.borderWidth = 0.5f;
    
    _Shopsitearea.adjustsFontSizeToFitWidth = YES;
    _Shopsitequyu.adjustsFontSizeToFitWidth = YES;
    _Shopsitetype.adjustsFontSizeToFitWidth = YES;
    _Shopsiterent.adjustsFontSizeToFitWidth = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
