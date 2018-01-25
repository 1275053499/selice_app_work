//
//  ZRManagementController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/25.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZRManagementController.h"

@interface ZRManagementController ()
@property (nonatomic,strong)UILabel   *Managementlab;

@property (nonatomic,strong)UIButton  *Managementbtn1;
@property (nonatomic,strong)UIButton  *Managementbtn2;


@property (nonatomic,strong)UIButton  *surebtn;

@property float autoSizeScaleX;
@property float autoSizeScaleY;
@end

@implementation ZRManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatbasesource];
    [self creatbase];
    [self creatbtn];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"选择店铺经营状态";
}

-(void)creatbasesource{
    
    _Managementlab                      = [[UILabel alloc]init];
    _Managementlab.font                 = [UIFont systemFontOfSize:18.0];
    _Managementlab.textAlignment        = NSTextAlignmentCenter;
    _Managementlab.textColor            =[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    _Managementlab.backgroundColor      = [UIColor clearColor];
    _Managementlab.layer.cornerRadius   = 4.0f;
    _Managementlab.layer.borderWidth    = 1.0f;
    if ([_labvalue isEqualToString:@"正在营业"]||[_labvalue isEqualToString:@"暂停营业"]){
        _Managementlab.text             = _labvalue;
        _Managementlab.layer.borderColor= kTCColor(77, 166, 214).CGColor;
        _Managementlab.textColor        = kTCColor(77, 166, 214);
    }
    else{
        _Managementlab.text                 = @"请从下面选项选择对应信息";
        _Managementlab.layer.borderColor    = kTCColor(161, 161, 161).CGColor;
        _Managementlab.textColor            = kTCColor(161, 161, 161);
    }
    [self.view addSubview:_Managementlab];
    //    适配方法
    [self.Managementlab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-40, 60));
        make.top.equalTo(self.view).with.offset(84);
        make.left.equalTo(self.view).with.offset(20);
    }];
}
-(void)creatbase{
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    
    
#pragma  -mark确认按钮按钮初始化
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
#pragma  -mark无数个按钮
-(void)creatbtn{
    //    ²
#pragma  -mark按钮初始化
    
    _Managementbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Managementbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
#pragma  -mark 按钮背景色
    _Managementbtn1.backgroundColor =_Managementbtn2.backgroundColor    = [UIColor whiteColor];
#pragma  -mark 按钮文字大小
    _Managementbtn1.titleLabel.font =_Managementbtn2.titleLabel.font    = [UIFont systemFontOfSize:14.0];
    
#pragma  -mark 按钮标题内容
    
    [_Managementbtn1 setTitle:@"正在营业"   forState:UIControlStateNormal];
    [_Managementbtn2 setTitle:@"暂停营业"   forState:UIControlStateNormal];

#pragma  -mark 按钮标题颜色
    if ([_labvalue isEqualToString:@"正在营业"]){
        
        [_Managementbtn1 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Managementbtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if ([_labvalue isEqualToString:@"暂停营业"]){
        
        [_Managementbtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Managementbtn2 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
  
    if ([_labvalue isEqualToString:@"请填写信息"]) {
        
        [_Managementbtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Managementbtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }

#pragma  -mark 按钮事件
    
    [_Managementbtn1 addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Managementbtn2 addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];

#pragma  -mark 按钮tag值
    
    _Managementbtn1.tag = 1;
    _Managementbtn2.tag = 2;

#pragma  -mark 按钮加入视图
    
    [self.view addSubview:_Managementbtn1];
    [self.view addSubview:_Managementbtn2];
    
#pragma  -mark。按钮范围
    
    [self.Managementbtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 40));
        make.left.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-100);
    }];
    
    [self.Managementbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 40));
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.view).with.offset(-100);
    }];
}

#pragma  -mark - 按钮点击
-(void)buttonBtnClick:(UIButton *)button{
    
    switch (button.tag) {
        case 1:{
#pragma _Turnbtn1 点击
            [_Managementbtn1 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            [_Managementbtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];

            _Managementlab.text = _Managementbtn1.titleLabel.text;
            _Managementlab.layer.borderColor = kTCColor(77, 166, 214).CGColor;
            _Managementlab.textColor  = kTCColor(77, 166, 214);
            
        }
            
            break;

        default:{
#pragma _Managementbtn2 点击
            [_Managementbtn2 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            
            [_Managementbtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Managementlab.text = _Managementbtn2.titleLabel.text;
            _Managementlab.layer.borderColor = kTCColor(77, 166, 214).CGColor;
            _Managementlab.textColor  = kTCColor(77, 166, 214);
        }
            break;
    }
}

#pragma  -mark - 按钮确认并返回   block回去传旨了
-(void)sureback:(UIButton *)btn{
    
    
    if (self.Managementlab.text.length>5) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您没有选择状态" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"选择" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    else
    {
        NSLog(@"文本内容：%@",self.Managementlab.text);
        NSString *inputString;

        inputString = self.Managementlab.text;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
  
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

}


@end
