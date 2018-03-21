//
//  ShopsrecruitViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/7.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsrecruitViewCell.h"
#import "ShopsrecruitModel.h"
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

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopsrecruitViewCell";
    ShopsrecruitViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

-(void)setModel:(ShopsrecruitModel *)model{
    _model = model;
    _CompanyJobname.text = [NSString stringWithFormat:@"职位:%@",model.CompanyJobname];
    _CompanyTimers.text  = [NSString stringWithFormat:@"更新时间:%@",model.CompanyTimers];
    _Companyname.text    = [NSString stringWithFormat:@"店名:%@",model.Companyname];
    _CompanyArea.text    = [NSString stringWithFormat:@"%@",model.CompanyArea];
    _CompanySuffer.text  = [NSString stringWithFormat:@"%@",model.CompanySuffer];
    _Companyeducation.text = [NSString stringWithFormat:@"%@",model.Companyeducation];
    _Companysalary.text  = [NSString stringWithFormat:@"%@/月",model.Companysalary];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
