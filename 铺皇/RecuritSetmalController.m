//
//  RecuritSetmalController.m
//  铺皇
//
//  Created by selice on 2017/10/13.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RecuritSetmalController.h"
#import "Password.h"
#import "ZYKeyboardUtil.h"
#define MARGIN_KEYBOARD 10
#import "SafenumberController.h"
@interface RecuritSetmalController ()<UIScrollViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    UIScrollView *  MainScrollrent;
    UIView *viewtwo;
    UILabel * labtwo;
    UIView  * white21; //白块1
    UILabel * white21_1;
    UILabel * white21_2;
    UILabel * white21_3;
    UIView  *white22;  //白块2
    UILabel * white22_1;
    UILabel * white22_2;
    UILabel * white22_3;
    
    UIView  *white23;  //白块3
    UILabel * white23_1;
    UILabel * white23_2;
    
    UILabel  *alertlab;     //提示内容
    UIButton *paybtn;       //支付按钮
    
    NSString * paystr;      //支付 积分 值
    NSString * paynum1;      //支付 积分 值
    NSString * paystate1;        //服务状态
    NSString * paytype1;         //套餐类型
    NSString * totalpay;        //总积分
    
    int i;
}
@property (strong, nonatomic) UITextField    * white23_3;
@property (strong, nonatomic) ZYKeyboardUtil * keyboardUtil;
@end

@implementation RecuritSetmalController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    i = 0;
    
    paystate1 = [NSString new];
    paystate1 = @"0";
    paystr    = [[NSString alloc]init];
   
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(Back:)];
    self.title = @"购买招聘信息";
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    MainScrollrent                                = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+64)];
    MainScrollrent.userInteractionEnabled         = YES;
    MainScrollrent.showsVerticalScrollIndicator   = YES;
    MainScrollrent.showsHorizontalScrollIndicator = YES;
    MainScrollrent.delegate                       = self;
    MainScrollrent.backgroundColor                = kTCColor(255, 255, 255);
    MainScrollrent.contentSize                    = CGSizeMake(KMainScreenWidth,720);
    [self.view addSubview:MainScrollrent];
    
    [self buildtopview];
    [self buildbottomview];
    
//    添加手势点击可以让键盘下去
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [MainScrollrent addGestureRecognizer:tap];

}

#pragma -mark 点击scrollowview键盘下去
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.white23_3 resignFirstResponder];
}

-(void)buildtopview{
#pragma -mark     服务1  信息展示+地图推荐
    viewtwo = [[UIView alloc]init];
    viewtwo.backgroundColor =kTCColor(229, 229, 229);
    [MainScrollrent addSubview:viewtwo];
    [viewtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, (KMainScreenWidth-60)/3+64));
        make.left.equalTo(MainScrollrent).with.offset(0);
        make.top.equalTo (MainScrollrent).with.offset(0);
    }];
    
#pragma -mark     服务 3 资源匹配 标题
    labtwo = [[UILabel alloc]init];
    labtwo.textAlignment = NSTextAlignmentLeft;
    labtwo.text = @"购买招聘信息";
    labtwo.font  = [UIFont systemFontOfSize:18.0f];
    [viewtwo addSubview:labtwo];
    [labtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewtwo).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.left.equalTo(viewtwo).with.offset(20);
    }];
    
