//
//  ShopsrecruitViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/7.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsrecruitViewCell.h"

@implementation ShopsrecruitViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _CompanyArea.layer.cornerRadius   = 5;
    _CompanyArea.layer.borderColor    = kTCColor(214, 77, 91).CGColor;
    _CompanyArea.layer.borderWidth    = 1.0f;
    
    _CompanySuffer.layer.cornerRadius = 5;
    _CompanySuffer.layer.borderColor  = kTCColor(77, 166, 214).CGColor;
    _CompanySuffer.layer.borderWidth  = 1.0f;
    
    _Companyeducation.layer.cornerRadius  = 5;
    _Companyeducation.layer.borderColor   = kTCColor(255, 191, 0).CGColor;
    _Companyeducation.layer.borderWidth   = 1.0f;
    
     _CompanyArea.adjustsFontSizeToFitWidth = YES;
     _CompanySuffer.adjustsFontSizeToFitWidth = YES;
     _Companyeducation.adjustsFontSizeToFitWidth = YES;
     _Companysalary.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
