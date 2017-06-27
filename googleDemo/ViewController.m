//
//  ViewController.m
//  googleDemo
//
//  Created by 166 on 2017/5/27.
//  Copyright © 2017年 166. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>
#import <MapKit/MapKit.h>
#import "MHNetwrok.h"
#import "jxhttps.h"


@interface ViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate>



@property (nonatomic,strong) GMSMarker *marker;
@property (nonatomic,strong) GMSMapView *mapView;
@property (nonatomic,strong) GMSGeocoder * geocoder;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic,strong) GMSPlacesClient *placesClient;
@property (nonatomic,strong) GMSPlacePicker *placePicker;

@property (nonatomic,strong) GMSMutablePath *path ;
@property (nonatomic,strong)GMSPolyline *polyline;

@property (nonatomic,strong)UIButton *pickPlaceBtn;//地点选择器btn
@property (nonatomic,strong)UIButton *seachBtn;//地点自动填充
@property (nonatomic,strong)UIButton *startNavnBtn;//开始导航按钮
@property (nonatomic,strong)UILabel *label;//显示距离位置的label；

//存放用户位置的数组
@property (nonatomic, strong) NSMutableArray *locationMutableArray;

@property (nonatomic,assign)CLLocationCoordinate2D purposeCord;//目的地
@property (nonatomic,strong)NSString *purposeTitle;//目的地名字


@end




@implementation ViewController


-(UIButton *)pickPlaceBtn
{
    
    if (!_pickPlaceBtn) {
        
        _pickPlaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pickPlaceBtn.frame = CGRectMake(25, 20, 100, 30);
        [_pickPlaceBtn setTitle:@"地点选择器" forState:UIControlStateNormal];
        [_pickPlaceBtn addTarget:self action:@selector(pickPlace) forControlEvents:UIControlEventTouchUpInside];
        _pickPlaceBtn.backgroundColor = [UIColor lightGrayColor];
    }
    return _pickPlaceBtn;
    
}


-(UIButton *)seachBtn
{
    
    if (!_seachBtn) {
        
        _seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _seachBtn.frame = CGRectMake(self.view.frame.size.width-125, 20, 100, 30);
        [_seachBtn setTitle:@"搜索选取地址" forState:UIControlStateNormal];
        [_seachBtn addTarget:self action:@selector(onLaunchClicked:) forControlEvents:UIControlEventTouchUpInside];
        _seachBtn.backgroundColor = [UIColor lightGrayColor];
    }
    return _seachBtn;
    
}

-(UIButton *)startNavnBtn
{
    
    if (!_startNavnBtn) {
        
        _startNavnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startNavnBtn.frame = CGRectMake(self.view.frame.size.width-125, 65, 100, 30);
        [_startNavnBtn setTitle:@"开始导航" forState:UIControlStateNormal];
        [_startNavnBtn addTarget:self action:@selector(navigation) forControlEvents:UIControlEventTouchUpInside];
        _startNavnBtn.backgroundColor = [UIColor lightGrayColor];
    }
    return _startNavnBtn;
    
}


-(UILabel *)label
{
    if (!_label) {
        _label =[[UILabel alloc]initWithFrame:CGRectMake(25, 65, 200, 50)];
        _label.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _label;
}


-(CLLocationManager *)locationManager
{
    
    if (!_locationManager ) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //位置信息更新最小距离
        _locationManager.distanceFilter = 1;
        //创建存放位置的数组
        _locationMutableArray = [[NSMutableArray alloc] init];
        
    }
    return _locationManager;
}



-(GMSMapView *)mapView
{
    if (!_mapView) {
        
//        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:7];
//        _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        _mapView = [[GMSMapView alloc]initWithFrame:self.view.frame];
        _mapView.myLocationEnabled = YES;//自己的位置定位打开
        _mapView.settings.compassButton = YES;//打开指南针
        _mapView.settings.myLocationButton = YES;//我的位置点击会聚焦
        _mapView.delegate = self;
        
    }
    return _mapView;
}


-(GMSMarker *)marker
{
    if (!_marker) {
        
        _marker = [[GMSMarker alloc] init];
        _marker.appearAnimation = kGMSMarkerAnimationPop;
        
//        self.marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        self.marker.map = self.mapView;
    }
    
    return _marker;
}


