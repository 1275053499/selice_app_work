//
//  LoginController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "LoginController.h"
#import "YJLUserDefaults.h"
@interface LoginController ()<UITextFieldDelegate>{
    UIButton *Backbtn;
    YJLlightlabel  * welcome;
    YJLlightlabel  * life;
    UIView         * midview;
    UITextField    * user;
    UITextField    * password;
    UIImageView *userImageView;
    UIImageView *passwordImageView;
    UIImageView *line1;
    UIImageView *line2;
    UIButton    *YCbtn;
    UIButton    *Loginbtn;
    UIButton    *Registerbtn;
    UIButton    *Forgetbn;
    BOOL         phoneRight;
    NSString *NSuser;       //本地账号
    NSString *NSpassword;   //本地密码
}

@end
@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSuser              = [NSString new];
    NSpassword          = [NSString new];
   

    UIImageView * backimg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backimg.image = [UIImage imageNamed:@"Loginbackgroud"];
    [self.view addSubview:backimg];
    [self.view sendSubviewToBack:backimg];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];

    [self getdata];

    [self buildUI1];
    
    [self buildUI2];
    
    [self buildUI3];
    
    [self buildNotfi];

}
#pragma  -mark  获取登录信息
-(void)getdata{
    
#pragma mark   从本地缓存拿数据
    
    NSuser      =[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser];// [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSpassword  = [[YJLUserDefaults shareObjet]getObjectformKey:YJLpassword];//[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];

//    NSLog(@"账号：%@=密码：%@",NSuser,NSpassword);
}
#pragma  -mark TOP
-(void)buildUI1{
    
    Backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Backbtn.frame = CGRectMake(0, 20, 44, 44);
    [Backbtn setImage:[UIImage imageNamed:@"baise_fanghui"] forState:UIControlStateNormal];
    [Backbtn addTarget:self action:@selector(BackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Backbtn];
    
    welcome             = [[YJLlightlabel alloc] init];
    welcome.frame       = CGRectMake(KMainScreenWidth/2-150, 100, 300, 30);
    welcome.text        = @"欢迎加入铺皇";
    welcome.textColor   = [UIColor whiteColor];       //设置固定颜色
    welcome.font        = [UIFont systemFontOfSize:30.0f];
    welcome.shimmerType     = ST_AutoReverse;
    welcome.shimmerWidth    = 20;                      // 高亮的宽度
    welcome.shimmerRadius   = 20;                     // 阴影的宽度
    [welcome startShimmer];                         // 开启闪烁
    [self.view addSubview:welcome];
    
    life            = [[YJLlightlabel alloc] init];
    life.frame      = CGRectMake(KMainScreenWidth/2-150, 135, 300, 20);
    life.text       = @"互 | 联 | 网 | 生 | 活";
    life.textColor  = [UIColor whiteColor];
    life.font       = [UIFont systemFontOfSize:15.0f];
    life.shimmerType    = ST_AutoReverse;
    life.shimmerWidth   = 20;                      // 高亮的宽度
    life.shimmerRadius  = 20;                     // 阴影的宽度
    [life startShimmer];                         // 开启闪烁
    [self.view addSubview:life];
}

#pragma  -mark MID
-(void)buildUI2{
    
    midview                     =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(life.frame)+100,KMainScreenWidth, 100)];
    midview.layer.cornerRadius  =4.0;
    midview.backgroundColor     =[UIColor clearColor];
    [self.view addSubview:midview];
    
//    账号
    user = [self createTextFielfFrame:CGRectMake(60, 10, KMainScreenWidth-120, 40) font:[UIFont systemFontOfSize:15.0f] placeholder:@"输入您的账号（手机号码）"];
    if (NSuser.length>0){
        
          user.text = NSuser;
    }
    user.keyboardType       =UIKeyboardTypeNumberPad;
    user.clearButtonMode    = UITextFieldViewModeWhileEditing;
    
//    账号左侧图片
    userImageView           =[self createImageViewFrame:CGRectMake(25, 15, 23, 25) imageName:@"user" color:nil];

//    账号下方线条
    line1=[self createImageViewFrame:CGRectMake(25, 50, KMainScreenWidth-50, 1) imageName:nil color:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:.7]];
    [midview addSubview:user];
    [midview addSubview:userImageView];
    [midview addSubview:line1];
    
//    密码
    password=[self createTextFielfFrame:CGRectMake(60, 59, KMainScreenWidth-120, 40) font:[UIFont systemFontOfSize:15.0f] placeholder:@"输入您的账号密码"];
    if (NSpassword.length>0){
        
        password.text = NSpassword;
    }
   
    password.delegate = self;
    password.secureTextEntry = YES;
    password.keyboardType= UIKeyboardTypeDefault;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;

    [midview addSubview:password];
