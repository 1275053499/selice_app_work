//
//  Companyinformontroller.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "Companyinformontroller.h"
#import "PlaceholderTextView.h"
@interface Companyinformontroller ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (nonatomic,strong)  NSString  *XZaddess;
@property (nonatomic,strong)UILabel *companynameTX;
//公司名称
@property (nonatomic,strong)UITextField *companyname;
@property (nonatomic,strong)UILabel *companyprofileTX;
//公司简介
@property (nonatomic, strong) PlaceholderTextView * textView;
//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;

@property (nonatomic,strong)  UIButton  *surebtn;

@end

@implementation Companyinformontroller

#pragma -mark textView创建
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(10, 168*_autoSizeScaleY, KMainScreenWidth - 20, 180)];
        _textView.backgroundColor   = [UIColor whiteColor];
        _textView.delegate          = self;
        _textView.font              = [UIFont systemFontOfSize:12.0f];
        _textView.textColor         = [UIColor blackColor];
        _textView.textAlignment     = NSTextAlignmentLeft;
        _textView.editable          = YES;
        //_textView.keyboardType = UIKeyboardTypeDefault;
        _textView.returnKeyType =UIReturnKeyGo;
        _textView.layer.cornerRadius    = 4.0f;
        _textView.layer.borderColor     = kTextBorderColor.CGColor;
        _textView.layer.borderWidth     = 0.5;
        _textView.placeholderColor      = RGBCOLOR(0x89, 0x89, 0x89);
        
        if (_profileValue.length < 1)
        {
            _textView.placeholder = @"请输入职位职责，任职要求等，至少10字，建议分条列出来\n岗位职责：\n  1:........\n    2:.......\n任职要求：\n\n    1:........\n    2:.......\n请勿输入个人或者企业邮箱，联系电话，薪资面议及其他连接，否则职位将自动删除，且不可以恢复";
        }
        
        
        else{
    
            _textView.text    = _profileValue;
    
        }

    }

    return _textView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"店铺信息";
    
#pragma mark  确认按钮
    _surebtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    _surebtn.frame = CGRectMake(20,KMainScreenHeight-10-40*_autoSizeScaleY , KMainScreenWidth-40, 40*_autoSizeScaleY);
    [_surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [_surebtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    [_surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_surebtn addTarget:self action:@selector(surebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_surebtn];
    
#pragma mark  公司名称提醒
    _companynameTX = [[UILabel alloc]initWithFrame:CGRectMake(10, 74*_autoSizeScaleY, KMainScreenWidth-20, 20*_autoSizeScaleY)];
    _companynameTX.text = @"店铺名称：";
    _companynameTX.textColor = kTCColor(161, 161, 161);
    _companynameTX.textAlignment  = NSTextAlignmentLeft;
    _companynameTX.font = [UIFont systemFontOfSize:10.0f];
    [self.view addSubview:_companynameTX];
#pragma mark  公司简介提醒
    _companyprofileTX = [[UILabel alloc]initWithFrame:CGRectMake(10, 145*_autoSizeScaleY, KMainScreenWidth-20, 20*_autoSizeScaleY)];
    _companyprofileTX.text = @"店铺简介：";
    _companyprofileTX.textColor = kTCColor(161, 161, 161);
    _companyprofileTX.textAlignment  = NSTextAlignmentLeft;
    _companyprofileTX.font = [UIFont systemFontOfSize:10.0f];
    [self.view addSubview:_companyprofileTX];
    
#pragma mark  店铺名称
    _companyname  = [[UITextField alloc]initWithFrame:CGRectMake(10, 94*_autoSizeScaleY, KMainScreenWidth-20, 35*_autoSizeScaleY)];
    _companyname.font = [UIFont systemFontOfSize:14.0];
    _companyname.textColor  = kTCColor(77, 166, 214);//主题色
    _companyname.returnKeyType =UIReturnKeyGo;
    _companyname.textAlignment = NSTextAlignmentCenter;
//    文本框变圆 第一种
    _companyname.layer.cornerRadius = 4.0f;
    _companyname.layer.borderColor = kTextBorderColor.CGColor;
    _companyname.layer.borderWidth = 0.5;
    
    if ([_nameValue isEqualToString:@"请填写信息"])
    {
        _companyname.placeholder = @"输入店铺名称";
        _companyname.layer.borderColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0].CGColor;
    }
    
    else
    {
        _companyname.text = _nameValue;
        _companyname.layer.borderColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0].CGColor;
    
    }
    _companyname.clearButtonMode = UITextFieldViewModeWhileEditing;
    _companyname.delegate = self;
    
    [self.view addSubview:_companyname];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_companyname];
    
    //关键句.不然出bug
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.textView];
    
    self.wordCountLabel   = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x,  168*_autoSizeScaleY+180, KMainScreenWidth - 20, 20)];
    _wordCountLabel.font  = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor   = [UIColor lightGrayColor];
    self.wordCountLabel.text    = @"0/700";
    self.wordCountLabel.backgroundColor  = [UIColor whiteColor];
    self.wordCountLabel.textAlignment    = NSTextAlignmentRight;
    [self.view addSubview:_wordCountLabel];
    //计算当前有多少个数
    [self textViewDidChange:self.textView];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
}

