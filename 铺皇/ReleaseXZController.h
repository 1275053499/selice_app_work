//
//  ReleaseXZController.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWcategoryController.h"
#import "ZWdescribeController.h"
#import "ZWhighlightController.h"
#import "ZWaddressController.h"
#import "Companyinformontroller.h"
#import "YJLbigimgview.h"
#import "InformaZPController.h"

#import "RecruitserviceController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@interface ReleaseXZController : UIViewController <passValue>
@property (nonatomic, strong)    UITableView *tableView;
@property (nonatomic,strong)NSString     *BJtag;//编辑信息标记

@property (nonatomic,strong)NSString     *ZWcategorystr;    //职位名称
@property (nonatomic,strong)NSString     *ZWGSnamestr;      //公司信息
@property (nonatomic,strong)NSString     *ZWGSprifestrstr;  //公司简介
@property (nonatomic,strong)NSString     *ZWnumstr;         //招聘人数
@property (nonatomic,strong)NSString     *ZWaddstrstr;      //具体地址
@property (nonatomic,strong)NSString     *ZWsalarystr;      //薪资待遇
@property (nonatomic,strong)NSString     *ZWhighlightstr;   //职位亮点
@property (nonatomic,strong)NSString     *ZWdescribestr;    //职位描述
@property (nonatomic,strong)NSString     *ZWaddressstr;     //工作区域地址
@property (nonatomic,strong)NSString     *ZWnaturestr;      //工作性质
@property (nonatomic,strong)NSString     *ZWexperiencestr;  //工作经验
@property (nonatomic,strong)NSString     *ZWeducationstr;   //学历要求

@property (nonatomic,strong)NSString     *row1value;//
@property (nonatomic,strong)NSString     *row2value;//
@end
