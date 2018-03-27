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
#import "SHMapSearchManager.h"

@interface XYSearchPlaceViewController ()<MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *onPageButton;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;

@property (weak, nonatomic) IBOutlet UIView *mapBcView;
@property (nonatomic, strong)MAMapView * searchMapView;
@property (nonatomic, strong) SHMapSearchManager * searchManager;
@property (nonatomic, copy)NSString * selCity;
@end

@implementation XYSearchPlaceViewController
- (SHMapSearchManager *)searchManager{
    if (!_searchManager) {
        self.searchManager =[[SHMapSearchManager alloc]init];
    }
    return _searchManager;
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
        CLLocationCoordinate2D cityCoordinate =CLLocationCoordinate2DMake(point.latitude, point.longitude);
        [weakSelf.searchMapView setCenterCoordinate:cityCoordinate];
    } failure:^(NSString *error) {
        
    }];
}
- (IBAction)areaButtonClick:(id)sender {
    if (ICIsStringEmpty(self.searchBar.text)) {
        [UIToast showMessage:@"请输入搜索内容"];
        return;
    }
}
- (IBAction)onPageButtonClick:(id)sender {
}
- (IBAction)nextPageButtonClick:(id)sender {
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
