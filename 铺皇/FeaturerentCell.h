//
//  FeaturerentCell.h
//  铺皇
//
//  Created by selice on 2017/9/21.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturerentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Featureimg;       //精选图片
@property (weak, nonatomic) IBOutlet UILabel     *Featuretitle;     //精选标题
@property (weak, nonatomic) IBOutlet UILabel     *Featurequyu;      //精选区域
@property (weak, nonatomic) IBOutlet UILabel     *Featuretime;      //精选时间
@property (weak, nonatomic) IBOutlet UILabel     *Featuretype;      //精选类型
@property (weak, nonatomic) IBOutlet UILabel     *Featurecommit;    //精选公共
@property (weak, nonatomic) IBOutlet UILabel     *Featurehassee;    //精选浏览量

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FeaturequyuWidth;

@end
