//
//  BagzrCollectionCell.m
//  铺皇
//
//  Created by selice on 2017/10/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "BagzrCollectionCell.h"
@implementation BagzrCollectionCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.servicetitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame)-20,40)];
        self.servicetitle.textColor =kTCColor(51, 51, 51);

        self.servicetitle.numberOfLines = 5;
        self.servicetitle.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:self.servicetitle];
        
        self.servicetimes = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.servicetitle.frame)+10, CGRectGetWidth(self.frame)-20, 15)];
        self.servicetimes.textColor =kTCColor(85, 85, 85);
        self.servicetimes.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.servicetimes];
        
    }
    
    return self;
}
@end
