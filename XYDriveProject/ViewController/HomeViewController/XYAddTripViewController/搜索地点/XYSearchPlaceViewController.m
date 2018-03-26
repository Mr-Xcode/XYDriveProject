//
//  XYSearchPlaceViewController.m
//  XYDriveProject
//
//  Created by gaoshuhuan on 2018/3/26.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYSearchPlaceViewController.h"
#import "AddressViewController.h"

@interface XYSearchPlaceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *onPageButton;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;

@property (weak, nonatomic) IBOutlet UIView *mapBcView;
@end

@implementation XYSearchPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"搜索位置";
}
- (IBAction)cityButtonClick:(id)sender {
    AddressViewController * cityVC =[[AddressViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
- (IBAction)areaButtonClick:(id)sender {
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
