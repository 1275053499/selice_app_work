//
//  SattornmapController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/8.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SattornmapController.h"
#import "UIBarButtonItem+Create.h"
#import  <MapKit/MapKit.h>
#import "MyAnnptation.h"
@interface SattornmapController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *Mapview;
@property(nonatomic,strong)NSString  *title_1;
@property(nonatomic,strong)NSString  *title_2;

@property(nonatomic,strong)NSArray   *coordinateArr;
@property(nonatomic,strong)NSString  *Latitude;
@property(nonatomic,strong)NSString  *longitude;

@end

@implementation SattornmapController
//22.583620 = 113.865251

-(NSString*)title_1{
    if (!_title_1) {
        _title_1=[[NSString alloc]init];
    }
    return _title_1;
}


-(NSString*)title_2{
    if (!_title_2) {
        _title_2=[[NSString alloc]init];
    }
    return _title_2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    _longitude = [[NSString alloc]init];
//    _Latitude = [[NSString alloc]init];
    
    [self UI];
//    通过经纬度定位到点
    [self location];
    
}
-(void)UI
{
    self.title=@"地图详情";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0]];
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickXQ)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"开启导航" style:UIBarButtonItemStylePlain target:self action:@selector(navigation)];
    rightButton.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

-(void)navigation{
    
    NSLog(@"导航一下。。。。");
        NSLog(@"经纬度：%@",_coordinatedata);
        _coordinateArr= [_coordinatedata componentsSeparatedByString:@"##"]; //从字符A中分隔成2个元素的数组
        _longitude = _coordinateArr[0] ;//经度113.865251
        _Latitude  = _coordinateArr[1]; //纬度22.583620

        NSArray * endLocation = [NSArray arrayWithObjects:_Latitude,_longitude, nil];
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
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([_Latitude floatValue],[_longitude floatValue]);
    
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
    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
}


#pragma mark - 定位置
-(void)location{

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(22.583620, 113.865251);
    //精度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    //设置显示位置
    self.Mapview.region = MKCoordinateRegionMake(coordinate, span);
    self.Mapview.delegate = self;
    //地理编码类
    CLGeocoder *geo = [CLGeocoder new];
    
    NSLog(@"定位点:%@",_coordinate);
    [geo geocodeAddressString:_coordinate completionHandler:^(NSArray *placemarks, NSError *error){
    
        if (error){
            NSLog(@"error = %@",error);
        }
        else{
            
            for (CLPlacemark *mark in placemarks){
                                NSLog(@"name = %@",mark.name);
                                NSLog(@"thoroughfare = %@",mark.thoroughfare);
                                NSLog(@"subThoroughfare = %@",mark.subThoroughfare);
                                NSLog(@"locality = %@",mark.locality);
                                NSLog(@"subLocality = %@",mark.subLocality);
                                NSLog(@"location = %@",mark.location);
                                NSLog(@"addressDictionary = %@",mark.addressDictionary);
                //添加标注
                [self addAnnotation:mark];
                
                //设置地图的显示位置
                self.Mapview.region = MKCoordinateRegionMake(mark.location.coordinate, self.Mapview.region.span);

            }
        }
        
    }];
}

//添加自定义标注
-(void)addAnnotation:(CLPlacemark *)placeMark{
    MyAnnptation *annotation = [MyAnnptation new];
    annotation.title = placeMark.name;
    annotation.subtitle = placeMark.thoroughfare;
//    标注的经纬度必须要有
    annotation.coordinate = placeMark.location.coordinate;
    annotation.locality = placeMark.locality;
    annotation.subLocality = placeMark.subLocality;
    _title_1 = [NSString stringWithFormat:@"%@",annotation.locality];
    _title_2 = [NSString stringWithFormat:@"%@",annotation.subLocality];
    [self.Mapview addAnnotation:annotation];

}

#pragma mark- MKMapViewDelegate
//每添加一个自定义的标注，就触发以下代理方法
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //复用的形式创建MKAnnotationView
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    if (!annotationView) {
        
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    //设置显示的图片
    annotationView.image = [UIImage imageNamed:@"地图小标"];
    //接收点击弹出信息
    annotationView.canShowCallout = YES;
    return annotationView;
}

//返回上页
- (void)BackButtonClickXQ
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"选好了我要返回");
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    tabbar不显示出来
    self.tabBarController.tabBar.hidden=YES;
    //    让导航栏不显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //    tabbar不显示出来
    self.tabBarController.tabBar.hidden=NO;
    //    让导航栏不显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
