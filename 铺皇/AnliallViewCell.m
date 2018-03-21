//
//  AnliallViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "AnliallViewCell.h"
#import "Anlimodel.h"
@implementation AnliallViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _Anliarea.layer.cornerRadius        = 4.0f;
    _Anlitage.layer.cornerRadius        = 4.0f;
   
    _Anliarea.layer.borderColor         = [kTCColor(77, 166, 214) CGColor];
    _Anlitage.layer.borderColor         = kTCColor(210, 54, 50).CGColor;
   
    _Anliarea.layer.borderWidth         = 0.5f;
    _Anlitage.layer.borderWidth         = 0.5f;

    _Anliarea.adjustsFontSizeToFitWidth =YES;
    _Anliarea.minimumScaleFactor        =0.5;
    _Anlitage.adjustsFontSizeToFitWidth =YES;
    _Anlitage.minimumScaleFactor        =0.5;
    _Anliprice.adjustsFontSizeToFitWidth=YES;
    _Anliprice.minimumScaleFactor       =0.5;
    
    _Anliregin.adjustsFontSizeToFitWidth    = YES;
   
}

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"AnliallViewCell";
    AnliallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}
-(void)setAnlimodel:(Anlimodel *)anlimodel{
    
    _anlimodel = anlimodel;
    _Anlititle.text          = anlimodel.Anli_title;//标题
    _Anliregin.text          = anlimodel.Anli_quyu;//区域所在
    _Anlitime.text           = anlimodel.Anli_time;//更新时间
    _Anlitage.text           = anlimodel.Anli_tag;//餐饮美食
    _Anliarea.text            = [NSString stringWithFormat:@"%@m²",anlimodel.Anli_area];//店铺面积
    _Anliprice.text          = [NSString stringWithFormat:@"%@元/月",anlimodel.Anli_price];//店铺租金
    [_Anliimgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",anlimodel.Anli_picture]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
