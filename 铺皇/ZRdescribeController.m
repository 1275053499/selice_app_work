//
//  ZRdescribeController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/25.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZRdescribeController.h"
#import "PlaceholderTextView.h"
#define kTextBorderColor     RGBCOLOR(227,224,216)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface ZRdescribeController ()<UITextViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)  UIButton *surebtn;
@property (nonatomic,strong)  UILabel  *alearlab;
@property (nonatomic, strong) PlaceholderTextView * textView;
//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;

@end

@implementation ZRdescribeController



#pragma -mark textView创建
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(20, 84, self.view.frame.size.width - 40, 180)];
        _textView.backgroundColor   = [UIColor whiteColor];
        _textView.delegate          = self;
        _textView.font              = [UIFont systemFontOfSize:14.f];
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
            _textView.placeholder = @"可以在此描述一下店铺的信息";
        }
        
        else{
            
            _textView.text    = _labvalue;
        }
    }
    
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = @"输入店铺描述";
    //关键句.不然出bug
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.textView];
    
    self.wordCountLabel   = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x,  self.textView.frame.size.height + 84, KMainScreenWidth - 40, 20)];
    _wordCountLabel.font  = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor   = [UIColor lightGrayColor];
    self.wordCountLabel.text    = @"0/800";
    self.wordCountLabel.backgroundColor  = [UIColor whiteColor];
    self.wordCountLabel.textAlignment    = NSTextAlignmentRight;
    [self.view addSubview:_wordCountLabel];

    //计算当前有多少个数
    [self textViewDidChange:self.textView];
    
    _surebtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    _surebtn.frame = CGRectMake(20,KMainScreenHeight-10-40 , KMainScreenWidth-40, 40);
    [_surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [_surebtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    [_surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_surebtn addTarget:self action:@selector(surebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_surebtn];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma  确定block回去传旨了
-(void)surebtn:(UIButton*)btn{
    
    if (self.textView.text.length<4) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您输入的字数不够哦，不允许进行下一步操作(>4字)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"完善信息" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }

    else{
    
    NSLog(@"文本内容：%@",self.textView.text);
    NSString *inputString = self.textView.text;
    
    if (self.returnValueBlock){
        
        self.returnValueBlock(inputString);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    if (_textView.text.length >0)
    {
//        NSLog(@"有数据的");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未保存数据，确认放弃编辑信息返回么？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                NSLog(@"点击了取消");
            
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSLog(@"点击了确认");
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancleAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"已经看过了我要返回");
    }

}

#pragma  -mark - 返回
-(void)back{
    
    if (_textView.text.length >0)
    {
//        NSLog(@"有数据的");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未保存数据，确认放弃编辑信息返回么？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了取消");
            
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了确认");
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancleAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    else
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"已经看过了我要返回");
    }

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

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
//    NSLog(@"1111%ld",textView.text.length);
    NSInteger wordCount         = textView.text.length;
    self.wordCountLabel.text    = [NSString stringWithFormat:@"%ld/800",(long)wordCount];
    [self wordLimit:textView];
}

#pragma mark 超过800字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length <= 800) {
        
//        NSLog(@"22222%ld",text.text.length);
        self.textView.editable = YES;
    }
    
    else
    {
//        NSLog(@"%ld",text.text.length);
        NSLog(@"%@",text.text);
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的输入超过了限制范围，注意修改" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        //截取字符串前面800位
        self.textView.text = [self.textView.text substringToIndex:800];
        [self presentViewController:alertC animated:YES completion:nil];
        //重新计算当前有多少个数
        [self textViewDidChange:self.textView];
        
    }
    
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_textView resignFirstResponder];
    
}




-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

@end
