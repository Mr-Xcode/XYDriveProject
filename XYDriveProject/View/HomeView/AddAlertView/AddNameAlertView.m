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
    AVObject * todo = [[AVObject alloc] initWithClassName:SqlRoadbook];// 构建对象
    [todo setObject:self.tripNameField.text forKey:@"name"];// 设置名称
    [todo setObject:self.selTimeStr forKey:@"startDate"];// 设置时间
    [todo setObject:currentUser.objectId forKey:@"userId"];
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            // 存储成功
            DLog(@"%@",todo.objectId);// 保存成功之后，objectId 会自动从云端加载到本
            if (self.addBlcok) {
                self.addBlcok(todo);
            }
             [self hideTargetView];
        }else{
            DLog(@"提交失败！");
        }
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
