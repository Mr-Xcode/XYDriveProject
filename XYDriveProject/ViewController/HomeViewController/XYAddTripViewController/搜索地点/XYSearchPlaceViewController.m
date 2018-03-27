//
//  XYSearchPlaceViewController.m
//  XYDriveProject
//
//  Created by gaoshuhuan on 2018/3/26.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYSearchPlaceViewController.h"
#import "AddressViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SHMapSearchManager.h"

@interface XYSearchPlaceViewController ()<MAMapViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *onPageButton;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;

@property (weak, nonatomic) IBOutlet UIView *mapBcView;
@property (nonatomic, strong)MAMapView * searchMapView;
@property (nonatomic, strong) SHMapSearchManager * searchManager;
//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy)NSString * selCity;
@property (nonatomic, strong)AMapGeoPoint * center;
@end

@implementation XYSearchPlaceViewController
- (SHMapSearchManager *)searchManager{
    if (!_searchManager) {
        self.searchManager =[[SHMapSearchManager alloc]init];
    }
    return _searchManager;
}
#pragma mark - MAP
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    }
    return _locationManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"搜索位置";
    [self addMapView];
}
- (void)addMapView{
    MAMapView * mapView = [[MAMapView alloc] init];
    mapView.frame =self.mapBcView.bounds;
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
    self.searchMapView =mapView;
    [self.mapBcView addSubview:mapView];
    [self location];
}
- (void)location{
    //定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            return ;
        }
        [self.cityButton setTitle:[NSString stringWithFormat:@"%@",regeocode.city] forState:UIControlStateNormal];
    }];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
- (IBAction)cityButtonClick:(id)sender {
    AddressViewController * cityVC =[[AddressViewController alloc]init];
    WeakSelf;
    cityVC.cityBlock = ^(NSDictionary *dic) {
        weakSelf.selCity =[NSString stringWithFormat:@"%@%@%@",dic[@"Province"],dic[@"City"],dic[@"Area"]];
        [weakSelf.cityButton setTitle:weakSelf.selCity forState:UIControlStateNormal];
        [weakSelf locationCityCenter];
    };
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
- (void)locationCityCenter{
    WeakSelf;
    [self.searchManager aMapGeocodeSearch:self.selCity block:^(AMapGeocodeSearchResponse *response) {
        NSArray * geocodes =response.geocodes;
        AMapGeocode * geoCode =[geocodes objectAtIndex:0];
        AMapGeoPoint * point =geoCode.location;
        weakSelf.center =point;
        CLLocationCoordinate2D cityCoordinate =CLLocationCoordinate2DMake(point.latitude, point.longitude);
        [weakSelf.searchMapView setCenterCoordinate:cityCoordinate];
    } failure:^(NSString *error) {
        
    }];
}
- (IBAction)areaButtonClick:(id)sender {
    [self.searchBar resignFirstResponder];
    if (ICIsStringEmpty(self.searchBar.text)) {
        [UIToast showMessage:@"请输入搜索内容"];
        return;
    }
    NSMutableArray * poisArray =[NSMutableArray new];
    WeakSelf;
    [self.searchManager searchGeoPoisWithLocation:self.center Kewords:self.searchBar.text poisBlock:^(NSArray *pois) {
        for (AMapPOI * poi in pois) {
            DLog(@"%@-%@",poi.city,poi.name);
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            pointAnnotation.title = poi.city;
            pointAnnotation.subtitle = poi.name;
            [poisArray addObject:pointAnnotation];
        }
        [weakSelf.searchMapView addAnnotations:poisArray];
        
    } failure:^(NSString *error) {
        
    }];
}
- (IBAction)onPageButtonClick:(id)sender {
}
- (IBAction)nextPageButtonClick:(id)sender {
}
#pragma mark - <UISearchBarDelegate>
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self areaButtonClick:searchBar];
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self areaButtonClick:searchBar];
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
