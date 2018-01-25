//
//  MapcheckController.h
//  铺皇
//
//  Created by 铺皇网 on 2017/6/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^Coordinate2DBlock)(CLLocationCoordinate2D coordinate);

#define WEAKSELF typeof(self) __weak weakSelf = self;
@interface MapcheckController : UIViewController
@property(nonatomic,strong)NSString *valueaddess;




@end
