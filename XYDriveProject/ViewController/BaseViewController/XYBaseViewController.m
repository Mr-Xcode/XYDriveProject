//
//  XYBaseViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYBaseViewController.h"

@interface XYBaseViewController ()

//@property (nonatomic, strong)SHButton * leftBtn;

@end

@implementation XYBaseViewController

-(void)createLeftBtnWithImage:(UIImage*)image
{
        SHButton *btn = [SHButton new];
//        _leftBtn=btn;
        [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        btn.imageRect=CGRectMake(0, (44-image.size.height)/2, image.size.width, image.size.height);
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        btn.frame=CGRectMake(0, 0, 44, 44);
        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setDefaultLeftBtn{
    [self createLeftBtnWithImage:[UIImage imageNamed:@"back_icon"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem.backBarButtonItem setTitle:@""];
    self.view.backgroundColor =[UIColor whiteColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self. automaticallyAdjustsScrollViewInsets=YES;
}
+(void)initialize
{
    
    UINavigationBar *navBar=[UINavigationBar appearance];
   
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, [UIColor colorWithString:@"#0A091B"],NSForegroundColorAttributeName, nil];
    [navBar setTitleTextAttributes:dict];

    //设置创建的item文字大小颜色
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TextFont_12,NSFontAttributeName, RGB(0x0a091b),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TextFont_12,NSFontAttributeName, RGB(0x0a091b),NSForegroundColorAttributeName, nil] forState:UIControlStateHighlighted];
    
    
}
- (void)dealloc{
    [SHNotificationCenter removeObserver:self];
    DLog(@"------------dealloc---------%@",NSStringFromClass([self class]));
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
