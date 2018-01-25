//
//  PopviewCell.m
//  铺皇
//
//  Created by selice on 2017/10/28.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "PopviewCell.h"

@implementation PopviewCell

- (instancetype)init{
    self = [super init];
    if (self){
        self.serviceName = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, KMainScreenWidth-20, 60)];
        self.serviceName.numberOfLines = 5;
        self.serviceName.textColor =kTCColor(51, 51, 51);
         self.serviceName.font = [UIFont systemFontOfSize:15.0f];
        
        
        self.serviceTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 200, 20)];
        self.serviceTime.textColor =kTCColor(85, 85, 85);
        self.serviceTime.font = [UIFont systemFontOfSize:14.0f];
        
        //是 self.contentView ，而不是self.view
        [self.contentView addSubview:self.serviceName];
        [self.contentView addSubview:self.serviceTime];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
