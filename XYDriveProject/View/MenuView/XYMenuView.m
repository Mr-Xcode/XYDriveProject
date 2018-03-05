//
//  XYMenuView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYMenuView.h"
#import "XYLoginViewController.h"
@interface XYMenuView ()
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@end

@implementation XYMenuView

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)setUpUI{
    
}
- (IBAction)logOutButtonClick:(id)sender {
    [AVUser logOut];
    XYLoginViewController * loginVC =[[XYLoginViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController  =nav;
}
@end
