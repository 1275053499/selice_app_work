//
//  RecommendCell.m
//  铺皇
//
//  Created by selice on 2017/9/11.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _recomendTag.layer.cornerRadius = 5;
    _recomendTag.layer.borderColor  = kTCColor(214, 77, 91).CGColor;
    _recomendTag.layer.borderWidth  = .7f;
    _recomendTime.adjustsFontSizeToFitWidth =YES;
    _recomendTag.adjustsFontSizeToFitWidth =YES;
    _recomendPrice.adjustsFontSizeToFitWidth =YES;
    
    
}

@end
