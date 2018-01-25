//
//  SafenumberController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//
/**************************1*************************/
/**************************3*************************/
/**************************6*************************/
/**************************8*************************/
/**************************2*************************/
/**************************5*************************/
/**************************6*************************/
/**************************1*************************/
/**************************4*************************/
/**************************6*************************/
/**************************2*************************/

#import "SafenumberController.h"
#import "Password.h"
#import "Passwordsure.h"
#import "oldpassword.h"
@interface SafenumberController ()<UITableViewDelegate,UITableViewDataSource>
{
    UISwitch *Myopenswitch;
}


@property (nonatomic,strong )UITableView    *NUmtableview;
@property (strong, nonatomic)NSMutableArray *dataArray;

@property (strong, nonatomic)NSString *Paymentpassword;
@property (strong, nonatomic)NSString *Paymentpasswordopen;

@property (nonatomic, strong)NSString *Firstpassword;
@property (nonatomic, strong)NSString *Secondpassword;

#define BtnColor [UIColor colorWithRed:0.01f green:0.45f blue:0.88f alpha:1.00f]     //按钮的颜色  蓝色
@end

@implementation SafenumberController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
    _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"设置支付密码",@"是否开启支付验证",@"修改支付密码",@"清除支付密码"],nil];
    }
    return _dataArray;
}

-(NSString *)Firstpassword{
    if (!_Firstpassword) {
        _Firstpassword = [[NSString alloc]init];
    }
    return _Firstpassword;
}

-(NSString *)Secondpassword{
    if (!_Secondpassword) {
        _Secondpassword = [[NSString alloc]init];
    }
    return _Secondpassword;
}

-(NSString *)Paymentpassword{
    if (!_Paymentpassword) {
        _Paymentpassword = [[NSString alloc]init];
    }
    return _Paymentpassword;
}

-(NSString *)Paymentpasswordopen{
    if (!_Paymentpasswordopen) {
        _Paymentpasswordopen = [[NSString alloc]init];
    }
    return _Paymentpasswordopen;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = kTCColor(255, 255, 255);
    Myopenswitch = [[UISwitch alloc]init];
    
    [self GETPay];
    [self GETPayopen];
    [self buildUI1];
    [self buildUI2];
}

#pragma 尝试获取本地支付密码是否拥有
-(void)GETPay{
    //    尝试获取本地支付密码是否拥有
    self.Paymentpassword           		=  [[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpassword];
    NSLog(@"获取本地支付密码：%@",self.Paymentpassword);
    
}

#pragma 判断是否开启了验证开关
-(void)GETPayopen{
    
    //    尝试获取本地支付验证是否拥有
    self.Paymentpasswordopen            =   [[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpasswordopen];
    NSLog(@"获取本地支付验证开关：%@",self.Paymentpasswordopen);

    if ([self.Paymentpasswordopen isEqualToString:@"openPay"])
    {
        Myopenswitch.on = YES;
    }else{
        Myopenswitch.on = NO;
    }
}

-(void)buildUI1
{


    if ([self.Paymentpasswordopen isEqualToString:@"openPay"]) {

        self.title =@"开启了支付密码";
//        ios5以后可以设置导航栏标题的颜色
        
    }else{
        self.title = @"设置支付密码";
    }
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];

}

-(void)buildUI2{
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    tableview.delegate  =self;
    tableview.dataSource  = self;
    [self.view addSubview:tableview];
    self.NUmtableview =  tableview;
    self.NUmtableview.tableFooterView = [UIView new];
    
}

#pragma  -mark -tabviewcell delegate
//几个段落Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

//一个段落几个row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

//  初始化cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"numcell";
    
    UITableViewCell *numcell  =[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!numcell) {
        numcell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        NSArray *cellArr = self.dataArray[indexPath.section];
        numcell.textLabel.text = cellArr[indexPath.row];
        
    }
    
    if (indexPath.row == 1)
    {
        numcell.accessoryView = Myopenswitch;
        [Myopenswitch addTarget:self action:@selector(swchange) forControlEvents:UIControlEventValueChanged];
    }

    numcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return numcell;
}

