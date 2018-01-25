//
//  ZRindustryController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/25.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZRindustryController.h"

@interface ZRindustryController ()

@property (nonatomic,strong)UILabel *Industrylab;

@property (nonatomic,strong)UIButton  *Industrybtn1;
@property (nonatomic,strong)UIButton  *Industrybtn2;
@property (nonatomic,strong)UIButton  *Industrybtn3;
@property (nonatomic,strong)UIButton  *Industrybtn4;
@property (nonatomic,strong)UIButton  *Industrybtn5;
@property (nonatomic,strong)UIButton  *Industrybtn6;
@property (nonatomic,strong)UIButton  *Industrybtn7;
@property (nonatomic,strong)UIButton  *Industrybtn8;
@property (nonatomic,strong)UIButton  *Industrybtn9;
@property (nonatomic,strong)UIButton  *Industrybtn10;
@property (nonatomic,strong)UIButton  *Industrybtn11;
@property (nonatomic,strong)UIButton  *Industrybtn12;

@property (nonatomic,strong)UIButton  *surebtn;
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@end

@implementation ZRindustryController

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
    self.title = @"输入店铺行业";
    
    _Industrylab = [[UILabel alloc]init];
    _Industrylab.font = [UIFont systemFontOfSize:18.0];
    _Industrylab.textAlignment     = NSTextAlignmentCenter;
    _Industrylab.layer.cornerRadius = 4.0f;
    _Industrylab.layer.borderWidth  = 1.0f;
    if ( [_labvalue isEqualToString:@"餐饮美食"]||[_labvalue isEqualToString:@"美容美发"]||[_labvalue isEqualToString:@"服饰鞋包"]||[_labvalue isEqualToString:@"休闲娱乐"]||[_labvalue isEqualToString:@"百货超市"]||[_labvalue isEqualToString:@"生活服务"]||[_labvalue isEqualToString:@"电子通讯"]||[_labvalue isEqualToString:@"汽车服务"]||[_labvalue isEqualToString:@"医疗保健"]||[_labvalue isEqualToString:@"家居建材"]||[_labvalue isEqualToString:@"教育培训"]||[_labvalue isEqualToString:@"酒店宾馆"])
    {
        _Industrylab.text = _labvalue;
        _Industrylab.layer.borderColor = kTCColor(77, 166, 214).CGColor;
        _Industrylab.textColor  = kTCColor(77, 166, 214);
        
    }
    else{
        
        _Industrylab.text = @"请从下面选项选择对应信息";
        _Industrylab.layer.borderColor = kTCColor(161, 161, 161).CGColor;
        _Industrylab.textColor  = kTCColor(161, 161, 161);
    }

    _Industrylab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_Industrylab];
    //    适配方法
    [self.Industrylab mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    _surebtn.frame = CGRectMake(20,KMainScreenHeight-10-40*_autoSizeScaleY , KMainScreenWidth-40, 40*_autoSizeScaleY);
    [_surebtn  setBackgroundImage:[UIImage imageNamed:@"pay_bg@2x"] forState:UIControlStateNormal];
    [_surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [_surebtn addTarget:self action:@selector(sureback:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_surebtn];
    
    
 #pragma  -mark无数个按钮
    [self creatbtn];
    
}

#pragma  -mark无数个按钮
-(void)creatbtn{
    //    ²
#pragma  -mark按钮初始化
    _Industrybtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn9 = [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn10= [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn11= [UIButton buttonWithType:UIButtonTypeCustom];
    _Industrybtn12= [UIButton buttonWithType:UIButtonTypeCustom];
   
#pragma  -mark 按钮背景色
      _Industrybtn1.backgroundColor=_Industrybtn2.backgroundColor =_Industrybtn3.backgroundColor =_Industrybtn4.backgroundColor =_Industrybtn5.backgroundColor =_Industrybtn6.backgroundColor =_Industrybtn7.backgroundColor =_Industrybtn8.backgroundColor=_Industrybtn9.backgroundColor=_Industrybtn10.backgroundColor=_Industrybtn11.backgroundColor=_Industrybtn12.backgroundColor = [UIColor whiteColor];
    
#pragma  -mark 按钮文字大小
    
    _Industrybtn1.titleLabel.font =_Industrybtn2.titleLabel.font=_Industrybtn3.titleLabel.font=_Industrybtn4.titleLabel.font=_Industrybtn5.titleLabel.font=_Industrybtn6.titleLabel.font=_Industrybtn7.titleLabel.font=_Industrybtn8.titleLabel.font=_Industrybtn9.titleLabel.font=_Industrybtn10.titleLabel.font=_Industrybtn11.titleLabel.font=_Industrybtn12.titleLabel.font= [UIFont systemFontOfSize:14.0];
#pragma  -mark 按钮标题内容
    [_Industrybtn1  setTitle:@"餐饮美食"  forState:UIControlStateNormal];
    [_Industrybtn2  setTitle:@"美容美发"  forState:UIControlStateNormal];
    [_Industrybtn3  setTitle:@"服饰鞋包"  forState:UIControlStateNormal];
    [_Industrybtn4  setTitle:@"休闲娱乐"  forState:UIControlStateNormal];
    [_Industrybtn5  setTitle:@"百货超市"  forState:UIControlStateNormal];
    [_Industrybtn6  setTitle:@"生活服务"  forState:UIControlStateNormal];
    [_Industrybtn7  setTitle:@"电子通讯"  forState:UIControlStateNormal];
    [_Industrybtn8  setTitle:@"汽车服务"  forState:UIControlStateNormal];
    [_Industrybtn9  setTitle:@"医疗保健"  forState:UIControlStateNormal];
    [_Industrybtn10 setTitle:@"家居建材"  forState:UIControlStateNormal];
    [_Industrybtn11 setTitle:@"教育培训"  forState:UIControlStateNormal];
    [_Industrybtn12 setTitle:@"酒店宾馆"  forState:UIControlStateNormal];
#pragma  -mark 按钮标题颜色

if ([_labvalue isEqualToString:@"餐饮美食"]) {
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }

if ([_labvalue isEqualToString:@"美容美发"]) {
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }

if ([_labvalue isEqualToString:@"服饰鞋包"]) {
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }

if ([_labvalue isEqualToString:@"休闲娱乐"]) {
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
if ([_labvalue isEqualToString:@"百货超市"]) {

        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
if ([_labvalue isEqualToString:@"生活服务"]) {
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }

if ([_labvalue isEqualToString:@"电子通讯"]) {
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
if ([_labvalue isEqualToString:@"汽车服务"]) {
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
if ([_labvalue isEqualToString:@"医疗保健"]) {
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
}

if ([_labvalue isEqualToString:@"家居建材"]) {
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
if ([_labvalue isEqualToString:@"教育培训"]) {
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
if ([_labvalue isEqualToString:@"酒店宾馆"]) {
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    }
    
    if ([_labvalue isEqualToString:@"请填写信息"]||[_labvalue isEqualToString:@"您尚未填写信息"]) {
        [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0  alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
    }

#pragma  -mark 按钮事件
    [_Industrybtn1  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn2  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn3  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn4  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn5  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn6  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn7  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn8  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn9  addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn10 addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn11 addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Industrybtn12 addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
#pragma  -mark 按钮tag值
    _Industrybtn1.tag  = 1 ;
    _Industrybtn2.tag  = 2 ;
    _Industrybtn3.tag  = 3 ;
    _Industrybtn4.tag  = 4 ;
    _Industrybtn5.tag  = 5 ;
    _Industrybtn6.tag  = 6 ;
    _Industrybtn7.tag  = 7 ;
    _Industrybtn8.tag  = 8 ;
    _Industrybtn9.tag  = 9 ;
    _Industrybtn10.tag = 10;
    _Industrybtn11.tag = 11;
    _Industrybtn12.tag = 12;
#pragma  -mark 按钮加入视图
    [self.view addSubview:_Industrybtn1];
    [self.view addSubview:_Industrybtn2];
    [self.view addSubview:_Industrybtn3];
    [self.view addSubview:_Industrybtn4];
    [self.view addSubview:_Industrybtn5];
    [self.view addSubview:_Industrybtn6];
    [self.view addSubview:_Industrybtn7];
    [self.view addSubview:_Industrybtn8];
    [self.view addSubview:_Industrybtn9];
    [self.view addSubview:_Industrybtn10];
    [self.view addSubview:_Industrybtn11];
    [self.view addSubview:_Industrybtn12];
    
//左边
    [self.Industrybtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.Industrylab.mas_bottom).with.offset(100);
    }];
    
    [self.Industrybtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.Industrybtn1.mas_bottom).with.offset(20);
    }];
    
    [self.Industrybtn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.Industrybtn3.mas_bottom).with.offset(20);
    }];
    
    [self.Industrybtn7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.Industrybtn5.mas_bottom).with.offset(20);
    }];
    
    [self.Industrybtn9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.Industrybtn7.mas_bottom).with.offset(20);
    }];
    
    [self.Industrybtn11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.Industrybtn9.mas_bottom).with.offset(20);
    }];
    
//    右边
    [self.Industrybtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.Industrylab.mas_bottom).with.offset(100);
    }];
    
    [self.Industrybtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.Industrybtn2.mas_bottom).with.offset(20);
    }];
    
    [self.Industrybtn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.Industrybtn4.mas_bottom).with.offset(20);
    }];
    
    [self.Industrybtn8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.Industrybtn6.mas_bottom).with.offset(20);
    }];
    
    [self.Industrybtn10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.Industrybtn8.mas_bottom).with.offset(20);
    }];
    
    [self.Industrybtn12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth/2-40, 30));
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.Industrybtn10.mas_bottom).with.offset(20);
    }];
}

