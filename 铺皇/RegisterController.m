//
//  RegisterController.m
//  铺皇
//
//  Created by 铺皇网 on 2014/7/19.
//  Copyright © 2014年 中国铺皇. All rights reserved.
//

#import "RegisterController.h"
#import "ZYKeyboardUtil.h"
#define MARGIN_KEYBOARD 10
@interface RegisterController ()<UITextFieldDelegate,UITextViewDelegate>{
    
    UIImageView *   userImageView;
    UIImageView *   line1;
    UIImageView *   messageimageview;
    UIImageView *   line2;
    UIButton    *   havecord;//获取验证码
    
   
    UIImageView *   passwordImageView;
    UIButton    *   YCbtn;//密码隐藏
    UIImageView *   line3;
    
    
    UIImageView   * surepasswordImageView;
    UIButton      * sureYCbtn;//再次密码隐藏
    UIImageView   * line4;
    
    UIImageView   * line5;
    
    UIImageView   * linesafe1;         //安全信号条
    UIImageView   * linesafe2;
    UIImageView   * linesafe3;
    UILabel       * safetitle1;
    UILabel       * safetitle2;
    UILabel       * safetitle3;
    
    BOOL                phoneRight;
    NSInteger           _count;               //倒计时
    
    NSInteger           _countnumber;         //数字个数
    NSInteger           _countletter;         //字母个数
    NSInteger           _countother;          //字符个数
    UIButton        * Register;         //完成注册
    UITextView      * protocolTextView ; //协议按钮
 
    UIButton        *  Chooseprotolbtn;            //协议勾选按钮
    UILabel         *  Chooseprotollab;            //协议勾选标题
    UIButton        *  protolbtn;                  //协议按钮
    
}

@property (nonatomic,strong)    UITextField     *   codeInput;//再次输入密码
@property (nonatomic,strong)    UILabel         *   codeTS; //邀请码
@property (nonatomic,strong)    UITextField     *   surepassword;//再次输入密码
@property (nonatomic,strong)    UITextField     *   password;//密码
@property (nonatomic,strong)    UITextField     *   message;//验证码
@property (nonatomic,strong)    UITextField     *   user;//账号


@property float autoSizeScaleX;
@property float autoSizeScaleY;

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@end

@implementation RegisterController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册铺皇网";
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;

    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    [self buildUI1];
    
    [self buildNotfi];
    
}

