//
//  XYRegiestViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYRegiestViewController.h"
#import "XYHomeViewController.h"
@interface XYRegiestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordField;
@property (weak, nonatomic) IBOutlet UIButton *regiestButton;

@end

@implementation XYRegiestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"注册";
    [self setDefaultLeftBtn];
}
#pragma mark - Button Click

- (IBAction)regiestBtnClick:(id)sender {
    [AVUser requestEmailVerify:self.accountField.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"请求重发验证邮件成功");
            AVUser *user = [AVUser user];// 新建 AVUser 对象实例
            user.username = self.surePasswordField.text;// 设置用户名
            user.password =  self.passwordField.text;// 设置密码
            user.email = self.accountField.text;// 设置邮箱
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // 注册成功
                    XYHomeViewController * homeVC =[[XYHomeViewController alloc]init];
                    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:homeVC];
                    [UIApplication sharedApplication].keyWindow.rootViewController  =nav;
                } else {
                    // 失败的原因可能有多种，常见的是用户名已经存在。
                }
            }];
        }else{
            
        }
    }];
    
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
