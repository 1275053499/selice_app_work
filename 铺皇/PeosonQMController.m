//
//  PeosonQMController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "PeosonQMController.h"
//#import "Singleton.h"
//#import "EGOCache.h"
#define kTextBorderColor     RGBCOLOR(227,224,216)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface PeosonQMController ()<UITextViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) PlaceholderTextView * textView;
@property (nonatomic, strong) UIView * aView;
//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation PeosonQMController

- (NSMutableArray *)dataArr {
    
    if(!_dataArr) {
        
        _dataArr = [NSMutableArray new];
    }
    
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatUI1];
}

//基本初始化事件
-(void)creatUI1{
    
    UIBarButtonItem * rightButton1 = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(keep)];
    rightButton1.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    rightButton1.tag = 100;
    self.navigationItem.rightBarButtonItem = rightButton1;
    
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    leftButton.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0f];
    
    
    self.aView = [[UIView alloc]init];
    _aView.backgroundColor = [UIColor cyanColor];
    _aView.frame = CGRectMake(20, 84, self.view.frame.size.width - 40, 180);
    [self.view addSubview:_aView];
    
    self.wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 84 - 1, [UIScreen mainScreen].bounds.size.width - 40, 20)];
    _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.text = @"0/300";
    self.wordCountLabel.backgroundColor = [UIColor whiteColor];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:_wordCountLabel];
    [_aView addSubview:self.textView];
    
    //关键句.不然出bug
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _textView.text = self.labvalue;
    //计算当前有多少个数
    [self textViewDidChange:self.textView];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    if (_textView.text.length >0)
    {
        NSLog(@"有数据的");
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

#pragma -mark textView创建
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 180)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = kTextBorderColor.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = @"彰显个性，写下个人心情！";
    }
    return _textView;
}


#pragma mark - 把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma -mark 保存之后返回
-(void)keep{

    [self.textView resignFirstResponder];//    键盘掉下
    NSLog(@"保存数据是：%@",self.textView.text);

    NSString *inputString;
    if (self.textView.text.length == 0) {
        inputString = @"欢迎咨询，欢迎合作";
    }
    else{
        inputString = self.textView.text;
    }
    
    if (self.returnValueBlock){
        
        self.returnValueBlock(inputString);
    }
    
    //  本地存数据 账号密码
    NSUserDefaults *defaults        =     [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES"      forKey:@"Editsignature"];//个人信息跟替
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma -mark 返回不修改
-(void)back{

    if (self.returnValueBlock){
        
        self.returnValueBlock(self.labvalue);
    }
     [_textView resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"已经看过了我要返回");
}

#pragma mark textField的字数限制

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/300",(long)wordCount];
    [self wordLimit:textView];
}
#pragma mark 超过300字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length <= 300) {
        NSLog(@"%ld",text.text.length);
        self.textView.editable = YES;
        
    }

    else{
        NSLog(@"%ld",text.text.length);
        NSLog(@"%@",text.text);
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的输入超过了限制范围，注意修改" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
       //截取字符串前面300位
        self.textView.text = [self.textView.text substringToIndex:300];
        [self presentViewController:alertC animated:YES completion:nil];
        //重新计算当前有多少个数
        [self textViewDidChange:self.textView];
    }
    return nil;
}
#pragma mark -
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
