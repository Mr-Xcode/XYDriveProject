//
//  XYMainViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYMainViewController.h"
#import "XYLoginViewController.h"
#import "XYHomeViewController.h"
#import "XYUserModel.h"

@interface XYMainViewController ()

@end

@implementation XYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    [self enterLoginView];
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser) {
        XYHomeViewController * homeVC =[[XYHomeViewController alloc]init];
        UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:homeVC];
        [UIApplication sharedApplication].keyWindow.rootViewController  =nav;
//        XYKeyWindow.rootViewController =nav;
    }else{
        [self enterLoginView];
    }
    
//    NSString * token = XYUserDefaultGetObjectForKey(LocalToken);
//    if (ICIsStringEmpty(token)) {
//        [self enterLoginView];
//    }else{
//        XYHomeViewController * homeVC =[[XYHomeViewController alloc]init];
//        UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:homeVC];
//        [UIApplication sharedApplication].keyWindow.rootViewController  =nav;
//    }
}
- (void)enterLoginView{
    XYLoginViewController * loginVC =[[XYLoginViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController  =nav;
//    XYKeyWindow.rootViewController  =nav;
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
