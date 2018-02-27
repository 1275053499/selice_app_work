//
//  ShopsmapsiteViewController.m
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ShopsmapsiteViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CustomBtn.h"
#import "YJLMenu.h"
enum {
    
        AnnotationViewControllerAnnotationTypeRed = 0,
        AnnotationViewControllerAnnotationTypeGreen,
        AnnotationViewControllerAnnotationTypePurple
};

@interface ShopsmapsiteViewController ()<YJLMenuDelegate,YJLMenuDataSource,CLLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate>{
    
    NSString *OldLoadkey;
    NSString *NewLoadkey;//区域
    
}
@property (nonatomic, strong) YJLMenu           * menu;
@property (nonatomic, strong) MAMapView         * mapView   ;
@property (nonatomic, strong) AMapSearchAPI     * search    ;
@property (nonatomic, strong) NSMutableArray    * coordinates;
@property (nonatomic, strong) NSMutableArray    * LoadData  ;
#pragma -mark 定位事件1
@property (nonatomic, strong)UIButton *gpsButton;
@property (nonatomic, strong)NSString * KEYWORD;//入境

@property (nonatomic, strong)NSString * RENT;   //租金
@property (nonatomic, strong)NSString * MONEYS; //价钱
@property (nonatomic, strong)NSString * AREA;   //面积
@property (nonatomic, strong)NSString * TYPE;   //类型

@property (nonatomic, strong) NSArray           * Rent;     //租金选店
@property (nonatomic, strong) NSArray           * Price;    //费用选店
@property (nonatomic, strong) NSArray           * Acreage;  //面积选店
@property (nonatomic, strong) NSArray           * Type;     //类型选店
@property (nonatomic, strong) NSArray           * Rentid;     //租金选店id
@property (nonatomic, strong) NSArray           * Priceid;    //费用选店id
@property (nonatomic, strong) NSArray           * Acreageid;  //面积选店id
@property (nonatomic, strong) NSArray           * Typeid;     //类型选店id

@property (nonatomic, strong)UIView   * mainView;    //弹出view
@property (nonatomic, strong)NSString * mainID;    //ID全局
@property (nonatomic, strong)NSString * mainDIS;   //区分全局
@property (nonatomic, strong)UILabel   * Countlab; //计数文本

@property(nonatomic,strong)NSURLSessionDataTask*task;

@end

@implementation ShopsmapsiteViewController

#pragma -mark 尺度变化事件2
- (UIView *)makeZoomPannelView{
    
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];

    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];

    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    return ret;
}

#pragma -mark 尺度变化事件2——1 放大精确
- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
    self.mapView.showsScale = YES;
     NSLog(@"%f",oldZoom);
}

#pragma -mark 尺度变化事件2——2缩小精确
- (void)zoomMinusAction{
    
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
    self.mapView.showsScale = YES;
    NSLog(@"%f",oldZoom);
}

#pragma -mark 定位事件3
- (UIButton *)makeGPSButtonView {

    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret setImage:[UIImage imageNamed:@"gpsStat2"] forState:UIControlStateSelected];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    return ret;
}

#pragma -mark 定位事件4
- (void)gpsAction {

    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];

        NSLog(@"点击定位按钮后:经度:%f-纬度:%f",self.mapView.userLocation.location.coordinate.longitude,self.mapView.userLocation.location.coordinate.latitude);

        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark *place in placemarks) {
                //                NSDictionary *location =[place addressDictionary];
                //                NSLog(@"定位国家：%@",[location objectForKey:@"Country"]);
                //                NSLog(@"定位城市：%@",[location objectForKey:@"State"]);
                //                NSLog(@"定位区：%@",[location objectForKey:@"SubLocality"]);
                //                NSLog(@"定位位置：%@", place.name);
                //                NSLog(@"定位国家：%@",   place.country);
                //                NSLog(@"定位城市：%@",   place.locality);
                //                NSLog(@"定位区 ：%@",    place.subLocality);
                //                NSLog(@"定位街道：%@",   place.thoroughfare);
                //                NSLog(@"定位子街道：%@", place.subThoroughfare);

                self.mapView.userLocation.title = [NSString stringWithFormat:@"我的位置"];
                self.mapView.userLocation.subtitle = [NSString stringWithFormat:@"%@ %@ %@",place.locality,place.subLocality,place.thoroughfare];
//               NewLoadkey = [NSString stringWithFormat:@"%@%@",place.locality,place.subLocality];
            }
        }];
    }
}

-(void)Buildbase{
   
    self.view.backgroundColor = [UIColor whiteColor];
    OldLoadkey           = [[NSString alloc]init];
    NewLoadkey           = [[NSString alloc]init];
    self.mainID          = [[NSString alloc]init];
    self.mainDIS         = [[NSString alloc]init];
    self.LoadData        = [[NSMutableArray alloc]init];
    self.coordinates     = [[NSMutableArray alloc]init];
    
     self.RENT   = @"0";
     self.MONEYS = @"0";
     self.AREA   = @"0";
     self.TYPE   = @"0";
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClickmap)];
     self.KEYWORD =  [[NSString alloc]initWithFormat:@"diqu=南山区&upid=0&rent=0&moneys=0&area=0&type=0"];

}

