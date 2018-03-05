//
//  TripCell.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "TripCell.h"
#import "RoadListModel.h"
@interface TripCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *startDateLable;
@property (weak, nonatomic) IBOutlet UILabel *lichengLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *daysLable;

@end

@implementation TripCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(AVObject *)model{
//    NSArray * markers = model[@"markers"];
//    for (NSDictionary * dic in markers) {
//        Markers * marker =[Markers mj_objectWithKeyValues:dic];
//        self.titleLable.text =marker.title;
//    }
//    self.titleLable.text = model[@"markers"][0][@"title"];
    self.titleLable.text =model[@"name"];
    self.startDateLable.text =model[@"startDate"];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
