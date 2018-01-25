//
//  SerachXZViewCell.m
//  铺皇
//
//  Created by selice on 2017/11/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SerachXZViewCell.h"

@implementation SerachXZViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.SEAXZtype.layer.cornerRadius = 4.0f;
    self.SEAXZtype.layer.borderColor = kTCColor(210, 54, 50).CGColor;
    self.SEAXZtype.layer.borderWidth = 0.5f;
    
    self.SEAXZquyu.layer.cornerRadius = 4.0f;
    self.SEAXZquyu.layer.borderColor = kTCColor(77, 166, 214).CGColor;
    self.SEAXZquyu.layer.borderWidth = 0.5f;
    
    self.SEAXZarea.layer.cornerRadius = 4.0f;
    self.SEAXZarea.layer.borderColor = kTCColor(255, 190, 0).CGColor;
    self.SEAXZarea.layer.borderWidth = 0.5f;
    
    self.SEAXZarea.adjustsFontSizeToFitWidth= YES;
    self.SEAXZtype.adjustsFontSizeToFitWidth= YES;
    self.SEAXZquyu.adjustsFontSizeToFitWidth= YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
