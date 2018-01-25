//
//  VoideCollectionViewCell.h
//  铺皇
//
//  Created by 铺皇网 on 2017/8/11.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoideCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Voideimage;
@property (weak, nonatomic) IBOutlet UILabel *Voidetitle;
@property (weak, nonatomic) IBOutlet UILabel *Voidetimes;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageswidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titlewidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timewidth;

@end
