//
//  ShopsserviceViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsserviceViewController.h"
#import "Defination.h"
#import "PermitController.h"
#import "RenovationController.h"
#import "HfiveController.h"
#import "CRMController.h"
#import "DailyController.h"
#import "ToolsController.h"
#import "ResourcesController.h"
#import "ShopsController.h"
#import "MarketingController.h"
#import "CooperationController.h"
#import "TrainingController.h"

#import "FSCustomButton.h" //Top按钮

@interface ShopsserviceViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *Mainscrollview;
@end

@implementation ShopsserviceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];

     self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickservice)];
    
    self.title = @"开店服务";
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    if (iOS11) {
        _Mainscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight-64)];
    }else{
        
        _Mainscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    }
    
    _Mainscrollview.userInteractionEnabled = YES;
    _Mainscrollview.showsVerticalScrollIndicator = YES;
    _Mainscrollview.showsHorizontalScrollIndicator = YES;
    _Mainscrollview.delegate = self;
    _Mainscrollview.contentSize = CGSizeMake(KMainScreenWidth, 800);
    [self.view addSubview:_Mainscrollview];

    [self buildUI];
}

-(void)buildUI{
    
    FSCustomButton *button1 = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth/3, KMainScreenWidth/3)];
    button1.adjustsTitleTintColorAutomatically = YES;
    [button1 setTintColor:kTCColor(27, 31, 35)];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button1 setTitle:@"办证" forState:UIControlStateNormal];
//    button1.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button1 setImage:[UIImage imageNamed:@"banzheng"] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 4;
    button1.buttonImagePosition = FSCustomButtonImagePositionTop;
    button1.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 1;
    [_Mainscrollview addSubview:button1];
    
    FSCustomButton *button2 = [[FSCustomButton alloc] initWithFrame:CGRectMake(KMainScreenWidth/3, 0, KMainScreenWidth/3, KMainScreenWidth/3)];
    button2.adjustsTitleTintColorAutomatically = YES;
    [button2 setTintColor:kTCColor(27, 31, 35)];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button2 setTitle:@"装修" forState:UIControlStateNormal];
//    button2.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button2 setImage:[UIImage imageNamed:@"zhxiu"] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 4;
    button2.buttonImagePosition = FSCustomButtonImagePositionTop;
    button2.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 2;
    [_Mainscrollview addSubview:button2];
    
    FSCustomButton *button3 = [[FSCustomButton alloc] initWithFrame:CGRectMake(KMainScreenWidth/3*2, 0, KMainScreenWidth/3, KMainScreenWidth/3)];
    button3.adjustsTitleTintColorAutomatically = YES;
    [button3 setTintColor:kTCColor(27, 31, 35)];
    button3.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button3 setTitle:@"H5" forState:UIControlStateNormal];
//    button3.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button3 setImage:[UIImage imageNamed:@"h5"] forState:UIControlStateNormal];
    button3.layer.cornerRadius = 4;
    button3.buttonImagePosition = FSCustomButtonImagePositionTop;
    button3.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag = 3;
    [_Mainscrollview addSubview:button3];
   
    FSCustomButton *button4 = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, KMainScreenWidth/3, KMainScreenWidth/3, KMainScreenWidth/3)];
    button4.adjustsTitleTintColorAutomatically = YES;
    [button4 setTintColor:kTCColor(27, 31, 35)];
    button4.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button4 setTitle:@"培训" forState:UIControlStateNormal];
//    button4.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button4 setImage:[UIImage imageNamed:@"train"] forState:UIControlStateNormal];
    button4.layer.cornerRadius = 4;
    button4.buttonImagePosition = FSCustomButtonImagePositionTop;
    button4.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button4 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button4.tag = 4;
    [_Mainscrollview addSubview:button4];
    
    
    FSCustomButton *button5 = [[FSCustomButton alloc] initWithFrame:CGRectMake(KMainScreenWidth/3, KMainScreenWidth/3, KMainScreenWidth/3, KMainScreenWidth/3)];
    button5.adjustsTitleTintColorAutomatically = YES;
    [button5 setTintColor:kTCColor(27, 31, 35)];
    button5.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button5 setTitle:@"日常" forState:UIControlStateNormal];
//    button5.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button5 setImage:[UIImage imageNamed:@"richang"] forState:UIControlStateNormal];
    button5.layer.cornerRadius = 4;
    button5.buttonImagePosition = FSCustomButtonImagePositionTop;
    button5.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button5 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button5.tag = 5;
    [_Mainscrollview addSubview:button5];
   
    FSCustomButton *button6 = [[FSCustomButton alloc] initWithFrame:CGRectMake(KMainScreenWidth/3*2, KMainScreenWidth/3, KMainScreenWidth/3, KMainScreenWidth/3)];
    button6.adjustsTitleTintColorAutomatically = YES;
    [button6 setTintColor:kTCColor(27, 31, 35)];
    button6.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button6 setTitle:@"工具" forState:UIControlStateNormal];
//    button6.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button6 setImage:[UIImage imageNamed:@"gongju"] forState:UIControlStateNormal];
    button6.layer.cornerRadius = 4;
    button6.buttonImagePosition = FSCustomButtonImagePositionTop;
    button6.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button6 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button6.tag = 6;
    [_Mainscrollview addSubview:button6];
    
    FSCustomButton *button7 = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, KMainScreenWidth/3*2, KMainScreenWidth/3, KMainScreenWidth/3)];
    button7.adjustsTitleTintColorAutomatically = YES;
    [button7 setTintColor:kTCColor(27, 31, 35)];
    button7.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button7 setTitle:@"资源" forState:UIControlStateNormal];