-(void)BuildMap{
    #pragma -mark 地图初始化
    [AMapServices sharedServices].apiKey = @"4b4878d3c67a3a9816ad997a7cdf8326";
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 114, KMainScreenWidth, KMainScreenHeight-114)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate       = self;
    self.mapView.zoomLevel      = 16;
    self.mapView.zoomEnabled    = YES;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
#pragma -mark 自动定位事件
    self.mapView.showsUserLocation  = YES;
    self.mapView.userTrackingMode   = MAUserTrackingModeFollowWithHeading;
    MAUserLocationRepresentation *represent = [[MAUserLocationRepresentation alloc] init];
    represent.showsAccuracyRing     = YES;
    represent.showsHeadingIndicator = YES;
    represent.fillColor             = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
    represent.strokeColor           = [UIColor lightGrayColor];;
    represent.lineWidth             = 2.f;
    represent.image                 = [UIImage imageNamed:@"userPosition"];
    [self.mapView updateUserLocationRepresentation:represent];
    
#pragma -mark 手动定位事件1
    self.gpsButton = [self makeGPSButtonView];
    self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,self.view.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 20);
    [self.view addSubview:self.gpsButton];
    self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
#pragma -mark 尺度变化事件1
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 10);

    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:zoomPannelView];

    self.Countlab = [[UILabel alloc]init];
    self.Countlab.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.Countlab.font = [UIFont systemFontOfSize:12.0f];
    self.Countlab.textAlignment = NSTextAlignmentCenter;
    [self.Countlab sizeToFit];
    self.Countlab.text = @"获取数据中";
    self.Countlab.frame = CGRectMake(KMainScreenWidth/2-30, KMainScreenHeight-20, 60, 15);
    self.Countlab.textColor  = [UIColor whiteColor];
    [self.view addSubview:self.Countlab];
    
    
}