/*
    UITextField * user;//账号
    UITextField * cord;//验证码
    UITextField * password;//密码
    UIButton    * havecord;//获取验证码
    UIButton    * YCbtn;//密码隐藏
    UIButton    * sure;//完成注册
*/
-(void)buildUI1{
    
/***************************账号输入************开始****************/
    _user = [self createTextFielfFrame:CGRectMake(60, 84, KMainScreenWidth-25-60, 40) font:[UIFont systemFontOfSize:14.0f] placeholder:@"输入手机号码"];
    _user.delegate = self;
    _user.textColor = [UIColor lightGrayColor];
    _user.keyboardType = UIKeyboardTypeNumberPad;
    _user.returnKeyType = UIReturnKeyDone;
    _user.clearButtonMode = UITextFieldViewModeWhileEditing;
    userImageView = [self createImageViewFrame:CGRectMake(25,90 ,23, 25) imageName:@"sjzc_dianhua@2x" color:nil];
    line1 = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(_user.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian@2x" color:nil];
    
    [self.view addSubview:line1];
    [self.view addSubview:_user];
    [self.view addSubview:userImageView];
/***************************账号输入************结束****************/
    
/***************************验证码输入************开始****************/
    _message                    = [self createTextFielfFrame:CGRectMake(60, CGRectGetMaxY(line1.frame)+5, KMainScreenWidth-125-60, 40) font:[UIFont systemFontOfSize:14.0f] placeholder:@"输入短信验证码"];
    _message.textColor          = [UIColor lightGrayColor];
    _message.delegate           = self;
    _message.keyboardType       = UIKeyboardTypeNumberPad;
    _message.returnKeyType      = UIReturnKeyDone;
    _message.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    havecord = [UIButton buttonWithType:UIButtonTypeCustom];
    havecord.frame = CGRectMake(CGRectGetMaxX(_message.frame), CGRectGetMaxY(line1.frame)+5, 100, 35);
    [havecord setBackgroundImage:[UIImage imageNamed:@"sjzc_get verification code@2x"] forState:UIControlStateNormal];
    [havecord setTitle:@"获取验证码" forState:UIControlStateNormal];
    havecord.enabled = NO;
    [havecord addTarget:self action:@selector(RegissendCode) forControlEvents:UIControlEventTouchUpInside];
    
    messageimageview = [self createImageViewFrame:CGRectMake(25,CGRectGetMaxY(line1.frame)+5+10 ,23, 20) imageName:@"sjzc_yzm@2x" color:nil];
    
    line2 = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(_message.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian@2x" color:nil];
    
    [self.view addSubview:messageimageview];
    [self.view addSubview:_message];
    [self.view addSubview:line2];
    [self.view addSubview:havecord];
/***************************验证码输入************开始****************/
    
    
/***************************密码输入************开始****************/
    _password = [self createTextFielfFrame:CGRectMake(60, CGRectGetMaxY(line2.frame)+5, KMainScreenWidth-120, 40) font:[UIFont systemFontOfSize:14.0f] placeholder:@"设置账号密码(6-11位)"];
    _password.delegate           = self;
    _password.secureTextEntry    = YES;//密文
    _password.returnKeyType      = UIReturnKeyDone;
    _password.textColor          = [UIColor lightGrayColor];
    _password.keyboardType       = UIKeyboardTypeDefault;
    _password.clearButtonMode    = UITextFieldViewModeWhileEditing;
    [_password addTarget:self action:@selector(input:) forControlEvents:UIControlEventEditingChanged];
    passwordImageView           = [self createImageViewFrame:CGRectMake(25,CGRectGetMaxY(line2.frame)+5+8,23, 25) imageName:@"sjzc_mima@2x" color:nil];
    
    //    密文显示隐藏按钮
    YCbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    YCbtn.frame = CGRectMake(CGRectGetMaxX(_password.frame)+5, CGRectGetMaxY(line2.frame)+5+8, 25,25);
    [YCbtn setImage:[UIImage imageNamed:@"sjzc_biyan"] forState:UIControlStateNormal];
    [YCbtn setImage:[UIImage imageNamed:@"sjzc_zhengyan"] forState:UIControlStateSelected];
    [YCbtn addTarget:self action:@selector(YCclick:) forControlEvents:UIControlEventTouchUpInside];
    
    line3 = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(_password.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian@2x" color:nil];
    [self.view addSubview:YCbtn];
    [self.view addSubview:line3];
    [self.view addSubview:passwordImageView];
    [self.view addSubview:_password];
    
/***************************密码输入***************结束****************/
    
/***************************再次密码输入************开始****************/
    _surepassword = [self createTextFielfFrame:CGRectMake(60, CGRectGetMaxY(line3.frame)+5, KMainScreenWidth-120, 40) font:[UIFont systemFontOfSize:14.0f] placeholder:@"再次输入账号密码"];
    _surepassword.delegate          = self;
    _surepassword.secureTextEntry   = YES;//密文
    _surepassword.returnKeyType     = UIReturnKeyDone;
    _surepassword.textColor         = [UIColor lightGrayColor];
    _surepassword.keyboardType      = UIKeyboardTypeDefault;
    _surepassword.clearButtonMode   = UITextFieldViewModeWhileEditing;
    [_surepassword addTarget:self action:@selector(input:) forControlEvents:UIControlEventEditingChanged];
    surepasswordImageView = [self createImageViewFrame:CGRectMake(25,CGRectGetMaxY(line3.frame)+5+8,23, 25) imageName:@"sjzc_mima@2x" color:nil];
/***************************再次密码输入***************结束****************/
/***************************密文按钮密码输入************开始****************/
    sureYCbtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    sureYCbtn.frame     = CGRectMake(CGRectGetMaxX(_password.frame)+5, CGRectGetMaxY(line3.frame)+5+8, 25,25);
    
    [sureYCbtn setImage:[UIImage imageNamed:@"sjzc_zhengyan"] forState:UIControlStateSelected];
    [sureYCbtn setImage:[UIImage imageNamed:@"sjzc_biyan"   ] forState:UIControlStateNormal];
    
    [sureYCbtn addTarget:self action:@selector(sureYCclick:) forControlEvents:UIControlEventTouchUpInside];
    line4 = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(_surepassword.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian@2x" color:nil];
    [self.view addSubview:sureYCbtn];
    [self.view addSubview:line4];
    [self.view addSubview:surepasswordImageView];
    [self.view addSubview:_surepassword];
/***************************密文按钮密码输入************end****************/
    
    //    邀请码TS
    _codeTS                  =      [[UILabel alloc]init];
    _codeTS .text            =      @"邀请码:";
    _codeTS.textColor        =      [UIColor blackColor];
    _codeTS.font             =      [UIFont systemFontOfSize:14.0f];
    _codeTS.frame            = CGRectMake(25, CGRectGetMaxY(line4.frame)+10, 50,25);
    [self.view addSubview:_codeTS];
    
    //    邀请码
    _codeInput                      = [[UITextField alloc]init];
    _codeInput.placeholder          = @"输入邀请码,可以让朋友获取积分哦";
    _codeInput.font                 = [UIFont systemFontOfSize:14.0f];
    _codeInput.textAlignment        = NSTextAlignmentLeft;
    _codeInput.delegate             = self;
    _codeInput.returnKeyType        = UIReturnKeyDone;
    _codeInput.textColor            = [UIColor lightGrayColor];
    _codeInput.clearButtonMode      = UITextFieldViewModeWhileEditing;
    _codeInput.frame                = CGRectMake(CGRectGetMaxX(_codeTS.frame), CGRectGetMaxY(line4.frame)+10, KMainScreenWidth-100,25);
    [self.view addSubview:_codeInput];
    
    line5 = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(_codeInput.frame)+5, KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian@2x" color:nil];
    [self.view addSubview:line5];
    
/**************************** 是否遵守协议按钮****************start*********/
    Chooseprotolbtn                     = [[UIButton alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(line5.frame)+10, 17, 17)];
    Chooseprotolbtn.layer.borderWidth   = 1.0f;
    Chooseprotolbtn.layer.borderColor   = [[UIColor grayColor]CGColor];
    Chooseprotolbtn.layer.cornerRadius  = 2;
    [Chooseprotolbtn addTarget:self action:@selector(protolAction1:) forControlEvents:UIControlEventTouchUpInside];
    [Chooseprotolbtn setBackgroundImage:[UIImage imageNamed:@"dc.png"] forState:UIControlStateSelected];
    Chooseprotolbtn.layer.borderWidth   = 1.0f;
    Chooseprotolbtn.layer.borderColor   = [[UIColor grayColor]CGColor];
    Chooseprotolbtn.layer.cornerRadius  = 2;
    [self.view addSubview:Chooseprotolbtn];
    
    Chooseprotollab= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Chooseprotolbtn.frame)+2, CGRectGetMaxY(line5.frame)+10, KMainScreenWidth-45-20, Chooseprotolbtn.frame.size.height)];
    Chooseprotollab.text            = @"同意注册铺皇网遵守《铺皇网用户协议》";
    Chooseprotollab.textAlignment   = NSTextAlignmentLeft;
    Chooseprotollab.font            = [UIFont systemFontOfSize:12.0f];
    Chooseprotollab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:Chooseprotollab];
///**************************** 是否遵守协议按钮****************end*********/
/***************************注册按钮************start****************/
    
    Register                        = [UIButton buttonWithType:UIButtonTypeCustom];
    Register.frame                  = CGRectMake(25,CGRectGetMaxY(Chooseprotolbtn.frame)+ 10 , KMainScreenWidth-50,35);
    [Register setTitle:@"注 册" forState:UIControlStateNormal];
    [Register setBackgroundImage:[UIImage imageNamed:@"sjzc_lansekuang@3x"] forState:UIControlStateNormal];
    Register.enabled                = NO;
    Register.titleLabel.font        = [UIFont systemFontOfSize:14.0f];
    Register.layer.cornerRadius     = 4.0f;
    Register.layer.borderColor      = kTCColor(255, 255, 255).CGColor;
    Register.layer.borderWidth      = 1.0f;
    [Register addTarget:self action:@selector(RegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Register];

/***************************安全信号条************开始****************/
    //安全信号条
    linesafe1                   = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(Register.frame)+5, (KMainScreenWidth-50)/3*1, 2) imageName:nil color:kTCColor(255, 0, 0)];
    linesafe1.hidden            = YES;
    [self.view addSubview:linesafe1];
    
    linesafe2                   = [self createImageViewFrame:CGRectMake(25+(KMainScreenWidth-50)/3*1, CGRectGetMaxY(Register.frame)+5, (KMainScreenWidth-50)/3, 2) imageName:nil color:kTCColor(50, 150, 240)];
    linesafe2.hidden            = YES;
    [self.view addSubview:linesafe2];
    
    linesafe3                   = [self createImageViewFrame:CGRectMake(25+(KMainScreenWidth-50)/3*2, CGRectGetMaxY(Register.frame)+5, (KMainScreenWidth-50)/3, 2) imageName:nil color:kTCColor(0, 255, 0)];
    linesafe3.hidden            = YES;
    [self.view addSubview:linesafe3];
    
    /***************************安全信号条************结束****************/

    /***************************安全title************开始****************/
    safetitle1              = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(linesafe3.frame)+5, (KMainScreenWidth-50)/3, 15)];
    safetitle1.text         = @"低级";
    safetitle1.font         = [UIFont systemFontOfSize:12.0f];
    safetitle1.textColor    = kTCColor(255, 0, 0);
    safetitle1.hidden       = YES;
    safetitle1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:safetitle1];
    
    safetitle2              = [[UILabel alloc]initWithFrame:CGRectMake(25+(KMainScreenWidth-50)/3*1, CGRectGetMaxY(linesafe3.frame)+5, (KMainScreenWidth-50)/3, 15)];
    safetitle2.text         = @"中级";
    safetitle2.font         = [UIFont systemFontOfSize:12.0f];
    safetitle2.textColor    = kTCColor(50, 150, 240);
    safetitle2.hidden       = YES;
    safetitle2.textAlignment= NSTextAlignmentCenter;
    [self.view addSubview:safetitle2];
    
    safetitle3              = [[UILabel alloc]initWithFrame:CGRectMake(25+(KMainScreenWidth-50)/3*2, CGRectGetMaxY(linesafe3.frame)+5, (KMainScreenWidth-50)/3, 15)];
    safetitle3.text         = @"高级";
    safetitle3.font         = [UIFont systemFontOfSize:12.0f];
    safetitle3.textAlignment= NSTextAlignmentCenter;
    safetitle3.textColor    = kTCColor(0, 255, 0);
    safetitle3.hidden       = YES;
    [self.view addSubview:safetitle3];
    /***************************安全title************结束****************/

