//
//  AnliallViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "AnliallViewCell.h"

@implementation AnliallViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _Anliarea.layer.cornerRadius        = 4.0f;
    _Anlitage.layer.cornerRadius        = 4.0f;
   
    _Anliarea.layer.borderColor         = [kTCColor(77, 166, 214) CGColor];
    _Anlitage.layer.borderColor         = kTCColor(210, 54, 50).CGColor;
   
    _Anliarea.layer.borderWidth         = 0.5f;
    _Anlitage.layer.borderWidth         = 0.5f;

    _Anliarea.adjustsFontSizeToFitWidth =YES;
    _Anliarea.minimumScaleFactor        =0.5;
    _Anlitage.adjustsFontSizeToFitWidth =YES;
    _Anlitage.minimumScaleFactor        =0.5;
    _Anliprice.adjustsFontSizeToFitWidth=YES;
    _Anliprice.minimumScaleFactor       =0.5;
    
    _Anliregin.adjustsFontSizeToFitWidth    = YES;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
