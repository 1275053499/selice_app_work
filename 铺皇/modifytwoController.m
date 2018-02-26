//
//  modifytwoController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "modifytwoController.h"
@interface modifytwoController ()<UITextFieldDelegate>{
    
    UITextField *newpassword;
    UIImageView *newpasswordimg;
    UIImageView *newline;
    UIButton    *newYCbtn;
    UIButton    *newsure;
}
@end

@implementation modifytwoController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.title = @"设置新密码";
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"传值过来的电话号码：%@",_user   );
    NSLog(@"传值过来的账号ID%@"   ,_userid);
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    [self buildUI1];
    [self  buildNotfi];
}

-(void)buildUI1{
    
    /***************************密码输入************开始****************/
    newpassword = [self createTextFielfFrame:CGRectMake(60, 84, KMainScreenWidth-120, 40) font:[UIFont systemFontOfSize:17.0f] placeholder:@"输入新密码(6-11位)"];
    newpassword.delegate = self;
    newpassword.secureTextEntry = YES;//密文
    newpassword.returnKeyType = UIReturnKeyDone;
    newpassword.textColor = [UIColor lightGrayColor];
    newpassword.keyboardType = UIKeyboardTypeDefault;
    newpassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    [newpassword addTarget:self action:@selector(input:) forControlEvents:UIControlEventEditingChanged];
    newpasswordimg = [self createImageViewFrame:CGRectMake(25,90,23, 25) imageName:@"sjzc_mima@2x" color:nil];
    
    //    密文显示隐藏按钮
    newYCbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newYCbtn.frame = CGRectMake(CGRectGetMaxX(newpassword.frame)+5, 90, 25,25);
    [newYCbtn setImage:[UIImage imageNamed:@"sjzc_biyan"] forState:UIControlStateNormal];
    [newYCbtn setImage:[UIImage imageNamed:@"sjzc_zhengyan"] forState:UIControlStateSelected];
    [newYCbtn addTarget:self action:@selector(newYCclick:) forControlEvents:UIControlEventTouchUpInside];
    
    newline = [self createImageViewFrame:CGRectMake(25, CGRectGetMaxY(newpassword.frame), KMainScreenWidth - 50, 1) imageName:@"sjzc_fenggeixian@2x" color:nil];
    [self.view addSubview:newpassword];
    [self.view addSubview:newpasswordimg];
    [self.view addSubview:newYCbtn];
    [self.view addSubview:newline];

    newsure = [UIButton buttonWithType:UIButtonTypeCustom];
    newsure.frame = CGRectMake(25,CGRectGetMaxY(newline.frame)+20 , KMainScreenWidth-50,35);
    [newsure setTitle:@"修改" forState:UIControlStateNormal];
    [newsure setBackgroundImage:[UIImage imageNamed:@"sjzc_lansekuang@3x"] forState:UIControlStateNormal];
    newsure.enabled = NO;
    newsure.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    newsure.layer.cornerRadius = 4.0f;
    newsure.layer.borderColor = kTCColor(255, 255, 255).CGColor;
    newsure.layer.borderWidth = 1.0f;
    [newsure addTarget:self action:@selector(newsureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newsure];
}

#pragma  -mark 完成修改按钮事件
-(void)newsureClick{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//默认的方式
   
    NSLog(@"%@--%@",self.userid,newpassword.text);
    NSDictionary *params = @{   @"phone"   :self.user,
                                @"id"      :self.userid,
                                @"password":newpassword.text
                             };
//    13163241430 徐静
    [manager POST:ChangeTwopath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"返---------%@",responseObject);
//        NSLog(@"状态  ----%@"  ,responseObject[@"code"]);
        NSString *rescode   = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        NSLog(@"提示  ----%@"  ,responseObject[@"massign"]);
        if ([rescode isEqualToString:@"200"]) {
            NSLog(@"修改成功");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"新密码设置成功！需要重新登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
                NSLog(@"密码修改成功了需要保存数据");
                
                 [[YJLUserDefaults shareObjet]saveObject:self.user forKey:YJLuser];
                 [[YJLUserDefaults shareObjet]saveObject:newpassword.text forKey:YJLpassword];//新密码
                 [[YJLUserDefaults shareObjet]saveObject:@"loginno" forKey:YJLloginstate];//账号登录状态
        
                UIViewController *viewCtl = self.navigationController.viewControllers[0];
                [self.navigationController popToViewController:viewCtl animated:YES];
            }];
    
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if ([rescode isEqualToString:@"201"]){
            
           NSLog(@"和密码相同");
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"新密码设置失败，不能与原始密码一致" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        else if ([rescode isEqualToString:@"301"]){
            
            NSLog(@"修改失败");
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"新密码设置失败，服务器小哥在测试，请稍后...." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }else{
            
            NSLog(@"非法操作");
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"新密码设置失败，服务器小哥在测试，请稍后...." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"信息失败----%@",error);
    }];
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

#pragma -mark 密文按钮事件
-(void)newYCclick:(UIButton *)btn{
    if (!btn.selected) {
        NSLog(@"常见文字");
        newpassword.secureTextEntry = NO;
    }
    else{
        NSLog(@"隐藏文字");
        newpassword.secureTextEntry = YES;
    }
    
    btn.selected = !btn.selected;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangednewpassword:)                                          name:@"UITextFieldTextDidChangeNotification" object:newpassword];
}

#pragma mark - UITextFieldDelegate 限制账号字数
-(void)textFiledEditChangednewpassword:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 >=11 && toBeString.length>0){
        textField.text = [toBeString substringToIndex:11];
    }
    
#pragma mark    获取密码个数 达到了6位数验证码可以按下去
    if (toBeString.length >= 6){
        newsure.enabled = YES;
    }
    else{
        newsure.enabled = NO;
    }
}


#pragma -mark 触摸屏幕键盘掉下去
-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
   
    [newpassword resignFirstResponder];
    
    
}

#pragma -mark 触摸屏幕键盘掉下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [newpassword resignFirstResponder];
    
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
    [super viewWillDisappear:YES];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