#pragma  -mark - 点击空白处置初始状态
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_companyname resignFirstResponder];
    [_textView resignFirstResponder];
    
}

//把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark 在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"1111==%ld",textView.text.length);
    
    if (textView.text.length>0) {
        _textView.layer.borderColor     = kTCColor(77, 166, 214).CGColor;
        _textView.textColor             = kTCColor(77, 166, 214);
    }else{
        _textView.layer.borderColor     = kTextBorderColor.CGColor;
        _textView.textColor             = kTCColor(0, 0, 0);
    }
    
    NSInteger wordCount         = textView.text.length;
    self.wordCountLabel.text    = [NSString stringWithFormat:@"%ld/700",(long)wordCount];
    if (textView.text.length)
    {
        self.textView.placeholder = @"请输入职位职责，任职要求等，至少10字，建议分条列出来\n岗位职责：\n    1:........\n   2:.......\n任职要求：\n    1:........\n    2:.......\n\n\n请勿输入不良信息";
    }
    
    [self wordLimit:textView];
}

#pragma mark 超过700字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length <= 700)
    {
        
        NSLog(@"22222==%ld",text.text.length);
        self.textView.editable = YES;
    }
    
    else
    {
        NSLog(@"%ld",text.text.length);
        NSLog(@"%@",text.text);
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的输入超过了限制范围，注意修改" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        //截取字符串前面700位
        self.textView.text = [self.textView.text substringToIndex:700];
        [self presentViewController:alertC animated:YES completion:nil];
        //重新计算当前有多少个数
        [self textViewDidChange:self.textView];
        
    }
    
    return nil;
}

#pragma 当点击键盘的返回键键盘下去
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [_companyname resignFirstResponder];
     [_textView resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

#pragma mark - UITextFieldDelegate 限制字数
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
#pragma mark当输入文字文本框变色
    if (toBeString.length>0) {
        _companyname.layer.borderColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0].CGColor;
    }else{
        _companyname.layer.borderColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0].CGColor;
        _companyname.placeholder = @"输入公司（店铺）名称";
    }
#pragma mark 限制10个字数
    if (toBeString.length-1 > 11 && toBeString.length>1) {
        textField.text = [toBeString substringToIndex:10];
    }
}

#pragma  确定内容并返回
-(void)surebtn:(UIButton *)btn{
    NSLog(@"确定内容并返回");
    NSLog(@"111文本内容：%@",_companyname.text);
    NSLog(@"222文本内容:%@",_textView.text);
    
    if (_companyname.text.length == 0 || _textView.text.length == 0) {
        
        UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"信息未填写完整，请完善信息！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续填写" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"不做事情重新写");
        }];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else{
        
        NSString *inputString = _companyname.text;
        
        
        if (self.returnValueBlockname)
        {
            
            self.returnValueBlockname(inputString);
        }
        
        
        NSString *inputadd = _textView.text;
        if (self.returnValueBlockpfofile) {
            self.returnValueBlockpfofile(inputadd);
        }
        
        
       
        [self.navigationController popViewControllerAnimated:YES];
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
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}




@end
