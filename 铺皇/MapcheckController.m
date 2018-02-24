//
//  MapcheckController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "MapcheckController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapcheckController (){
    NSString * Longitude;
    NSString * Latitude;
}
@property (weak, nonatomic) IBOutlet MKMapView *Mapview;


@end

@implementation MapcheckController


-(void)GETlog:(NSString *)address{
    
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            Longitude =[NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.longitude];
            Latitude =[NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.latitude];
            NSLog(@"纬度：Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"经度：Latitude = %f", firstPlacemark.location.coordinate.latitude);
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

-(void)navigation{
      NSLog(@"导航一下。。。。");
    NSArray * endLocation = [NSArray arrayWithObjects:Latitude,Longitude, nil];
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name=深圳市&mode=driving&coord_type=gcj02",endLocation[0],endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",@"铺皇",@"nav123456",endLocation[0],endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"铺皇",@"nav123456",endLocation[0], endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%@,%@&to=终点&coord_type=1&policy=0",endLocation[0], endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    //选择
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = maps.count;
    
    for (int i = 0; i < index; i++) {
        
        NSString * title = maps[i][@"title"];
        
        //苹果原生地图方法
        if (i == 0) {
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMap];
            }];
            [alert addAction:action];
            
            continue;
        }
        
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *urlString = maps[i][@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction * actioncancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actioncancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


//苹果地图
- (void)navAppleMap{
    
    //终点坐标
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([Latitude floatValue],[Longitude floatValue]);
    
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
    
    
    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    //第二个，都可以用
    //    NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    //                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//   地名转换经纬度
    [self GETlog:self.valueaddess];
    
    self.title = @"该店铺地图位置";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClick)];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"开启导航" style:UIBarButtonItemStylePlain target:self action:@selector(navigation)];
    rightButton.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    self.navigationItem.leftBarButtonItem = backItm;
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    // longitude = 113.860125
    // latitude  = 22.586637
    
    //经纬度
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(22.586637, 113.860125);
    //精度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    //设置显示位置
    self.Mapview.region = MKCoordinateRegionMake(coordinate, span);
    //地理编码类
    CLGeocoder *geo = [CLGeocoder new];
    
    //正向编码 地名->经纬度
    [geo geocodeAddressString:_valueaddess completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSLog(@"输入位置 == %@",_valueaddess);
        if (error) {
            NSLog(@"error = %@",error);
        }else {
            
            for (CLPlacemark *mark in placemarks) {
                //添加标注
                [self addAntationWithPlaceMark:mark];
                
                //设置地图的显示位置
                self.Mapview.region = MKCoordinateRegionMake(mark.location.coordinate, self.Mapview.region.span);
            }
        }
    }];
    
}

/**
 *  添加标注
 */
-(void)addAntationWithPlaceMark:(CLPlacemark *)placeMark{
    
    //添加系统的标注
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    
    //设置标题
    pointAnnotation.title = placeMark.name;
    //设置副标题
    pointAnnotation.subtitle = placeMark.subLocality;
    //设置标注位置
    pointAnnotation.coordinate = placeMark.location.coordinate;
    
    [self.Mapview addAnnotation:pointAnnotation];
    
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
    
}
#pragma  -mark - 按钮返回
- (void)BackButtonClick
{
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}


@end
