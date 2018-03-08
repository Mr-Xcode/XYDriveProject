//
//  XYBaseViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYBaseViewController.h"

@interface XYBaseViewController ()

@property (nonatomic, strong)SHButton * oneItemBtn;
@property (nonatomic, strong)SHButton * twoItemBtn;


@end

@implementation XYBaseViewController
- (UIView *)rightButtonView{
    //两个按钮的父类view
    if (!_rightButtonView) {
        self.rightButtonView =[[UIView alloc]init];
        self.rightButtonView.frame =CGRectMake(0, 0, 150, 50);
        //        self.rightButtonView.backgroundColor =[UIColor redColor];
        
        //历史浏览按钮
        
        SHButton *historyBtn = [[SHButton alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
        
        [historyBtn setTitle:@"" forState:UIControlStateNormal];
        
        historyBtn.titleLabel.font =TextFont_12;
        
        historyBtn.tag =201;
        
        [historyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [historyBtn setImage:[UIImage imageNamed:@"button_history"] forState:UIControlStateNormal];
        
        [historyBtn addTarget:self action:@selector(itmeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rightButtonView addSubview:historyBtn];
        
        self.oneItemBtn =historyBtn;
        
        //主页搜索按钮
        
        SHButton *mainAndSearchBtn = [[SHButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(historyBtn.frame), 0, 75, 50)];
        
        [mainAndSearchBtn setTitle:@"" forState:UIControlStateNormal];
        
        mainAndSearchBtn.titleLabel.font =TextFont_12;
        
         historyBtn.tag =202;
        
        [mainAndSearchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"button_filter-"] forState:UIControlStateNormal];
        
        [mainAndSearchBtn addTarget:self action:@selector(itmeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rightButtonView addSubview:mainAndSearchBtn];
        
        self.twoItemBtn =mainAndSearchBtn;
        
    }
    return _rightButtonView;
}
- (void)setItemsBtnTitles:(NSArray *)titles images:(NSArray *)images action:(NavBtnAction)blcok{
    if (!ICIsObjectEmpty(titles)) {
        [self.oneItemBtn setTitle:[titles objectAtIndex:0] forState:UIControlStateNormal];
        [self.twoItemBtn setTitle:[titles objectAtIndex:1] forState:UIControlStateNormal];
    }
    if (!ICIsObjectEmpty(images)) {
        [self.oneItemBtn setImage:[UIImage imageNamed:[images objectAtIndex:0]] forState:UIControlStateNormal];
        [self.twoItemBtn setImage:[UIImage imageNamed:[images objectAtIndex:1]] forState:UIControlStateNormal];
    }
    self.rightItemAction = ^(UIButton *button) {
        if (blcok) {
            blcok(button);
        }
    };
}
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
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:self.rightButtonView];
    
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
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
#pragma mark - BtnClick
-(void)itmeBtnClick:(UIButton *)sender{
    if (self.rightItemAction) {
        self.rightItemAction(sender);
    }
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
