//
//  SecondViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/17.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SecondViewController.h"
#import "ReleaseXZController.h"//选址
#import "ReleaseZRController.h"//转让
#import "ReleaseZSController.h"//招聘
#import "ReleaseCZController.h"//出租

#define BXAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
@interface SecondViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>{

}

@property (nonatomic,strong) NSString *NSloginstate;//登录状态
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end
@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kTCColor(255, 255, 255);
    self.navigationItem.title = @"发布";
    
     UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate      = self;
    tableView.dataSource    = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - Tableviewdatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID = @"oneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
           if (indexPath.section == 0) {
              cell.textLabel.text = @"选择您要发布的信息类型？";
              cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
           }
    
            if (indexPath.section == 1) {
                cell.textLabel.text = @"商铺转让";
                cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
                cell.imageView.image = [UIImage imageNamed:@"fabu_ZR"];
//                加入跳转符号
                cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text =@"专业商铺信息服务中心";//副标题
                cell.detailTextLabel.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
                
            }
            if (indexPath.section == 2) {
                cell.textLabel.text = @"出租招商";
                cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
                cell.imageView.image = [UIImage imageNamed:@"fabu_ZS"];
                //                加入跳转符号
                cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.detailTextLabel.text =@"专业商铺信息服务中心";//副标题
                cell.detailTextLabel.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
                
            }
            if (indexPath.section == 3) {
                cell.textLabel.text = @"商铺选址";
                cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
                cell.imageView.image = [UIImage imageNamed:@"fabu_XZ"];
                //                加入跳转符号
                cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text =@"专业商铺信息服务中心";//副标题
                cell.detailTextLabel.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
            }
    
            if (indexPath.section == 4){
                
                    cell.textLabel.text = @"招聘中心";
                    cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
                    cell.imageView.image = [UIImage imageNamed:@"fabu_ZP"];
                //                加入跳转符号
                cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text =@"专业商铺信息服务中心";//副标题
                cell.detailTextLabel.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
                
                }
//    去掉分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -   段与段之间间隔
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (KMainScreenHeight-64-49)/5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        switch (indexPath.section) {
            case 0:{
        
            }
                break;
            case 1:{
                
//                NSLog(@"转让发布");
                if ([self.NSloginstate isEqualToString:@"loginyes"]){

                    ReleaseZRController *ctl = [[ReleaseZRController alloc]init];
                    ctl.Navtitle = @"发布转让";
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                }else{
                
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了去登录");
                        LoginController *ctl = [[LoginController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。

                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了取消");}];
                    [alertController addAction:commitAction];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            
            }
                break;
                
            case 2:{
                NSLog(@"出租招商");

#pragma  - mark 商铺出租招商  与 商铺转让 共用一个东西

            
                if ([self.NSloginstate isEqualToString:@"loginyes"]){
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    ReleaseCZController *ctl = [[ReleaseCZController alloc]init];
                    ctl.Navtitle = @"发布出租";
                    [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                }else{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了去登录");
                        
                        LoginController *ctl = [[LoginController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                        
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了取消");}];
                    [alertController addAction:commitAction];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
                break;
            case 3:{
                
                NSLog(@"发布选址");
                
                if ([self.NSloginstate isEqualToString:@"loginyes"]){
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        ReleaseZSController *ctl = [[ReleaseZSController alloc]init];
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                }else{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了去登录");
                        LoginController *ctl = [[LoginController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                        
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了取消");}];
                    [alertController addAction:commitAction];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
                break;
            default:{
                NSLog(@"发布招聘");
                
                
                if ([self.NSloginstate isEqualToString:@"loginyes"]){
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    ReleaseXZController *ctl = [[ReleaseXZController alloc]init];
                    [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                }else{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请您先登录过账号" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了去登录");
                        LoginController *ctl = [[LoginController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = NO;//1.并在push后设置self.hidesBottomBarWhenPushed=NO;2.这样back回来的时候，tabBar会恢复正常显示。
                        
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了取消");}];
                    [alertController addAction:commitAction];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
        
            }
                break;
        }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
     NSLog(@"发布导航栏%@",self.navigationController);
     NSLog(@"%@",self.navigationController.viewControllers.lastObject);
     self.NSloginstate      = [[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate];
     NSLog(@"登录状态%@", self.NSloginstate );
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ( [[NSUserDefaults standardUserDefaults]boolForKey:@"firstCouponBoard_iPhone2"]) {
        NSLog(@"加载过了指导页，不能加载第二次了");
        
    }else{
        NSLog(@"没有加载过指导页，马上加载第1次了");
        
        GUIDbackview                     =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        GUIDbackview.layer.masksToBounds = YES;
        GUIDbackview.backgroundColor     = [UIColor colorWithWhite:0 alpha:0];
        
        GUIDimgview        = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        GUIDimgview.center = GUIDbackview.center;
        GUIDimgview.layer.masksToBounds        = YES;
        GUIDimgview.image  = [UIImage imageNamed:@"teach_2"];
        NSLog(@"%@----%@",GUIDimgview,GUIDbackview);
        [GUIDbackview addSubview:GUIDimgview];
        
        GUIDbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        GUIDbtn.frame = CGRectMake(190, KMainScreenHeight-200, 90, 35);
        [GUIDbtn setImage:[UIImage imageNamed:@"teach_btn"] forState:UIControlStateNormal];
        [GUIDbtn addTarget:self action:@selector(sureTapClick:) forControlEvents:UIControlEventTouchUpInside];
        [GUIDbackview addSubview:GUIDbtn];
        
        [[UIApplication sharedApplication].delegate.window addSubview:GUIDbackview];
        [UIView animateWithDuration:1.0 delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            GUIDbackview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
            
        } completion:^(BOOL finished) {
            NSLog(@"动画结束");
        }];
    }
}

#pragma -mark 指导页推出
- (void)sureTapClick:(id)sender{

        NSLog(@"指导页推出去了");
        [UIView animateWithDuration:0.1 animations:^{
            
            GUIDbackview.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            
        } completion:^(BOOL finished) {
            
            [GUIDbackview removeFromSuperview];
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstCouponBoard_iPhone2"];
}

-(void)viewWilldisAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

@end