//    协议
    protolbtn                           = [UIButton buttonWithType:UIButtonTypeCustom];
    protolbtn.frame                     = CGRectMake(KMainScreenWidth/2-50, KMainScreenHeight - 64, 100, 20);
    [protolbtn setTitle:@"<<铺皇网用户协议>>" forState:UIControlStateNormal];
    [protolbtn setBackgroundColor:[UIColor clearColor]];
    [protolbtn addTarget:self action:@selector(protolAction2:) forControlEvents:UIControlEventTouchUpInside];
    [protolbtn setTitleColor:kTCColor(77, 166, 214) forState:UIControlStateNormal];
    protolbtn.titleLabel.font           = [UIFont systemFontOfSize:10.0f];
    protolbtn.titleLabel.textAlignment  = NSTextAlignmentCenter;
    
    [self.view addSubview:protolbtn];
    
     [self configKeyBoardRespond];
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak RegisterController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.user, weakSelf.password, weakSelf.surepassword, weakSelf.codeInput,weakSelf.message, nil];
    }];
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

#pragma  - mark 勾选遵守协议
-(void)protolAction1:(UIButton *)btn{
    
    Chooseprotolbtn.selected = !Chooseprotolbtn.selected;
    
    if (Chooseprotolbtn.selected){
        
        Chooseprotolbtn.layer.borderWidth = 0;
    }
    else{
        
        Chooseprotolbtn.layer.borderWidth = 1;
    }
}
#pragma  - mark 铺皇网协议按钮
-(void)protolAction2:(UIButton *)btn{
    
    WebsetController *ctl = [[WebsetController alloc]init];
//          ctl.url =@"https://www.xw18.cn/h5/serviceTerms";
    ctl.url =@"https://ph.chinapuhuang.com";//注册协议
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

#pragma -mark 实时获取密码全部内容做处理 屏蔽汉字和空格
- (void)input:(UITextField *)textField
{
    NSLog(@"密码内容修改前：%@",textField.text);
    
    for (int i =0; i<textField.text.length; i++){
        
        NSString *chinese = [textField.text substringWithRange:NSMakeRange(i,1)];
        NSLog(@"第%d个字是:%@",i,chinese);
        
        if ([self inputShouldChinese:chinese]||[chinese isEqualToString:@" "])
        {
           
            
            textField.text = [textField.text stringByReplacingOccurrencesOfString:chinese withString:@"*"];
        }
    }
   NSLog(@"密码内容修改后：%@",textField.text);
}

#pragma -mark 密文按钮事件
-(void)YCclick:(UIButton *)btn{
    if (!btn.selected) {
        NSLog(@"常见文字");
        _password.secureTextEntry = NO;
    }
    else{
        NSLog(@"隐藏文字");
        _password.secureTextEntry = YES;
    }
    
    btn.selected = !btn.selected;
}

#pragma -mark 密文按钮事件
-(void)sureYCclick:(UIButton *)btn{
    if (!btn.selected) {
        NSLog(@"常见文字");
        _surepassword.secureTextEntry = NO;
    }
    else{
        NSLog(@"隐藏文字");
        _surepassword.secureTextEntry = YES;
    }
    
    btn.selected = !btn.selected;
}

#pragma -mark 发送请求验证码 1
-(void)RegissendCode{
    
    [_user resignFirstResponder];
    NSLog(@"输入内容%@",_user.text);

    [self isMobileNumber:_user.text];
    //电话号码正确
    if (phoneRight != 0){
        
//        发送网络请求判断当前号码是否可以注册
        [self haveregister];
        
    }
    
    //电话号码出错
    else{
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您输入手机号出错，请确认号码再尝试此操作。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma -mark 发送网络判断号码是否已经注册过
-(void)haveregister{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//默认的方式
    
    NSDictionary *params = @{@"phone":_user.text,
                             @"password":_password.text};
    
    [manager POST:Registpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"发送验证码注册状态----%@",responseObject[@"code"]);
        NSString *rescode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSLog(@"发送验证码注册提示----%@",responseObject[@"massign"]);
        
//       NSString *code = @"202";//没有注册过电话号码
        if ([rescode isEqualToString:@"202"]){
            
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_user.text zone:@"+86" customIdentifier:nil result:^(NSError *error)
             {
                 if (!error){
                     
                     NSLog(@"获取验证码成功");
                    
                     MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode            = MBProgressHUDModeText;
                     hud.labelText       = @"验证码已发送";
                     hud.removeFromSuperViewOnHide = YES;
                     [hud hide:YES afterDelay:1.5];
                 }
                 
                 else{
                     
                     NSLog(@"错误信息：%@",error);
                     MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode            = MBProgressHUDModeText;
                     hud.labelText       = [NSString stringWithFormat:@"%@",error];
                     hud.removeFromSuperViewOnHide = YES;
                     [hud hide:YES afterDelay:1.5];
                 }
             }];
            
            [self performSelector:@selector(countClick) withObject:nil];
        }
        else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的手机号已经注册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSLog(@"点击了确认返回去");
              
            }];
            
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode            = MBProgressHUDModeText;
        hud.labelText       = [NSString stringWithFormat:@"%@",error];
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }];
}

