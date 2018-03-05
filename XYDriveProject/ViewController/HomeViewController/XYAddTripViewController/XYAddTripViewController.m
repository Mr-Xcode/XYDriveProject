//
//  XYAddTripViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYAddTripViewController.h"
#import "CalenderAnimationController.h"
#include <stdlib.h>
#import "XYDateSlecteView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "XYTimeTripView.h"
#import "RoadListModel.h"
#import "SHMapSearchManager.h"
#import "SHRoutePolylineRenderer.h"
#import "CommonUtility.h"
#import "XYCustomAnnotationView.h"

#define DATEVIEW_H 450

@interface XYAddTripViewController ()<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate,MAMapViewDelegate,AMapSearchDelegate>
@property CalenderAnimationController *animationController;
@property (nonatomic, strong)XYDateSlecteView * dateSelView;
@property (nonatomic, weak)MAMapView * xyMapView;

//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) SHMapSearchManager * searchManager;
@property (nonatomic,strong) SHRoutePolylineRenderer *lineOverlay;//路线
@property (nonatomic,strong) SHRoutePolylineRenderer *tempOverlay;

//逆地理编码
//@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;
////逆地理编码使用的
//@property (nonatomic, strong) AMapSearchAPI *search;
//大头针
@property (nonatomic, strong) MAPointAnnotation *annotation;
@property (nonatomic, strong)UIImageView * centerImageView;
@property (nonatomic, strong)NSMutableArray * markersAnnotationArray;
@property (nonatomic, strong)NSMutableArray * attributesArray;

@end

@implementation XYAddTripViewController
- (XYDateSlecteView *)dateSelView{
    if (!_dateSelView) {
        self.dateSelView =[[XYDateSlecteView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-DATEVIEW_H, SCREEN_W, DATEVIEW_H)];
            CGFloat r = RND_COLOR;
            CGFloat g = RND_COLOR;
            CGFloat b = RND_COLOR;
        self.dateSelView.backgroundColor =[UIColor colorWithRed:r green:g blue:b alpha:1];
    }
    return _dateSelView;
}
#pragma mark - MAP
//- (AMapReGeocodeSearchRequest *)regeo {
//    if (!_regeo) {
//        _regeo = [[AMapReGeocodeSearchRequest alloc]init];
//        _regeo.requireExtension = YES;
//    }
//    return _regeo;
//}
//
//- (AMapSearchAPI *)search {
//    if (!_search) {
//        _search = [[AMapSearchAPI alloc]init];
//        _search.delegate = self;
//    }
//    return _search;
//}
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locationManager.locationTimeout = 2;
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
}
- (SHMapSearchManager *)searchManager{
    if (!_searchManager) {
        self.searchManager =[[SHMapSearchManager alloc]init];
        __weak typeof(_xyMapView) weakMapView =_xyMapView;
        WeakSelf;
        self.searchManager.routeBlock = ^(NSArray *polylines) {
            if (weakSelf.lineOverlay) {
                [weakMapView removeOverlay:weakSelf.lineOverlay];
                weakSelf.lineOverlay=nil;
            }
            weakSelf.tempOverlay=nil;
            
            weakSelf.lineOverlay=polylines.firstObject;
            [weakSelf addLineRouteWithOverlay:polylines.firstObject];
        };
    }
    return _searchManager;
}
-(void)addLineRouteWithOverlay:(SHRoutePolylineRenderer*)overlay
{
    [_xyMapView addOverlay:overlay];
    
    [CommonUtility setMapViewVisibleMapRect:[CommonUtility mapRectForOverlays:@[overlay]]  withInsets:UIEdgeInsetsMake(100, 82,230,82) animated:YES forMapView:_xyMapView];
}
- (void)addMapView{
    MAMapView * mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, VIEW_H-45)];
    mapView.delegate =self;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.rotateCameraEnabled=NO;
    mapView.rotateEnabled=NO;
    mapView.showsScale=NO;
    [mapView setZoomLevel:MapZommLevel-1 animated:YES];
    mapView.screenAnchor =CGPointMake(0.5, 0.5);
    ///把地图添加至view
    self.xyMapView =mapView;
    [self.view addSubview:mapView];
//    [self addAnntationView];
    
    //定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {

        if (error) {
            return ;
        }