-(GMSGeocoder *)geocoder
{
    
    if (!_geocoder) {
        
        
        _geocoder = [GMSGeocoder geocoder];
    }
    return _geocoder;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];


    self.polyline = [[GMSPolyline alloc]init];
    self.path = [GMSMutablePath path];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.pickPlaceBtn];
    [self.view addSubview:self.seachBtn];
    [self.view addSubview:self.label];
    [self.view addSubview:self.startNavnBtn];
    NSLog(@"User's location: %@", self.mapView.myLocation);
    

    


    
    
    
    
    
    
    [self findMe];
    
    [self getLoad];

}


//地点选举器
-(void)pickPlace
{


    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(30.484500, 114.405438);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {

            
            NSLog(@"place.name=%@-----addressLabel=%@",place.name,[[place.formattedAddress componentsSeparatedByString:@", "]
            
                                                                   componentsJoinedByString:@"\n"]);
            //根据地点选择器选择周围位置
            self.marker.position = place.coordinate;
            
        } else {
            
            
            
        }
    }];
    
}

#pragma mark -搜索

//地址补全
- (void)onLaunchClicked:(id)sender {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

// 搜索后处理用户选择.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name： %@", place.name);
    NSLog(@"Place address ：%@", place.formattedAddress);
    NSLog(@"Place attributions ：%@", place.attributions.string);
    NSLog(@"搜索后详情：%@",place);
    //根据地点选择器选择周围位置
    self.marker.position = place.coordinate;
    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude zoom:15];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// 用户取消后返回
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again. 再次打开和关闭网络活动指标。
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 调用自身定位获取坐标
- (void)findMe
{
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    
    //是否启用定位服务
    if ([CLLocationManager locationServicesEnabled]){
        NSLog(@"开始定位");
        //调用 startUpdatingLocation 方法后,会对应进入 didUpdateLocations 方法
        [self.locationManager startUpdatingLocation];//开始定位，不断调用其代理方法
    }
    else{
        
        NSLog(@"定位服务为关闭状态,无法使用定位服务");
    }

   
}




#pragma mark -  路线规划 ----------------
//根据自己所在位置和目的地  获取规划路线点
- (void)getToDestinationWithDirections:(CLLocationCoordinate2D )localCoord destination:(CLLocationCoordinate2D)toCoord {
    
    NSString *urlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%g,%g&destination=%g,%g&sensor=false&mode=walking",localCoord.latitude,localCoord.longitude,toCoord.latitude,toCoord.longitude];
    
    
}

