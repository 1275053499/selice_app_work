//
//  ZRcontractController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/25.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//
#import "ZRcontractController.h"
#import "HcdDateTimePickerView.h"
#define kBasePadding 15
@interface ZRcontractController (){
    HcdDateTimePickerView * dateTimePickerView;
}

@property (nonatomic,strong)UILabel   *Contractlab;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (nonatomic,strong)UIButton  *surebtn;
@property (nonatomic,strong)UIButton  *choicebtn;

@end

@implementation ZRcontractController

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

    UIBarButtonItem *backItm        = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor       = [UIColor groupTableViewBackgroundColor];
    self.title                      = @"选择店铺合同到期时间";

    _Contractlab                    = [[UILabel alloc]init];
    _Contractlab.font               = [UIFont systemFontOfSize:18.0];
    _Contractlab.textAlignment      = NSTextAlignmentCenter;
    _Contractlab.backgroundColor    = [UIColor clearColor];
    _Contractlab.layer.cornerRadius = 4.0f;
    _Contractlab.layer.borderWidth  = 1.0f;
    
    if ([_labvalue isEqualToString:@"请填写信息"]) {
        _Contractlab.text =@"请选择日期";
        _Contractlab.layer.borderColor  = kTCColor(161, 161, 161).CGColor;
        _Contractlab.textColor          = kTCColor(161, 161, 161);
    }
    else{
        _Contractlab.text =_labvalue;
        _Contractlab.layer.borderColor  = kTCColor(77, 166, 214).CGColor;
        _Contractlab.textColor          = kTCColor(77, 166, 214);
    }
    [self.view addSubview:_Contractlab];
    //    适配方法
    [self.Contractlab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-40, 60));
        make.top.equalTo(self.view).with.offset(84);
        make.left.equalTo(self.view).with.offset(20);
    }];
    
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
#pragma  -mark选择城市按钮按钮初始化
    _choicebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_choicebtn  setBackgroundImage:[UIImage imageNamed:@"pay_bg@2x"] forState:UIControlStateNormal];
    [_choicebtn setTitle:@"选择" forState:UIControlStateNormal];
    [_choicebtn addTarget:self action:@selector(creatbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_choicebtn];
    
    //    选择适配方法
    [self.choicebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-40, 40));
        make.left.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-60);
    }];
}

#pragma  -mark弹出时间选择
-(void)creatbtn:(UIButton *)btn{

     __block ZRcontractController *weakSelf = self;
    dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    [dateTimePickerView setMinYear:1975];
    [dateTimePickerView setMaxYear:2040];
    
    dateTimePickerView.title = @"合同到期时间";
    dateTimePickerView.titleColor = [UIColor whiteColor];
    
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        NSLog(@"%@", datetimeStr);
        weakSelf.Contractlab.text = datetimeStr;
        weakSelf.Contractlab.layer.borderColor = kTCColor(77, 166, 214).CGColor;
        weakSelf.Contractlab.textColor  = kTCColor(77, 166, 214);
    };

    if (dateTimePickerView) {
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}

#pragma  -mark - 按钮确认并返回   block回去传旨了
-(void)sureback:(UIButton *)btn{
    if (self.Contractlab.text.length > 10) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您没有选择日期" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"选择" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }

    else
    {
        NSLog(@"文本内容：%@",self.Contractlab.text);
        NSString *inputString;
        inputString = self.Contractlab.text;
   
    if (self.returnValueBlock)
    {
        self.returnValueBlock(inputString);
    }
    
   
    [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma  -mark - 返回
-(void)back{

    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
}

@end