#pragma -mark 创建菜单栏
-(void)Buildmenu{
    self.Rent   = @[@"租金选店",@"1千5以下",@"1千5-3千 ",@"3千-6千"   ,@"6千-1万"     ,@"1万-3万"     ,@"3万以上"      ];
    self.Rentid = @[@"00000" ,@"0~1499",@"1500~2999",@"3000~5999",@"6000~9999",@"10000~29999",@"30000~500000"];
    
    self.Price   = @[@"低价选店",@"5万以下",@"5～10万 ",@"10～20万",@"20～40万",@"40～80万",@"80～150万" ,@"150万以上"];
    self.Priceid = @[@"00000" ,@"0~5",@"5.01~10",@"10.01~20",@"20.01~40",@"40.01~80",@"80.01~150",@"150.01~50000"];
   
    self.Acreage   = @[@"合适面积",@"30m²以下",@"31～60m²",@"61～100m²",@"101～150m²",@"151～200m²",@"201～300m²",@"301～500m²",@"500m²以上"];
    self.Acreageid = @[@"00000",@"0~30",@"31~60",@"61~100",@"101~150",@"151~200",@"201~300",@"301~500",@"501~50000000"];
    
    self.Type    = @[@"经营行业",@"餐饮美食",@"美容美发",@"服饰鞋包",@"休闲娱乐",@"百货超市",@"生活服务",@"电子通讯",@"汽车服务",@"医疗保健",@"家居建材",@"教育培训",@"酒店宾馆"];
    self.Typeid = @[@"00000",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
#pragma -mark 创建条件选择视图
    _menu = [[YJLMenu alloc] initWithOrigin:CGPointMake(0, 64 ) andHeight:50];
    _menu.delegate   = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
}

#pragma  - mark UItextfield 代理方法 end
#pragma -mark - 菜单的代理方法 start
-(NSInteger )numberOfColumnsInMenu:(YJLMenu *)menu{
    
    return 4;
}

-(NSInteger )menu:(YJLMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    
    if (column == 0) {
        return self.Rent.count;
    }
    if (column == 1) {
        return self.Price.count;
    }
    if (column == 2) {
        return self.Acreage.count;
    }else{
        return self.Type.count;
    }
}

-(NSString *)menu:(YJLMenu *)menu titleForRowAtIndexPath:(YJLIndexPath *)indexPath{
    
    if (indexPath.column  == 0) {
        
        return self.Rent[indexPath.row];
    }else if (indexPath.column == 1){
        
        return self.Price[indexPath.row];
    }else if (indexPath.column == 2){
        
        return self.Acreage[indexPath.row];
    }else{
        
        return self.Type[indexPath.row];
    }
}

- (void)menu:(YJLMenu *)menu didSelectRowAtIndexPath:(YJLIndexPath *)indexPath {
    
    if (indexPath.item >= 0)   //有二级菜单
    {
        NSLog(@"点击了 %ld列 - 第%ld栏（一级） - %ld栏（二级）",indexPath.column+1,indexPath.row + 1,indexPath.item+1);
    }
    else {
        NSLog(@"点击了 %ld列 - 第%ld栏（一级）",indexPath.column+1,indexPath.row+1);
        switch (indexPath.column+1){
            case 1:{
                
                valuerent1 = self.Rent[indexPath.row];
                valuerent1id = self.Rentid[indexPath.row];
                NSLog(@"获取值租金 = %@",valuerent1);
                NSLog(@"获取值租金id = %@",valuerent1id);
            }
                break;
                
            case 2:{
                
                valuemoney2 = self.Price[indexPath.row];
                NSLog(@"获取值费用 = %@",valuemoney2);
                valuemoney2id = self.Priceid[indexPath.row];
                NSLog(@"获取值费用id = %@",valuemoney2id);
            }
                break;
                
            case 3:{
                
                valuearea3 = self.Acreage[indexPath.row];
                NSLog(@"获取值面积 = %@",valuearea3);
                valuearea3id = self.Acreageid[indexPath.row];
                NSLog(@"获取值面积id = %@",valuearea3id);
            }
                break;
                
            case 4:{
                
                valuetype4 = self.Type[indexPath.row];
                NSLog(@"获取值类型 = %@",valuetype4);
                valuetype4id = self.Typeid[indexPath.row];
                NSLog(@"获取值类型id = %@",valuetype4id);
            }
                break;
        }
#pragma -mark 显示当前点击多少项  那几项名称 id
        [self setup:valuerent1id :valuemoney2id :valuearea3id :valuetype4id];
    }
}

#pragma -mark 显示当前点击多少项  那几项名称id 方法
-(void)setup:(NSString *)value1 :(NSString *)value2 : (NSString *)value3 :(NSString *)value4{
    
    NSLog(@"%@~~%@~~%@~~%@",value1,value2,value3,value4);
    if (value1.length<1) {
        value1 = @"0";
    }
    if (value2.length<1) {
        value2 = @"0";
    }
    if (value3.length<1) {
        value3 = @"0";
    }
    if (value4.length<1) {
        value4 = @"0";
    }
    
    self.RENT   = value1;
    self.MONEYS = value2;
    self.AREA   = value3;
    self.TYPE   = value4;
    
    [self.mapView removeAnnotations:self.coordinates];
    
     self.KEYWORD =  [[NSString alloc]initWithFormat:@"diqu=%@&rent=%@&moneys=%@&area=%@&type=%@",[NewLoadkey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],self.RENT,self.MONEYS,self.AREA,self.TYPE ];
   
    NSLog(@"拼接字符串%@",_KEYWORD);
    
    [self loadanntions];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
   
//    基础类
    [self Buildbase];
    [self BuildMap ];
    [self Buildmenu];

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    MAAnnotationView *userLocationView = [self.mapView viewForAnnotation:self.mapView.userLocation];
    [UIView animateWithDuration:0.1 animations:^{

        double degree = self.mapView.userLocation.heading.trueHeading - self.mapView.rotationDegree;
        userLocationView.imageView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
    }];
}

/**
        加载数据的
 */
#pragma mark - Initialization
- (void)initAnnotations{

    [self.coordinates removeAllObjects];
    NSLog(@"个数啊啊啊啊啊啊啊%ld",self.LoadData.count);
    for (int i = 0; i < self.LoadData.count; i++){
    
        Mapmodel  * model = self.LoadData[i];
        
        MyAnnptation * an = [[MyAnnptation alloc]init];
        an.title        = model.Maptitle;
        an.subtitle     = model.Mapdistrict;
        an.coordinate   = CLLocationCoordinate2DMake([model.MapCoordinateLatitude doubleValue], [model.MapCoordinateLongitude doubleValue]);
        an.subid        = model.Mapsubid;
        [self.coordinates addObject:an];
        
    }
    
     [self.mapView addAnnotations:self.coordinates];
}

/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        
        return nil;
    }
    
    if ([annotation isKindOfClass:[MyAnnptation class]]){
        
            static NSString *pointReuseIndetifier = @"MyAnnptationIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil){
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
        
            annotationView.image    = [UIImage imageNamed:@"地图小标"];
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView.centerOffset = CGPointMake(0, -20);
            annotationView.canShowCallout               = YES;//是否允许弹出callout
            annotationView.animatesDrop                 = NO;//出现动画
            annotationView.draggable                    = NO;//是否支持拖动
            CustomBtn *Cus = [CustomBtn buttonWithType:UIButtonTypeCustom];
            Cus.backgroundColor = [UIColor clearColor];
            [Cus setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            Cus.frame = CGRectMake(0, 0, 50, 30);
            [Cus setTitle:@"详情" forState:UIControlStateNormal];
            [Cus addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = Cus;
            Cus.subid = [(MyAnnptation *)annotation subid];
            return annotationView;
    }
    
    return nil;
}


/**
 * @brief 当选中一个annotation view时，调用此接口. 注意如果已经是选中状态，再次点击不会触发此回调。取消选中需调用-(void)deselectAnnotation:animated:
 * @param mapView 地图View
 * @param view 选中的annotation view
 */

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
    NSLog(@"当选中一个annotation view时，调用此接口. 注意如果已经是选中状态，再次点击不会触发此回调。取消选中需调用");
//    NSLog(@"点击view title：%@",view.annotation.title);
//    NSLog(@"点击view subtitle：%@",view.annotation.subtitle);
//    NSLog(@"%f-%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    for (int i = 0; i < self.coordinates.count; i++) {

        if (view.annotation.coordinate.latitude == ((MyAnnptation *)self.coordinates[i]).coordinate.latitude&&view.annotation.coordinate.longitude == ((MyAnnptation *)self.coordinates[i]).coordinate.longitude&&[view.annotation.title isEqualToString: ((MyAnnptation *)self.coordinates[i]).title]&&[view.annotation.subtitle isEqualToString: ((MyAnnptation *)self.coordinates[i]).subtitle]) {
            
            Mapmodel *model = self.LoadData[i];
//            NSLog(@"标题：%@",model.Maptitle);
//            NSLog(@"具体位置：%@",model.Mapdistrict);
//            NSLog(@"ID：%@",model.Mapsubid);
//            NSLog(@"纬度：%@",model.MapCoordinateLatitude);
//            NSLog(@"经度：%@",model.MapCoordinateLongitude);
            NSLog(@"区分: %@",model.Mapdistinction);
            self.mainID  = model.Mapsubid;
            self.mainDIS = model.Mapdistinction;
            [self Build:self.mainID];
            return;//当有2个一样的定位时跳出循环体
        }
    }
}


