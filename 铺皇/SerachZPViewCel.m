//
//  SerachZPViewCel.m
//  铺皇
//
//  Created by selice on 2017/11/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SerachZPViewCel.h"

@implementation SerachZPViewCel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.SEAZPquyu.layer.cornerRadius = 4.0f;
    self.SEAZPquyu.layer.borderColor = kTCColor(210, 54, 50).CGColor;
    self.SEAZPquyu.layer.borderWidth = 0.5f;
    
    self.SEAZPage.layer.cornerRadius = 4.0f;
    self.SEAZPage.layer.borderColor = kTCColor(77, 166, 214).CGColor;
    self.SEAZPage.layer.borderWidth = 0.5f;
    
    self.SEAZPedu.layer.cornerRadius = 4.0f;
    self.SEAZPedu.layer.borderColor = kTCColor(255, 190, 0).CGColor;
    self.SEAZPedu.layer.borderWidth = 0.5f;
    
    self.SEAZPedu.adjustsFontSizeToFitWidth  = YES;
    self.SEAZPage.adjustsFontSizeToFitWidth  = YES;
    self.SEAZPquyu.adjustsFontSizeToFitWidth = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