//    密码左侧图片
    passwordImageView=[self createImageViewFrame:CGRectMake(25, 65, 23, 25) imageName:@"password" color:nil];
    [midview addSubview:passwordImageView];
//    密码下方线条
    line2=[self createImageViewFrame:CGRectMake(25, 100, KMainScreenWidth-50, 1) imageName:nil color:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:.7]];
    [midview addSubview:line2];
    
//    密文显示隐藏按钮
    YCbtn               = [UIButton buttonWithType:UIButtonTypeCustom];
    YCbtn.frame         = CGRectMake(CGRectGetMaxX(password.frame)+5,65 , 25,25);
    [YCbtn setImage:[UIImage imageNamed:@"XS"] forState:UIControlStateNormal];
    [YCbtn setImage:[UIImage imageNamed:@"YC"] forState:UIControlStateSelected];
    [YCbtn addTarget:self action:@selector(YCclick:) forControlEvents:UIControlEventTouchUpInside];
    [midview addSubview:YCbtn];
    
    Loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Loginbtn.frame = CGRectMake(25,CGRectGetMaxY(midview.frame)+20 , KMainScreenWidth-50,35);
    [Loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    Loginbtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    Loginbtn.layer.cornerRadius = 4.0f;
    Loginbtn.layer.borderColor = kTCColor(255, 255, 255).CGColor;
    Loginbtn.layer.borderWidth = 1.0f;
    Loginbtn.backgroundColor = [UIColor clearColor];
    [Loginbtn addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Loginbtn];
}

#pragma  -mark  DOWN
-(void)buildUI3{
    
    Registerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Registerbtn.frame = CGRectMake(KMainScreenWidth/5,KMainScreenHeight-84, KMainScreenWidth/5,20);
    [Registerbtn setTitle:@"注册铺皇" forState:UIControlStateNormal];
    Registerbtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    Registerbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    Registerbtn.backgroundColor = [UIColor clearColor];
    [Registerbtn addTarget:self action:@selector(RegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Registerbtn];
    
    Forgetbn = [UIButton buttonWithType:UIButtonTypeCustom];
    Forgetbn.frame = CGRectMake(KMainScreenWidth/5*3,KMainScreenHeight-84 ,KMainScreenWidth/5,20);
    [Forgetbn setTitle:@"忘记密码" forState:UIControlStateNormal];
    Forgetbn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    Forgetbn.titleLabel.adjustsFontSizeToFitWidth = YES;
    Forgetbn.backgroundColor = [UIColor clearColor];
    [Forgetbn addTarget:self action:@selector(ForgetbnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Forgetbn];
}

#pragma -mark 登录按钮事件
-(void)LoginClick{
    
    [user resignFirstResponder];
    [password resignFirstResponder];
    
//    NSLog(@"登录铺皇");
    [self isMobileNumber:user.text];
    if (phoneRight != 0){
        
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode            = MBProgressHUDModeText;
        hud.labelText       = @"登录中...";
        hud.removeFromSuperViewOnHide = YES;
        
        AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
        manager.responseSerializer          = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
        NSDictionary *params = @{
                                     @"phone":user.text,
                                     @"password":password.text
                                 };
        [manager POST:Loginpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){

             NSLog(@"请求数据成功----%@",responseObject);
             NSLog(@"登录状态----   %@",responseObject[@"code"]);
             NSLog(@"登录提示----   %@",responseObject[@"massign"]);
             if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){//验证码成功了
           
                 hud.labelText = @"登录成功";
                 // 1秒之后再消失
                 [hud hide:YES afterDelay:1.0];
                 
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                     NSLog(@"账号密码验证成功");
                     
                     if ([[pershowData shareshowperData]getAllDatas].count>0) {
                         
                         [[pershowData shareshowperData]deletedData];
                         
                     }else{
                         
                     }
//                      NSLog(@"登录的缓存还有没有数据:%ld",[[pershowData shareshowperData]getAllDatas].count);
                     //  本地存数据 账号密码
                     [[YJLUserDefaults shareObjet]saveObject:responseObject[@"data"][@"phone"] forKey:YJLuser];
                     [[YJLUserDefaults shareObjet]saveObject:responseObject[@"data"][@"code"] forKey:YJLpassword];
                     [[YJLUserDefaults shareObjet]saveObject:responseObject[@"data"][@"id"] forKey:YJLuserid];
                     [[YJLUserDefaults shareObjet]saveObject:@"loginyes"forKey:YJLloginstate];
                     
                     
                     NSLog(@"登录成功ID:%@",[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]);
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                     
                         [self.navigationController popViewControllerAnimated:YES];
                        
                     });
                 });
                 
             }
             else if ([[responseObject[@"code"] stringValue] isEqualToString:@"303"]){//密码错误
//                 NSLog(@"密码错误");
        
                 hud.labelText = @"密码错误";
                 // 1秒之后再消失
                 [hud hide:YES afterDelay:1.5];
             }
            
             else if ([[responseObject[@"code"] stringValue] isEqualToString:@"304"]){//密码不能为空
                 hud.labelText = @"密码未填写";
                 [hud hide:YES afterDelay:1.5];
             }

             else{//[rescode isEqualToString:@"305"]

                 [hud hide:YES afterDelay:0];
//                 NSLog(@"手机号未注册");
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"手机号尚未注册" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//                     NSLog(@"点击了确认");
                 }];
                 
                 UIAlertAction *registAction = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//                     NSLog(@"点击了注册");
                     
                     RegisterController *ctl = [[RegisterController alloc]init];
                     