#pragma -mark 发送请求验证码 2
-(void)countClick{
    
    havecord.enabled =NO;
    _count = 60;
    [havecord setTitle:@"60秒" forState:UIControlStateDisabled];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

#pragma -mark 发送请求验证码 3
-(void)timerFired:(NSTimer *)timer
{
    if (_count !=1) {
        _count -=1;
        [havecord setTitle:[NSString stringWithFormat:@"%ld秒",_count] forState:UIControlStateDisabled];
    }
    else
    {
        [timer invalidate];
        havecord.enabled = YES;
        [havecord setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


#pragma -mark  注册铺皇按钮事件
-(void)RegisterClick{
    
    if (Chooseprotolbtn.selected){   //勾选了协议
        
//                验证验证码是否填写正确
                [SMSSDK commitVerificationCode:_message.text phoneNumber:_user.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {{
                    NSLog(@"注册按钮点击后error:%@",error);
                    if (!error){
                        
                            NSLog(@"验证成功");
                            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
                            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
                            manager.requestSerializer.timeoutInterval = 10.0;
                            NSDictionary *params = @{
                                                          @"phone"    :_user.text,
                                                          @"password" :_password.text,
                                                          @"code"     :_codeInput.text
                                                     };
                            
                        [manager POST:Registpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
                                NSLog(@"注册铺皇按钮请求数据成功----%@",responseObject);
                                NSLog(@"注册铺皇按钮注册状态----   %@",responseObject[@"code"]);
                                NSLog(@"注册铺皇按钮注册提示----   %@",responseObject[@"massign"]);
                        
                        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){//验证码成功了
                            
                             NSLog(@"注册铺皇按钮注册成功");
                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册成功！" preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                                    NSLog(@"点击了确认");
                            
                                                    [self registerSuccess];//注册成功后调用  保存数据
                                            }];
                                     
                                     [alertController addAction:commitAction];
                                     [self presentViewController:alertController animated:YES completion:nil];
                                     
                                 }
                        else{
                                     NSLog(@"注册失败");
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = @"注册失败，请重新注册";
                            hud.removeFromSuperViewOnHide = YES;
                            [hud hide:YES afterDelay:1.0];
                                }
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                NSLog(@"请求数据失败----%@",error);
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                hud.mode = MBProgressHUDModeText;
                                hud.labelText = @"网络连接失败";
                                hud.removeFromSuperViewOnHide = YES;
                                [hud hide:YES afterDelay:1.0];
                                
                            }];
                           
                        }

                        else{
                            
//                            验证码失败了
                            NSLog(@"错误信息:%@",error);
                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您输入的验证码不正确，验证码有效时间120秒，再次确认输入" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                            
                    
                            [alertC addAction:alertAction];
                            [self presentViewController:alertC animated:YES completion:nil];
                        }
                    }
                }];
    }

    else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"如果您确定注册铺皇网平台\n请先同意铺皇网协议";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }
}

