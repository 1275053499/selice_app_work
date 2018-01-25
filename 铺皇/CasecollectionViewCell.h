//
//  CasecollectionViewCell.h
//  铺皇
//
//  Created by selice on 2017/9/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CasecollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView    *caseimgView;
@property (weak, nonatomic) IBOutlet UILabel        *casetitle;
@property (weak, nonatomic) IBOutlet UILabel        *casearea;
@property (weak, nonatomic) IBOutlet UILabel        *casetime;
@property (weak, nonatomic) IBOutlet UILabel        *casetag;
@property (weak, nonatomic) IBOutlet UILabel        *caseprice;

@end
