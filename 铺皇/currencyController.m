//
//  currencyController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "currencyController.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
@interface currencyController ()<UITableViewDelegate,UITableViewDataSource>

@property float folderSize;
@property(nonatomic,strong)UILabel *Cache;
@property(nonatomic,strong)UILabel *Notice;

@end

@implementation currencyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTCColor(255, 255, 255);

    self.title = @"通用设置";
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(backset3)];
    self.navigationItem.leftBarButtonItem = backItm;
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
//    计算文件大小
     [self sizeCache];
    
    [self creatUI];
    
}

#pragma  -mark 计算文件夹的缓存
-(void)sizeCache{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"途径%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    float folderSize = 0.0 ;
    if ([fileManager fileExistsAtPath:path]){
        
        NSArray *Files = [fileManager subpathsAtPath:path];
        NSLog(@"文件数：%ld",Files.count);
        for (NSString *filename in  Files){
            
            NSString *fullpath = [path stringByAppendingPathComponent:filename];
            
            //            计算单个文件夹
            _folderSize += [self fileSizeAtPath:fullpath];
        }
        
    }
}

#pragma  -mark 计算单个文件夹的大小
-(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        
        return size/1024.0/1024.0;
    }
    return 0;
}

#pragma  -mark构建UI
-(void)creatUI{
    
    _Cache=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    _Cache.font = [UIFont systemFontOfSize:15];
    _Cache.textColor= kTCColor(77, 166, 214);
    _Cache.textAlignment = NSTextAlignmentRight;
    
    _Notice=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    _Notice.font = [UIFont systemFontOfSize:15];
    _Notice.textColor= kTCColor(77, 166, 214);
    _Notice.textAlignment = NSTextAlignmentRight;
    
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:tableView];
    self.currencytableview = tableView;
    self.currencytableview.tableFooterView = [[UIView alloc]init];
}

//一个段落几个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"oneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    switch (indexPath.row){
        case 0:
            cell.textLabel.text = @"清理缓存";
            cell.accessoryView  = _Cache;
            _Cache.text = [NSString stringWithFormat:@"%2.fM",_folderSize];
            break;
        case 1:
            
            cell.textLabel.text = @"消息通知";
            cell.detailTextLabel.text = @"您可以在[设置-通知-铺皇网]更改状态";
            cell.detailTextLabel.textColor = kTCColor(161, 161, 161);
               cell.accessoryView  = _Notice;
            if (iOS8) { //iOS8以上包含iOS8
                if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
                    _Notice.text = @"未开启";
                }
                
                else{
                    _Notice.text = @"已开启";
                }
            }
            
            else{ // ios7 一下
                if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
                    _Notice.text = @"未开启";
                }
                else{
                    _Notice.text = @"已开启";
                }
            }
            
            break;
        case 2:
            
            cell.textLabel.text = @"系统设置";
            cell.detailTextLabel.text = @"您可以在[铺皇]更改信息，关闭某些功能使用效果会降低";
            cell.detailTextLabel.textColor = kTCColor(161, 161, 161);
            
            break;
        case 3:
            
            cell.textLabel.text = @"应用信息";
            cell.detailTextLabel.text = @"检测版本信息";
            cell.detailTextLabel.textColor = kTCColor(161, 161, 161);
            
            break;
            
        case 4:
            
            cell.textLabel.text = @"铺皇评分";
            cell.detailTextLabel.text = @"给我们的服务打个满意的分数吧";
            cell.detailTextLabel.textColor = kTCColor(161, 161, 161);
            
            break;
            
        default:
            cell.textLabel.text = @"-=-=--=";
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了第%ld段,第%ld个cell信息",indexPath.section,indexPath.row);
    
    switch (indexPath.row) {
        case 0:{
            
            NSLog(@"清理缓存");
            [self clearCache];
        }
            break;
        case 1:{
            
            NSLog(@"通知信息");
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            
            break;
            
        case 2:{
            
            NSLog(@"铺皇设置");
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
         }
            break;
        case 3:{
            
            //调用获取是否需要更新方法
            [self checkAppUpdate];
            
        }break;
            
        case 4:{
            //调用评分
            [self scoring];
            
        }break;
        default:{
            
            NSLog(@"修改登录密码");
        }
            break;
    }
}

