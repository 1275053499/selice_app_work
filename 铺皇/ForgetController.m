//
//  ForgetController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ForgetController.h"

@interface ForgetController ()<UITextFieldDelegate>

{
    UITextField *user ;
    UIImageView *userimg;
    UIImageView *userline;
    
    UITextField  *cord;
    UIImageView  *cordimg;
    UIImageView  *cordline;
    
    UIButton *cordbtn;
    
    UIButton *nextbtn;
    
    BOOL  phoneRight;
    
    NSInteger _count;//倒计时
    
    NSString * userid;
    
}
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@end

@implementation ForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"验证账号信息";
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    
    [self build1];
    
    [self buildNotfifet];
}

-(void)build1{

    /***************************账号输入************开始****************/
    user = [self createTextFielfFrame:CGRectMake(60, 84, KMainScreenWidth-25-60, 40) font:[UIFont systemFontOfSize:17.0f] placeholder:@"输入查询账号"];
    user.delegate = self;
    user.textColor = [UIColor lightGrayColor];
    user.keyboardType = UIKeyboardTypeNumberPad;
    user.returnKeyType = UIReturnKeyDone;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    userimg = [self createImageViewFrame:CGRectMake(25,90 ,23, 25) imageName:@"sjzc_dianhua@2x" color:nil];
    
    userline = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(user.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian@2x" color:nil];
    [self.view addSubview:userline];
    [self.view addSubview:user];
    [self.view addSubview:userimg];
    /***************************账号输入************结束****************/
    
    /***************************验证码输入************开始****************/
    cord = [self createTextFielfFrame:CGRectMake(60, CGRectGetMaxY(userline.frame)+5, KMainScreenWidth-125-60, 40) font:[UIFont systemFontOfSize:17.0f] placeholder:@"输入短信验证码"];
    cord.textColor = [UIColor lightGrayColor];
    cord.delegate = self;
    cord.keyboardType = UIKeyboardTypeNumberPad;
    cord.returnKeyType = UIReturnKeyDone;
    cord.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    cordbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cordbtn.frame = CGRectMake(CGRectGetMaxX(cord.frame), CGRectGetMaxY(userline.frame)+5, 100, 35);
    [cordbtn setBackgroundImage:[UIImage imageNamed:@"sjzc_get verification code@2x"] forState:UIControlStateNormal];
    [cordbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    cordbtn.enabled  = NO;
    [cordbtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    
    cordimg = [self createImageViewFrame:CGRectMake(25,CGRectGetMaxY(userline.frame)+5+10 ,23, 20) imageName:@"sjzc_yzm@2x" color:nil];
    
    cordline = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(cord.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian@2x" color:nil];
    
    [self.view addSubview:cord];
    [self.view addSubview:cordline];
    [self.view addSubview:cordimg];
    [self.view addSubview:cordbtn];
    /***************************验证码输入************开始****************/
    
    nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbtn.frame = CGRectMake(25,CGRectGetMaxY(cordline.frame)+60 , KMainScreenWidth-50,35);
    [nextbtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextbtn setBackgroundImage:[UIImage imageNamed:@"sjzc_lansekuang@3x"] forState:UIControlStateNormal];
    nextbtn.enabled = NO;
    nextbtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    nextbtn.layer.cornerRadius = 4.0f;
    nextbtn.layer.borderColor = kTCColor(255, 255, 255).CGColor;
    nextbtn.layer.borderWidth = 1.0f;
    [nextbtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextbtn];
}

#pragma  -mark 下一步按钮事件
-(void)nextClick{
////            验证验证码是否填写正确
            [SMSSDK commitVerificationCode:cord.text phoneNumber:user.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error)
             {
    
                {
                    if (!error){
//
                        NSLog(@"验证成功进入下一步设置新密码");
                        ForgotController *ctl = [[ForgotController alloc]init];
                        ctl.user = user.text;
                        ctl.userID = userid;
                        NSLog(@"跳转页面%@",userid);
                        self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                        [self.navigationController pushViewController:ctl animated:YES];
                        self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    }

                    else
                    {
                        NSLog(@"错误信息:%@",error);
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您输入的验证码不正确，验证码有效时间120秒，再次确认输入" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [alertC addAction:alertAction];
                        [self presentViewController:alertC animated:YES completion:nil];
                    
                    }
                }
            }];
}

#pragma  -mark  发送获取验证码
-(void)sendCode
{
    [user resignFirstResponder];
    NSLog(@"输入内容%@",user.text);
    [self isMobileNumber:user.text];
    
    if (phoneRight != 0){ //号码是手机号

        AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
        manager.responseSerializer          = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
       
        NSDictionary *params = @{@"phone":user.text };
        
        [manager POST:ForgetOnepath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"返---------%@",responseObject);
            NSLog(@"状态  ----%@",responseObject[@"code"]);
            NSString *rescode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            NSLog(@"id号码----%@",responseObject[@"data"][@"id"]);
            NSString *phoneid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"id"]];
            //    后台账号ID
            userid = [[NSString alloc]initWithString:phoneid];
           
            NSLog(@"提示  ----%@",responseObject[@"massign"]);
            
            if ([rescode isEqualToString:@"202"]){//注册过的手机号
                NSLog(@"注册过账号的");
                
                [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:user.text zone:@"+86" customIdentifier:nil result:^(NSError *error){
                    
                    if (!error){
                        
                        NSLog(@"获取验证码成功");
                        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode            = MBProgressHUDModeText;
                        hud.removeFromSuperViewOnHide = YES;
                        hud.labelText       = @"验证码已发送，注意查收";
                        [hud hide:YES afterDelay:2];
                        
                     }
                     else{
                         
                        
                     }
                 }];
                
                [self performSelector:@selector(countClick) withObject:nil];
            }
            
            else if([rescode isEqualToString:@"309"]){  //没有注册过的手机号  309
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该帐号未注册过铺皇网" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"已经看过了我要返回");
                }];
                
                [alertController addAction:commitAction];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
              else if([rescode isEqualToString:@"401"]){
                  NSLog(@"非法操作");
                  
              }
              else{
                  NSLog(@"请正确输入！");
              }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"信息失败----%@",error);
        }];
    }
    else //号码不是手机号
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您输入手机号有误，请确认号码再尝试此操作。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma  -mark  按钮倒计时 1
-(void)countClick{
    
    cordbtn.enabled =NO;
    _count = 60;
    [cordbtn setTitle:@"60秒" forState:UIControlStateDisabled];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}
