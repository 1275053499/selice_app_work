//
//  FeaturerentCell.m
//  铺皇
//
//  Created by selice on 2017/9/21.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "FeaturerentCell.h"

@implementation FeaturerentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _Featuretype.layer.borderColor  = [kTCColor(214, 77, 91) CGColor];
    _Featuretype.layer.borderWidth  = 0.5f;
    _Featuretype.layer.cornerRadius = 4.0f;
    
    _Featurecommit.layer.borderColor = [kTCColor(77, 166, 214) CGColor];
    _Featurecommit.layer.borderWidth = 0.5f;
    _Featurecommit.layer.cornerRadius= 4.0f;
    
    _Featurequyu.adjustsFontSizeToFitWidth = YES;
    _Featuretype.adjustsFontSizeToFitWidth = YES;
    _Featurecommit.adjustsFontSizeToFitWidth = YES;
    _Featurehassee.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
