//
//  CommonUtility.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface CommonUtility : NSObject

+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token;
//根据坐标点串 创建折线
+ (MAPolyline *)polylineForCoordinateString:(NSString *)coordinateString;
+ (MAMultiPolyline *)multiPolylineForCoordinateString:(NSString *)coordinateString;
+ (MAPolyline *)polylineForBusLine:(AMapBusLine *)busLine;

+ (MAMapRect)unionMapRect1:(MAMapRect)mapRect1 mapRect2:(MAMapRect)mapRect2;

+ (MAMapRect)mapRectUnion:(MAMapRect *)mapRects count:(NSUInteger)count;

//根据overlay获取macrect来让折线完全在地图上显示
+ (MAMapRect)mapRectForOverlays:(NSArray *)overlays;


+ (MAMapRect)minMapRectForMapPoints:(MAMapPoint *)mapPoints count:(NSUInteger)count;

+ (MAMapRect)minMapRectForAnnotations:(NSArray *)annotations;

+ (NSString *)getApplicationScheme;
+ (NSString *)getApplicationName;

//获取两点距离
+ (double)distanceToPoint:(MAMapPoint)p fromLineSegmentBetween:(MAMapPoint)l1 and:(MAMapPoint)l2;


//百度坐标->火星坐标
+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat bdLon:(double)bdLon;
//火星坐标->百度坐标
+ (CLLocationCoordinate2D)bd09Encrypt:(double)gcLat bdLon:(double)gcLon;

//根据maoview适应显示范围
+ (void)setMapViewVisibleMapRect:(MAMapRect)mapRect withInsets:(UIEdgeInsets)insets animated:(BOOL)animated forMapView:(MAMapView *)mapView;

@end
