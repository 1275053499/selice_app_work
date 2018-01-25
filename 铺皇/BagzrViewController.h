//
//  BagzrViewController.h
//  铺皇
//
//  Created by selice on 2017/10/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BagzrCollectionCell.h"
//#import "RoundCorner.h"
#import "Bagzrmodel.h"
@interface BagzrViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *cellArray;
}
@property (nonatomic,strong)UICollectionView *Bagzrcollectionview;
@end
