//
//  SerachViewCell.m
//  铺皇
//
//  Created by selice on 2017/11/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SerachViewCell.h"

@implementation SerachViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.SEAtype.layer.cornerRadius = 4.0f;
    self.SEAtype.layer.borderColor = kTCColor(210, 54, 50).CGColor;
    self.SEAtype.layer.borderWidth = 0.5f;
    
    self.SEAarea.layer.cornerRadius = 4.0f;
    self.SEAarea.layer.borderColor = kTCColor(77, 166, 214).CGColor;
    self.SEAarea.layer.borderWidth = 0.5f;
    
    self.SEAtype.adjustsFontSizeToFitWidth= YES;
    self.SEAarea.adjustsFontSizeToFitWidth= YES;
    self.SEAmoney.adjustsFontSizeToFitWidth= YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
