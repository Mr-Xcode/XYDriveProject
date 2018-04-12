//
//  SHMapSearchManager.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/4.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "SHMapSearchManager.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import "SelectableOverlay.h"

@interface SHMapSearchManager ()<AMapSearchDelegate,AMapNaviDriveManagerDelegate>

@property (nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic,assign)CGFloat startLatitude;
@property (nonatomic,assign)CGFloat startLongitude;

@property (nonatomic,assign)CGFloat endLatitude;
@property (nonatomic,assign)CGFloat endLongitude;

@property (nonatomic,strong) AMapRouteSearchBaseRequest *lastRequest;

@property (nonatomic, strong) NSMutableArray * polylines;
@end

@implementation SHMapSearchManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
//         [[AMapNaviDriveManager sharedInstance] setDelegate:self];
//        self.polylines =[NSMutableArray array];
        
    }
    return self;
}
#pragma mark - <路径规划>
-(void)startSearchCityWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    AMapReGeocodeSearchRequest *request=[[AMapReGeocodeSearchRequest alloc]init];
    AMapGeoPoint *location=[AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    request.location=location;
    [self.search AMapReGoecodeSearch:request];
}

//步行
-(void)startSearchRouteWithStartLongitude:(CGFloat)startLongitude startLatitude:(CGFloat)startLatitude endLongitude:(CGFloat)endLongitude endLatitude:(CGFloat)endLatitude
{
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    self.lastRequest=navi;
    //出发点
    navi.origin = [AMapGeoPoint locationWithLatitude:startLatitude longitude:startLongitude];
    // 目的地
    navi.destination = [AMapGeoPoint locationWithLatitude:endLatitude longitude:endLongitude];
    
    self.startLatitude=startLatitude;
    self.startLongitude=startLongitude;
    self.endLatitude=endLatitude;
    self.endLongitude=endLongitude;
    [self.search AMapWalkingRouteSearch:navi];
    
}
//驾车
-(void)startSearchDriveRouteWithStartLongitude:(CGFloat)startLongitude startLatitude:(CGFloat)startLatitude endLongitude:(CGFloat)endLongitude endLatitude:(CGFloat)endLatitude waypointsArray:(NSArray<AMapGeoPoint *>*)waypoints{
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];

    navi.requireExtension = YES;
    navi.strategy = 2;
//    navi.waypoints =waypoints;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:startLatitude
                                           longitude:startLongitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:endLatitude
                                                longitude:endLongitude];

    self.lastRequest=navi;

    [self.search AMapDrivingRouteSearch:navi];
}
#pragma mark - <AMapGeocodeSearchRequest>
- (void)aMapGeocodeSearch:(NSString *)city block:(SHAMAPGeoSearchSuccess)block failure:(SHAMAPSearchManagerFailure)failure{
    AMapGeocodeSearchRequest * crequest =[[AMapGeocodeSearchRequest alloc]init];
    crequest.address =city;
    crequest.city =city;
    [self.search AMapGeocodeSearch:crequest];
    self.geoSuccess = ^(AMapGeocodeSearchResponse *response) {
        if (block) {
            block(response);
        }
    };
    self.failureBlock = ^(NSString *error) {
        if (failure) {
            failure(error);
        }
    };
}
- (void)searchGeoPoisWithLocation:(AMapGeoPoint *)center Kewords:(NSString *)kewords poisBlock:(SHaMapPoisSearchSuccess)block failure:(SHAMAPSearchManagerFailure)failure{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:center.latitude longitude:center.longitude];
    request.keywords            = kewords;
    request.radius              = 2000;
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
    self.poisBlock = ^(NSArray * pois) {
        if (block) {
            block(pois);
        }
    };
   
}
#pragma mark - <AMapGeoDelegate>
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (self.geoSuccess) {
        self.geoSuccess(response);
    }
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    //解析response获取POI信息
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:obj];
        
    }];
    if (self.poisBlock) {
        self.poisBlock(poiAnnotations);
    }
}
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    DLog(@"反地理编码结果：%@",response);
    NSString *city= response.regeocode.addressComponent.city;
    if (self.cityBlock) {
        self.cityBlock(city,response.regeocode.addressComponent.citycode,response.regeocode.formattedAddress);
    }
}
- (void)initProperties
{
    AMapNaviPoint * start = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    AMapNaviPoint * end  = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
    
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[start]
                                                                    endPoints:@[end]
                                                                    wayPoints:nil
                                                              drivingStrategy:2];
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    [self showNaviRoutes];
    //显示路径或开启导航
}
//计算路线失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    DLog(@"搜索失败:%@",error.localizedDescription);
    if (self.failureBlock) {
        self.failureBlock(error.localizedDescription);
    }
}