#pragma -mark  创建弹出视图
-(void)Build:(NSString *)ID{
    
//    NSLog(@"创建视图:%ld",[ID integerValue]);
    
    for (int i = 0; i < self.LoadData.count; i++) {
        
        Mapmodel *model = self.LoadData[i];
        
        if ([model.Mapsubid isEqualToString:ID]) {
            
//            NSLog(@"%@",model.Mapsubid);
//            NSLog(@"%@",ID);
       
            self.mainView = [[UIView alloc]init];
            self.mainView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
            [self.view addSubview:self.mainView];
            [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(0);
                make.left.equalTo(self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 200));
            }];
            
//            图片
            UIImageView *IMG =[[UIImageView alloc]init];
            [IMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.Mapimg]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
            [self.mainView addSubview:IMG];
            [IMG mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(150, 180));
                make.left.equalTo(self.mainView).with.offset(10);
                make.top.equalTo(self.mainView).with.offset(10);
            }];
            
//            标题
            UILabel *Maptitle       =[[UILabel alloc]init];
            Maptitle.text           = [NSString stringWithFormat:@"[标题]:%@",model.Maptitle];
            Maptitle.textColor      = [UIColor blackColor];
            Maptitle.lineBreakMode  = NSLineBreakByTruncatingMiddle;
            Maptitle.numberOfLines  = 0;
            Maptitle.textAlignment  = NSTextAlignmentLeft;
            Maptitle.font           = [UIFont systemFontOfSize:12.0f];
            [self.mainView addSubview:Maptitle];
            [Maptitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-180, 15));
                make.left.equalTo(IMG.mas_right).with.offset(10);
                make.top.equalTo(self.mainView).with.offset(10);
            }];
            
//            具体地址
            UILabel *Mapdistrict    = [[UILabel alloc]init];
            Mapdistrict.text        = [NSString stringWithFormat:@"[位置]:%@",model.Mapdistrict];
            Mapdistrict.textColor   = [UIColor blackColor];
            Mapdistrict.lineBreakMode = NSLineBreakByTruncatingTail;
            Mapdistrict.numberOfLines = 0;
            Mapdistrict.textAlignment = NSTextAlignmentLeft;
            Mapdistrict.font          = [UIFont systemFontOfSize:12.0f];
            [self.mainView addSubview:Mapdistrict];
            [Mapdistrict mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-180, 15));
                make.left.equalTo(IMG.mas_right).with.offset(10);
                make.top.equalTo(Maptitle.mas_bottom).with.offset(10);
            }];
            
