//
//  DetailedViewCell.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/5.
//  Copyright © 2017年 中国铺皇. All rights reserved.


#import "DetailedViewCell.h"
#import "SattornmapController.h"

@implementation DetailedViewCell{
    NSString *NSloginstate;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    数据显示适配      租金 + 量  面积 + 量 转让费 + 量
     self.zujinwidth.constant = self.mianjiwidth.constant=self.zhuanranwidth.constant=self.zujinLwidth.constant=self.zhuanranLwidth.constant=self.mianjiLwidth.constant=(KMainScreenWidth-20-2)/3;

//    适合经验适配
    self.shihewidth.constant = KMainScreenWidth - 60;
    
//配套设施
    
    self.Top1img.constant =  (KMainScreenWidth-18*5)/6-16;//图片
        self.Top2img.constant
    =   self.Top3img.constant
    =   self.Top4img.constant
    =   self.Top5img.constant
    =   (KMainScreenWidth-18*5)/6;//图片
    
    self.Bot1img.constant =  (KMainScreenWidth-18*5)/6-16;//图片
    self.Bot2img.constant
    =   self.Bot3img.constant
    =   self.Bot4img.constant
    =   self.Bot5img.constant
    =   (KMainScreenWidth-18*5)/6;//图片
    
    if (KMainScreenWidth>375) {
//        （540 6p 6sp ）
        
        self.Top1lab.constant= (KMainScreenWidth-54*5)/6+16;//文案
        self.Top2lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Top3lab.constant= (KMainScreenWidth-54*5)/6-4;//文案
        self.Top4lab.constant= (KMainScreenWidth-54*5)/6-6;//文案
        self.Top5lab.constant= (KMainScreenWidth-54*5)/6-4;//文案
        
        self.Bot1lab.constant= (KMainScreenWidth-54*5)/6+16;//文案
        self.Bot2lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Bot3lab.constant= (KMainScreenWidth-54*5)/6-4;//文案
        self.Bot4lab.constant= (KMainScreenWidth-54*5)/6-6;//文案
        self.Bot5lab.constant= (KMainScreenWidth-54*5)/6-4;//文案
        
    }else if (KMainScreenWidth<375){
        
        NSLog(@"320 iphone 5 4系列");
        self.Top1lab.constant= (KMainScreenWidth-54*5)/6+16;//文案
        self.Top2lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Top3lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Top4lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Top5lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        
        self.Bot1lab.constant= (KMainScreenWidth-54*5)/6+16;//文案
        self.Bot2lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Bot3lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Bot4lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Bot5lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
    }
    
    else{
//        375
        self.Top1lab.constant= (KMainScreenWidth-54*5)/6+4;//文案
        self.Top2lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Top3lab.constant= (KMainScreenWidth-54*5)/6-6;//文案
        self.Top4lab.constant= (KMainScreenWidth-54*5)/6-4;//文案
        self.Top5lab.constant= (KMainScreenWidth-54*5)/6-6;//文案
        
        self.Bot1lab.constant= (KMainScreenWidth-54*5)/6+4;//文案
        self.Bot2lab.constant= (KMainScreenWidth-54*5)/6-6;//文案
        self.Bot3lab.constant= (KMainScreenWidth-54*5)/6-8;//文案
        self.Bot4lab.constant= (KMainScreenWidth-54*5)/6-4;//文案
        self.Bot5lab.constant= (KMainScreenWidth-54*5)/6-6;//文案
        
    }
    
    
    [self.ShopXQdescribe setEditable:NO];//不能编辑
    self.Shopquyu.lineBreakMode = NSLineBreakByTruncatingHead;
    self.ShopXQstate.adjustsFontSizeToFitWidth  = YES;
    self.Shoprent.adjustsFontSizeToFitWidth     = YES;
    self.ShopXQnumber.adjustsFontSizeToFitWidth = YES;
    self.ShopXQarea.adjustsFontSizeToFitWidth   = YES;
    self.ShopXQrent.adjustsFontSizeToFitWidth   = YES;
    self.ShopXQtype.adjustsFontSizeToFitWidth   = YES;
    self.ShopXQarea.adjustsFontSizeToFitWidth   = YES;
    self.ShopXQperson.adjustsFontSizeToFitWidth = YES;

}

#pragma mark-详情按钮
- (IBAction)LocationCK:(UIButton *)sender {

#pragma mark   从本地缓存拿数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSloginstate      = [defaults objectForKey:@"loginstate"];
    NSLog(@"登录状态%@",NSloginstate);
    
    if ([NSloginstate isEqualToString:@"loginyes"]){

        SattornmapController *ctl =[[SattornmapController alloc]init];
        ctl.coordinate      = _ShopDitu;//中文区域
        ctl.coordinatedata = _ShopDitudata;//经纬度
        
        NSLog(@"111\n%@",_ShopDitu);
        NSLog(@"222\n%@\n\n\n",_ShopDitudata);
        
        [self.nav pushViewController:ctl animated:YES];
    }
    
    else{
        
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.mode            = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        hud.labelText       = @"请登录账号";
        [hud hide:YES afterDelay:2];

    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