#pragma -mark block传2个值 方法实现
                     [ctl result:^(NSString * uservalue,NSString * passwordvalue){
                         
//                          NSLog(@"账号：%@   密码：%@",uservalue,passwordvalue);
                          user.text       =  uservalue;
                          password.text   =  passwordvalue;
                          
                      }];
                     
                     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                     [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                     
                 }];
                 [alertController addAction:commitAction];
                 [alertController addAction:registAction];
                 [self presentViewController:alertController animated:YES completion:nil];
             }

         } failure:^(NSURLSessionDataTask *task, NSError *error) {
//             NSLog(@"请求数据失败----%@",error);
             
             hud.labelText = @"服务器连接失败";
             // 1秒之后再消失
             [hud hide:YES afterDelay:1.5];
         }];
    }
    
else{
    
        //电话号码不正确
        UIAlertController *alertC   = [UIAlertController alertControllerWithTitle:@"提示" message:@"您输入手机号出错，请确认号码再尝试此操作。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //    电话号码是可用的
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)){
        phoneRight = 1;
        return YES;
    }
    else{
        phoneRight = 0;
        return NO;
    }
}

#pragma -mark 注册按钮事件
-(void)RegisterClick{
    
//     NSLog(@"注册铺皇");
    RegisterController *ctl = [[RegisterController alloc]init];

#pragma -mark block传2个值 方法实现
    [ctl result:^(NSString * uservalue,NSString * passwordvalue){
        
//         NSLog(@"账号：%@   密码：%@",uservalue,passwordvalue);
         user.text       =  uservalue;
         password.text  =  passwordvalue;
     }];
    
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

#pragma -mark 忘记密码按钮事件
-(void)ForgetbnClick{
    
//     NSLog(@"忘记密码");
    ForgetController *ctl = [[ForgetController alloc]init];
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

#pragma -mark 触摸屏幕键盘掉下去  一根或者多根手指开始触摸view（手指按下）
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [user resignFirstResponder];
    [password resignFirstResponder];
}


#pragma -mark 密文按钮事件
-(void)YCclick:(UIButton *)btn{
    if (!btn.selected) {
//        NSLog(@"常见文字");
       password.secureTextEntry = NO;
    }
    else{
//        NSLog(@"隐藏文字");
         password.secureTextEntry = YES;
    }
    
     btn.selected = !btn.selected;
}

#pragma -mark UItextfield 快捷创建UI
-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor whiteColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    
    if (color)
    {
        imageView.backgroundColor=color;
    }
    return imageView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [user resignFirstResponder];
    [password resignFirstResponder];
   
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
   
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 按钮返回
- (void)BackButtonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"已经看过了我要返回");
}

#pragma  -mark 通知限制输入字数
-(void)buildNotfi{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangeduser:)                                          name:@"UITextFieldTextDidChangeNotification" object:user];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedpassword:)                                          name:@"UITextFieldTextDidChangeNotification" object:password];
}

#pragma mark - UITextFieldDelegate 限制账号字数
-(void)textFiledEditChangeduser:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=11 && toBeString.length>1){
        textField.text = [toBeString substringToIndex:11];
    }
}

#pragma mark - UITextFieldDelegate 限制密码字数
-(void)textFiledEditChangedpassword:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >= 11 && toBeString.length>1){
        textField.text = [toBeString substringToIndex:11];
    }
}

#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        welcome.isPlaying = false;
        life.isPlaying = false;
        [welcome startShimmer];
        [life startShimmer];
    });
    //    让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}

@end
