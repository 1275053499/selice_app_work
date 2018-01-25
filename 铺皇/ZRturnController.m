//
//  ZRturnController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/25.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZRturnController.h"

@interface ZRturnController ()
@property (nonatomic,strong)UILabel *Turnlab;

@property (nonatomic,strong)UIButton  *Turnbtn1;
@property (nonatomic,strong)UIButton  *Turnbtn2;
@property (nonatomic,strong)UIButton  *Turnbtn3;

@property (nonatomic,strong)UIButton  *surebtn;

@property float autoSizeScaleX;
@property float autoSizeScaleY;

@end

@implementation ZRturnController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatbase];
    
    [self creatsouce];
    
    [self creatbtn];
}


-(void)creatsouce
{
    _Turnlab = [[UILabel alloc]init];
    _Turnlab.font = [UIFont systemFontOfSize:18.0];
    _Turnlab.textAlignment = NSTextAlignmentCenter;
    _Turnlab.textColor =[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    _Turnlab.backgroundColor = [UIColor clearColor];
    
    _Turnlab.layer.cornerRadius = 4.0f;
    _Turnlab.layer.borderWidth = 1.0f;
    
    if ([_labvalue isEqualToString:@"允许 空转"]||[_labvalue isEqualToString:@"允许 整转"]||[_labvalue isEqualToString:@"空转或整转"])
    {
        _Turnlab.text = _labvalue;
        _Turnlab.layer.borderColor = kTCColor(77, 166, 214).CGColor;
        _Turnlab.textColor  = kTCColor(77, 166, 214);
    }
    
    else
    {
        _Turnlab.text = @"请从下面选项选择对应信息";
        _Turnlab.layer.borderColor = kTCColor(161, 161, 161).CGColor;
        _Turnlab.textColor  = kTCColor(161, 161, 161);
    }
    [self.view addSubview:_Turnlab];
    //    适配方法
    [self.Turnlab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-40, 60));
        make.top.equalTo(self.view).with.offset(84);
        make.left.equalTo(self.view).with.offset(20);
    }];
    
}


-(void)creatbase{
    self.title = @"选择店铺转让形式";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//返回按钮
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
// 右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
// 确认按钮按钮初始化
    _surebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_surebtn  setBackgroundImage:[UIImage imageNamed:@"pay_bg@2x"] forState:UIControlStateNormal];
    [_surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [_surebtn addTarget:self action:@selector(sureback:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_surebtn];
    //    适配方法
    [self.surebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-40, 40));
        make.left.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
}

#pragma  -mark 三个按钮
-(void)creatbtn
{
    //    ²
#pragma  -mark按钮初始化
    _Turnbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Turnbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Turnbtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
#pragma  -mark 按钮背景色
    _Turnbtn1.backgroundColor =_Turnbtn2.backgroundColor=_Turnbtn3.backgroundColor = [UIColor whiteColor];
    
#pragma  -mark 按钮文字大小  
    _Turnbtn1.titleLabel.font=_Turnbtn2.titleLabel.font=_Turnbtn3.titleLabel.font= [UIFont systemFontOfSize:14.0];
    
#pragma  -mark 按钮标题内容
    [_Turnbtn1 setTitle:@"允许 空转"   forState:UIControlStateNormal];
    [_Turnbtn2 setTitle:@"允许 整转"   forState:UIControlStateNormal];
    [_Turnbtn3 setTitle:@"空转或整转"   forState:UIControlStateNormal];
    
#pragma  -mark 按钮标题颜色
    if ([_labvalue isEqualToString:@"允许 空转"]){
        
        [_Turnbtn1 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Turnbtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Turnbtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    if ([_labvalue isEqualToString:@"允许 整转"]){
        
        [_Turnbtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Turnbtn2 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Turnbtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    if ([_labvalue isEqualToString:@"空转或整转"]){
        
        [_Turnbtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Turnbtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Turnbtn3 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
   if ([_labvalue isEqualToString:@"请填写信息"]) {
       [_Turnbtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
       [_Turnbtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
       [_Turnbtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
   }
    
#pragma  -mark 按钮事件
    
    [_Turnbtn1 addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Turnbtn2 addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Turnbtn3 addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma  -mark 按钮tag值
    _Turnbtn1.tag = 1;
    _Turnbtn2.tag = 2;
    _Turnbtn3.tag = 3;
    
#pragma  -mark 按钮加入视图
    
    [self.view addSubview:_Turnbtn1];
    [self.view addSubview:_Turnbtn2];
    [self.view addSubview:_Turnbtn3];
    
#pragma  -mark。按钮范围
    
    [self.Turnbtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-40)/3, 30));
        make.left.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-220);
    }];
    
    [self.Turnbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-40)/3, 30));
        make.right.equalTo(self.view).with.offset(-20-(KMainScreenWidth-40)/3);
        make.bottom.equalTo(self.view).with.offset(-170);
    }];
    
    [self.Turnbtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((KMainScreenWidth-40)/3, 30));
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.view).with.offset(-120);
    }];
}

#pragma  -mark - 按钮点击
-(void)buttonBtnClick:(UIButton *)button{

    switch (button.tag) {
        case 1:{
#pragma _Turnbtn1 点击
            [_Turnbtn1 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            [_Turnbtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Turnbtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            _Turnlab.text = _Turnbtn1.titleLabel.text;
            
        }
            break;
            
        case 2:{
#pragma _Turnbtn2 点击
            [_Turnbtn2 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            [_Turnbtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Turnbtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Turnlab.text = _Turnbtn2.titleLabel.text;
        }
            break;
            
        default:{
#pragma _Turnbtn3 点击
            [_Turnbtn3 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            [_Turnbtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Turnbtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Turnlab.text = _Turnbtn3.titleLabel.text;
        }
            break;
            
    }
    _Turnlab.layer.borderColor = kTCColor(77, 166, 214).CGColor;
    _Turnlab.textColor  = kTCColor(77, 166, 214);
}

#pragma  -mark - 按钮确认并返回   block回去传旨了
-(void)sureback:(UIButton *)btn{
    
    if (self.Turnlab.text.length>5) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您没有选择状态" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"选择" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else
    {
        NSLog(@"文本内容：%@",self.Turnlab.text);
        NSString *inputString;
        inputString = self.Turnlab.text;
    if (self.returnValueBlock)
    {
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


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
   
    
    
}

@end