//            时间
            UILabel *Maptime =[[UILabel alloc]init];
            Maptime.textColor = kTCColor(85, 85, 85);
            Maptime.textAlignment = NSTextAlignmentLeft;
            Maptime.font = [UIFont systemFontOfSize:12.0f];
            Maptime.adjustsFontSizeToFitWidth=YES;
            NSMutableAttributedString *Maptimestring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[更新时间]:%@",model.Maptime]];
            //修改颜色
            [Maptimestring addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 7)];
            Maptime.attributedText = Maptimestring;
            [self.mainView addSubview:Maptime];
            [Maptime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-180, 15));
                make.left.equalTo(IMG.mas_right).with.offset(10);
                make.top.equalTo(Mapdistrict.mas_bottom).with.offset(10);
            }];
            
            
//            租金Maprent
            UILabel *Maprent           = [[UILabel alloc]init];
            Maprent.textColor          = kTCColor(255, 0, 0);
            Maprent.textAlignment      = NSTextAlignmentLeft;
            Maprent.font               = [UIFont systemFontOfSize:12.0f];
            Maprent.adjustsFontSizeToFitWidth=YES;
            NSMutableAttributedString *Maprentstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[租金]:%@元/月",model.Maprent]];
            //修改颜色
            [Maprentstring addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
            Maprent.attributedText = Maprentstring;
       
            [self.mainView addSubview:Maprent];
            [Maprent mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-180, 15));
                make.left.equalTo(IMG.mas_right).with.offset(10);
                make.top.equalTo(Maptime.mas_bottom).with.offset(10);
            }];
            
//            费用 Mapmoneys
            UILabel *Mapmoneys           = [[UILabel alloc]init];
            Mapmoneys.textColor          = kTCColor(255, 0, 0);
            Mapmoneys.textAlignment      = NSTextAlignmentLeft;
            Mapmoneys.adjustsFontSizeToFitWidth=YES;
            Mapmoneys.font               = [UIFont systemFontOfSize:12.0f];
            if ([self.mainDIS isEqualToString:@"zr"]) {
               NSMutableAttributedString *Mapmoneysstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[费用]:%@万",model.Mapmoneys]];
                //修改颜色
                [Mapmoneysstring addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
                Mapmoneys.attributedText     = Mapmoneysstring;
                [self.mainView addSubview:Mapmoneys];
                [Mapmoneys mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-180, 15));
                    make.left.equalTo(IMG.mas_right).with.offset(10);
                    make.top.equalTo(Maprent.mas_bottom).with.offset(10);
                }];
            }else{
                NSMutableAttributedString *Mapmoneysstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[租金类型]:%@",model.Mapmoneys]];
                //修改颜色
                [Mapmoneysstring addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
                Mapmoneys.attributedText     = Mapmoneysstring;
                [self.mainView addSubview:Mapmoneys];
                [Mapmoneys mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-180, 15));
                    make.left.equalTo(IMG.mas_right).with.offset(10);
                    make.top.equalTo(Maprent.mas_bottom).with.offset(10);
                }];
            }
            
//            类型 Maptype
            UILabel *Maptype =[[UILabel alloc]init];
            Maptype.text               = [NSString stringWithFormat:@"%@",model.Maptype];
            Maptype.textColor          = kTCColor(210, 54, 50);
            Maptype.layer.borderColor  = kTCColor(210, 54, 50).CGColor;
            Maptype.layer.borderWidth  = 0.5f;
            Maptype.layer.cornerRadius = 4.0f;
            Maptype.textAlignment      = NSTextAlignmentCenter;
            Maptype.adjustsFontSizeToFitWidth=YES;
            Maptype.font               = [UIFont systemFontOfSize:12.0f];
            [self.mainView addSubview:Maptype];
            [Maptype mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(50, 15));
                make.left.equalTo(IMG.mas_right).with.offset(10);
                make.top.equalTo(Mapmoneys.mas_bottom).with.offset(10);
            }];
            
//            面积 Maparea
            UILabel *Maparea           = [[UILabel alloc]init];
            Maparea.text               = [NSString stringWithFormat:@"%@m²",model.Maparea];
            Maparea.textColor          = kTCColor(255, 191, 0);
            Maparea.layer.borderColor  = kTCColor(255, 191, 0).CGColor;
            Maparea.layer.borderWidth  = 0.5f;
            Maparea.layer.cornerRadius = 4.0f;
            Maparea.textAlignment      = NSTextAlignmentCenter;
            Maparea.adjustsFontSizeToFitWidth=YES;
            Maparea.font               = [UIFont systemFontOfSize:12.0f];
            [self.mainView addSubview:Maparea];
            [Maparea mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(50, 15));
                make.left.equalTo(Maptype.mas_right).with.offset(10);
                make.top.equalTo(Mapmoneys.mas_bottom).with.offset(10);
            }];
            