#pragma  -mark  注册成功 存储账号密码数据
-(void)registerSuccess{
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
}

-(void)delayMethod{
    
#pragma mark 本地存数据 账号密码
    
    //  本地存数据 账号密码
    [[YJLUserDefaults shareObjet]saveObject:_user.text forKey:YJLuser];
    [[YJLUserDefaults shareObjet]saveObject:_password.text forKey:YJLpassword];
    [[YJLUserDefaults shareObjet]saveObject:@"registeryes" forKey:YJLregisterstate];
    [[YJLUserDefaults shareObjet]saveObject:@"loginno" forKey:YJLloginstate];
    
    NSLog(@"登录状态%@",[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate]);
    NSLog(@"注册状态%@",[[YJLUserDefaults shareObjet]getObjectformKey:YJLregisterstate]);
    NSLog(@"密码%@",[[YJLUserDefaults shareObjet]getObjectformKey:YJLpassword]);
    NSLog(@"账号%@",[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser]);
    
#pragma -mark block传值回去1

            if(_value){
                
                self.value(_user.text, _password.text);
            }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark block传值代理方法2
-(void)result:(returnvalue)value{
    
    _value = value;
}

#pragma  -mark - return键事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_user resignFirstResponder];
    [_password resignFirstResponder];
    [_message resignFirstResponder];
    [_surepassword resignFirstResponder];
    [_codeInput resignFirstResponder];
    return YES;
}


