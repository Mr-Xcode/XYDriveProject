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

@interface SHMapSearchManager ()<AMapSearchDelegate>

@property (nonatomic,strong) AMapSearchAPI *search;

@property (nonatomic,assign)CGFloat startLatitude;
@property (nonatomic,assign)CGFloat startLongitude;

@property (nonatomic,assign)CGFloat endLatitude;
@property (nonatomic,assign)CGFloat endLongitude;

@property (nonatomic,strong) AMapRouteSearchBaseRequest *lastRequest;
@end

@implementation SHMapSearchManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    return self;
}

-(void)startSearchCityWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    AMapReGeocodeSearchRequest *request=[[AMapReGeocodeSearchRequest alloc]init];
    AMapGeoPoint *location=[AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    request.location=location;
    [self.search AMapReGoecodeSearch:request];
}


-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    DLog(@"反地理编码结果：%@",response);
    NSString *city= response.regeocode.addressComponent.city;
    if (self.cityBlock) {
        self.cityBlock(city,response.regeocode.addressComponent.citycode,response.regeocode.formattedAddress);
    }
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
    navi.strategy = 5;
    navi.waypoints =waypoints;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:startLatitude
                                           longitude:startLongitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:endLatitude
                                                longitude:endLongitude];
    
    self.lastRequest=navi;
    
    self.startLatitude=startLatitude;
    self.startLongitude=startLongitude;
    self.endLatitude=endLatitude;
    self.endLongitude=endLongitude;
    [self.search AMapDrivingRouteSearch:navi];
}
//计算路线失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    DLog(@"搜索失败:%@",error.localizedDescription);
    if (self.failureBlock) {
        self.failureBlock(error.localizedDescription);
    }
}

-(NSArray*)polylinesWithRoute:(AMapRoute*)route
{
    AMapPath *path=route.paths.firstObject;
    
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    NSMutableString *stepStr=[NSMutableString string];
    [stepStr appendString:[NSString stringWithFormat:@"%.6lf,%.6lf",self.startLongitude,self.startLatitude]];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        [stepStr appendString:@";"];
        [stepStr appendString:step.polyline];
    }];
    [stepStr appendString:[NSString stringWithFormat:@";%.6lf,%.6lf",self.endLongitude,self.endLatitude]];
    
    
    
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
    if (self.lastRequest!=request) {//避免多次点击搜索回调
        return;
    }
    //    DLog(@"路线规划成功了。。。。。。。。。。。");
    if (response.route == nil){
        self.failureBlock(@"路线规划失败");
        return;
    }
    
    if (response.count > 0)
    {
        NSArray *array= [self polylinesWithRoute:response.route];
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

@end