//        DLog(@"当前位置:%f",location.coordinate.latitude);
//        //添加大头针
//        _annotation = [[MAPointAnnotation alloc]init];
//
//        _annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//        [mapView addAnnotation:_annotation];
//        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) animated:YES];
//        //让地图在缩放过程中移到当前位置试图
//        [mapView setZoomLevel:16.1 animated:YES];

    }];
}
- (void)addAnntationViewLat:(CGFloat)lat Lng:(CGFloat)lng{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    pointAnnotation.title = @"";
    pointAnnotation.subtitle = @"";
    
    [self.xyMapView addAnnotation:pointAnnotation];
}
#pragma mark - MAP delegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]] && ![annotation isKindOfClass:[MAUserLocation class]])
//    {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        //放一张大头针图片即可
//        annotationView.image = [UIImage imageNamed:@"icon_location"];
//        annotationView.centerOffset = CGPointMake(0, -15);
//        return annotationView;
//    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]] && ![annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        XYCustomAnnotationView *annotationView = (XYCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[XYCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_location"];
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
//长按地图添加标注
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self addAnntationViewLat:coordinate.latitude Lng:coordinate.longitude];
}
#pragma mark - 让大头针不跟着地图滑动，时时显示在地图最中间
- (void)mapViewRegionChanged:(MAMapView *)mapView {
    _annotation.coordinate = mapView.centerCoordinate;
}
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    CLLocationCoordinate2D locationaD = [mapView convertPoint:self.centerImageView.center toCoordinateFromView:self.view];
//    DLog(@"地图中心位置:%f",locationaD.latitude);
     [self jumpAnimation:self.centerImageView];
}
#pragma mark - 滑动地图结束修改当前位置
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
//    self.regeo.location = [AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
//    [self.search AMapReGoecodeSearch:self.regeo];
}
#pragma mark - 路径规划代理
#pragma mark----- 路径规划
//线路规划
- (void)lineProject
{
    if (self.markersAnnotationArray && self.markersAnnotationArray.count >2) {
        NSMutableArray * array =[NSMutableArray array];
        for (MAPointAnnotation *pointAnnotation in self.markersAnnotationArray) {
            AMapGeoPoint * point =[AMapGeoPoint locationWithLatitude:pointAnnotation.coordinate.latitude longitude:pointAnnotation.coordinate.longitude];
            [array addObject:point];
        }
        [array removeLastObject];
        [array removeObjectAtIndex:0];
        MAPointAnnotation * startAnnotation =[self.markersAnnotationArray objectAtIndex:0];
        CLLocationCoordinate2D startCoordinate =startAnnotation.coordinate;
        MAPointAnnotation * endAnnotation =[self.markersAnnotationArray lastObject];
        CLLocationCoordinate2D endCoordinate =endAnnotation.coordinate;
        //驾车路线规划
        [self.searchManager startSearchDriveRouteWithStartLongitude:startCoordinate.longitude startLatitude:startCoordinate.latitude endLongitude:endCoordinate.longitude endLatitude:endCoordinate.latitude waypointsArray:array];
    }
    
}
//显示轨迹
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //路线规划
        if (self.lineOverlay||self.tempOverlay) {
            SHRoutePolylineRenderer* polylineView = [[SHRoutePolylineRenderer alloc] initWithMultiPolyline:overlay];
            return polylineView;
        }else{
            [mapView removeOverlay:overlay];
            return nil;
        }
    }
    return nil;
}
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    //解析response获取路径信息，具体解析见 Demo
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"添加行程";
    [self setDefaultLeftBtn];
    self.markersAnnotationArray =[NSMutableArray array];
//    [self.view addSubview:self.dateSelView];
//    self.animationController = [[CalenderAnimationController alloc] init];
    [self addMapView];
//    self.centerImageView =[[UIImageView alloc]init];
//    self.centerImageView.frame =CGRectMake(0, 0, 30, 30);
//    self.centerImageView.image =[UIImage imageNamed:@"icon_location"];
//    self.centerImageView.center =self.view.center;
//    self.centerImageView.centerY -=44;
//    [self.view addSubview:self.centerImageView];
//    [self.view bringSubviewToFront:self.centerImageView];
//    [self jumpAnimation:self.centerImageView];
    [self addTimeTripView];
    [self request];
}
- (void)request{
        NSArray * markers = self.tirpObj[@"markers"];
        for (NSDictionary * dic in markers) {
            Markers * marker =[Markers mj_objectWithKeyValues:dic];
            NSLog(@"%@,%@",marker.attributes.city,marker.title);
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([marker.attributes.lat doubleValue], [marker.attributes.lng doubleValue]);
            pointAnnotation.coordinate = coor;
            
            pointAnnotation.title = @"123456";
            [self.markersAnnotationArray addObject:pointAnnotation];
        }
    [self.xyMapView addAnnotations:self.markersAnnotationArray];
    [self lineProject];
}
- (void)jumpAnimation:(UIView *)annotationView{
    CGRect endFrame = annotationView.frame;
    
    annotationView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y - 100.0, endFrame.size.width, endFrame.size.height);
    
    [UIView beginAnimations:@"drop" context:NULL];
    
    [UIView setAnimationDuration:0.45];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [annotationView setFrame:endFrame];
    
    [UIView commitAnimations];
}
- (void)addTimeTripView{
    XYTimeTripView * timeView =[[XYTimeTripView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.xyMapView.frame)-64, SCREEN_W,TIMEVIEWHEIGHT)];
    [self.view addSubview:timeView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
