//
//  RecommendCell.h
//  铺皇
//
//  Created by selice on 2017/9/11.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *reommendImgview;
@property (weak, nonatomic) IBOutlet UILabel     *recomendTime;
@property (weak, nonatomic) IBOutlet UILabel     *recomendTitle;
@property (weak, nonatomic) IBOutlet UILabel     *recomendTag;
@property (weak, nonatomic) IBOutlet UILabel     *recomendPrice;

@end
