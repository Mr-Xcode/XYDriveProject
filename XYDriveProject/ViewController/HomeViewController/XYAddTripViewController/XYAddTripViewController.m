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
#import "SelectableOverlay.h"
#import "RouteCollectionViewCell.h"
#import "DriveNaviViewController.h"
#import "SetTripRoudeViewController.h"
#import "XYCustomAnnotation.h"
#import "AnnotatationModel.h"
#define DATEVIEW_H 450
#define kRoutePlanInfoViewHeight    130.f
#define kRouteIndicatorViewHeight   64.f
#define kCollectionCellIdentifier   @"kCollectionCellIdentifier"

@interface XYAddTripViewController ()<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate,MAMapViewDelegate,AMapSearchDelegate,AMapNaviDriveManagerDelegate, DriveNaviViewControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property CalenderAnimationController *animationController;
@property (nonatomic, strong)XYDateSlecteView * dateSelView;
@property (nonatomic, strong)MAMapView * xyMapView;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) SHMapSearchManager * searchManager;
@property (nonatomic,strong) SHRoutePolylineRenderer *lineOverlay;//路线
@property (nonatomic,strong) SHRoutePolylineRenderer *tempOverlay;

//点
@property (nonatomic, assign) CGFloat myLat;
@property (nonatomic, assign) CGFloat myLng;

@property (nonatomic, assign) int tripRoadIndex;
@property (nonatomic, strong) UICollectionView *routeIndicatorView;
@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;

//逆地理编码
//@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;
////逆地理编码使用的
//@property (nonatomic, strong) AMapSearchAPI *search;
//大头针
@property (nonatomic, strong) MAPointAnnotation * annotation;
@property (nonatomic, strong) XYCustomAnnotation * addAnnotation;
@property (nonatomic, strong)UIImageView * centerImageView;
@property (nonatomic, strong)NSMutableArray * markersAnnotationArray;
@property (nonatomic, strong)NSMutableArray * markersArray;
@property (nonatomic, strong)NSMutableArray * roads;

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
//            if (weakSelf.lineOverlay) {
//                [weakMapView removeOverlay:weakSelf.lineOverlay];
//                weakSelf.lineOverlay=nil;
//            }
//            weakSelf.tempOverlay=nil;
            
//            weakSelf.lineOverlay=polylines.firstObject;
            [weakSelf addLineRouteWithOverlay:polylines.firstObject];
        };
        self.searchManager.cityBlock = ^(NSString *city, NSString *cityCode, NSString *formattedAddress) {
            Markers * markmodel =[[Markers alloc]init];
            weakSelf.addAnnotation.title =city;
            weakSelf.addAnnotation.subtitle =formattedAddress;
            markmodel.title =formattedAddress;
            weakSelf.addAnnotation.model =markmodel;
            [weakMapView addAnnotation:weakSelf.addAnnotation];
        };
    }
    return _searchManager;
}
-(void)addLineRouteWithOverlay:(id<MAOverlay>)overlay
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
        self.myLat =location.coordinate.latitude;
        self.myLng =location.coordinate.longitude;