//    button7.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button7 setImage:[UIImage imageNamed:@"ziyuan"] forState:UIControlStateNormal];
    button7.layer.cornerRadius = 4;
    button7.buttonImagePosition = FSCustomButtonImagePositionTop;
    button7.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button7 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button7.tag = 7;
    [_Mainscrollview addSubview:button7];
    
    FSCustomButton *button8 = [[FSCustomButton alloc] initWithFrame:CGRectMake(KMainScreenWidth/3, KMainScreenWidth/3*2, KMainScreenWidth/3, KMainScreenWidth/3)];
    button8.adjustsTitleTintColorAutomatically = YES;
    [button8 setTintColor:kTCColor(27, 31, 35)];
    button8.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button8 setTitle:@"商铺" forState:UIControlStateNormal];
//    button8.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button8 setImage:[UIImage imageNamed:@"shangpu"] forState:UIControlStateNormal];
    button8.layer.cornerRadius = 4;
    button8.buttonImagePosition = FSCustomButtonImagePositionTop;
    button8.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button8 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button8.tag = 8;
    [_Mainscrollview addSubview:button8];
    
    FSCustomButton *button9 = [[FSCustomButton alloc] initWithFrame:CGRectMake(KMainScreenWidth/3*2, KMainScreenWidth/3*2, KMainScreenWidth/3, KMainScreenWidth/3)];
    button9.adjustsTitleTintColorAutomatically = YES;
    [button9 setTintColor:kTCColor(27, 31, 35)];
    button9.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button9 setTitle:@"营销" forState:UIControlStateNormal];
//    button9.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button9 setImage:[UIImage imageNamed:@"yingxiao"] forState:UIControlStateNormal];
    button9.layer.cornerRadius = 4;
    button9.buttonImagePosition = FSCustomButtonImagePositionTop;
    button9.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button9 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button9.tag = 9;
    [_Mainscrollview addSubview:button9];
    
    FSCustomButton *button10 = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, KMainScreenWidth, KMainScreenWidth/3, KMainScreenWidth/3)];
    button10.adjustsTitleTintColorAutomatically = YES;
    [button10 setTintColor:kTCColor(27, 31, 35)];
    button10.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button10 setTitle:@"合作" forState:UIControlStateNormal];
//    button10.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
    [button10 setImage:[UIImage imageNamed:@"hezuo"] forState:UIControlStateNormal];
    button10.layer.cornerRadius = 4;
    button10.buttonImagePosition = FSCustomButtonImagePositionTop;
    button10.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [button10 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button10.tag = 10;
    [_Mainscrollview addSubview:button10];
    
//    FSCustomButton *button11= [[FSCustomButton alloc] initWithFrame:CGRectMake(KMainScreenWidth/3, KMainScreenWidth, KMainScreenWidth/3, KMainScreenWidth/3)];
//    button11.adjustsTitleTintColorAutomatically = YES;
//    [button11 setTintColor:kTCColor(27, 31, 35)];
//    button11.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    [button11 setTitle:@"CRM" forState:UIControlStateNormal];
////    button11.backgroundColor = [UIColor brownColor];//kTCColor(255, 255, 255);
//    [button11 setImage:[UIImage imageNamed:@"CRM"] forState:UIControlStateNormal];
//    button11.layer.cornerRadius = 10;
//    button11.buttonImagePosition = FSCustomButtonImagePositionTop;
//    button11.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
//    [button11 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    button11.tag = 11;
//    [_Mainscrollview addSubview:button11];
    
}


-(void)click:(UIButton *)btn {
    
    switch (btn.tag) {
        case 1:{
            
            NSLog(@"办证");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                PermitController     *perCtl = [PermitController new];
                [self.navigationController pushViewController:perCtl animated:YES];
            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
            
        }break;
        case 2:{
            
            NSLog(@"装修");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            RenovationController * renCtl = [RenovationController new];
            [self.navigationController pushViewController:renCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        case 3:{
            
                NSLog(@"H5");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                HfiveController *hfiCtl = [HfiveController new];
                [self.navigationController pushViewController:hfiCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        case 4:{
            
            NSLog(@"培训");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            TrainingController *marCtl = [TrainingController new];
            [self.navigationController pushViewController:marCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
            
        }
            break;
        case 5:{
            
            NSLog(@"日常");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            DailyController *daiCtl = [DailyController new];
            [self.navigationController pushViewController:daiCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        case 6:{
            
            NSLog(@"工具");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            ToolsController *toolCtl = [ToolsController new];
            [self.navigationController pushViewController:toolCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        case 7:{
            
            NSLog(@"资源");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            ResourcesController *resCtl = [ResourcesController new];
            [self.navigationController pushViewController:resCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        case 8:{
            
            NSLog(@"商铺");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            ShopsController *shoCtl = [ShopsController new];
            [self.navigationController pushViewController:shoCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        case 9:{
            
            NSLog(@"营销");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            MarketingController *marCtl = [MarketingController new];
            [self.navigationController pushViewController:marCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        case 10:{
            
            NSLog(@"合作 ");
             self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            CooperationController *cooCtl = [CooperationController new];
            [self.navigationController pushViewController:cooCtl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        case 11:{
            
            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"非常抱歉" message:@"CRM功能正在努力更新中ing,请等待......" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//                NSLog(@"点击了确认");
//            }];
//
//            [alertController addAction:commitAction];
//            [self presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
    }
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
    
}
//返回上页
- (void)BackButtonClickservice{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 让导航栏不显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}


@end