#pragma 是否开启验证
-(void)swchange{
    
    [self GETPay];
    
    if (Myopenswitch.on)
    {
        NSLog(@"打开验证");
        //      没有设置密码 不能关闭
        if (!(_Paymentpassword.length>0)){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您还未设置支付密码，是否需要设置支付密码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置支付密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
           {
                                               
                   [self openandverify];
                   NSLog(@"需要设置密码");
                  Myopenswitch.on = NO;
                                               
               }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                               NSLog(@"暂时不需要");
                               Myopenswitch.on = NO;
                                               
               }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        //设置了密码 尝试开启验证信号
        else{
            NSLog(@"开启验证");
            [[YJLUserDefaults shareObjet]saveObject:@"openPay" forKey:YJLPaymentpasswordopen];
            self.title =  @"开启了支付密码验证";
        }
    }
    else{
        NSLog(@"关闭验证");
         [[YJLUserDefaults shareObjet]saveObject:@"closePay" forKey:YJLPaymentpasswordopen];
        self.title =  @"关闭了支付密码验证";
       
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *titleArr = @[@"设置",@"number2"];
    return titleArr[section];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    尝试获取本地支付密码是否拥有
    self.Paymentpassword           		=  [[YJLUserDefaults shareObjet]getObjectformKey:YJLPaymentpassword];
    NSLog(@"获取本地支付密码：%@",self.Paymentpassword);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了第%ld段,第%ld个cell信息",indexPath.section,indexPath.row);
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0://开启并设置支付密码
                {
                    
                    [self openandverify];
                    
                }
                    break;
                    
                    
                case 1://关闭支付密码
                {

                }
                    
                    break;
                case 2://修改支付密码
                {
                    [self changePay];
                }
                    break;
                case 3://清理支付密码
                {
                    
                    [self clearPay];
                    
                }
                    break;
                    
                default:{
                    
                }
                    break;
            }
        }
            
            break;
        case 2:{
            
        }
            break;
        default:{
            
        }
            break;
    }
    
}

#pragma  -mark 设置支付密码
-(void)openandverify{
    //                    设置了支付密码
    if (_Paymentpassword.length > 0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您已经设置过支付密码，如果需要修改请到[修改支付密码]" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
                        NSLog(@"好的");
                                           
                }];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //                    没有设置支付密码
    else{
        
        //弹出式密码框
        Password *passView = [[Password alloc]initSingleBtnView];
        passView.passWordTextConfirm =^(NSString *text){//点击确定按钮输出密码
            
            _Firstpassword = [NSString stringWithFormat:@"%@",text];
            NSLog(@"第一个密码：%@",text);
            NSLog(@"点击了确定按钮");
            
            Passwordsure *passViewsure = [[Passwordsure alloc]initSingleBtnView];
            passViewsure.passWordTextConfirm =^(NSString *text){//点击确定按钮输出密码
                _Secondpassword = [NSString stringWithFormat:@"%@",text];
                NSLog(@"第二个密码：%@",text);
                NSLog(@"点击了确定按钮");
        
                if (![_Firstpassword isEqualToString:_Secondpassword]){
                    
                    NSLog(@"不一样");
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您输入的2次支付密码不一致，重新设置吧" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                        
                           NSLog(@"好的");
                           self.title =  @"支付密码设置失败";
                        
                                                       
                       }];
                    [alertController addAction:commitAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                else{
                    
                    NSLog(@"一样");

                    [YJLHUD showImage:nil message:@"密码设置中..."];//无图片 纯文字
                    
                    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                    manager.requestSerializer.timeoutInterval = 10.0;
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
                    NSDictionary *params = @{
                                                 @"phone"   : [[YJLUserDefaults shareObjet]getObjectformKey:YJLuser]
                                             };
                    NSLog(@"用户ID:%@",params);
                    [manager POST:Hostpaysetword parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                        
                        //    资源匹配套餐3 个数
                        [formData appendPartWithFormData:[_Secondpassword dataUsingEncoding:NSUTF8StringEncoding] name:@"paypassword"];
                    }
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             NSLog(@"请求成功=%@",     responseObject);
                             
                             NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                             if ([code isEqualToString:@"200"]) {
                                 NSLog(@"200设置成功");
                                  [YJLHUD showSuccessWithmessage:@"设置成功"];
                                  [YJLHUD dismissWithDelay:1];
                                
                                 
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提示"] message:@"支付密码设置成功\n是否开启支付验证" preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                 
                                                                 NSLog(@"好的");
                                                         
                                                         [[YJLUserDefaults shareObjet]saveObject:@"openPay" forKey:YJLPaymentpasswordopen];//支付验证开启
                                                         [[YJLUserDefaults shareObjet]saveObject:_Secondpassword forKey:YJLPaymentpassword];//支付密码
                                                    
                                                                 self.title  =  @"设置并开启支付密码验证";
                                                             Myopenswitch.on = YES;
                                 
                                                         }];
                                 
                                                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                 
                                                                NSLog(@"好的");
                                                         
                                                         [[YJLUserDefaults shareObjet]saveObject:@"closePay" forKey:YJLPaymentpasswordopen];//支付验证开启
                                                         [[YJLUserDefaults shareObjet]saveObject:_Secondpassword forKey:YJLPaymentpassword];//支付密码
                                                         
                                                         self.title =  @"设置支付密码尚未开启验证";
                                                         Myopenswitch.on = NO;
                                                        }];
                                                     [alertController addAction:commitAction];
                                                     [alertController addAction:cancelAction];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                             }else{
                                 
                                 NSLog(@"300设置失败");
                                 [YJLHUD showErrorWithmessage:@"设置失败，请重新设置"];
                                 [YJLHUD dismissWithDelay:1];
                                
                                 
                             }
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             NSLog(@"请求失败=%@",error);
                             
                             [YJLHUD showErrorWithmessage:@"服务器连接失败"];
                             [YJLHUD dismissWithDelay:1];
                             
             }];
                    
                }
            };
            
            [passViewsure show];
        };
        
        [passView show];
    }
}

