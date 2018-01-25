//
//  informaZPCell.h
//  铺皇
//
//  Created by selice on 2017/9/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface informaZPCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *InformaZPjob;     //招聘职位
@property (weak, nonatomic) IBOutlet UILabel *InformaZPtime;    //招聘时间
@property (weak, nonatomic) IBOutlet UILabel *InformaZPtitle;   //招聘店铺
@property (weak, nonatomic) IBOutlet UILabel *InformaZParea;    //招聘区域
@property (weak, nonatomic) IBOutlet UILabel *InformaZPsuffer;  //招聘经验
@property (weak, nonatomic) IBOutlet UILabel *InformaZPeduca;   //招聘学历
@property (weak, nonatomic) IBOutlet UILabel *InformaZPsalary;  //招聘工资
@property (weak, nonatomic) IBOutlet UILabel *InformaZPshenhe;  //招聘状态


@end
