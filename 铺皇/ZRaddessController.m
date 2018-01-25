//
//  ZRaddessController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/24.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZRaddessController.h"
#import "PlaceholderTextView.h"
#import <MapKit/MapKit.h>
#define kTextBorderColor     RGBCOLOR(227,224,216)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface ZRaddessController ()<UITextViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
    BOOL ismap;
}
@property (nonatomic,strong)UIButton *surebtn;
@property (nonatomic,strong)UILabel  *alearlab;
@property (nonatomic, strong) PlaceholderTextView * textView;
@property(nonatomic,strong)MKMapView *mapView;

@property (nonatomic,strong)NSString  *coordinate;

@end

@implementation ZRaddessController

- (void)viewDidLoad {
    [super viewDidLoad];
    ismap = NO;//是否显示了地图
    _coordinate = [NSString new];

    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"输入店铺具体位置";
    //关键句.不然出bug
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.textView];
    
    _surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _surebtn.frame = CGRectMake(20,KMainScreenHeight-10-40 , KMainScreenWidth-40, 40);
    [_surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [_surebtn setBackgroundImage:[UIImage imageNamed:@"pay_bg@2x"] forState:UIControlStateNormal];
    [_surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_surebtn addTarget:self action:@selector(surebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_surebtn];
    
    _alearlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 114, KMainScreenWidth-20, 20)];
    _alearlab.text = @"⚠️注意限制输入字数为45个哦";
    _alearlab.textColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _alearlab.font = [UIFont systemFontOfSize:10.0];
    [self.view addSubview:_alearlab];
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
}

#pragma -mark 确定block回去传旨了
-(void)surebtn:(UIButton*)btn{
    
    NSLog(@"文本内容：%@",self.textView.text);
    if (self.textView.text.length <1) {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示"] message:@"请先输入具体地址" preferredStyle:UIAlertControllerStyleAlert];
        
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                NSLog(@"点击了取消");}];
        
                            [alertController addAction:cancelAction];
                            [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
        NSString *inputString = self.textView.text;
        if (self.returnValueBlock) {
            self.returnValueBlock(inputString);
        }
        
        if (ismap) {//加载了地图 可以直接返回经纬度
            if (self.returnValueBlockcoo) {
                self.returnValueBlockcoo(_coordinate);
            }
        }
        else{
            //没有加载了地图 可以直接返回经纬度
            //地理编码类
            CLGeocoder *geo = [CLGeocoder new];
            _quyuvalue = [_quyuvalue stringByReplacingOccurrencesOfString:@" " withString:@""]; // 去掉空格
            NSString *Geostr = [NSString stringWithFormat:@"%@%@",_quyuvalue,_textView.text];
            NSLog(@"搜索位置%@",Geostr);
            //正向编码 地名->经纬度
            [geo geocodeAddressString:Geostr completionHandler:^(NSArray *placemarks, NSError *error) {
                
                if ([placemarks count] > 0 && error == nil) {
                    NSLog(@"发现 %lu 个对应地址placemark(s).", (unsigned long)[placemarks count]);
                    CLPlacemark *Placemark = [placemarks objectAtIndex:0];
                    NSLog(@"Longitude = %f", Placemark.location.coordinate.longitude);
                    NSLog(@"Latitude = %f", Placemark.location.coordinate.latitude);
                    
                    _coordinate = [NSString stringWithFormat:@"%lf##%lf",Placemark.location.coordinate.latitude,Placemark.location.coordinate.longitude];
                    
                    if (self.returnValueBlockcoo) {
                        self.returnValueBlockcoo(_coordinate);
                    }
                }
                else if ([placemarks count] == 0 && error == nil) {
                    NSLog(@"没有找到这个地址.");
                } else if (error != nil) {
                    NSLog(@"其他错误信息 = %@", error);
                }
            }];
        }
        
        [self back];
    }
}


#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
     [self back];
}

#pragma  -mark - 返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark textView创建
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(10, 74, KMainScreenWidth-20, 40)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:18.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.returnKeyType = UIReturnKeySearch;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = kTextBorderColor.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        [_textView becomeFirstResponder];
        if ([_labvalue isEqualToString:@"请填写信息"]||[_labvalue isEqualToString:@"您尚未填写信息"]) {
             _textView.placeholder = @"请输入店铺具体位置信息";
        }
        
        else
        {
            _textView.text = _labvalue;
            [self creatmapView];
        }
    }
    
    return _textView;
}

//把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSLog(@"21213%@",textView.text);
    NSLog(@"888%@",_textView.text);
    if ([@"\n" isEqualToString:text] == YES){
        
        [textView resignFirstResponder];
        
        [self creatmapView];
        ismap = YES;
        return NO;
    }
    
    return YES;
}


/**
 点击搜索创建地图显示位置
 */
-(void)creatmapView{
    
    NSLog(@"888444%@",_textView.text);
    
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 134, KMainScreenWidth, KMainScreenHeight - 134-60)];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(22.583620, 113.865251);
    
    //精度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    //设置显示位置
    self.mapView.region = MKCoordinateRegionMake(coordinate, span);
    
    [self.view addSubview:self.mapView];
    
    //地理编码类
    CLGeocoder *geo = [CLGeocoder new];

    _quyuvalue = [_quyuvalue stringByReplacingOccurrencesOfString:@" " withString:@""]; // 去掉空格
    NSString *Geostr = [NSString stringWithFormat:@"%@%@",_quyuvalue,_textView.text];
    NSLog(@"搜索位置%@",Geostr);
    //正向编码 地名->经纬度
    [geo geocodeAddressString:Geostr completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSLog(@"输入内容 == %@",_textView.text);
        NSLog(@"搜索内容 == %@",Geostr);

        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"发现 %lu 个对应地址placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *Placemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", Placemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", Placemark.location.coordinate.latitude);
            //添加标注
            [self addAntationWithPlaceMark:Placemark];
             self.mapView.region = MKCoordinateRegionMake(Placemark.location.coordinate, self.mapView.region.span);
//            经纬度拼接到一起
            _coordinate = [NSString stringWithFormat:@"%lf##%lf",Placemark.location.coordinate.latitude,Placemark.location.coordinate.longitude];
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"没有找到这个地址.");
        } else if (error != nil) {
            NSLog(@"其他错误信息 = %@", error);
        }
    }];
}

/**
 *  添加标注
 */
-(void)addAntationWithPlaceMark:(CLPlacemark *)placeMark{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    //添加系统的标注
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    //设置标题
    pointAnnotation.title = placeMark.name;
    //设置副标题
    pointAnnotation.subtitle = placeMark.subLocality;
    //设置标注位置
    pointAnnotation.coordinate = placeMark.location.coordinate;
    [self.mapView addAnnotation:pointAnnotation];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_textView resignFirstResponder];
}

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView{
    
    [self wordLimit:textView];
}

#pragma mark 超过300字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length <= 45) {
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
        self.textView.text = [self.textView.text substringToIndex:45];
        [self presentViewController:alertC animated:YES completion:nil];
        //重新计算当前有多少个数
        [self textViewDidChange:self.textView];
    }
    return nil;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

@end