#pragma  -mark  修改支付密码
-(void)changePay{
    
    [self GETPay];
    
    //    有支付密码 准备修改密码
    if (_Paymentpassword.length  > 0){
        
        oldpassword *oldpassView = [[oldpassword alloc]initSingleBtnView];
        oldpassView.passWordTextConfirm =^(NSString *text){//点击确定按钮输出密码
            
            NSLog(@"原始密码输入%@",text);
            if ([_Paymentpassword isEqualToString:text]) {
                
                Myopenswitch.on = NO;
                //弹出式密码框
                Password *passView = [[Password alloc]initSingleBtnView];
                passView.passWordTextConfirm =^(NSString *text)
                {
                    //点击确定按钮输出密码
                    _Firstpassword = [NSString stringWithFormat:@"%@",text];
                    NSLog(@"第一个密码：%@",text);
                    NSLog(@"点击了确定按钮");
                    
                    Passwordsure *passViewsure = [[Passwordsure alloc]initSingleBtnView];
                    passViewsure.passWordTextConfirm =^(NSString *text){
                    //点击确定按钮输出密码
                        _Secondpassword = [NSString stringWithFormat:@"%@",text];
                        NSLog(@"第二个密码：%@",text);
                        NSLog(@"点击了确定按钮");
                        
                        if (![_Firstpassword isEqualToString:_Secondpassword])
                        {
                            NSLog(@"不一样");
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提示"] message:@"您输入的2次支付密码不一致，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                    
                                    NSLog(@"好的");
                                    self.title = @"密码修改有误";
                                    
                                }];
                            
                            [alertController addAction:commitAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                        }
                        
                        else{
                            
                            NSLog(@"一样");
                            
                            [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"密码修改中..."];
                            
                            
                            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                            manager.requestSerializer.timeoutInterval = 10.0;
                            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
                            NSDictionary *params = @{
                                                     @"phone"   :[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser]
                                                     };
                            NSLog(@"用户ID:%@",params);
                            [manager POST:Hostpaysetword parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                            
                                [formData appendPartWithFormData:[_Secondpassword dataUsingEncoding:NSUTF8StringEncoding] name:@"paypassword"];
                            }
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      NSLog(@"请求成功=%@",     responseObject);
                                      NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                          if ([code isEqualToString:@"200"]) {
                                          NSLog(@"200设置成功");
                              [YJLHUD showSuccessWithmessage:@"密码修改成功"];
                              [YJLHUD dismissWithDelay:1];
                             
                                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提示"] message:@"支付密码修改成功\n是否需要开启支付验证" preferredStyle:UIAlertControllerStyleAlert];
                                  UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                         NSLog(@"好的");
                                      
                                      [[YJLUserDefaults shareObjet]saveObject:@"openPay" forKey:YJLPaymentpasswordopen];//支付验证开启
                                      [[YJLUserDefaults shareObjet]saveObject:_Secondpassword forKey:YJLPaymentpassword];//支付密码
                                      
                                         self.title =  @"修改成功并开启支付密码验证";
                                         Myopenswitch.on = YES;
                                          
                                     }];
                                          
                                  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                      
                                          NSLog(@"好的");
                                      
                                      [[YJLUserDefaults shareObjet]saveObject:@"closePay" forKey:YJLPaymentpasswordopen];//支付验证开启
                                      [[YJLUserDefaults shareObjet]saveObject:_Secondpassword forKey:YJLPaymentpassword];//支付密码
                                
                                          self.title =  @"修改支付密码尚未开启验证";
                                          Myopenswitch.on = NO;
                                          }];
                                              [alertController addAction:commitAction];
                                              [alertController addAction:cancelAction];
                                              [self presentViewController:alertController animated:YES completion:nil];
                                      }else{
                                          
                                          NSLog(@"300设置失败");
                                          
                                          [YJLHUD showErrorWithmessage:@"设置失败，请重新设置"];
                                          [YJLHUD dismissWithDelay:1];
                                         
                                      }
                            
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      
                                      NSLog(@"请求失败=%@",error);
                                     
                                      [YJLHUD showErrorWithmessage:@"服务器连接失败"];
                                      [YJLHUD dismissWithDelay:1];
                                     
                                      
                                  }];
                        }
                    };
                    [passViewsure show];
                };
                [passView show];
            }
            
            else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提示"] message:@"您输入的原始密码似乎不对" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                    {
                                                   
                        NSLog(@"再想想看");
                    }];
                
                [alertController addAction:commitAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        };
        
        [oldpassView show];
    }
    
    //    没有支付密码 如何修改密码
    else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您还未设置过支付密码，如果需要请先去设置一下" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置支付密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
                        NSLog(@"需要设置密码");
                        [self openandverify];
                                           
            }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
                        NSLog(@"修改密码取消");
                                           
            }];
        [alertController addAction:cancelAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma  -mark 清除支付密码
-(void)clearPay{
    
    [self GETPay];
    //    有支付密码 判断思路准备清理密码
    if (_Paymentpassword.length > 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"温馨提示"] message:@"您确定要清除支付密码\n如果您不需要可以关闭验证" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
                            oldpassword *oldpassView = [[oldpassword alloc]initSingleBtnView];
                            oldpassView.passWordTextConfirm =^(NSString *text){//点击确定按钮输出密码
                                               
                            if ([text isEqualToString:_Paymentpassword]){
                                
                                [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"密码清除中..."];
                               
                                AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                                manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                                manager.requestSerializer.timeoutInterval = 10.0;
                                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
                                
                                NSDictionary *params = @{
                                                             @"phone"   :[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                                         };
                                NSLog(@"用户ID:%@",params);
                                [manager POST:Hostpaysetword parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                                    
                                    NSString * nillstr = [NSString stringWithFormat:@""];
                                    [formData appendPartWithFormData:[nillstr dataUsingEncoding:NSUTF8StringEncoding] name:@"paypassword"];
                                }
                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                          NSLog(@"请求成功=%@",     responseObject);
                                          NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                          if ([code isEqualToString:@"200"]) {
                                              NSLog(@"200设置成功");
                                              
                                              [[YJLUserDefaults shareObjet]saveObject:@"" forKey:YJLPaymentpassword];
                                               [[YJLUserDefaults shareObjet]saveObject:@"closePay" forKey:YJLPaymentpasswordopen];
                                            
                                              self.title =  @"支付密码已经清除";
                                              Myopenswitch.on = NO;
                                              
                                              [YJLHUD showSuccessWithmessage:@"支付密码已经清除"];
                                              [YJLHUD dismissWithDelay:1];
                                              
                                              
                                          }else{
                                              
                                              NSLog(@"300设置失败");
                                             
                                              [YJLHUD showErrorWithmessage:@"设置失败，请重新设置"];
                                              [YJLHUD dismissWithDelay:1];
                                              
                                          }
                                          
                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                          
                                          NSLog(@"请求失败=%@",error);
                                          [YJLHUD showErrorWithmessage:@"服务器连接失败"];
                                          [YJLHUD dismissWithDelay:1];
                                         
                                          
                                      }];

                                }
                                               
                            else{
                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您输入的原始密码有误，清除失败" preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                                    {
                                
                                                        NSLog(@"确认");
                                                    }];
                                                   
                                                   [alertController addAction:commitAction];
                                                   [self presentViewController:alertController animated:YES completion:nil];
                                               }
                                           };
                                           
                                           [oldpassView show];
                                       }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                NSLog(@"取消清除");
            }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
//    没有支付密码 如何清理密码呢
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"清除提示"] message:@"您还未设置过支付密码，如果需要请先去设置一下" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置支付密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                            NSLog(@"需要设置密码");
                            [self openandverify];
            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                            NSLog(@"取消");
                                           
            }];
        [alertController addAction:cancelAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
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


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}


@end
