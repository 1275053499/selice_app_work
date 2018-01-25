//
//  ShopsiteXQViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsiteXQViewCell.h"
#import "Defination.h"
@implementation ShopsiteXQViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    数据显示适配      租金 + 量  面积 + 量 转让费 + 量
    self.rentwidth_XQ.constant = self.areawidth_XQ.constant=self.industywidth_XQ.constant=self.rentlwidth_XQ.constant=self.arealwidth_XQ.constant=self.industylwidth_XQ.constant=(KMainScreenWidth-20-2)/3;
 //配套设施
    self.ingXQ_1width.constant=20;
    self.ingXQ_2width.constant=(KMainScreenWidth-40-100)/4+20+20;
    self.ingXQ_3width.constant=KMainScreenWidth /2-8;
    self.ingXQ_4width.constant=(KMainScreenWidth-40-100)/4+20+15;
    self.ingXQ_5width.constant=20;
    self.ingXQ_6width.constant=20;
    self.ingXQ_7width.constant=(KMainScreenWidth-40-100)/4+20+20;
    self.ingXQ_8width.constant=KMainScreenWidth /2-8;
    self.ingXQ_9width.constant=(KMainScreenWidth-40-100)/4+20+15;
    self.ingXQ_10width.constant=20;
    

    self.labXQ_1width.constant=7.5;
    self.labXQ_2width.constant=(KMainScreenWidth-40-125)/4+20+20-5 ;
    self.labXQ_3width.constant= KMainScreenWidth /2-22.5;
    self.labXQ_4width.constant=(KMainScreenWidth-40-125)/4+20+20-10;
    self.labXQ_5width.constant=7.5;
    
    self.labXQ_6width.constant=7.5;
    self.labXQ_7width.constant=(KMainScreenWidth-40-125)/4+20+20-5 ;
    self.labXQ_8width.constant= KMainScreenWidth /2-22.5;
    self.labXQ_9width.constant=(KMainScreenWidth-40-125)/4+20+20-10;
    self.labXQ_10width.constant=7.5;
    
    [self.shopXQdescribed setEditable:NO];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