#pragma  -mark 输入密码判断密码安全强度
-(void)safeHUD
{
    if (_password.text.length < 6)
    {
        linesafe1.hidden    = YES;
        linesafe2.hidden    = YES;
        linesafe3.hidden    = YES;
        safetitle1.hidden   = YES;
        safetitle2.hidden   = YES;
        safetitle3.hidden   = YES;
    }
    
    else{  //   surepassword.text.length > 6
        //有3个等于0 没有输入密码
        if (_countother == 0&&_countletter ==0 &&_countnumber == 0)
        {
            linesafe1.hidden    = YES;
            linesafe2.hidden    = YES;
            linesafe3.hidden    = YES;
            safetitle1.hidden   = YES;
            safetitle2.hidden   = YES;
            safetitle3.hidden   = YES;
            NSLog(@"没有输入密码");
        }
        
        //有2个等于0 低级安全
        if ((_countother == 0&&_countletter == 0&&_countnumber!=0)||(_countletter == 0 && _countnumber == 0&&_countother!=0)||(_countother == 0 && _countnumber == 0&&_countletter!=0)) {
            
            linesafe1.hidden    = NO;
            linesafe2.hidden    = YES;
            linesafe3.hidden    = YES;
            safetitle1.hidden   = NO;
            safetitle2.hidden   = YES;
            safetitle3.hidden   = YES;
            NSLog(@"低级安全");
        }
        
        //有1个等于0 中级安全
        if ((_countother != 0&&_countletter != 0&& _countnumber)||(_countletter != 0 && _countnumber != 0&&_countother==0)||(_countother != 0 && _countnumber != 0&&_countletter==0))
        {
            linesafe1.hidden    = NO;
            linesafe2.hidden    = NO;
            linesafe3.hidden    = YES;
            safetitle1.hidden   = YES;
            safetitle2.hidden   = NO;
            safetitle3.hidden   = YES;
            NSLog(@"中级安全");
        }
        
        //有0个等于0 高级安全
        if (_countother != 0&&_countletter !=0 &&_countnumber != 0){
            linesafe1.hidden    = NO;
            linesafe2.hidden    = NO;
            linesafe3.hidden    = NO;
            safetitle1.hidden   = YES;
            safetitle2.hidden   = YES;
            safetitle3.hidden   = NO;
            NSLog(@"高级安全");
        }

    }
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
-(void)buildNotfi{
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZCuser:)                                          name:@"UITextFieldTextDidChangeNotification" object:_user];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZCmessage:)                                          name:@"UITextFieldTextDidChangeNotification" object:_message];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZCpassword:)                                          name:@"UITextFieldTextDidChangeNotification" object:_password];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZCsurepassword:)                                          name:@"UITextFieldTextDidChangeNotification" object:_surepassword];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedZCcodeiInput:)                                          name:@"UITextFieldTextDidChangeNotification" object:_codeInput];
}

