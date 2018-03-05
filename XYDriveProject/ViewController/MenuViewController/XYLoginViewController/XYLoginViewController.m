//
//  XYLoginViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYLoginViewController.h"
#import "XYRegiestViewController.h"
#import "XYHomeViewController.h"
#import "XYUserModel.h"
@interface XYLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *regiestButton;

@end

@implementation XYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Request
- (void)loginRequest{
    [AVUser logInWithUsernameInBackground:self.accountField.text password:self.passwordField.text block:^(AVUser *user, NSError *error) {
        if (error) {
            DLog(@"登录失败");
        }
        if (user != nil) {
            XYHomeViewController * homeVC =[[XYHomeViewController alloc]init];
            UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:homeVC];
            [UIApplication sharedApplication].keyWindow.rootViewController  =nav;
//            XYUserModel * model =[XYUserModel mj_objectWithKeyValues:user];
//            DLog(@"---------%@",model.username);
//            XYUserDefaultSetObjectWithKey(model.sessionToken, LocalToken);
        } else {
            
        }
    }];
}
#pragma mark - Button Click
- (IBAction)loginBtnClick:(id)sender {
    DLog(@"点击登录");
    [self loginRequest];
    DLog(@"");
//    if (succeeded) {
//        XYHomeViewController * homeVC =[[XYHomeViewController alloc]init];
//        UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:homeVC];
//        [UIApplication sharedApplication].keyWindow.rootViewController  =nav;
//    }
}
- (IBAction)regiestBtnClick:(id)sender {
    DLog(@"跳转注册");
    XYRegiestViewController * regiestVC =[[XYRegiestViewController alloc]init];
    [self.navigationController pushViewController:regiestVC animated:YES];
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