//            区域 Mapdityour
            UILabel *Mapdityour           = [[UILabel alloc]init];
            Mapdityour.text               = [NSString stringWithFormat:@"%@",model.Mapdityour];
            Mapdityour.textColor          = kTCColor(77, 166, 214);
            Mapdityour.layer.borderColor  = [kTCColor(77, 166, 214) CGColor];
            Mapdityour.layer.borderWidth  = 0.5f;
            Mapdityour.layer.cornerRadius = 4.0f;
            Mapdityour.textAlignment      = NSTextAlignmentCenter;
            Mapdityour.adjustsFontSizeToFitWidth=YES;
            Mapdityour.font               = [UIFont systemFontOfSize:12.0f];
            [self.mainView addSubview:Mapdityour];
            [Mapdityour mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(50, 15));
                make.left.equalTo(Maparea.mas_right).with.offset(10);
                make.top.equalTo(Mapmoneys.mas_bottom).with.offset(10);
            }];
            
//           查看详情
            UILabel *check           = [[UILabel alloc]init];
            check.text               = @"详情";
            check.textColor          = [UIColor orangeColor];
            check.textAlignment      = NSTextAlignmentRight;
            check.font               = [UIFont systemFontOfSize:14.0f];
            [self.mainView addSubview:check];
            [check mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-180, 20));
                make.left.equalTo(IMG.mas_right).with.offset(10);
                make.bottom.equalTo(IMG.mas_bottom).with.offset(0);
            }];

            check.userInteractionEnabled=YES;
            UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [check addGestureRecognizer:tapGesturRecognizer];
        }
    }
}


#pragma - mark  弹出框的按钮
-(void)tapAction:(id)tap{
    
//    NSLog(@"点击了tapView");
  
        //    去详情页
    DetailedController *ctl =[[DetailedController alloc]init];
    ctl.shopsubid = self.mainID;
    if ([self.mainDIS isEqualToString:@"zr"]) {
        ctl.shopcode  = @"transfer";
    }else{
        ctl.shopcode  = @"rentout";
    }
    
//    NSLog(@"店铺🆔%@",ctl.shopsubid);
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

/**
 * @brief 当取消选中一个annotation view时，调用此接口
 * @param mapView 地图View
 * @param view 取消选中的annotation view
 */

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"当取消选中一个annotation view时，调用此接口");
   
    [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 0));
    }];
}

#pragma - mark  annionview按钮事件
-(void)check:(UIButton *)sender{
    
//    NSLog(@"查看详情");
//    NSLog(@"%@", [(CustomBtn *)sender  subid]);
    
    //    去详情页
    DetailedController *ctl =[[DetailedController alloc]init];
    ctl.shopsubid = [(CustomBtn *)sender  subid];
    if ([self.mainDIS isEqualToString:@"zr"]) {
        ctl.shopcode  = @"transfer";
    }else{
        ctl.shopcode  = @"rentout";
    }
//    NSLog(@"店铺🆔%@",ctl.shopsubid);
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

#pragma mark -自定位事件
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

    if (!updatingLocation){

//        NSLog(@"自定位方向改变就会动 纬度:%f 精度:%f", userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark *place in placemarks) {
                //                NSDictionary *location =[place addressDictionary];
                //                NSLog(@"定位国家：%@",[location objectForKey:@"Country"]);
                //                NSLog(@"定位城市：%@",[location objectForKey:@"State"]);
                //                NSLog(@"定位区：%@",[location objectForKey:@"SubLocality"]);
                //                NSLog(@"定位位置：%@", place.name);
                //                NSLog(@"进入自定位国家：%@", place.country);
                //                NSLog(@"进入自定位城市：%@", place.locality);
                //                NSLog(@"进入自定位区 ：%@",  place.subLocality);
                //                NSLog(@"进入自定位街道：%@", place.thoroughfare);
                //                NSLog(@"进入自定位子街道：%@", place.subThoroughfare);

                self.mapView.userLocation.title    = [NSString stringWithFormat:@"我的位置"];
                self.mapView.userLocation.subtitle = [NSString stringWithFormat:@"%@ %@ %@",place.locality,place.subLocality,place.thoroughfare];
            }
        }];

        MAAnnotationView *userLocationView = [mapView viewForAnnotation:mapView.userLocation];
        [UIView animateWithDuration:0.1 animations:^{

            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            userLocationView.imageView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}

/**
 * @brief 地图区域即将改变时会调用此接口
 * @param mapView 地图View
 * @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
     [self.gpsButton setSelected:NO];
}

/**
 * @brief 地图区域改变完成后会调用此接口
 * @param mapView 地图View
 * @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//     NSLog(@"地图区域改变完成后会调用此接口");
    
        MACoordinateRegion region;
        CLLocationCoordinate2D centerCoordinate = mapView.region.center;
        region.center = centerCoordinate;
//        NSLog(@"地图区域范围改变了 经度:%f 纬度:%f",centerCoordinate.longitude,centerCoordinate.latitude);
    
//    逆编码事件
    [AMapServices sharedServices].apiKey = @"4b4878d3c67a3a9816ad997a7cdf8326";
    self.search  = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    /**
     *  逆地址编码查询接口
     *  request 查询选项。具体属性字段请参考 AMapReGeocodeSearchRequest 类。
     */
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc]init];
    regeo.location = [AMapGeoPoint locationWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    regeo.requireExtension = YES;
   //发起逆地理编码
    [self.search AMapReGoecodeSearch:regeo];
}

