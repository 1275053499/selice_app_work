//
//  FirstViewController.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ScrollImage.h"
#import "Header.pch"


#import "DCTitleRolling.h"//头条

//店铺详情
#import "DetailedController.h"

#import "VideoXQViewController.h"
//广告
#import "ADView.h"
#import "ADViewController.h"

//城市选择
#import "TLCityPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TLCity.h"

//搜索界面
#import "SerachViewController.h"
//案例model
#import "AnliallController.h"

//推荐店铺cell信息类
#import "RecommendCell.h"
#import "recomendcellmodel.h"
#import "RecommendData.h"

//案例collectioncell
#import "CasecollectionViewCell.h"
#import "casecellmodel.h"
#import "FirstcaseData.h"

//推荐店铺
#import "RecommedController.h"

//大数据
#import "Bigdatamodel.h"
#import "Bigshopdata.h"

//精选租金
#import "FeaturedController.h"
//精选低价
#import "FeaturepriceController.h"
//精选面积
#import "FeatureareaController.h"
//精选区域
#import "FeaturedistrictController.h"
#import "DetailedController.h"  //转让出租详情
#import "ShopsiteXQController.h"//选址详情
#import "ResumeXQController.h"  //招聘详情

#import "Cityareamodel.h"//各个城市的区域存储
#import "Cityarea.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>//视频类
#import "VoideCollectionViewCell.h"

@interface FirstViewController : UIViewController{
    UIButton      *GUIDbtn;
    UIImageView   *GUIDimgview;
    UIView        *GUIDbackview;
}

/*
 *  城市数据，可在Getter方法中重新指定
 */

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *cityData;

@end








