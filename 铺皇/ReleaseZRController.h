//
//  ReleaseZRController.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"


#import "ZRaddessController.h"
#import "ZRindustryController.h"
#import "ZRturnController.h"
#import "ZRManagementController.h"
#import "ZRcontractController.h"
#import "ZRdescribeController.h"
#import "ZRfacilityController.h"

#import "MyReleaseController.h"

#import "pershowData.h"     //个人账号密码信息数据库

#import "YJLbigimgview.h" // 简单的图片放大

#import "PopviewCell.h"
#import "Popmodel.h"
@interface ReleaseZRController : UIViewController{
    NSMutableArray *cellArray;
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * FBtableView;
@property (nonatomic, strong) NSString    * Navtitle;



@end
