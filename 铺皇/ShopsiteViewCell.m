//
//  ShopsiteViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/8.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsiteViewCell.h"
#import "Shopsitemodel.h"
@implementation ShopsiteViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _Shopsitetype.layer.cornerRadius = 4.0f;
    _Shopsitetype.layer.borderColor = kTCColor(210, 54, 50).CGColor;
    _Shopsitetype.layer.borderWidth = 0.5f;
    
    _Shopsitearea.layer.cornerRadius = 4.0f;
    _Shopsitearea.layer.borderColor  =kTCColor(255, 191, 0).CGColor;
    _Shopsitearea.layer.borderWidth  = 0.5f;

    _Shopsitequyu.layer.cornerRadius = 4.0f;
    _Shopsitequyu.layer.borderColor = kTCColor(77, 166, 214).CGColor;
    _Shopsitequyu.layer.borderWidth = 0.5f;
    
    _Shopsitearea.adjustsFontSizeToFitWidth = YES;
    _Shopsitequyu.adjustsFontSizeToFitWidth = YES;
    _Shopsitetype.adjustsFontSizeToFitWidth = YES;
    _Shopsiterent.adjustsFontSizeToFitWidth = YES;
    
}

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopsiteViewCell";
    ShopsiteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

-(void)setModel:(Shopsitemodel *)model{
    _model = model;
    _Shopsitetitle.text    = model.Shopsitetitle;
    _Shopsitedescribe.text = model.Shopsitedescribe;
    _Shopsitetype.text     = model.Shopsitetype;
    _Shopsitequyu.text     = model.Shopsitequyu;
    _Shopsitearea.text     = [NSString stringWithFormat:@"%@m²",model.Shopsitearea];
    _Shopsiterent.text     = [NSString stringWithFormat:@"%@元/月",model.Shopsiterent];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
