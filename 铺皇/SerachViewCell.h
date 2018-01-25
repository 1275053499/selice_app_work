//
//  SerachViewCell.h
//  铺皇
//
//  Created by selice on 2017/11/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerachViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *SEAImgview;
@property (weak, nonatomic) IBOutlet UILabel *SEAtitle;
@property (weak, nonatomic) IBOutlet UILabel *SEAquyu;
@property (weak, nonatomic) IBOutlet UILabel *SEAtime;
@property (weak, nonatomic) IBOutlet UILabel *SEAtype;
@property (weak, nonatomic) IBOutlet UILabel *SEAarea;
@property (weak, nonatomic) IBOutlet UILabel *SEAmoney;
@property (weak, nonatomic) IBOutlet UIButton *CheckAll;
@property (weak, nonatomic) IBOutlet UILabel *SEAerror;
@property (weak, nonatomic) IBOutlet UILabel *SEAsection;

@end
