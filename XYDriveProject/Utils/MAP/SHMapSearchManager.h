//
//  SHMapSearchManager.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/4.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <MAMapKit/MAMapKit.h>
typedef void(^SHAMAPSearchManagerRouteSuccess)(NSArray *polylines);
typedef void(^SHAMAPSearchManagerCitySuccess)(NSString *city,NSString *cityCode,NSString*formattedAddress);
typedef void(^SHAMAPGeoSearchSuccess)(AMapGeocodeSearchResponse *response);
typedef void(^SHaMapPoisSearchSuccess)(NSArray * pois);
typedef void(^SHAMAPSearchManagerFailure)(NSString *error);


@interface SHMapSearchManager : NSObject

@property (nonatomic,copy) SHAMAPSearchManagerRouteSuccess routeBlock;
@property (nonatomic,copy) SHAMAPSearchManagerCitySuccess cityBlock;
@property (nonatomic,copy) SHAMAPSearchManagerFailure failureBlock;
@property (nonatomic,copy) SHAMAPGeoSearchSuccess geoSuccess;
@property (nonatomic,copy) SHaMapPoisSearchSuccess poisBlock;

//反地理编码
-(void)startSearchCityWithLatitude:(CGFloat)latitude  longitude:(CGFloat)longitude;


//搜索步行路线
-(void)startSearchRouteWithStartLongitude:(CGFloat)startLongitude startLatitude:(CGFloat)startLatitude endLongitude:(CGFloat)endLongitude endLatitude:(CGFloat)endLatitude;

//驾车路线
-(void)startSearchDriveRouteWithStartLongitude:(CGFloat)startLongitude startLatitude:(CGFloat)startLatitude endLongitude:(CGFloat)endLongitude endLatitude:(CGFloat)endLatitude waypointsArray:(NSArray<AMapGeoPoint *>*)waypoints;

//地理编码
- (void)aMapGeocodeSearch:(NSString *)city block:(SHAMAPGeoSearchSuccess)block failure:(SHAMAPSearchManagerFailure)failure;

//poi搜索
- (void)searchGeoPoisWithLocation:(AMapGeoPoint *)center Kewords:(NSString *)kewords poisBlock:(SHaMapPoisSearchSuccess)block failure:(SHAMAPSearchManagerFailure)failure;

@end