#pragma -mark 资源匹配 20个 start
    white21 = [[UIView alloc]init];
    white21.backgroundColor         = [UIColor whiteColor];
    white21.layer.cornerRadius      = 10;
    white21.layer.borderWidth       = 2.0f;
    white21.layer.masksToBounds     = YES;
    white21.layer.borderColor      = [[UIColor whiteColor] CGColor];//框白颜色
    [viewtwo addSubview:white21];
    [white21 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(viewtwo).with.offset(20);
        make.top.equalTo(labtwo.mas_bottom).with.offset(16);
    }];
    white21.userInteractionEnabled = YES;
    UITapGestureRecognizer *white21GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white21Gesclick:)];
    [white21 addGestureRecognizer:white21GES];
    
    white21_1            = [[UILabel alloc]init];
    white21_1.text       =  @"效率快，范围广";
    white21_1.font       = [UIFont systemFontOfSize:12.0f];
    white21_1.textColor  =kTCColor(101, 101, 101);
    [white21 addSubview:white21_1];
    [white21_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white21).with.offset(10);
        make.top.equalTo(white21).with.offset(12);
    }];
    
    white21_2            = [[UILabel alloc]init];
    white21_2.text       =  @"5条招聘";
    white21_2.font       = [UIFont systemFontOfSize:15.0f];
    white21_2.textColor  =kTCColor(0, 0, 0);
    [white21 addSubview:white21_2];
    [white21_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white21).with.offset(10);
        make.top.equalTo(white21_1.mas_bottom).with.offset(12);
    }];
    
    white21_3            = [[UILabel alloc]init];
    NSString *string21_3 = @"20";
    NSString *string221_3 = [NSString stringWithFormat:@"%@积分",string21_3];
    NSMutableAttributedString *stra21_3 = [[NSMutableAttributedString alloc]initWithString:string221_3];//可随意拼接字符串
    [stra21_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string21_3.length)];
    white21_3.attributedText=stra21_3;
    white21_3.font       = [UIFont systemFontOfSize:18.0f];
    [white21 addSubview:white21_3];
    [white21_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white21).with.offset(10);
        make.top.equalTo(white21_2.mas_bottom).with.offset(12);
    }];
#pragma -mark 资源匹配 20个  end
#pragma -mark 资源匹配 40个  start
    white22 = [[UIView alloc]init];
    white22.backgroundColor         = [UIColor whiteColor];
    white22.layer.cornerRadius      = 10;
    white22.layer.borderWidth       = 2.0f;
    white22.layer.masksToBounds     = YES;
    white22.layer.borderColor      = [[UIColor whiteColor] CGColor];//框白颜色
    [viewtwo addSubview:white22];
    [white22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(white21.mas_right).with.offset(10);
        make.top.equalTo(labtwo.mas_bottom).with.offset(16);
    }];
    white22.userInteractionEnabled = YES;
    UITapGestureRecognizer *white22GES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(white22Gesclick:)];
    [white22 addGestureRecognizer:white22GES];
    
    white22_1            = [[UILabel alloc]init];
    white22_1.text       = @"效率快，范围广";
    white22_1.font       = [UIFont systemFontOfSize:12.0f];
    white22_1.textColor  = kTCColor(101, 101, 101);
    [white22 addSubview:white22_1];
    [white22_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22).with.offset(12);
    }];
    
    white22_2            = [[UILabel alloc]init];
    white22_2.text       =  @"10条招聘";
    white22_2.font       = [UIFont systemFontOfSize:15.0f];
    white22_2.textColor  = kTCColor(0, 0, 0);
    [white22 addSubview:white22_2];
    [white22_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22_1.mas_bottom).with.offset(12);
    }];
    
    white22_3                 = [[UILabel alloc]init];
    NSString *string22_3      = @"35";
    NSString *string222_3     = [NSString stringWithFormat:@"%@积分",string22_3];
    NSMutableAttributedString *stra22_3   = [[NSMutableAttributedString alloc]initWithString:string222_3];//可随意拼接字符串
    [stra22_3 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:35],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string22_3.length)];
    white22_3.attributedText  = stra22_3;
    white22_3.font            = [UIFont systemFontOfSize:18.0f];
    [white22 addSubview:white22_3];
    [white22_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 20));
        make.left.equalTo(white22).with.offset(10);
        make.top.equalTo(white22_2.mas_bottom).with.offset(12);
    }];
    
