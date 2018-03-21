//
//  JX_FourCell.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/24.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JX_FourModel;
@interface JX_FourCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *PictureImage;

@property (weak, nonatomic) IBOutlet UILabel *BTlab;

@property (weak, nonatomic) IBOutlet UILabel *QuYulab;

@property (weak, nonatomic) IBOutlet UILabel *Timerlab;

@property (weak, nonatomic) IBOutlet UILabel *Taglab;

@property (weak, nonatomic) IBOutlet UILabel *Arealab;

@property (weak, nonatomic) IBOutlet UILabel *Pricelab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QuyulabWidth;


@property(nonatomic,strong)JX_FourModel* JX_FourModel;
+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;

@end
