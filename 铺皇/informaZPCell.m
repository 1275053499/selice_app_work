//
//  informaZPCell.m
//  铺皇
//
//  Created by selice on 2017/9/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "informaZPCell.h"

@implementation informaZPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _InformaZParea.layer.cornerRadius   = 5;
    _InformaZParea.layer.borderColor    = kTCColor(214, 77, 91).CGColor;
    _InformaZParea.layer.borderWidth    = 1.0f;
    
    _InformaZPsuffer.layer.cornerRadius = 5;
    _InformaZPsuffer.layer.borderColor  = kTCColor(77, 166, 214).CGColor;
    _InformaZPsuffer.layer.borderWidth  = 1.0f;

    _InformaZPeduca.layer.cornerRadius  = 5;
    _InformaZPeduca.layer.borderColor   = kTCColor(255, 191, 0).CGColor;
    _InformaZPeduca.layer.borderWidth   = 1.0f;
    
    _InformaZPeduca.adjustsFontSizeToFitWidth = YES;
    _InformaZPsuffer.adjustsFontSizeToFitWidth = YES;
    _InformaZParea.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