#pragma -mark 资源匹配 40个  end
#pragma -mark 资源匹配 自定义购买量 start
    white23 = [[UIView alloc]init];
    white23.backgroundColor         = [UIColor whiteColor];
    white23.layer.cornerRadius      = 10;
    white23.layer.borderWidth       = 2.0f;
    white23.layer.masksToBounds     = YES;
    white23.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    [viewtwo addSubview:white23];
    [white23 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3, (KMainScreenWidth-60)/3));
        make.left.equalTo(white22.mas_right).with.offset(10);
        make.top.equalTo(labtwo.mas_bottom).with.offset(16);
    }];
    
    white23_1            = [[UILabel alloc]init];
    white23_1.text       =  @"效率快，范围广";
    white23_1.font       = [UIFont systemFontOfSize:12.0f];
    white23_1.textColor  = kTCColor(101, 101, 101);
    [white23 addSubview:white23_1];
    [white23_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23).with.offset(12);
    }];
    white23_2            = [[UILabel alloc]init];
    white23_2.text       =  @"选择条数";
    white23_2.font       = [UIFont systemFontOfSize:14.0f];
    white23_2.textColor  = kTCColor(0, 0, 0);
    [white23 addSubview:white23_2];
    [white23_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-10, 15));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23_1.mas_bottom).with.offset(12);
    }];
    
    self.white23_3                    = [[UITextField alloc]init];
    self.white23_3.textColor          = [UIColor redColor];
    self.white23_3.placeholder        = @"填写购买量";
    self.white23_3.delegate           = self;
    self.white23_3.returnKeyType      = UIReturnKeyDone;
    self.white23_3.font               = [UIFont systemFontOfSize:14.0f];
    self.white23_3.textAlignment      = NSTextAlignmentCenter;
    self.white23_3.keyboardType       = UIKeyboardTypeNumberPad;
    self.white23_3.clearButtonMode    = UITextFieldViewModeWhileEditing;
    self.white23_3.borderStyle=UITextBorderStyleRoundedRect;
    [self.white23_3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [white23 addSubview:self.white23_3];
    [self.white23_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-60)/3-20, 20));
        make.left.equalTo(white23).with.offset(10);
        make.top.equalTo(white23_2.mas_bottom).with.offset(12);
    }];
    
    //键盘处理 抬起
    [self configKeyBoardRespond];
#pragma -mark  资源匹配  end
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak RecuritSetmalController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.white23_3,nil];
    }];
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}



#pragma -mark 触摸屏幕键盘掉下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.white23_3 endEditing:YES];
    [self.white23_3 resignFirstResponder];
}

-(void)buildbottomview{
    
    alertlab= [[UILabel alloc]init];
    alertlab.text = @"温馨提示\n\n1.积分业务一经开通支付后不支持退款；\n\n2.充值后若还是无法正常使用，请尝试联系客服；";
    alertlab.textColor        = [UIColor blackColor];
    alertlab.textAlignment    = NSTextAlignmentLeft;
    alertlab.numberOfLines    = 0;
    alertlab.font             = [UIFont systemFontOfSize:12.0f];
    [MainScrollrent addSubview:alertlab];
    [alertlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 100));
        make.top.equalTo(viewtwo.mas_bottom).with.offset(100);
        make.left.equalTo(MainScrollrent).with.offset(20);
    }];
    
    //    按钮
    paybtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [paybtn setTitle:@"支 付" forState:UIControlStateNormal];
    [paybtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    paybtn.titleLabel.font  = [UIFont systemFontOfSize:20.0f];
    [paybtn setTintColor:[UIColor whiteColor]];
    [paybtn addTarget:self action:@selector(payclick:) forControlEvents:UIControlEventTouchUpInside];
    paybtn.enabled = NO;
    [MainScrollrent addSubview:paybtn];
    [paybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(KMainScreenWidth-40, 32));
        make.left.equalTo(MainScrollrent).with.offset(20);
        make.top.equalTo(alertlab.mas_bottom).with.offset(20);
    }];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    NSLog(@"开始编辑");
    white21.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white22.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white23.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.white23_3 resignFirstResponder];
    paystr = [NSString stringWithFormat:@"购买招聘发布量:%@个",self.white23_3.text];
    paynum1 = [NSString stringWithFormat:@"%ld", [self.white23_3.text integerValue]*4];
    
    if (self.white23_3.text.length>0) {
        paystate1 = @"1";
        paytype1 = @"3";
        paybtn.enabled = YES;
    }else{
        paystate1 = @"0";
        paytype1 = @"3";
        paybtn.enabled = NO;
    }
}

#pragma 当点击键盘的返回键键盘下去
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.white23_3 resignFirstResponder];
    paystr = [NSString stringWithFormat:@"购买招聘发布量:%@个",self.white23_3.text];
    paynum1 = [NSString stringWithFormat:@"%ld", [self.white23_3.text integerValue]*4];
    if (self.white23_3.text.length>0) {
        paystate1 = @"1";
        paytype1 = @"3";
        paybtn.enabled = YES;
    }
    else{
        paystate1 = @"0";
        paytype1 = @"3";
        paybtn.enabled = NO;
    }
    return YES;
}