#pragma  -mark - 按钮确认并返回   block回去传旨了
-(void)sureback:(UIButton *)btn{
    
    if (self.Industrylab.text.length>5) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"您没有选择类型行业" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"选择" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else{

     NSLog(@"文本内容：%@",self.Industrylab.text);
    NSString *inputString;
    inputString = self.Industrylab.text;
    if (self.returnValueBlock){
        
        self.returnValueBlock(inputString);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    }
}

#pragma  -mark - 按钮点击
-(void)buttonBtnClick:(UIButton *)button{
    
    switch (button.tag) {
        case 1:{
            #pragma _Industrybtn1 点击
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn1.titleLabel.text;
        }
            break;
        case 2:{
            #pragma _Industrybtn2 点击
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn2.titleLabel.text;
        }
            break;
        case 3:{
           #pragma _Industrybtn3 点击
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn3.titleLabel.text;
        }
            break;
        case 4:{
            #pragma _Industrybtn4 点击
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn4.titleLabel.text;
        }
            break;
        case 5:{
            #pragma _Industrybtn5 点击
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn5.titleLabel.text;
        }
            break;
        case 6:{
            #pragma _Industrybtn6 点击
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn6.titleLabel.text;
        }
            break;
        case 7:{
            #pragma _Industrybtn7 点击
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn7.titleLabel.text;
        }
            break;
            
        case 8:{
#pragma _Industrybtn8 点击
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn8.titleLabel.text;
        }
            break;
        case 9:{
#pragma _Industrybtn9 点击
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn9.titleLabel.text;
        }
            break;
        case 10:{
#pragma _Industrybtn10 点击
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn10.titleLabel.text;
        }
            break;
        case 11:{
#pragma _Industrybtn11 点击
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn11.titleLabel.text;
        }
            break;
        default:{
            #pragma _Industrybtn12 点击
            [_Industrybtn12 setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn1 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn2 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn3 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn4 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn5 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn6 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn7 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn8 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn9 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn10 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_Industrybtn11 setTitleColor:[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0] forState:UIControlStateNormal];
            _Industrylab.text = _Industrybtn12.titleLabel.text;
        }
            break;
    }
    _Industrylab.layer.borderColor = kTCColor(77, 166, 214).CGColor;
    _Industrylab.textColor  = kTCColor(77, 166, 214);
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}



@end
