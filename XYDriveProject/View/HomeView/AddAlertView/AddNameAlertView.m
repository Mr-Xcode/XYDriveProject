//
//  AddNameAlertView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/2.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "AddNameAlertView.h"
@interface AddNameAlertView ()
@property (weak, nonatomic) IBOutlet UITextField *tripNameField;
@property (weak, nonatomic) IBOutlet UIButton *goTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *sureAddButton;


@end

@implementation AddNameAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (instancetype)initWithBlcok:(AddClickBlock)block{
//    self =[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
//    if (self) {
//        self.addBlcok = ^{
//            block();
//        };
//    }
//    return self;
//}
- (IBAction)goTimebuttonClick:(id)sender {
    
}
- (IBAction)addButtonClick:(id)sender {
    AVUser * currentUser =[AVUser currentUser];
    AVObject *todoFolder = [[AVObject alloc] initWithClassName:SqlRoadbook];// 构建对象
    [todoFolder setObject:@"仙踪林" forKey:@"name"];// 设置名称
    [todoFolder setObject:@"2018-03-05" forKey:@"statDate"];// 设置优先级
    [todoFolder setObject:currentUser.objectId forKey:@"userId"];
    [todoFolder saveInBackground];// 保存到云端
    if (self.addBlcok) {
        self.addBlcok();
    }
}
//+ (void)showAddNameView:(AddClickBlock)block{
//    AddNameAlertView * alertView =[AddNameAlertView viewFromXib];
//}

@end