#pragma mark - self.white33_3 限制购买量字数
-(void)textFieldDidChange:(UITextField *)textField{
    
    if (textField == self.white23_3) {
        if (textField.text.length >3) {
            textField.text = [textField.text substringToIndex:3];
        }
    }
}


-(void)white21Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@" 520积分 5条信息");
    white21.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    white22.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white23.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    self.white23_3.text = @"";
    [self.white23_3 resignFirstResponder];
    paystr = [NSString stringWithFormat:@"购买招聘发布量5条:%@",white21_3.text];
    paynum1 = [NSString stringWithFormat:@"20"];
    paystate1 = @"1";
    paytype1 = @"1";
     paybtn.enabled = YES;
    NSLog(@"积分值%@",paystr);
}


-(void)white22Gesclick:(UIGestureRecognizer*)GES{
    NSLog(@"资源购买 1920积分 40");
    white21.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white23.layer.borderColor       = [[UIColor whiteColor] CGColor];//框白颜色
    white22.layer.borderColor       = [kTCColor(38,147,255) CGColor];//框蓝颜色
    self.white23_3.text = @"";
    [self.white23_3 resignFirstResponder];
    paystr = [NSString stringWithFormat:@"购买招聘发布量10条:%@",white22_3.text];
    paynum1 = [NSString stringWithFormat:@"35"];
    paystate1 = @"1";
    paytype1 = @"2";
     paybtn.enabled = YES;
    NSLog(@"积分值%@",paystr);
}


#pragma -mark 支付按钮点击事件
-(void)payclick:(id)sender{
    NSLog(@"支付点击.....");
    NSString *paysetmeal = [NSString stringWithFormat:@"%@\n需要消耗积分:%ld分",paystr,[paynum1 integerValue]];
    
    [LEEAlert alert].config
    
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = @"确认套餐选择";
        
        label.textColor = [UIColor blackColor];
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = paysetmeal;
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    })
    
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = @"取消";
        
        action.titleColor = kTCColor(255, 255, 255);
        
        action.backgroundColor = kTCColor(174, 174, 174);
        
        action.clickBlock = ^{
            
            // 取消点击事件Block
        };
    })
    
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = @"立即支付";
        
        action.titleColor = kTCColor(255, 255, 255);
        
        action.backgroundColor = kTCColor(77, 166, 214);
        
        action.clickBlock = ^{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TouchIDneed"] isEqualToString:@"yes"]){
                
                LAContext *laContext = [[LAContext alloc] init];
                NSError *error = nil;
                
                if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
                    
                    [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                              localizedReason:@"需要授权Touch ID购买"
                                        reply:^(BOOL success, NSError *error) {
                                            if (success) {
                                                NSLog(@"success to evaluate");
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    [self payintergal];
                                                });
                                                
                                            }
                                            
                                            if (error) {
                                                
                                                NSLog(@"---failed to evaluate---error: %@---", error.description);
                                            }
                                        }];
                }
                
                else {
                    
                    NSLog(@"==========Not support :%@", error.description);
                }
            }
            
        else{//[[[NSUserDefaults standardUserDefaults] objectForKey:@"TouchIDneed"] isEqualToString:@"no"]
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"您尚未开启使用Touch ID进行支付，是否开启" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    
                    NSLog(@"开启");
                    
                    SafeController * NUMBER  = [[SafeController alloc]init];
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    [self.navigationController pushViewController:NUMBER animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }];
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"使用支付密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    
                    NSLog(@"使用支付密码");
                    
                    NSString *HasPaycode = [[NSUserDefaults standardUserDefaults]objectForKey:@"Paymentpassword"];
                    if (HasPaycode.length<1) {//没有支付密码
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未设置支付密码，是否需要设置" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                            
                            NSLog(@"前往设置");
                           
                            SafenumberController *ctl =[[SafenumberController alloc]init];//套餐页面
                            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                            [self.navigationController pushViewController:ctl animated:YES];
                            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                            
                        }];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                            
                            NSLog(@"取消");
                            
                        }];
                        
                        [alertController addAction:cancelAction];
                        [alertController addAction:commitAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }else{//有支付密码
                        
                        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Paymentpasswordopen"] isEqualToString:@"openPay"]) {//openPay 开启了支付验证的
                            //弹出式密码框
                            Password *passView = [[Password alloc]initSingleBtnView];
                            passView.passWordTextConfirm =^(NSString *text)
                            {
                                NSLog(@"输入密码：%@",text);
                                NSLog(@"点击了确定按钮 验证密码是否正确");
                                //点击确定按钮输出密码
                                if ( [[[NSUserDefaults standardUserDefaults]objectForKey:@"Paymentpassword"] isEqualToString:text]) {
                                    NSLog(@"输入密码正确");
#pragma     付钱方法
                                    [self payintergal];
                                    
                                }else{
                                    
                                    NSLog(@"输入密码错误");
                                 
                                     [YJLHUD showErrorWithmessage:@"支付密码输入错误"];
                                    [YJLHUD dismissWithDelay:1];
                                }
                            };
                            [passView show];//支付密码输入页面出现
                        }
                        
                        else{//closePay 关闭了支付验证的
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未开启密码认证，是否需要开启" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"前往开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                
                                NSLog(@"前往开启支付验证开关");
                
                                SafenumberController *ctl =[[SafenumberController alloc]init];//套餐页面
                                self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                                [self.navigationController pushViewController:ctl animated:YES];
                                self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                                
                            }];
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                
                                NSLog(@"取消");
                                
                            }];
                            
                            [alertController addAction:cancelAction];
                            [alertController addAction:commitAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                        }
                    }
                    
                }];
            
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    NSLog(@"不用");
                }];
        
                [alertController addAction:commitAction];
                [alertController addAction:otherAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];

            }
        };
    })
    .LeeHeaderColor(kTCColor(255, 255, 255))
    .LeeShow();
}