#pragma  -mark  按钮倒计时 2
-(void)timerFired:(NSTimer *)timer{
    
    if (_count !=1){
        
        _count -=1;
        [cordbtn setTitle:[NSString stringWithFormat:@"%lu秒",_count] forState:UIControlStateDisabled];
    }
    
    else{
        
        [timer invalidate];
        cordbtn.enabled = YES;
        [cordbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

#pragma  -mark return按钮事件处理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [user resignFirstResponder];
    [cord resignFirstResponder];
    return YES;
}


#pragma -mark 判断全字母
- (BOOL)inputShouldLetter:(NSString *)inputString {
    if (inputString.length == 0)return NO;
    
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}
#pragma -mark 判断全数字
- (BOOL)inputShouldNumber:(NSString *)inputString {
    
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}
#pragma -mark 判断全汉字
- (BOOL)inputShouldChinese:(NSString *)inputString {
    
    if (inputString.length == 0) return NO;
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

#pragma -mark判断仅输入字母或数字
- (BOOL)inputShouldLetterOrNum:(NSString *)inputString {
    
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}


#pragma  -mark 通知限制输入字数
-(void)buildNotfifet{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedFOuser:)                                          name:@"UITextFieldTextDidChangeNotification" object:user];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedFOcord:)                                          name:@"UITextFieldTextDidChangeNotification" object:cord];
   }

#pragma mark - UITextFieldDelegate 限制账号字数
-(void)textFiledEditChangedFOuser:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=11 && toBeString.length>0){
        
        textField.text = [toBeString substringToIndex:11];
        
    }
    
    
    #pragma mark    获取电话号码个数 达到了11位数验证码可以按下去
    if (toBeString.length >= 11){
        
        cordbtn.enabled = YES;
    }
    
    else{
        
        cordbtn.enabled = NO;
    }
    
    #pragma mark    获取验证码号码个数 达到了4位数下一步可以按下去
    if (cord.text.length >= 4 && user.text.length == 11 ) {
        
        nextbtn.enabled  = YES;
    }else{
        
        nextbtn.enabled  = NO;
    }
}


#pragma mark - UITextFieldDelegate 限制验证码字数
-(void)textFiledEditChangedFOcord:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=4 && toBeString.length>0){
        
        textField.text = [toBeString substringToIndex:4];
    }
    
    #pragma mark    获取验证码号码个数 达到了4位数下一步可以按下去
    if (cord.text.length >= 4 && user.text.length == 11 ) {
        
        nextbtn.enabled  = YES;
    }else{
        
        nextbtn.enabled  = NO;
    }
}

#pragma -mark 触摸屏幕键盘掉下去
-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    [user resignFirstResponder];
    [cord resignFirstResponder];

}

#pragma -mark 触摸屏幕键盘掉下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [user resignFirstResponder];
    [cord resignFirstResponder];
    
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

- (BOOL)isMobileNumber:(NSString *)mobileNum{
    
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
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
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

#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //    让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