#pragma mark - UITextFieldDelegate 限制邀请码字数
-(void)textFiledEditChangedZCcodeiInput:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=8 && toBeString.length>0)
    {
        textField.text = [toBeString substringToIndex:8];
    }

}

#pragma mark - UITextFieldDelegate 限制账号字数
-(void)textFiledEditChangedZCuser:(NSNotification *)obj
{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=11 && toBeString.length>0)
    {
        textField.text = [toBeString substringToIndex:11];
    }
    
#pragma mark    获取电话号码个数 达到了11位数验证码可以按下去
    if (toBeString.length >= 11)
    {
        havecord.enabled = YES;
    }
    
    else
    {
        havecord.enabled = NO;
        
    }
     #pragma mark 注册按钮可以使用的判断
    if ((_user.text.length == 11)&&(_message.text.length == 4) && (_password.text.length >=6) &&( _surepassword.text.length >= 6)&&
        
        ([_surepassword.text isEqualToString:_password.text]))
    {
       
        Register.enabled = YES;
    }else{
        Register.enabled = NO;
    }
    
}

#pragma mark - UITextFieldDelegate 限制验证码字数
-(void)textFiledEditChangedZCmessage:(NSNotification *)obj{
     #pragma mark 注册按钮可以使用的判断
    if ((_user.text.length == 11)&&(_message.text.length == 4) && (_password.text.length >=6) &&( _surepassword.text.length >= 6)&&([_surepassword.text isEqualToString:_password.text]))
    {
       
        Register.enabled = YES;
    }else{
        Register.enabled = NO;
    }
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=4 && toBeString.length>0)
    {
        textField.text = [toBeString substringToIndex:4];
    }
}

