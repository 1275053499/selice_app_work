//
//  InformaXZCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "InformaXZCell.h"

@implementation InformaXZCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _InformaXZtype.layer.cornerRadius = 5;
    _InformaXZtype.layer.borderColor  = kTCColor(214, 77, 91).CGColor;
    _InformaXZtype.layer.borderWidth  = 1.0f;

    _InformaXZarea.layer.cornerRadius = 5;
    _InformaXZarea.layer.borderColor  = kTCColor(77, 166, 214).CGColor;
    _InformaXZarea.layer.borderWidth  = 1.0f;
    
    _InformaXZrent.layer.cornerRadius  = 5;
    _InformaXZrent.layer.borderColor   = kTCColor(255, 191, 0).CGColor;
    _InformaXZrent.layer.borderWidth   = 1.0f;
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
