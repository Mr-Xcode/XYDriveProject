//
//  SetTripRoudeViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/8.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "SetTripRoudeViewController.h"
#import <PGDatePicker/PGDatePickManager.h>
#import "NSDate+PGCategory.h"
#import "XYSearchPlaceViewController.h"
@interface SetTripRoudeViewController ()<PGDatePickerDelegate,XYAddDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic, strong)UIView * rightBtnView;

@property (nonatomic, strong)NSArray * markers;
@property (nonatomic, strong)NSDictionary * routes;
@property (nonatomic, assign)BOOL isStartTime;

@end

@implementation SetTripRoudeViewController
- (UIView *)rightButtonView{
    //两个按钮的父类view
    if (!_rightBtnView) {
        self.rightBtnView =[[UIView alloc]init];
        self.rightBtnView.frame =CGRectMake(0, 0, 150, 50);
        //        self.rightButtonView.backgroundColor =BLUE_COLOR;
        
        //筛选按钮
        
        UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 13, 24, 24)];
        
        historyBtn.titleLabel.font =TextFont_12;
        
        historyBtn.tag =201;
        
        //        [historyBtn setTitle:@"筛选" forState:UIControlStateNormal];
        
        [historyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [historyBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        
//        [historyBtn addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rightButtonView addSubview:historyBtn];
        
        //添加按钮
        
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rightButtonView.frame)-39, CGRectGetMinY(historyBtn.frame), 24, 24)];
        
        mainAndSearchBtn.titleLabel.font =TextFont_12;
        
        historyBtn.tag =202;
        
        [mainAndSearchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [mainAndSearchBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        [mainAndSearchBtn addTarget:self action:@selector(saveRequest) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rightButtonView addSubview:mainAndSearchBtn];
        
    }
    return _rightBtnView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isStartTime =YES;
    self.title =@"添加行程";
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtnView];
    
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    self.titleLable.text =self.model.attributes.address;
    [self.startBtn setTitle:self.model.start forState:UIControlStateNormal];
    [self.endBtn setTitle:self.model.end forState:UIControlStateNormal];
}
- (void)saveRequest{
    [self handleData];
    NSString * markId =[self getRandom];
    NSMutableArray * markers = [NSMutableArray arrayWithArray:self.markers];
    NSMutableDictionary * routes =[NSMutableDictionary dictionaryWithDictionary:self.routes];
    if (self.markers.count >0) {
        NSDictionary * lastMarker =[markers lastObject];
        NSMutableDictionary * newRoutes =[NSMutableDictionary dictionary];
        newRoutes[@"id"] =[NSString stringWithFormat:@"%@-%@",lastMarker[@"id"],markId];
        newRoutes[@"title"] =[NSString stringWithFormat:@"%@-%@",lastMarker[@"title"],self.titleLable.text];
        newRoutes[@"start"] =self.startBtn.titleLabel.text;
        newRoutes[@"end"] =self.endBtn.titleLabel.text;
        newRoutes[@"editable"] =@(NO);
        NSMutableDictionary * routAttributes =[NSMutableDictionary new];
        routAttributes[@"driveTime"] =@"";
        routAttributes[@"driveDistance"] =@"";
        routAttributes[@"type"] =@"route";
        routAttributes[@"remark"] =self.describeTextView.text;
        routAttributes[@"waypoints"] =nil;
        routAttributes[@"policy"] =@"LEAST_TIME";
        newRoutes[@"attributes"] =routAttributes;
        routes[[NSString stringWithFormat:@"%@-%@",lastMarker[@"id"],markId]] =newRoutes;
    }

    [UILoading showMessage:@"加载中……"];
    AVObject *todo = [AVObject objectWithClassName:@"Roadbook" objectId:self.objId];
    NSMutableDictionary * attributes =[NSMutableDictionary new];
    attributes[@"address"] =self.model.attributes.address;
    attributes[@"city"] =self.model.attributes.city;
    attributes[@"type"] =@"maker";
    attributes[@"arrived"] =@"0";
    attributes[@"lat"] =self.model.attributes.lat;
    attributes[@"lng"] =self.model.attributes.lng;
    NSMutableDictionary * dic =[NSMutableDictionary new];
    dic[@"attributes"] =attributes;
    dic[@"start"] =self.startBtn.titleLabel.text;
    dic[@"title"] =self.titleLable.text;
    dic[@"id"] =markId;
    dic[@"end"] =self.endBtn.titleLabel.text;
    [markers addObject:dic];
    
    [todo setObject:markers forKey:@"markers"];
    [todo setObject:routes forKey:@"routes"];
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [UILoading hide];
                if (succeeded) {
                    // 存储成功
                    [self.navigationController popViewControllerAnimated:YES];
                    DLog(@"%@",todo.objectId);// 保存成功之后，objectId 会自动从云端加载到本
                }else{
                    DLog(@"提交失败！");
                    [UIToast showMessage:@"提交失败"];
                }
            }];
    
}
- (void)handleData{
    if (!ICIsObjectEmpty(self.tripObject)) {
        self.objId =self.tripObject.objectId;
        self.markers =self.tripObject[@"markers"];
        NSDictionary * routeDic =self.tripObject[@"routes"];
        self.routes =routeDic;
        DLog(@"markers=%@ routes=%@",self.markers,self.routes);
    }
}
- (IBAction)searchButtonClick:(id)sender {
    XYSearchPlaceViewController * searchVC =[[XYSearchPlaceViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (IBAction)searchBtnClick:(id)sender {
    XYSearchPlaceViewController * searchVC =[[XYSearchPlaceViewController alloc]init];
    searchVC.adddelegate =self;
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (IBAction)startBtnClick:(id)sender {
    self.isStartTime =YES;
    [self showTimeAlert];
}
- (IBAction)endBtnClick:(id)sender {
    self.isStartTime =NO;
    [self showTimeAlert];
}
- (void)addPoint:(Markers *)model{
    self.model =model;
    self.titleLable.text =self.model.attributes.address;
}
- (void)showTimeAlert{
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeDateAndTime;
    [self presentViewController:datePickManager animated:false completion:nil];
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSDate * date =[NSDate setYear:dateComponents.year month:dateComponents.month day:dateComponents.day hour:dateComponents.hour minute:dateComponents.minute];
    NSString * string =[self dateFormattingWithDate:date toFormate:@"YYYY-MM-dd HH:mm"];
    NSLog(@"date = %@", string);
    if (self.isStartTime) {
        [self.startBtn setTitle:string forState:UIControlStateNormal];
    }else{
        [self.endBtn setTitle:string forState:UIControlStateNormal];
    }
//    [self.goTimeButton setTitle:string forState:UIControlStateNormal];
//    self.selTimeStr =string;
    
}
- (NSString *)dateFormattingWithDate:(NSDate *)date toFormate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    return [formatter stringFromDate:date];
}
- (NSString *)getRandom{
    NSString * str=@"XY@";
    NSString * nLetterValue;
    NSArray * numArray =[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F", nil];
    for (int ii=0; ii<11; ii++) {
        int num =arc4random() % 19;
        nLetterValue =[numArray objectAtIndex:num];
        str =[str stringByAppendingString:nLetterValue];
        DLog(@"----------num =%d str=%@",num,str);
    }
    
    return str;
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
