//
//  JX_FourCell.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/24.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "JX_FourCell.h"
#import "JX_FourModel.h"
@implementation JX_FourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _Arealab.layer.borderColor = [kTCColor(77, 166, 214) CGColor];
    _Arealab.layer.borderWidth = 0.5f;
    _Arealab.layer.cornerRadius= 4.0f;
    
    _Taglab.layer.borderColor  = [kTCColor(214, 77, 91) CGColor];
    _Taglab.layer.borderWidth  = 0.5f;
    _Taglab.layer.cornerRadius = 4.0f;
    
    _QuYulab.adjustsFontSizeToFitWidth  = YES;
    _Taglab.adjustsFontSizeToFitWidth   = YES;
    _Arealab.adjustsFontSizeToFitWidth  = YES;
    _Pricelab.adjustsFontSizeToFitWidth = YES;
}


+ (instancetype)cellWithOrderTableView:(UITableView *)tableView{
    static NSString *ID = @"JX_FourCell";
    JX_FourCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}
-(void)setJX_FourModel:(JX_FourModel *)JX_FourModel{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
@end