/**
 * @brief 逆地理编码查询回调函数
 * @param request  发起的请求，具体字段参考 AMapReGeocodeSearchRequest 。
 * @param response 响应结果，具体字段参考 AMapReGeocodeSearchResponse 。
 */

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    if (response.regeocode !=nil ){
        
//        NSLog(@"反向地理编码回调 省/直辖市:%@",response.regeocode.addressComponent.province);
//        NSLog(@"反向地理编码回调 市:%@",response.regeocode.addressComponent.city);
//        NSLog(@"反向地理编码回调 城市编码:%@",response.regeocode.addressComponent.citycode);
//        NSLog(@"反向地理编码回调 区:%@",response.regeocode.addressComponent.district);
//        NSLog(@"反向地理编码回调 区域编码:%@",response.regeocode.addressComponent.adcode);
//        NSLog(@"反向地理编码回调 乡镇街道:%@",response.regeocode.addressComponent.township);
//        NSLog(@"反向地理编码回调 乡镇街道编码:%@",response.regeocode.addressComponent.towncode);
//        NSLog(@"反向地理编码回调 社区:%@",response.regeocode.addressComponent.neighborhood);
//        NSLog(@"反向地理编码回调 建筑:%@",response.regeocode.addressComponent.building);
//        NSLog(@"反向地理编码回调 门牌信息:%@",response.regeocode.addressComponent.streetNumber);
        
        NewLoadkey =  [NSString stringWithFormat:@"%@",response.regeocode.addressComponent.district];
         self.title =[NSString stringWithFormat:@"%@▪️%@▪️地图选铺",response.regeocode.addressComponent.city,NewLoadkey];
        NewLoadkey = [NewLoadkey stringByReplacingOccurrencesOfString:@"区" withString:@""];
//        NSLog(@"去哪里了 我的新位置%@",NewLoadkey);
       
        if ([self.cityname isEqualToString:response.regeocode.addressComponent.city]) {//如果城市一样可以进行下一步
            
            if ( [NewLoadkey isEqualToString:OldLoadkey]) {
//                NSLog(@"一样的 旧：%@  新：%@",OldLoadkey,NewLoadkey);
//                NSLog(@"一样的");
            }
            else{
                
                [self.mapView removeAnnotations:self.coordinates];
//                NSLog(@"不一样的 旧：%@  新：%@",OldLoadkey,NewLoadkey);
//                NSLog(@"不是一样的");
                
                self.KEYWORD =  [[NSString alloc]initWithFormat:@"diqu=%@&rent=%@&moneys=%@&area=%@&type=%@",[NewLoadkey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],self.RENT,self.MONEYS,self.AREA,self.TYPE ];
                [self loadanntions];
                OldLoadkey = NewLoadkey;
            }
            
        }else{//如果城市不一样可以进行下一步
            
            [YJLHUD showImage:nil message:[NSString stringWithFormat:@"您当前查询范围已经超越了%@，如需查询，请先切换城市",self.cityname]];//无图片 纯文字
            [YJLHUD dismissWithDelay:1];
            
        }
        
    }
}

