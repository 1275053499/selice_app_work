//
//  BagczViewController.h
//  铺皇
//
//  Created by selice on 2017/10/28.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BagzrCollectionCell.h"
//#import "RoundCorner.h"
#import "Bagzrmodel.h"
@interface BagczViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *cellArray;
}
@property (nonatomic,strong)UICollectionView *Bagczcollectionview;

@end
