//
//  VideoXQTableViewCell.h
//  铺皇
//
//  Created by 铺皇网 on 2017/5/20.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoXQTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImgview;

@property(strong, nonatomic)NSString   *videoPath;

@end
