//
//  SafeController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SafeController.h"

@interface SafeController ()<UITableViewDelegate,UITableViewDataSource>
{
    UISwitch *Myswitch;
}

@property(nonatomic,strong)UITableView *safetableview;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (strong, nonatomic)NSMutableArray *dataArray;


@end

@implementation SafeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTCColor(255, 255, 255);
    //    适配必要使用
    //    *_autoSizeScaleX
    //    *_autoSizeScaleY
    if(KMainScreenHeight < 667){                                 // 这里以(iPhone6)为准
        _autoSizeScaleX = KMainScreenWidth/375;
        _autoSizeScaleY = KMainScreenHeight/667;
    }else{
        _autoSizeScaleX = 1.0;
        _autoSizeScaleY = 1.0;
    }
    
    NSLog(@"X比例=%f,Y比例=%f",_autoSizeScaleX,_autoSizeScaleY);
    self.title = @"安全设置";
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    [self tabview];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    Myswitch = [[UISwitch alloc]init];
}

- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil){
        //创建LAContext
        LAContext *context = [LAContext new];
        //这个属性是设置指纹输入失败之后的弹出框的选项
        context.localizedFallbackTitle = @"输入密码";
        NSError *error = nil;
        
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])//检测是否可以使用 Touch ID
        {
            _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"数字密码验证",@"Touch ID 验证"],nil];
           
        }
        
        else
        
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您尚未开启Touch ID用于支付快捷，是否需要试用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
                NSString * urlStr = @"App-Prefs:root=NOTIFICATIONS_ID";
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]){
                    if (iOS10){
                        //iOS10.0以上  使用的操作
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
                    } else{
                        //iOS10.0以下  使用的操作
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }
                NSLog(@"设置");
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
                NSLog(@"取消");
               
            }];
            
             [alertController addAction:cancelAction];
             [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
             _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"数字密码验证"],nil];
        }
        
    }
    
    return _dataArray;
}

-(void)tabview{
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:tableView];
    self.safetableview = tableView;
    self.safetableview.tableFooterView = [[UIView alloc]init];
    
}

#pragma mark - Tableviewdatasource
//几个段落Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSLog(@"段=%ld",self.dataArray.count);
    return self.dataArray.count;
}

//一个段落几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"列=%@",self.dataArray[section]);
    
    NSArray *arr = self.dataArray[section];
    return arr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"oneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        NSArray *arr = self.dataArray[indexPath.section];
        cell.textLabel.text = arr[indexPath.row];
        if (indexPath.row == 0) {
            NSLog(@"12132131232131322");
        }
        
        
        if (indexPath.row == 1)
        {
           
            if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLTouchIDneed] isEqualToString:@"yes"])
            {
                [Myswitch setOn:YES];
            }

            else
            {
                [Myswitch setOn:NO];
            }
            cell.accessoryView = Myswitch;
            [Myswitch addTarget:self action:@selector(swchange) forControlEvents:UIControlEventValueChanged];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma -mark 按钮状态开关
-(void)swchange{
    

    //判断登录状态
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
        
        if (Myswitch.on == YES){
            
            NSLog(@"开启验证");
            NSLog(@"希望开启验证Touch ID");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@" 您即将开启使用Touch ID验证一些内容" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                NSLog(@"点击了确认---开启开关");
                [[YJLUserDefaults shareObjet]saveObject:@"yes" forKey:YJLTouchIDneed];
                    
                    }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        
                        NSLog(@"点击了取消---关闭开关");
                         [[YJLUserDefaults shareObjet]saveObject:@"no" forKey:YJLTouchIDneed];
                        Myswitch.on = NO;
                    }];

                    [alertController addAction:commitAction];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];

        }
        
        else{
            
            NSLog(@"关闭验证");
            // 存储不需要验证
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@" 您即将关闭使用Touch ID验证一些内容" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        NSLog(@"点击了确认---关闭开关");
                        [[YJLUserDefaults shareObjet]saveObject:@"no" forKey:YJLTouchIDneed];
                }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    Myswitch.on = YES;
                    NSLog(@"点击了确认---开启开关");
                     [[YJLUserDefaults shareObjet]saveObject:@"yes" forKey:YJLTouchIDneed];
                    
                }];
            [alertController addAction:commitAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"没有登录状态点击了确认---关闭开关");
            //        存储不需要验证
            [[YJLUserDefaults shareObjet]saveObject:@"no" forKey:YJLTouchIDneed];
            Myswitch.on=NO;
        }];
        
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50 *_autoSizeScaleY;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"验证设置",@"其它测试"];
    return titles[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSLog(@"点击了第%ld段,第%ld个cell信息",indexPath.section,indexPath.row);
    switch (indexPath.section) {
        case 0:
        {
//            安全设置
            switch (indexPath.row)
            {
                case 0:
                {
//                   数字密码
                   
                    SafenumberController * NUMBER  = [[SafenumberController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:NUMBER animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                   
                }
                    break;
                    
                case 1:{
                    
                    
                }break;
                default:{

                }
                    break;
            }
        }
            break;
            
        default:
        {
        }
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_safetableview reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
    
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
@end