#pragma 付钱方法
-(void)payintergal{

   [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"购买中...."];
    
#pragma     付钱开始
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSDictionary *params = @{
                                 @"id"   :[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                             };
    NSLog(@"用户ID:%@",params);
    
    [manager POST:MyserviceZPpath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        //                    总积分
        [formData appendPartWithFormData:[paynum1 dataUsingEncoding:NSUTF8StringEncoding] name:@"vip_integral"];
        NSLog(@" 总积分:%@",paynum1);
        
        //    资源服务开通状态
        [formData appendPartWithFormData:[paystate1 dataUsingEncoding:NSUTF8StringEncoding] name:@"recruit"];
        NSLog(@" 资源服务开通状态:%@",paystate1);
        
        //    资源匹配 套餐 ？
        [formData appendPartWithFormData:[paytype1 dataUsingEncoding:NSUTF8StringEncoding] name:@"recruit_type"];
        NSLog(@" 资源匹配 套餐 ？:%@",paytype1);
        
        //    资源匹配套餐3 个数
        [formData appendPartWithFormData:[self.white23_3.text dataUsingEncoding:NSUTF8StringEncoding] name:@"recruits"];
        NSLog(@" 资源匹配套餐3购买个数:%@",self.white23_3.text);
        
    }

  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"请求成功code=%@",     responseObject[@"code"]);
              NSLog(@"请求成功massign=%@",  responseObject[@"massign"]);
              NSLog(@"请求成功data=%@",     responseObject[@"data"]);
      
     
       if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"])
       {
            [YJLHUD showSuccessWithmessage:@"购买成功，赶紧去消费吧"];
           
       } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"408"]){
           
            [YJLHUD showErrorWithmessage:@"积分不足，请先去充值"];
       }else{
            [YJLHUD showErrorWithmessage:@"服务器繁忙～～"];
           
       }
   
      [YJLHUD dismissWithDelay:2.0f];
      
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [YJLHUD dismissWithDelay:0.5];
              NSLog(@"请求失败=%@",error);
              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️提示" message:@"已断开与互联网的连接" preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                  NSLog(@"点击了确认");
              }];
              [alertController addAction:commitAction];
              [self presentViewController:alertController animated:YES completion:nil];
              
          }];
}

#pragma -mark 返回
-(void)Back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"已经看过了我要返回");
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
}

@end
