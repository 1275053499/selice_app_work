//
//  ShopsrecruitViewCell.h
//  铺皇
//
//  Created by 铺皇网 on 2017/6/7.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopsrecruitModel;
@interface ShopsrecruitViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CompanyJobname;       //招聘职位
@property (weak, nonatomic) IBOutlet UILabel *CompanyTimers;        //招聘时间
@property (weak, nonatomic) IBOutlet UILabel *Companyname;          //公司名称
@property (weak, nonatomic) IBOutlet UILabel *CompanyArea;          //公司所在区域
@property (weak, nonatomic) IBOutlet UILabel *CompanySuffer;        //招聘经验
@property (weak, nonatomic) IBOutlet UILabel *Companyeducation;     //招聘学历
@property (weak, nonatomic) IBOutlet UILabel *Companysalary;        //招聘工资
@property (nonatomic, strong)       ShopsrecruitModel *model;
+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;
@end
