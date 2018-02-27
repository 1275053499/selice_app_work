//
//  DetailedViewCell.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/5.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defination.h"
#import "SattornmapController.h"

@interface DetailedViewCell : UITableViewCell

@property (nonatomic,strong)UINavigationController *nav;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Describe_height;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zujinwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianjiwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhuanranwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zujinLwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianjiLwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhuanranLwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shihewidth;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top1img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top2img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top3img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top4img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top5img;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top1lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top2lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top3lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top4lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top5lab;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot1img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot2img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot3img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot4img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot5img;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot1lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot2lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot3lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot4lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bot5lab;





@property (weak, nonatomic) IBOutlet UILabel *Shopname;//商铺名称
@property (weak, nonatomic) IBOutlet UILabel *Shoptime;//商铺上线时间

@property (weak, nonatomic) IBOutlet UILabel *Shoprent;//商铺租金
@property (weak, nonatomic) IBOutlet UILabel *Shoparea;//商铺面积
@property (weak, nonatomic) IBOutlet UILabel *Shopprice;//商铺转让费OR租金类型
@property (weak, nonatomic) IBOutlet UILabel *ShoppriceTitle;//区别商铺转让费OR租金类型


@property (weak, nonatomic) IBOutlet UILabel *Shopquyu;//商铺区域
@property (weak, nonatomic) IBOutlet UILabel *Shopfit;//商铺适合经营

@property (weak, nonatomic) IBOutlet UIImageView *Shoping11;//商铺上下火
@property (weak, nonatomic) IBOutlet UIImageView *Shoping12;//商铺可明火
@property (weak, nonatomic) IBOutlet UIImageView *Shoping13;//商铺380v
@property (weak, nonatomic) IBOutlet UIImageView *Shoping14;//商铺煤气管道
@property (weak, nonatomic) IBOutlet UIImageView *Shoping15;//商铺排烟管道

@property (weak, nonatomic) IBOutlet UIImageView *Shoping21;//商铺排污管道
@property (weak, nonatomic) IBOutlet UIImageView *Shoping22;//商铺停车位
@property (weak, nonatomic) IBOutlet UIImageView *Shoping23;//商铺产权
@property (weak, nonatomic) IBOutlet UIImageView *Shoping24;//商铺证件齐全
@property (weak, nonatomic) IBOutlet UIImageView *Shoping25;//商铺中央空调

@property (weak, nonatomic) IBOutlet UILabel *ShopXQrent;//商铺详情租金
@property (weak, nonatomic) IBOutlet UILabel *ShopXQarea;//商铺详情面积
@property (weak, nonatomic) IBOutlet UILabel *ShopXQtype;//商铺详情类型
@property (weak, nonatomic) IBOutlet UILabel *ShopXQquyu;//商铺详情区域
@property (weak, nonatomic) IBOutlet UILabel *ShopXQperson;//商铺详情联系人
@property (weak, nonatomic) IBOutlet UILabel *ShopXQnumber;//商铺详情电话
@property (weak, nonatomic) IBOutlet UILabel *ShopXQstate;//商铺详情经验状态
@property (weak, nonatomic) IBOutlet UILabel *ShopXQprice;//商铺详情转让费OR租金类型
@property (weak, nonatomic) IBOutlet UILabel *ShopXQpricetitle;//区别商铺详情转让费OR租金类型


@property (weak, nonatomic) IBOutlet UITextView *ShopXQdescribe;

@property(nonatomic,strong)NSString *ShopDitu;          //商铺地图
@property(nonatomic,strong)NSString *ShopDitudata;      //商铺地图经纬度

@property (weak, nonatomic) IBOutlet UIButton *record_service;



@end