//路劲规划返回数据
-(void)getLoad
{
    [jxhttps getPathWihtParams:nil success:^(id returnSucc) {
        
        if (returnSucc && [returnSucc isKindOfClass:[NSData class]]) {
            GMSPath *path = [GMSPath pathFromEncodedPath:[self getDirecPolyLinePoit:returnSucc]];
            GMSPolyline *polyLine = [GMSPolyline polylineWithPath:path];
            polyLine.strokeWidth = 5.f;
            polyLine.strokeColor = [UIColor lightGrayColor];
            polyLine.geodesic = YES;
            polyLine.map = _mapView;
            
            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(30.712433,114.222524) coordinate:CLLocationCoordinate2DMake(30.712433,114.222526)];
            GMSCameraUpdate *upData = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(20, 50, 20, 50)];
            [self.mapView animateWithCameraUpdate:upData];
            
        }else{
//            [self xw_showError:LS(@"data exception")];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}


- (id)getDirecPolyLinePoit:(id)respon{
//    NSDictionary *dic = [RootRoute getDictionaryWithJSONString:respon];
    NSDictionary *tmp;
    if (respon) {
        tmp = [respon[@"routes"] objectAtIndex:0][@"overview_polyline"];
        if (tmp[@"points"]) {
            return tmp[@"points"];
        }
    }
//    [self xw_showError:LS(@"Data resolution failure")];
    return nil;
}



#pragma mark Location and Delegate


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    
    //    self.longitute = [NSNumber numberWithDouble:coordinate.longitude];
//    self.latitude = [NSNumber numberWithDouble:coordinate.latitude];
    
    
    
    
    
    // 2.停止定位
//    [manager stopUpdatingLocation];
    
    if (_locationMutableArray.count != 0) {
        
        //从位置数组中取出最新的位置数据
        NSString *locationStr = _locationMutableArray.lastObject;
        NSArray *temp = [locationStr componentsSeparatedByString:@","];
        NSString *latitudeStr = temp[0];
        NSString *longitudeStr = temp[1];
        CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([latitudeStr doubleValue], [longitudeStr doubleValue]);
        
        //当前确定到的位置数据
        CLLocationCoordinate2D endCoordinate;
        endCoordinate.latitude = coordinate.latitude;
        endCoordinate.longitude =coordinate.longitude;
        
        //移动距离的计算
        double meters = [self calculateDistanceWithStart:startCoordinate end:endCoordinate];
        NSLog(@"移动的距离为%f米",meters);
        self.label.text = [NSString stringWithFormat:@"距离%f",meters];
        //为了美化移动的轨迹,移动的位置超过10米,方可添加进位置的数组
        if (meters >= 0){
            
            NSLog(@"添加进位置数组");
            NSString *locationString = [NSString stringWithFormat:@"%f,%f",coordinate.latitude, coordinate.longitude];
            [_locationMutableArray addObject:locationString];
            
            //开始绘制轨迹
            CLLocationCoordinate2D pointsToUse[2];
            pointsToUse[0] = startCoordinate;
            pointsToUse[1] = endCoordinate;
            //调用 addOverlay 方法后,会进入 rendererForOverlay 方法,完成轨迹的绘制

           
//            [self.path addLatitude:coordinate.latitude longitude:coordinate.longitude];
//            GMSPolyline *polyline = [GMSPolyline polylineWithPath:self.path];
            [self.path addCoordinate:coordinate];
            self.polyline.path = self.path;
            self.polyline.strokeColor = [UIColor redColor];
            self.polyline.strokeWidth = 2;
            self.polyline.map = self.mapView;
            
            
        }else{
            
            NSLog(@"不添加进位置数组");
        }
    }else{
        
        //存放位置的数组,如果数组包含的对象个数为0,那么说明是第一次进入,将当前的位置添加到位置数组
        NSString *locationString = [NSString stringWithFormat:@"%f,%f",coordinate.latitude, coordinate.longitude];
        [_locationMutableArray addObject:locationString];
    }

    NSString *locationStr = _locationMutableArray.firstObject;
    NSArray *temp = [locationStr componentsSeparatedByString:@","];
    NSString *latitudeStr = temp[0];
    NSString *longitudeStr = temp[1];
    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:[latitudeStr doubleValue] longitude:[longitudeStr doubleValue] zoom:15];
}



- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}


#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"点击后的坐标 %f,%f", coordinate.latitude, coordinate.longitude);
    
//    self.marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    
    
}

//移动视图
- (void)mapView:(GMSMapView *)mapView
idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    
//    NSLog(@"移动 ===%@",cameraPosition);

//    self.marker.position =cameraPosition.target;
    id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
            GMSReverseGeocodeResult *result = response.firstResult;
            self.marker.position =cameraPosition.target;
            self.marker.title = result.lines[0];
            self.marker.snippet = result.lines[1];
//            self.marker.map = mapView;
            
            self.purposeTitle =result.lines[0];
            self.purposeCord =cameraPosition.target;
            NSLog(@"-----%@",result);
                 }
    };
    [self.geocoder reverseGeocodeCoordinate:cameraPosition.target completionHandler:handler];
    
    
   
}

//调用自身地图开始导航
-(void)navigation
{
    
    //获取当前位置
    
    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    

    //当前经维度
    
    float currentLatitude=mylocation.placemark.location.coordinate.latitude;
    
    float currentLongitude=mylocation.placemark.location.coordinate.longitude;
    
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);
    
   NSLog(@"当前经纬度-----%f   %f" ,currentLatitude,currentLongitude);
    // 直接调用ios自己带的apple map
    
    //当前的位置
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    //起点
    
    //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
    
    //目的地的位置
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.purposeCord addressDictionary:nil]];

    toLocation.name = self.purposeTitle;

    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
}




#pragma mark - 距离测算
- (double)calculateDistanceWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end {
    
    double meter = 0;
    
    double startLongitude = start.longitude;
    double startLatitude = start.latitude;
    double endLongitude = end.longitude;
    double endLatitude = end.latitude;
    
    double radLatitude1 = startLatitude * M_PI / 180.0;
    double radLatitude2 = endLatitude * M_PI / 180.0;
    double a = fabs(radLatitude1 - radLatitude2);
    double b = fabs(startLongitude * M_PI / 180.0 - endLongitude * M_PI / 180.0);
    
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(b/2),2)));
    s = s * 6378137;
    
    meter = round(s * 10000) / 10000;
    return meter;
}



@end
