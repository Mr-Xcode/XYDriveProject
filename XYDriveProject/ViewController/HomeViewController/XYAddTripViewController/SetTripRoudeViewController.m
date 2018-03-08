//
//  SetTripRoudeViewController.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/8.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "SetTripRoudeViewController.h"

@interface SetTripRoudeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;

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
- (IBAction)searchBtnClick:(id)sender {
}
- (IBAction)startBtnClick:(id)sender {
}
- (IBAction)endBtnClick:(id)sender {
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
