//
//  ZWdescribeController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/31.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZWdescribeController.h"
#import "PlaceholderTextView.h"
@interface ZWdescribeController ()<UITextViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (nonatomic,strong)  UIButton *surebtn;
@property (nonatomic, strong) PlaceholderTextView * textView;
//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;
@end

@implementation ZWdescribeController


#pragma -mark textView创建
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(20, 84, self.view.frame.size.width - 40, 180)];
        _textView.backgroundColor   = [UIColor whiteColor];
        _textView.delegate          = self;
        _textView.font              = [UIFont systemFontOfSize:12.f];
        _textView.textColor         = [UIColor blackColor];
        _textView.textAlignment     = NSTextAlignmentLeft;
        _textView.editable          = YES;
        //       _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.layer.cornerRadius    = 4.0f;
        _textView.layer.borderColor     = kTextBorderColor.CGColor;
        _textView.layer.borderWidth     = 0.5;
        _textView.placeholderColor      = RGBCOLOR(0x89, 0x89, 0x89);
        

        if ([_labvalue isEqualToString:@"请填写信息"]||[_labvalue isEqualToString:@"您尚未填写信息"])
        {
            
            _textView.placeholder = @"请输入职位职责，任职要求等，至少5个字，建议分条列出来\n岗位职责：\n    1:........\n    2:.......\n任职要求：\n    1:........\n    2:.......\n\n\n请勿输入个人或者企业邮箱，联系电话，薪资面议及其他连接，否则职位将自动删除，且不可以恢复";
        }
        
        else{
            
            _textView.text    = _labvalue;
            
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
    
    self.title = @"职位描述";
    
    //关键句.不然出bug
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.textView];
    

    self.wordCountLabel   = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x,  self.textView.frame.size.height + 84, KMainScreenWidth - 40, 20)];
    _wordCountLabel.font  = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor   = [UIColor lightGrayColor];
    self.wordCountLabel.text    = @"0/700";
    self.wordCountLabel.backgroundColor  = [UIColor whiteColor];
    self.wordCountLabel.textAlignment    = NSTextAlignmentRight;
    [self.view addSubview:_wordCountLabel];
    
    //计算当前有多少个数
    [self textViewDidChange:self.textView];
    
    _surebtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    _surebtn.frame = CGRectMake(20,KMainScreenHeight-10-40*_autoSizeScaleY , KMainScreenWidth-40, 40*_autoSizeScaleY);
    [_surebtn setTitle:@"确定" forState:UIControlStateNormal];
    
    
//    按钮背景色
//    _surebtn.backgroundColor = [UIColor colorWithRed:63/255.0 green:149/255.0 blue:205/255.0 alpha:1.0];
    [_surebtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    [_surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_surebtn addTarget:self action:@selector(surebtn2:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_surebtn];
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    

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

#pragma -mark 在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length>0) {
        _textView.layer.borderColor     = kTCColor(77, 166, 214).CGColor;
        _textView.textColor             = kTCColor(77, 166, 214);
    }else{
        _textView.layer.borderColor     = kTextBorderColor.CGColor;
        _textView.textColor             = kTCColor(0, 0, 0);
    }
    NSLog(@"1111==%ld",textView.text.length);
    
    NSInteger wordCount         = textView.text.length;
    self.wordCountLabel.text    = [NSString stringWithFormat:@"%ld/700",(long)wordCount];
    if (textView.text.length) {
        self.textView.placeholder = @"请输入职位职责，任职要求等，至少5个字，建议分条列出来\n岗位职责：\n    1:........\n   2:.......\n任职要求：\n    1:........\n    2:.......\n\n\n请勿输入公司邮箱，联系电话，薪资面议及其他连接，否则职位将自动删除，且不可以恢复";
    }
    [self wordLimit:textView];
}

#pragma mark 超过700字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length <= 700) {
        
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_textView resignFirstResponder];
    
}

-(void)surebtn2:(UIButton *)btn{
    

    NSLog(@"确定内容并返回");
    NSLog(@"文本内容：%@",self.textView.text);
    
    if (self.textView.text.length<5) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您输入的字数不够哦，不允许进行下一步操作(>5字)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"完善信息" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else{
    
    NSString *inputString = self.textView.text;
    
    if (self.returnValueBlock){
        
        self.returnValueBlock(inputString);
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
