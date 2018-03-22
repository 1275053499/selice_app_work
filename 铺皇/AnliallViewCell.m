//
//  AnliallViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "AnliallViewCell.h"
#import "Anlimodel.h"
@implementation AnliallViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _Anliarea.layer.cornerRadius        = 4.0f;
    _Anlitage.layer.cornerRadius        = 4.0f;
   
    _Anliarea.layer.borderColor         = [kTCColor(77, 166, 214) CGColor];
    _Anlitage.layer.borderColor         = kTCColor(210, 54, 50).CGColor;
   
    _Anliarea.layer.borderWidth         = 0.5f;
    _Anlitage.layer.borderWidth         = 0.5f;

    _Anliarea.adjustsFontSizeToFitWidth =YES;
    _Anliarea.minimumScaleFactor        =0.5;
    _Anlitage.adjustsFontSizeToFitWidth =YES;
    _Anlitage.minimumScaleFactor        =0.5;
    _Anliprice.adjustsFontSizeToFitWidth=YES;
    _Anliprice.minimumScaleFactor       =0.5;
    
    _Anliregin.adjustsFontSizeToFitWidth    = YES;
   
}

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"AnliallViewCell";
    AnliallViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

-(void)setAnlimodel:(Anlimodel *)anlimodel{
    
    _anlimodel  = anlimodel;
    _Anlititle.text          = anlimodel.Anli_title; //标题
    _Anliregin.text          = anlimodel.Anli_quyu; //区域所在
    _Anlitime.text           = anlimodel.Anli_time; //更新时间
    _Anlitage.text           = anlimodel.Anli_tag;  //餐饮美食
    _Anliarea.text           = [NSString stringWithFormat:@"%@m²",  anlimodel.Anli_area];//店铺面积
    _Anliprice.text          = [NSString stringWithFormat:@"%@元/月",anlimodel.Anli_price];//店铺租金
    // 从内存\沙盒缓存中获得原图，
    UIImage *originalImage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:anlimodel.Anli_picture];
    
    if (originalImage) {// 内存\沙盒缓存有原图
        self.Anliimgview.image = originalImage;
        NSLog(@"走这里？？？？？？？");
    }
    
    else{// 内存\沙盒缓存没有原图
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
        
        if (mgr.isReachableViaWiFi) {                   //Wi-Fi网络
            [self.Anliimgview sd_setImageWithURL:[NSURL URLWithString:anlimodel.Anli_picture] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
        
        }else if (mgr.isReachableViaWWAN){              //3G/4G网络
            #warning 从沙盒中读取用户的配置项：在3G\4G环境是否仍然下载原图
            BOOL alwaysDownloadOriginalImage = [[NSUserDefaults standardUserDefaults] boolForKey:@"alwaysDownloadOriginalImage"];
            if (alwaysDownloadOriginalImage) {          // 下载原图
                [self.Anliimgview sd_setImageWithURL:[NSURL URLWithString:anlimodel.Anli_picture] placeholderImage:[UIImage imageNamed:@"nopicture"]];
            } else {                                    // 下载小图
                [self.Anliimgview sd_setImageWithURL:[NSURL URLWithString:anlimodel.anlismall_picture] placeholderImage:[UIImage imageNamed:@"nopicture"]];
            }
        
        }else{//无网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:anlimodel.anlismall_picture];
            if (thumbnailImage) {
                self.Anliimgview.image = thumbnailImage;
            }else{
                self.Anliimgview.image =[UIImage imageNamed:@"nopicture"];
            }
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
