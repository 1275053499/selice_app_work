//
//  ZWaddressController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/31.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZWaddressController.h"
@interface ZWaddressController ()<UITextFieldDelegate>
@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;
@property (nonatomic,strong)  NSString  *XZaddess;
@property (nonatomic,strong)  UIButton  *surebtn;
//城市
@property (nonatomic, strong)UILabel *citylab;
//具体地址
@property (nonatomic,strong)UITextField *addessfie;

//提示城市
@property (nonatomic, strong)UILabel *TXcity;
//提示具体地址
@property (nonatomic, strong)UILabel *TXaddess;

@end

@implementation ZWaddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = @"工作地址";
    
#pragma mark  确认按钮
    _surebtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    _surebtn.frame = CGRectMake(20,KMainScreenHeight-10-40 , KMainScreenWidth-40, 40);
    [_surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [_surebtn setBackgroundImage:[UIImage imageNamed:@"pay_bg"] forState:UIControlStateNormal];
    [_surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_surebtn addTarget:self action:@selector(surebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_surebtn];
    
#pragma mark  提醒城市
    _TXcity  =[UILabel new];
    _TXcity.frame = CGRectMake(10, 84, KMainScreenWidth-20, 26);
    _TXcity.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];//主题色
    _TXcity.text = @"选择XX省份：XX市：XX地区";
    _TXcity.font = [UIFont systemFontOfSize:10.0];
    _TXcity.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_TXcity];
#pragma mark  城市
    _citylab  =[UILabel new];
    _citylab.frame = CGRectMake(10, 110, KMainScreenWidth-20, 35);
  
    if ([_labvalue isEqualToString:@"请填写信息"]) {
        _citylab.text = @"城市选择";
        _citylab.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];//主题色
        _citylab.layer.borderColor = kTextBorderColor.CGColor;
       
    }
    
    else{
        _citylab.text = _labvalue;
#pragma mark当输入城市文本框变色
        _citylab.layer.borderColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0].CGColor;
        _citylab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
        
    }
//    圆角
    _citylab.layer.cornerRadius = 4.0f;
    _citylab.layer.borderWidth = 1.0;
    _citylab.font = [UIFont systemFontOfSize:14.0];
    _citylab.textAlignment = NSTextAlignmentCenter;
    _citylab.userInteractionEnabled = YES;
    
#pragma mark   label可以点击
    UITapGestureRecognizer * TapGes  =[[ UITapGestureRecognizer alloc]init];
    [TapGes addTarget:self action:@selector(TapGes)];
    [self.citylab addGestureRecognizer:TapGes];
    
    [self.view addSubview:_citylab];

    
#pragma mark  提醒具体地址
    _TXaddess  =[UILabel new];
    _TXaddess.frame = CGRectMake(10, 160, KMainScreenWidth-20, 26);
    _TXaddess.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];//主题色
    _TXaddess.text = @"填写比较详细的工作地址";
    _TXaddess.font = [UIFont systemFontOfSize:10.0];
    _TXaddess.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_TXaddess];
    
#pragma mark  具体地址
    _addessfie  = [[UITextField alloc]initWithFrame:CGRectMake(10, 186, KMainScreenWidth-20, 35)];
    _addessfie.font = [UIFont systemFontOfSize:14.0];
    _addessfie.textColor  = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
     _addessfie.returnKeyType =UIReturnKeyDefault;
    _addessfie.textAlignment = NSTextAlignmentCenter;
//    圆角
    _addessfie.layer.cornerRadius = 4.0f;
    _addessfie.layer.borderColor = kTextBorderColor.CGColor;
    _addessfie.layer.borderWidth = 0.5;
    
    if (_labvalueadd.length > 0)
    {
        _addessfie.text = _labvalueadd;
        _addessfie.layer.borderColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0].CGColor;
        
    }
    else
    {
        _addessfie.placeholder = @"输入具体的工作地址";
        _addessfie.layer.borderColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0].CGColor;

    }
    
    _addessfie.clearButtonMode = UITextFieldViewModeWhileEditing;
    _addessfie.delegate = self;

    [self.view addSubview:_addessfie];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_addessfie];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma  -mark - 点击空白处置初始状态
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
     [_addessfie resignFirstResponder];
    
}
#pragma 当点击键盘的返回键键盘下去
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [_addessfie resignFirstResponder];
    return YES;
}

#pragma  -mark弹出城市选择
-(void)TapGes{
    NSLog(@"选择城市");
    
    if ([_citylab.text isEqualToString:@"城市选择"]) {
        _XZaddess = @"广东 深圳 宝安区";
    }else{
        _XZaddess = _citylab.text;
    }
    NSArray * array =[_XZaddess componentsSeparatedByString:@" "];
    NSString *province = @"";//省
    NSString *city = @"";//市
    NSString *county = @"";//县
    if (array.count > 2) {
        province = array[0];
        city = array[1];
        county = array[2];
    } else if (array.count > 1) {
        province = array[0];
        city = array[1];
    } else if (array.count > 0) {
        province = array[0];
    }
    
#pragma  -mark 城市选择 调用
    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];
}

#pragma  -mark 城市选择方法
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            self.citylab.text = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,countyName];
            self.citylab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];
            self.citylab.layer.borderColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0].CGColor;
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

#pragma  确定内容并返回
-(void)surebtn:(UIButton *)btn{
    NSLog(@"确定内容并返回");
    NSLog(@"111文本内容：%@",self.citylab.text);
    NSLog(@"222文本内容:%@",self.addessfie.text);
    
    if ([self.citylab.text isEqualToString:@"城市选择"]) {
        self.citylab.text = @"";
        NSLog(@"清零文本内容：%@",self.citylab.text);
    }
    
    if (self.citylab.text.length == 0 || self.addessfie.text.length == 0) {
        
        UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"信息未填写完整，请完善信息！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续填写" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"不做事情重新写");
        }];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else{
    
    NSString *inputString = self.citylab.text;
    if (self.returnValueBlock)
    {
        self.returnValueBlock(inputString);
    }
    
    NSString *inputadd = self.addessfie.text;
    if (self.returnValueBlockadd)
    {
        self.returnValueBlockadd(inputadd);
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


#pragma mark - UITextFieldDelegate 限制字数
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    #pragma mark当输入文字文本框变色
    if (toBeString.length>0) {
        _addessfie.layer.borderColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0].CGColor;
    }else{
        _addessfie.layer.borderColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0].CGColor;
        _addessfie.placeholder = @"输入具体的工作地址";
    }
    #pragma mark 限制25个字数
    if (toBeString.length-1 > 24 && toBeString.length>1) {
        textField.text = [toBeString substringToIndex:25];
    }
}




-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
}





@end
