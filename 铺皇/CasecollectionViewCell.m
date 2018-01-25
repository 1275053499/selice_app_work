

//
//  CasecollectionViewCell.m
//  铺皇
//
//  Created by selice on 2017/9/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "CasecollectionViewCell.h"

@implementation CasecollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _casetag.layer.cornerRadius = 5;
    _casetag.layer.borderColor  = kTCColor(214, 77, 91).CGColor;
    _casetag.layer.borderWidth  = 1.0f;
    
        _casetitle.adjustsFontSizeToFitWidth = YES;
        _casearea.adjustsFontSizeToFitWidth = YES;
        _casetime.adjustsFontSizeToFitWidth = YES;
        _casetag.adjustsFontSizeToFitWidth = YES;
        _caseprice.adjustsFontSizeToFitWidth = YES;
    
    
}

@end
