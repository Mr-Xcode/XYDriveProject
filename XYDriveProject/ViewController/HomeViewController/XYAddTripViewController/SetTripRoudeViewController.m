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
@interface SetTripRoudeViewController ()<PGDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SetTripRoudeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"添加行程";
    [self setItemsBtnTitles:@[@"搜索",@"确认"] images:@[@"",@""] action:^(UIButton *button) {
        if (button.tag==201) {
            //item1
        }else if (button.tag ==202){
            //item2
        }
    }];
    
    self.titleLable.text =self.model.title;
    [self.startBtn setTitle:self.model.start forState:UIControlStateNormal];
    [self.endBtn setTitle:self.model.end forState:UIControlStateNormal];
}
- (IBAction)searchButtonClick:(id)sender {
    XYSearchPlaceViewController * searchVC =[[XYSearchPlaceViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (IBAction)searchBtnClick:(id)sender {
    XYSearchPlaceViewController * searchVC =[[XYSearchPlaceViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (IBAction)startBtnClick:(id)sender {
    [self showTimeAlert];
}
- (IBAction)endBtnClick:(id)sender {
    [self showTimeAlert];
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
//    [self.goTimeButton setTitle:string forState:UIControlStateNormal];
//    self.selTimeStr =string;
    
}
- (NSString *)dateFormattingWithDate:(NSDate *)date toFormate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    return [formatter stringFromDate:date];
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
