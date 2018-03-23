//
//  XYHomeViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYHomeViewController.h"
#import "TripCell.h"
#import "UIBarButtonItem+ImageTitle.h"
#import "XYMenuView.h"
#import "BackGroundGestureView.h"
#import "XYAddTripViewController.h"
#import "XYLoginViewController.h"
#import "RoadListModel.h"
#import "AddNameAlertView.h"

@interface XYHomeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL is_MenuStatus;
}
@property (nonatomic, strong)UITableView * homeTableView;
@property (nonatomic, strong)XYMenuView * menuView;
@property (nonatomic,weak)  BackGroundGestureView *backView;
@property (nonatomic, strong)NSMutableArray * dataList;
@property (nonatomic, weak) UIRefreshControl * xyrefreshControl;

@end

@implementation XYHomeViewController

#pragma mark - LayzLoad and UI
// 下拉刷新
- (void)setupRefresh {
    NSLog(@"setupRefresh -- 下拉刷新");
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(showData) forControlEvents:UIControlEventValueChanged];
    [self.homeTableView addSubview:refreshControl];
    [refreshControl beginRefreshing];
    self.xyrefreshControl =refreshControl;
//    [self refreshClick:refreshControl];
}
- (UITableView *)homeTableView{
    if (!_homeTableView) {
        self.homeTableView =[[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        self.homeTableView.frame= CGRectMake(0, 0, VIEW_W, VIEW_H-64);
        self.homeTableView.delegate =self;
        self.homeTableView.dataSource =self;
        self.homeTableView.estimatedRowHeight = 60;
        self.homeTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [self.homeTableView registerNib:[UINib nibWithNibName:@"TripCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.homeTableView.estimatedSectionFooterHeight=0;
        self.homeTableView.estimatedSectionHeaderHeight=0;
        [self setupRefresh];
    }
    return _homeTableView;
}
- (void)setUI{
    self.navigationItem.leftBarButtonItem =[UIBarButtonItem itemWithImageName:@"menuIcon" target:self action:@selector(showMenuView)];
    //个人中心
    if (!_menuView)
    {
        self.menuView =[XYMenuView viewFromXib];
        _menuView.frame =CGRectMake(-SCREEN_W, 0,SCREEN_W-50, SCREEN_H);
        [self.navigationController.view addSubview:_menuView];
    }
    
//    AddNameAlertView * addView =[AddNameAlertView viewFromXib];
//    addView.frame =CGRectMake(0, CGRectGetMinY(self.view.frame)-30, SCREEN_W, 300);
//    [self.view addSubview:addView];
//    self.addV =addView;
}
- (void)showData{
    AVUser * currentUser =[AVUser currentUser];
    if (currentUser && !ICIsStringEmpty(currentUser.sessionToken)) {
        [UILoading showMessage:@"刷新中……"];
        [currentUser isAuthenticatedWithSessionToken:currentUser.sessionToken callback:^(BOOL succeeded, NSError * _Nullable error) {
            [self.xyrefreshControl endRefreshing];
            [UILoading hide];
            if (succeeded) {
                // 用户的 sessionToken 有效
                AVQuery *query = [AVQuery queryWithClassName:SqlRoadbook];
                [query whereKey:@"userId" equalTo:currentUser.objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if (!ICIsObjectEmpty(self.dataList)) {
                            [self.dataList removeAllObjects];
                        }
                        NSArray<AVObject *> *todos = objects;
                        for (AVObject *todo in todos) {
                            [self.dataList addObject:todo];
                        }
//                        NSString * title = objects[0][@"markers"][0][@"title"];
                        [self.homeTableView reloadData];
                    }
                }];
            }else{
//                [self showLoginView];
            }
        }];
    }else{
        [self showLoginView];
    }
    
}
- (void)showLoginView{
    XYLoginViewController * loginVC =[[XYLoginViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController  =nav;
}
#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"我的行程";
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addTrip)];
    [self.view addSubview:self.homeTableView];
    self.dataList =[NSMutableArray array];
    [self setUI];
    [self showData];
}
#pragma mark - Button Click
- (void)showMenuView{
    BackGroundGestureView *view= [[BackGroundGestureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    WeakSelf;
    view.personView=_menuView;
    view.endBlock = ^() {
        [weakSelf hidePersonView];
    };
    self.backView=view;
    view.alpha=0;
    [self.navigationController.view insertSubview:view belowSubview:_menuView];
    [UIView animateWithDuration:0.25 animations:^{
        _menuView.x=0;
        view.alpha =1;
    } completion:^(BOOL finished) {
        is_MenuStatus =YES;
    }];
}
#pragma mark ----隐藏个人中心----
- (void)hidePersonView
{
    if (is_MenuStatus==NO) {
        return;
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [UIView animateWithDuration:0.25 animations:^{
        _menuView.x=-SCREEN_W;
        self.backView.alpha=0;
    } completion:^(BOOL finished) {
        is_MenuStatus = NO;//个人中心关闭
        [self.backView removeFromSuperview];
        self.backView=nil;
    }];
}
- (void)addTrip{
    WeakSelf;
    [[[AddNameAlertView alloc]initWithShowAddBlock:^(AVObject *obj) {
        DLog(@"添加了一个行程：%@",obj[@"name"]);
        [weakSelf pushAddVC:obj];
    }]show];
}
#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripCell *cell=(TripCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model=self.dataList[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section==(self.dataList.count-1)) {
//        return 10;
//    }
    return CGFLOAT_MIN;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AVObject * obj= self.dataList[indexPath.section];
    [self pushAddVC:obj];
}
- (void)pushAddVC:(AVObject *)obj{
    XYAddTripViewController * addVC =[[XYAddTripViewController alloc]init];
    addVC.tirpObj =obj;
    [self.navigationController pushViewController:addVC animated:YES];
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
