//
//  AddNameAlertView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/2.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "AddNameAlertView.h"
#import <PGDatePicker/PGDatePickManager.h>
#import "XYCoverView.h"
#import "TGCoverView.h"
#import "NSDate+PGCategory.h"
@interface AddNameAlertView ()<PGDatePickerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tripNameField;
@property (weak, nonatomic) IBOutlet UIButton *goTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *sureAddButton;
@property (nonatomic, copy) NSString * selTimeStr;


@end

@implementation AddNameAlertView
- (instancetype)initWithShowAddBlock:(AddClickBlock)block{
    self =[super init];
    if (self) {
        self =[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        [self layoutIfNeeded];
        self.addBlcok = ^(AVObject *obj) {
            if (block) {
                block(obj);
            }
        };
    }
    return self;
}
- (void)show{
     [XYCoverView showTargetView:self];
}
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)showTimeAlert{
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeDateAndTime;
    [[self viewController] presentViewController:datePickManager animated:false completion:nil];
}
- (IBAction)goTimebuttonClick:(id)sender {
    [self showTimeAlert];
}
- (IBAction)addButtonClick:(id)sender {
    if (ICIsStringEmpty(self.tripNameField.text) || ICIsStringEmpty(self.selTimeStr)) {
        return;
    }
    AVUser * currentUser =[AVUser currentUser];
    
    NSMutableDictionary * parames =[NSMutableDictionary dictionary];
    parames[@"name"] = self.tripNameField.text;
    parames[@"startDate"] = self.selTimeStr;
    parames[@"userId"] = currentUser.objectId;
    parames[@"creater"] =currentUser.username;
    parames[@"markers"] =nil;
    parames[@"routes"] =nil;
    [XYLeancloudManager requestAddObjectClassName:SqlRoadbook parames:parames Success:^(AVObject *obj) {
        [obj setObject:obj.objectId forKey:@"id"];
        [obj save];
        if (self.addBlcok) {
            self.addBlcok(obj);
        }
        [self hideTargetView];
    } Failure:^(NSError *error) {

    }];
}
#pragma mark - <UITextFiledDelegate>
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.tripNameField.text =textField.text;
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSDate * date =[NSDate setYear:dateComponents.year month:dateComponents.month day:dateComponents.day hour:dateComponents.hour minute:dateComponents.minute];
    NSString * string =[self dateFormattingWithDate:date toFormate:@"YYYY-MM-dd HH:mm"];
    NSLog(@"date = %@", string);
    [self.goTimeButton setTitle:string forState:UIControlStateNormal];
    self.selTimeStr =string;
    
}
- (NSString *)dateFormattingWithDate:(NSDate *)date toFormate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    return [formatter stringFromDate:date];
}

@end