//        [self addDriveLine:self.tripRoadIndex];
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
- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager =[AMapNaviDriveManager sharedInstance];
        self.driveManager.delegate =self;
    }
}
- (void)addAnntationViewLat:(CGFloat)lat Lng:(CGFloat)lng{
    self.addAnnotation =nil;
    XYCustomAnnotation *pointAnnotation = [[XYCustomAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    pointAnnotation.title = @"";
    pointAnnotation.subtitle = @"";
    self.addAnnotation =pointAnnotation;
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
    
    if ([annotation isKindOfClass:[XYCustomAnnotation class]])
    {
        XYCustomAnnotation * xyAnnotation =(XYCustomAnnotation *)annotation;
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        XYCustomAnnotationView *annotationView = (XYCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[XYCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_location"];
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        annotationView.model =xyAnnotation.model;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
//长按地图添加标注
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self.searchManager startSearchCityWithLatitude:coordinate.latitude longitude:coordinate.longitude];
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
#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"添加行程";
    [self setDefaultLeftBtn];
    self.markersAnnotationArray =[NSMutableArray array];
    self.roads =[NSMutableArray array];
    self.routeIndicatorInfoArray = [NSMutableArray array];
    self.markersArray =[NSMutableArray array];
//    [self.view addSubview:self.dateSelView];
//    self.animationController = [[CalenderAnimationController alloc] init];
    [self addMapView];
//    [self initDriveManager];
//    [self initRouteIndicatorView];
//    self.centerImageView =[[UIImageView alloc]init];
//    self.centerImageView.frame =CGRectMake(0, 0, 30, 30);
//    self.centerImageView.image =[UIImage imageNamed:@"icon_location"];
//    self.centerImageView.center =self.view.center;
//    self.centerImageView.centerY -=44;
//    [self.view addSubview:self.centerImageView];
//    [self.view bringSubviewToFront:self.centerImageView];
//    [self jumpAnimation:self.centerImageView];
    [self getTripPoints];
    
    [self setItemsBtnTitles:@[@"上一站",@"下一站"] images:@[@"",@""] action:^(UIButton *button) {
//        SetTripRoudeViewController * setVC =[[SetTripRoudeViewController alloc]init];
//        [self.navigationController pushViewController:setVC animated:YES];
        if (button.tag==201) {
            //item1
        }else if (button.tag ==202){
            //item2
        }
    }];
}
- (void)getTripPoints{
    NSArray * markers = self.tirpObj[@"markers"];
    for (NSDictionary * dic in markers) {
        Markers * marker =[Markers mj_objectWithKeyValues:dic];
        NSLog(@"%@,%@",marker.attributes.city,marker.title);
        [self.markersArray addObject:marker];
        XYCustomAnnotation *pointAnnotation = [[XYCustomAnnotation alloc] init];
        CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([marker.attributes.lat doubleValue], [marker.attributes.lng doubleValue]);
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = marker.attributes.city;
        pointAnnotation.subtitle =marker.title;
        [self.markersAnnotationArray addObject:pointAnnotation];
    
        pointAnnotation.model =marker;
        //把所有景点的坐标存起来
        AMapGeoPoint * roadPoint = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
        [self.roads addObject:roadPoint];
        
    }
    [self.xyMapView addAnnotations:self.markersAnnotationArray];
    [self addDriveLine:self.tripRoadIndex];
    [self addTimeTripView];
}
- (void)initRouteIndicatorView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _routeIndicatorView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - kRouteIndicatorViewHeight, CGRectGetWidth(self.view.bounds), kRouteIndicatorViewHeight) collectionViewLayout:layout];
    
    _routeIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _routeIndicatorView.backgroundColor = [UIColor clearColor];
    _routeIndicatorView.pagingEnabled = YES;
    _routeIndicatorView.showsVerticalScrollIndicator = NO;
    _routeIndicatorView.showsHorizontalScrollIndicator = NO;
    
    _routeIndicatorView.delegate = self;
    _routeIndicatorView.dataSource = self;
    
    [_routeIndicatorView registerClass:[RouteCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
    
    [self.view addSubview:_routeIndicatorView];
}
#pragma mark----- 路径规划
//线路规划
- (void)addDriveLine:(int)curentIndex
{
    if (self.roads && self.roads.count >1) {
        for (int ii =0; ii<self.roads.count- 1; ii++) {
            
            AMapGeoPoint * onPoint =[self.roads objectAtIndex:ii];
            AMapGeoPoint * nextPoint =[self.roads objectAtIndex:ii+1];
            
            [self.searchManager startSearchDriveRouteWithStartLongitude:onPoint.longitude startLatitude:onPoint.latitude endLongitude:nextPoint.longitude endLatitude:nextPoint.latitude waypointsArray:nil];
        }
    }
}
//显示轨迹
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    
//    if ([overlay isKindOfClass:[MAPolyline class]])
//    {
////            SHRoutePolylineRenderer* polylineView = [[SHRoutePolylineRenderer alloc] initWithMultiPolyline:overlay];
//            SHRoutePolylineRenderer * selectableOverlay = (SHRoutePolylineRenderer *)overlay;
//            id<MAOverlay> actualOverlay = selectableOverlay.overlay;
//
//            MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
//            polylineRenderer.strokeImage =[UIImage imageNamed:@"trackDirection"];
//            polylineRenderer.lineWidth = 8.f;
//            polylineRenderer.strokeColor = [UIColor blueColor];
//            return polylineRenderer;
//
//    }
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeImage =[UIImage imageNamed:@"trackDirection"];
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
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
    XYTimeTripView * timeView =[[XYTimeTripView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.xyMapView.frame)-64, SCREEN_W,TIMEVIEWHEIGHT) markers:self.markersArray];
    [self.view addSubview:timeView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    [self showNaviRoutes];
    self.tripRoadIndex ++;
    [self addDriveLine:self.tripRoadIndex];
}
- (void)showNaviRoutes
{
    if ([self.driveManager.naviRoutes count] <= 0)
    {
        return;
    }
    
//    [self.xyMapView removeOverlays:self.xyMapView.overlays];
    
    //将路径显示到地图上
    for (NSNumber *aRouteID in [self.driveManager.naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[self.driveManager naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
        [selectablePolyline setRouteID:[aRouteID integerValue]];
        
        [self addLineRouteWithOverlay:selectablePolyline];
        free(coords);
        
        //更新CollectonView的信息
        RouteCollectionViewInfo *info = [[RouteCollectionViewInfo alloc] init];
        info.routeID = [aRouteID integerValue];
//        info.title = [NSString stringWithFormat:@"路径ID:%ld | 路径计算策略:%ld | %@", (long)[aRouteID integerValue], (long)[self.preferenceView strategyWithIsMultiple:YES], [[aRoute.routeLabels firstObject] content]];
        info.subtitle = [NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count];
        
        [self.routeIndicatorInfoArray addObject:info];
    }
    [self.routeIndicatorView reloadData];
    [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
}
#pragma mark - DriveNaviView Delegate

- (void)driveNaviViewCloseButtonClicked
{
    //开始导航后不再允许选择路径，所以停止导航
    [self.driveManager stopNavi];
    
    //停止语音
//    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.routeIndicatorInfoArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RouteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    
    cell.shouldShowPrevIndicator = (indexPath.row > 0 && indexPath.row < _routeIndicatorInfoArray.count);
    cell.shouldShowNextIndicator = (indexPath.row >= 0 && indexPath.row < _routeIndicatorInfoArray.count-1);
    cell.info = self.routeIndicatorInfoArray[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) - 10, CGRectGetHeight(collectionView.bounds) - 5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DriveNaviViewController *driveVC = [[DriveNaviViewController alloc] init];
    [driveVC setDelegate:self];
    
    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [self.driveManager addDataRepresentative:driveVC.driveView];
    
    [self.navigationController pushViewController:driveVC animated:NO];
    [self.driveManager startEmulatorNavi];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    RouteCollectionViewCell *cell = [[self.routeIndicatorView visibleCells] firstObject];
    
    if (cell.info)
    {
        [self selectNaviRouteWithID:cell.info.routeID];
    }
}
- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    //在开始导航前进行路径选择
    if ([self.driveManager selectNaviRouteWithRouteID:routeID])
    {
        [self selecteOverlayWithRouteID:routeID];
    }
    else
    {
        NSLog(@"路径选择失败!");
    }
}

- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [self.xyMapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             
             /* 获取overlay对应的renderer. */
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.xyMapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID)
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = YES;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [self.xyMapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.xyMapView.overlays.count - 1];
             }
             else
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = NO;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             
             [overlayRenderer glRender];
         }
     }];
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