#pragma mark - UITextFieldDelegate 限制密码字数
-(void)textFiledEditChangedZCpassword:(NSNotification *)obj{
    
     #pragma mark 注册按钮可以使用的判断
    if ((_user.text.length == 11)&&(_message.text.length == 4) && (_password.text.length >=6) &&( _surepassword.text.length >= 6)&&([_surepassword.text isEqualToString:_password.text])){
        Register.enabled = YES;
    }
    else{
        Register.enabled = NO;
    }
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if (toBeString.length > 11 && toBeString.length>0){
        
        textField.text = [toBeString substringToIndex:11];
    }
    
    _countnumber = 0;
    _countletter = 0;
    _countother  = 0;
    if (textField == _password){
        
        for (int i =0; i<textField.text.length; i++){
            
            NSString *chinese = [textField.text substringWithRange:NSMakeRange(i,1)];
            NSLog(@"第%d个字是:%@",i,chinese);
            
            if ([self inputShouldLetter:chinese]){
                
                NSLog(@"是字母");
                //字母个数
                _countletter +=1;
            }
            
            if ([self inputShouldNumber:chinese]){
                //数字个数
                _countnumber +=1;
                NSLog(@"是数字");
            }
        }
        //字符个数
        _countother = _password.text.length - _countletter - _countnumber;
        NSLog(@"字母%ld-数字%ld-字符%ld",_countletter,_countnumber,_countother);
        //输入密码判断密码安全强度
        [self safeHUD];
    }

}

#pragma mark - UITextFieldDelegate 限制确认密码字数
-(void)textFiledEditChangedZCsurepassword:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if (toBeString.length > 11 && toBeString.length>6)
    {
        textField.text = [toBeString substringToIndex:11];
    }
    
    #pragma mark 注册按钮可以使用的判断
    if ((_user.text.length == 11)&&(_message.text.length == 4) && (_password.text.length >=6) &&( _surepassword.text.length >= 6)&&([_surepassword.text isEqualToString:_password.text])){

        Register.enabled = YES;
    }
    else{
        Register.enabled = NO;
    }
}

#pragma -mark 触摸屏幕键盘掉下去 一根或者多根手指开始触摸view（手指按下）
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
    [_user resignFirstResponder];
    [_password resignFirstResponder];
    [_message resignFirstResponder];
    [_surepassword resignFirstResponder];
    [_codeInput resignFirstResponder];
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
    
    if (imageName){
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color){
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
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[014-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     14         */
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
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        phoneRight = 1;
        return YES;
    }
    else
    {
        phoneRight = 0;
        return NO;
    }
}

#pragma  -mark - 返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
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

- (void)dealloc {
    

    NSLog(@"i am dealloc");
}
@end
