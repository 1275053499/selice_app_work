//
//  SetupController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SetupController.h"
#import "Defination.h"
@interface SetupController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatbase];
    [self creatview];

}

-(void)creatbase{
    
    self.title = @"设置";
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma  -mark - 创建视图
-(void)creatview{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    tableView.delegate      = self;
    tableView.dataSource    = self;
    tableView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:tableView];
    self.settableview       = tableView;
    self.settableview.tableFooterView = [[UIView alloc]init];
    
    UIButton *backlogin = [UIButton buttonWithType:UIButtonTypeCustom];
    backlogin.frame = CGRectMake(10, KMainScreenHeight-60, KMainScreenWidth-20, 50);
    [backlogin setBackgroundImage:[UIImage imageNamed:@"setting_out"] forState:UIControlStateNormal];
    [backlogin setTitle:@"退出登录" forState:UIControlStateNormal];
    [backlogin addTarget:self action:@selector(backlogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backlogin];
}


-(void)Pullout{
    
    
    //  本地存登录状态
    [[YJLUserDefaults shareObjet]saveObject:@"loginno" forKey:YJLloginstate];
    [YJLHUD showSuccessWithmessage:@"注销成功"];
    [YJLHUD dismiss];
    [self back];
}

#pragma mark -推出登陆
-(void)backlogin{
    
    NSLog(@"退出登录事件点击");
    
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"退出登录将不能使用全部功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                NSLog(@"点击了确认");
        
            [self performSelector:@selector(Pullout) withObject:nil afterDelay:0.1];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"在玩一会" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSLog(@"点击了取消");
        }];
        [alertController addAction:commitAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请先登录铺皇" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了去登录");
            
                        LoginController *ctl = [[LoginController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = YES;//1.并在push后设置 2.这样back回来的时候，tabBar不会会恢复正常显示。
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSLog(@"点击了取消"); }];
        
                [alertController addAction:commitAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark - Tableviewdatasource
//几个段落Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//一个段落几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

//cell创建并赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"意见反馈";
            
            break;
        case 1:
            cell.textLabel.text = @"关于我们";
            
            break;
        case 2:
            cell.textLabel.text = @"通用设置";
            
            break;
        case 3:{
            cell.textLabel.text =  @"安全设置";
        }
            break;
            
        case 4:{
            cell.textLabel.text =  @"常见问题";
        }
            break;
        default:
            cell.textLabel.text = @"修改登录密码";
            
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了第%ld段,第%ld个cell信息",indexPath.section,indexPath.row);
   
            switch (indexPath.row) {
                case 0:
                {  NSLog(@"意见反馈");
             
                    OpinionController *ctl = [[OpinionController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:{
                    NSLog(@"关于我们");
                   
                    aboutController *ctl = [[aboutController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 2:{
                    
                    NSLog(@"通用设置");
                  
                    currencyController *ctl = [[currencyController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                    
                case 3:{
                    
                     NSLog(@"安全设置");
                    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
                        
                       
                        SafeController *ctl = [[SafeController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    }
                    
                    else{
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请先登录铺皇" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                            NSLog(@"点击了去登录");
                            LoginController *ctl = [[LoginController alloc]init];
                            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                            [self.navigationController pushViewController:ctl animated:YES];
                            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置
                            
                        }];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                            NSLog(@"点击了取消");}];
                        [alertController addAction:commitAction];
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }
                    break;
        
                case 4:{
                    
                    NSLog(@"服务问题");
                
                    DoubtController *ctl = [[DoubtController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                    
                case 5:{
                    NSLog(@"修改登录密码");

                    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"])
                    {
                        
                        modifyController *ctl = [[modifyController alloc]init];
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    }
                
                else{
                    
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请不要搞事情，您都没有登录过铺皇网" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                    NSLog(@"点击了去登录");
                                        LoginController *ctl = [[LoginController alloc]init];
                            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                            [self.navigationController pushViewController:ctl animated:YES];
                            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                            
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


#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 返回
-(void)back{
    
[self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark  视图渲染 进入
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma  -mark  视图渲染推出
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

@end
