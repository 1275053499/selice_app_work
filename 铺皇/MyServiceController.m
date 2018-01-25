//
//  MyServiceController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "MyServiceController.h"
#import "UIImage+GIF.h"
@interface MyServiceController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *ServicetabView;

}

@property(strong,nonatomic)NSMutableArray *TitleArray;
@property(strong,nonatomic)NSMutableArray *SubtitleArray;

@end

@implementation MyServiceController

-(NSMutableArray *)TitleArray{
    if (_TitleArray == nil) {
        
        _TitleArray = [[NSMutableArray alloc]initWithObjects:@[@"商铺转让",@"商铺出租",@"商铺选址",@"招聘中心"],@[@"转让资源",@"出租资源"],@[@"CRM"],nil];
    }
    return _TitleArray;
}

-(NSMutableArray *)SubtitleArray{
    
    if (_SubtitleArray == nil) {
        
        _SubtitleArray = [[NSMutableArray alloc]initWithObjects:@[@"全网推广，线下匹配客户",@"全网布局，客户需要量大",@"优质服务，全方位审核",@"资源充足，最优质服务"],@[@"您购买的转让资源全部在这里，赶紧联系老板吧!",@"您购买的出租资源全部在这里，赶紧联系老板吧!"],@[@"当前仅限铺皇员工使用"], nil];
    }
    return _SubtitleArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   self.view.backgroundColor = kTCColor(255, 255, 255);
    //    返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    
    //   完成记录小标图
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem rightbarButtonItemWithImage:@"diary" highImage:nil target:self action:@selector(record)];
    
    self.title = @"我的服务";
    [self creatTabliview];
}
#pragma - mark 日记记录

-(void)record{
    
    NSLog(@"记录本..........");
    Toprightcornertroller *ctl =[[Toprightcornertroller alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

#pragma - mark 创建tableview视图
-(void)creatTabliview{
    
    ServicetabView                   = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    ServicetabView.delegate          = self;
    ServicetabView.dataSource        = self;
    ServicetabView.backgroundColor   = [UIColor clearColor];
    ServicetabView.tableFooterView   = [UIView new];
    [self.view addSubview:ServicetabView];
}

//tableview 适配
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    ServicetabView.frame = self.view.bounds;
}

#pragma  -mark tableviewdatasource代理方法
//段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.TitleArray.count;
}

//列
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.TitleArray[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    NSArray *arr = self.TitleArray[indexPath.section];
    NSArray *subarr = self.SubtitleArray[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    cell.detailTextLabel.text =subarr[indexPath.row];
    cell.detailTextLabel.textColor = kTCColor(102, 102, 102);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==2) {
        
        cell.textLabel.textColor = kTCColor(77, 166, 214);
        cell.detailTextLabel.textColor = kTCColor(77, 166, 214);
    }
    return cell;
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"第%ld段--第%ld列",indexPath.section,indexPath.row);
    NSArray * titlearr = self.TitleArray[indexPath.section];
    NSLog(@"titles:%@",titlearr[indexPath.row]);
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    //            转让
                    
                    TransferserviceController *ctl =[[TransferserviceController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:{
                    //            出租
                    
                    RentserviceController *ctl =[[RentserviceController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 2:
                {
                    //            选址
                    
                    ChooseserviceController *ctl =[[ChooseserviceController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 3:
                {
                    //            招聘
                    
                    RecruitserviceController *ctl =[[RecruitserviceController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
         case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    //            转让资源
                    
                    Myserviceresource *ctl =[[Myserviceresource alloc]init];
                     ctl.serviceCode = @"转让资源";
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:
                {
                    //            出租资源
                    
                    Myserviceresource *ctl =[[Myserviceresource alloc]init];
                    ctl.serviceCode = @"出租资源";
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
            }
            
        }
            break;
        default:{
            
            NSLog(@"CRM管理");
            WebViewVC *ctl = [[WebViewVC alloc] init];
            //    vc.url = @"http://www.baidu.com";
            ctl.url = @"http://waps.zhongguopuwang.com";
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            [self.navigationController pushViewController:ctl animated:YES];
            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }break;
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

//列高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

//段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


#pragma  -mark - 返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}
@end