#pragma mark - <计算处理>
- (void)showNaviRoutes
{
    if ([[AMapNaviDriveManager sharedInstance].naviRoutes count] <= 0)
    {
        return;
    }
    
    //将路径显示到地图上
    for (NSNumber *aRouteID in [[AMapNaviDriveManager sharedInstance].naviRoutes allKeys])
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
        [self.polylines addObject: selectablePolyline];
        free(coords);
        [self.polylines addObject:polyline];
        
    }
    if (self.routeBlock)
    {
        self.routeBlock(self.polylines);
    }
    
}

-(NSArray*)polylinesWithRoute:(AMapRoute*)route start:(AMapGeoPoint *)start end:(AMapGeoPoint *)end
{
    AMapPath *path=route.paths.firstObject;
    
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    NSMutableString *stepStr=[NSMutableString string];
    [stepStr appendString:[NSString stringWithFormat:@"%.6lf,%.6lf",start.longitude,start.latitude]];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        [stepStr appendString:@";"];
        [stepStr appendString:step.polyline];
    }];
    [stepStr appendString:[NSString stringWithFormat:@";%.6lf,%.6lf",end.longitude,end.latitude]];
    
    
    
    if (stepStr.length>0) {
        
    }
    MAPolyline *stepPolyline = [CommonUtility multiPolylineForCoordinateString:stepStr];
    if (stepPolyline!=nil) {
        [polylines addObject:stepPolyline];
        //            if (idx > 0)
        //            {
        //                [self replenishPolylinesWith:stepPolyline lastPolyline:[self  polylineForStep:step] polylines:polylines];
        //            }
    }
    return polylines;
    
}

-(void)replenishPolylinesWith:(MAPolyline*)stepPolyline lastPolyline:(MAPolyline*)lastPolyline polylines:polylines
{
    CLLocationCoordinate2D startCoor ;
    CLLocationCoordinate2D endCoor;
    
    //新的折线
    [stepPolyline getCoordinates:&endCoor   range:NSMakeRange(0, 1)];
    //旧的折线
    [lastPolyline getCoordinates:&startCoor range:NSMakeRange(lastPolyline.pointCount -1, 1)];
    
    if (endCoor.latitude != startCoor.latitude || endCoor.longitude != startCoor.longitude){
        CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(2 * sizeof(CLLocationCoordinate2D));
        
        coordinates[0]=startCoor;
        coordinates[1]=endCoor;
        MAPolyline *newPolyline=[MAPolyline polylineWithCoordinates:coordinates count:2];
        
        if (newPolyline){
            [polylines addObject:newPolyline];
        }
    }
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
//    if (self.lastRequest!=request) {//避免多次点击搜索回调
//        return;
//    }
    //    DLog(@"路线规划成功了。。。。。。。。。。。");
    if (response.route == nil){
        self.failureBlock(@"路线规划失败");
        return;
    }
    
    if (response.count > 0)
    {
        NSArray *array= [self polylinesWithRoute:response.route start:request.origin end:request.destination];
        if (array.count>0)
        {
            if (self.routeBlock)
            {
                self.routeBlock(array);
            }
        }
        else
        {
            self.failureBlock(@"路线规划失败");
        }
    }
}
- (void)dealloc
{
    [[AMapNaviDriveManager sharedInstance] stopNavi];
//    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    
    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d",success);
    
}

@end