#pragma -mark 数据获取
-(void)loadanntions{
    
        [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    
        [self.LoadData removeAllObjects];
        NSString  * URL = [NSString stringWithFormat:@"%@?city=%@&%@",Hostmaplistpath,self.cityid,self.KEYWORD];
        NSLog(@"获取地图数据请求入境：%@",URL);
        AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
        manager.responseSerializer          = [AFJSONResponseSerializer serializer];
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
        manager.requestSerializer.timeoutInterval = 10.0;
     self.task = [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
    
            NSLog(@"数据:%@",    responseObject[@"data"]);
//            NSLog(@"数据状态:%@", responseObject[@"code"]);
            if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                [YJLHUD showSuccessWithmessage:@"加载成功"];
                [YJLHUD dismissWithDelay:1];
                NSLog(@"可以拿到数据的");
                for (NSDictionary *dic in responseObject[@"data"][@"zr"]){
                    
                    Mapmodel *mapmodel = [[Mapmodel alloc]init];
                    NSArray * coordinateArr;
                    coordinateArr = [dic[@"coordinate"] componentsSeparatedByString:@"##"]; //从字符A中分隔成2个元素的数
                    mapmodel.MapCoordinateLongitude = coordinateArr[0];//店铺经度
                    mapmodel.MapCoordinateLatitude  = coordinateArr[1];//店铺纬度
                    
                     mapmodel.Mapimg   = dic[@"images"  ];      //店铺图像
                     mapmodel.Maptitle = dic[@"title"   ];      //店铺标题
                     mapmodel.Maptype  = dic[@"type"    ];      //店铺类型
                     mapmodel.Mapsubid = dic[@"id"      ];      //店铺唯一id
                     mapmodel.Maprent  = dic[@"rent"    ];        //店铺租金
                     mapmodel.Mapuser  = dic[@"users"   ];        //店铺联系人
                     mapmodel.Maptime   = dic[@"time"   ];        //店铺时间
                     mapmodel.Maparea   = dic[@"area"   ];        //店铺面积
                     mapmodel.Mapmoneys = dic[@"moneys" ];        //店铺费用
                     mapmodel.Mapphone  = dic[@"phone"  ];        //店铺联系号码
                     mapmodel.Mapuser   = dic[@"users"  ];        //店铺联系人
                     mapmodel.Mapdityour   = dic[@"city"];        //店铺区域
                     mapmodel.Mapdistrict  = dic[@"district"];     //店铺具体地址
                    mapmodel.Mapdistinction = dic[@"name"];//区分是什么套餐的
                    [mapmodel setValuesForKeysWithDictionary:dic];
                    [self.LoadData addObject:mapmodel];
                    
                }
                
                for (NSDictionary *dic in responseObject[@"data"][@"cz"]){
                    
                    Mapmodel *mapmodel = [[Mapmodel alloc]init];
                    NSArray * coordinateArr;
                    coordinateArr = [dic[@"coordinate"] componentsSeparatedByString:@"##"]; //从字符A中分隔成2个元素的数
                    mapmodel.MapCoordinateLongitude = coordinateArr[0];//店铺经度
                    mapmodel.MapCoordinateLatitude  = coordinateArr[1];//店铺纬度
                    
                    mapmodel.Mapimg   = dic[@"images"  ];      //店铺图像
                    mapmodel.Maptitle = dic[@"title"   ];      //店铺标题
                    mapmodel.Maptype  = dic[@"type"    ];      //店铺类型
                    mapmodel.Mapsubid = dic[@"id"      ];      //店铺唯一id
                    mapmodel.Maprent  = dic[@"rent"    ];        //店铺租金
                    mapmodel.Mapuser  = dic[@"users"   ];        //店铺联系人
                    mapmodel.Maptime   = dic[@"time"   ];        //店铺时间
                    mapmodel.Maparea   = dic[@"area"   ];        //店铺面积
                    mapmodel.Mapmoneys = dic[@"moneys" ];        //店铺费用
                    mapmodel.Mapphone  = dic[@"phone"  ];        //店铺联系号码
                    mapmodel.Mapuser   = dic[@"users"  ];        //店铺联系人
                    mapmodel.Mapdityour   = dic[@"city"];        //店铺区域
                    mapmodel.Mapdistrict  = dic[@"district"];     //店铺具体地址
                    mapmodel.Mapdistinction = dic[@"name"];//区分是什么套餐的
                    [mapmodel setValuesForKeysWithDictionary:dic];
                    [self.LoadData addObject:mapmodel];
                    
                }
                
                
                [YJLHUD showImage:nil message:[NSString stringWithFormat:@"当前共获取到%ld套信息",self.LoadData.count]];//无图片 纯文字
                [YJLHUD dismissWithDelay:2];
                NSLog(@"总请求到数据有%ld个",self.LoadData.count);
                self.Countlab.text =[NSString stringWithFormat:@"当前%ld套",self.LoadData.count];
               
            }
            
            else{
                
                //code 499
                NSLog(@"没有数据了");
                [YJLHUD showErrorWithmessage:@"服务器开小差了，稍等~"];
                [YJLHUD dismissWithDelay:1];
                self.Countlab.text = @"当前0套";
            }
            
             [self initAnnotations];
            
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"ERROR:%@",error);
            
            if (error.code == -999) {
                NSLog(@"网络数据连接取消");
            }else{
            [YJLHUD showErrorWithmessage:@"服务器开小差了，稍等~"];
            [YJLHUD dismissWithDelay:1];
            self.Countlab.text = @"连接失败";
        }
    }];
}

/**
 * @brief 在地图View将要启动定位时，会调用此函数
 * @param mapView 地图View
 */

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView{
     NSLog(@"在地图View将要启动定位时，会调用此函数");

}

/**
 * @brief 在地图View停止定位后，会调用此函数
 * @param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView{
     NSLog(@"在地图View停止定位后，会调用此函数");
}

/**
 * @brief 定位失败后，会调用此函数
 * @param mapView 地图View
 * @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
     NSLog(@"定位失败后，会调用此函数");
    
    NSLog(@"定位失败:%@",error);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}


- (void)BackButtonClickmap{
    if(self.task) {
        [self.task cancel];//取消当前界面的数据请求.
        
    }
    [self.mainView removeFromSuperview];
    [self.mapView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
    
    
}

@end
