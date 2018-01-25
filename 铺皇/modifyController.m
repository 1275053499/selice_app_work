//
//  modifyController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "modifyController.h"

@interface modifyController ()<UITextFieldDelegate>
{
    UITextField *user ;
    UIImageView *userimg;
    UIImageView *userline;
    
    UITextField  *oldpass;
    UIImageView  *oldpassimg;
    UIImageView  *oldpassline;
    
    UIButton    *oldYCbtn;
    
    UIButton *nextbtn;
    
    BOOL  phoneRight;
    
    NSInteger _count;//倒计时
    
    NSString * userid;
    
}
@property float autoSizeScaleX;
@property float autoSizeScaleY;


@end

@implementation modifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改密码";
    
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
    user = [self createTextFielfFrame:CGRectMake(60, 84, KMainScreenWidth-25-60, 40) font:[UIFont systemFontOfSize:17.0f] placeholder:@"输入账号"];
    user.delegate = self;
    user.textColor = [UIColor lightGrayColor];
    user.keyboardType = UIKeyboardTypeNumberPad;
    user.returnKeyType = UIReturnKeyDone;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    userimg = [self createImageViewFrame:CGRectMake(25,90 ,23, 25) imageName:@"sjzc_dianhua" color:nil];
    
    userline = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(user.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian" color:nil];
    [self.view addSubview:userline];
    [self.view addSubview:user];
    [self.view addSubview:userimg];
    /***************************账号输入************结束****************/
    
    
    /***************************密码输入************开始****************/
    oldpass = [self createTextFielfFrame:CGRectMake(60, CGRectGetMaxY(userline.frame)+5, KMainScreenWidth-120, 40) font:[UIFont systemFontOfSize:17.0f] placeholder:@"输入旧密码"];
    oldpass.delegate = self;
    oldpass.secureTextEntry = YES;//密文
    oldpass.returnKeyType = UIReturnKeyDone;
    oldpass.textColor = [UIColor lightGrayColor];
    oldpass.keyboardType = UIKeyboardTypeDefault;
    oldpass.clearButtonMode = UITextFieldViewModeWhileEditing;
    [oldpass addTarget:self action:@selector(input:) forControlEvents:UIControlEventEditingChanged];
    oldpassimg = [self createImageViewFrame:CGRectMake(25,CGRectGetMaxY(userline.frame)+5+8,23, 25) imageName:@"sjzc_mima@2x" color:nil];
    
    //    密文显示隐藏按钮
    oldYCbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    oldYCbtn.frame = CGRectMake(CGRectGetMaxX(oldpass.frame)+5, CGRectGetMaxY(userline.frame)+5+8, 25,25);
    [oldYCbtn setImage:[UIImage imageNamed:@"sjzc_biyan"] forState:UIControlStateNormal];
    [oldYCbtn setImage:[UIImage imageNamed:@"sjzc_zhengyan"] forState:UIControlStateSelected];
    [oldYCbtn addTarget:self action:@selector(oldYCclick:) forControlEvents:UIControlEventTouchUpInside];
    
    oldpassline = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(oldpass.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian" color:nil];
    [self.view addSubview:oldpass];
    [self.view addSubview:oldYCbtn];
    [self.view addSubview:oldpassimg];
    [self.view addSubview:oldpassline];
    
     /***************************密码输入***********结束****************/
    
    nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbtn.frame = CGRectMake(25,CGRectGetMaxY(oldpassline.frame)+60 , KMainScreenWidth-50,35);
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


#pragma -mark 密文按钮事件
-(void)oldYCclick:(UIButton *)btn{
    if (!btn.selected) {
        NSLog(@"常见文字");
        oldpass.secureTextEntry = NO;
    }
    
    else
    {
        NSLog(@"隐藏文字");
        oldpass.secureTextEntry = YES;
    }
    
    btn.selected = !btn.selected;
}

#pragma -mark 实时获取密码全部内容做处理 屏蔽汉字和空格
- (void)input:(UITextField *)textField{
    
    NSLog(@"密码内容修改前：%@",textField.text);
    for (int i =0; i<textField.text.length; i++){
        
        NSString *chinese = [textField.text substringWithRange:NSMakeRange(i,1)];
        NSLog(@"第%d个字是:%@",i,chinese);
        
        if ([self inputShouldChinese:chinese]||[chinese isEqualToString:@" "]){
            
            textField.text = [textField.text stringByReplacingOccurrencesOfString:chinese withString:@"*"];
        }
    }
    NSLog(@"密码内容修改后：%@",textField.text);
}

#pragma  -mark 下一步按钮事件
-(void)nextClick{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//默认的方式
    NSDictionary *params = @{@"phone":user.text,
                             @"password":oldpass.text};
    
    [manager POST:ChangeOnepath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"返---------%@",responseObject);
//        NSLog(@"状态  ---- %@",responseObject[@"code"]);
        NSString *rescode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        NSLog(@"id号码----%@",responseObject[@"data"][@"id"]);
        //            后台账号ID
        userid= [NSString stringWithFormat:@"%@",responseObject[@"data"][@"id"]];
//        NSLog(@"提示  ----%@",responseObject[@"massign"]);
        
        if ([rescode isEqualToString:@"201"]) {
            
//            NSLog(@"密码与数据库一致");
//            NSLog(@"验证成功进入下一步设置新密码");
           
            modifytwoController *ctl = [[modifytwoController alloc]init];
            ctl.userid  = userid;
            ctl.user    = user.text;
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            [self.navigationController pushViewController:ctl animated:YES];
            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
        
        else if ([rescode isEqualToString:@"308"]){
             NSLog(@"密码与数据库不一致");
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的密码或者账号输入不正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        else if ([rescode isEqualToString:@"309"]){
            
            NSLog(@"账号不存在");
        }else{
            
            NSLog(@"非法操作");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"信息失败----%@",error);
    }];
    
}

//     13163241430

#pragma  -mark return按钮事件处理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [user resignFirstResponder];
    [oldpass resignFirstResponder];
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
-(void)buildNotfifet
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedFOuser:)                                          name:@"UITextFieldTextDidChangeNotification" object:user];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedFOcord:)                                          name:@"UITextFieldTextDidChangeNotification" object:oldpass];
}

#pragma mark - UITextFieldDelegate 限制账号字数
-(void)textFiledEditChangedFOuser:(NSNotification *)obj
{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=11 && toBeString.length>0)
    {
        textField.text = [toBeString substringToIndex:11];
        
    }
    
#pragma mark    获取验证码号码个数 达到了4位数下一步可以按下去
    if (oldpass.text.length >= 6 && user.text.length == 11 ) {
        nextbtn.enabled  = YES;
    }
    else
    {
        nextbtn.enabled  = NO;
    }
}

#pragma mark - UITextFieldDelegate 限制验证码字数
-(void)textFiledEditChangedFOcord:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=11 && toBeString.length>0)
    {
        textField.text = [toBeString substringToIndex:11];
    }
    
#pragma mark    获取验证码号码个数 达到了4位数下一步可以按下去
    if (oldpass.text.length >= 6 && user.text.length == 11 ) {
        nextbtn.enabled  = YES;
    }else{
        nextbtn.enabled  = NO;
    }
}


#pragma -mark 触摸屏幕键盘掉下去
-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    
    [user resignFirstResponder];
    [oldpass resignFirstResponder];
    
    
}

#pragma -mark 触摸屏幕键盘掉下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [user resignFirstResponder];
    [oldpass resignFirstResponder];
    
}

#pragma -mark UItextfield 快捷创建UI
-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor whiteColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}


-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