#pragma -mark 评分
-(void)scoring{

//     初始化控制器
        NSString * Appid = @"1315260303";
//         NSString * Appid = @"805363884";
    
    if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
        //防止键盘遮挡
         //仅支持iOS10.3+（需要做校验） 且每个APP内每年最多弹出3次评分alart
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [SKStoreReviewController requestReview];

    }else{
        
        NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",Appid];//替换为对应的APPID
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
    }
    NSLog(@"评分啊");
}

#pragma -mark 获取是否需要更新方法实现
-(void)checkAppUpdate{
    
    //定义的app的地址
    NSString *urld = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=1315260303"];//自己的
    //网络请求app的信息，主要是取得我说需要的Version
    NSURL *url = [NSURL URLWithString:urld];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            //data是有关于App所有的信息
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"AppStore==%@",receiveDic);
            NSLog(@"resultCount=%d",[[receiveDic valueForKey:@"resultCount"] intValue]);
            NSLog(@"results=%@",    [receiveDic  valueForKey:@"results"]              );
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {//线上产品
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
                
                //请求的有数据，进行版本比较
                [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
                [self Thehighest];
            }
        }else{
            
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
    }];
    
    [task resume];
}

#pragma -mark 版本最高提示
-(void)Thehighest{

    dispatch_async(dispatch_get_main_queue(), ^{
        //                                      主线程做事情
        NSString *msg = [NSString stringWithFormat:@"铺皇已经是最高级，不需要更新哦"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"我知道了"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        }];
        
        [alertController addAction:otherAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma -mark 版本比较
-(void)receiveData:(id)sender{
    
    //获取APP自身版本号
//    NSString *localVersion      = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"];//内部测试获取版本号
    
    NSString *localVersion      = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];//上线了测试获取版本号
    NSLog(@"当前版本号     :%@",localVersion);
    NSLog(@"AppStore版本号:%@",sender[@"version"]);
    
    NSArray *localArray = [localVersion         componentsSeparatedByString:@"."];//当前手机安装 版本信息
    NSArray *versionArray = [sender[@"version"] componentsSeparatedByString:@"."];//Appstore 版本信息
    
    NSLog(@"当前版本信息:%@\nAppStore版本信息%@",localArray,versionArray);
    if ((versionArray.count == 3) && (localArray.count == versionArray.count)) {
        
        if ([localArray[0] intValue] <  [versionArray[0] intValue]) {//第1位不等
            [self updateVersion:sender[@"version"]];
        }
        else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]){
            if ([localArray[1] intValue] <  [versionArray[1] intValue]){
                [self updateVersion:sender[@"version"]];
            }
            else if ([localArray[1] intValue] ==  [versionArray[1] intValue]){
                if ([localArray[2] intValue] <  [versionArray[2] intValue]){
                    [self updateVersion:sender[@"version"]];
                }
                else{
                    [self Thehighest];
                }
            }
            else{
                NSLog(@"测试测试测试");
            }
        }
    }else{
        NSLog(@"AppStore版本号位数有误");
    }
}
#pragma -
-(void)updateVersion:(NSString *)version{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您当前有新版本(%@)",version] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在更新"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {

        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/%E9%93%BA%E7%9A%87/id1315260303?mt=8&uo=4"];//自己的app
        [[UIApplication sharedApplication]openURL:url];
    }];
    UIAlertAction *otherAction2 = [UIAlertAction actionWithTitle:@"我在看看"style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        
    }];
    
    [alertController addAction:otherAction];
    [alertController addAction:otherAction2];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

#pragma  -mark清理文件夹缓存
-(void)clearCache{
    NSLog(@"内容：%@",_Cache.text);
    
    if ([_Cache.text isEqualToString:@"0M"]||[_Cache.text isEqualToString:@"清理完成"]){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的APP非常干净，不需要清理" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            NSLog(@"点击了确认");
        }];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message: [NSString stringWithFormat:@"当前中APP存在缓存%@，您确定要全部清理么？",_Cache.text] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了取消");
        }];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了确认");
            
         
             [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"清理中..."];
           
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSFileManager *fileManager=[NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:path]){
                NSArray *childerFiles=[fileManager subpathsAtPath:path];
                for (NSString *fileName in childerFiles){
                    
                     //如有需要，加入条件，过滤掉不想删除的文件
                     NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                     [fileManager removeItemAtPath:absolutePath error:nil];
                        [YJLHUD showSuccessWithmessage:@"清理完成"];
                        [YJLHUD dismissWithDelay:1];
                }
            }
            _Cache.text = @"清理完成";
        }];
        
        [alertController addAction:cancleAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 返回
-(void)backset3{
    
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
