//
//  FloatingView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/10.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "FloatingView.h"
@interface FloatingView ()

@end

@implementation FloatingView

-(instancetype)initWithStartDate:(NSDate *)start end:(NSDate *)end{
    self =[super init];
    if (self) {
        self.frame =[self getFrameWithStartDate:start end:end];
    }
    return self;
}
- (CGRect)getFrameWithStartDate:(NSDate *)start end:(NSDate *)end{
    CGRect rect;
//    NSInteger hour =[start ]
    DTTimePeriod *timePeriod =[[DTTimePeriod alloc] initWithStartDate:start endDate:end];
    double  durationInMinutes = [timePeriod durationInMinutes];  //相差分（最终蓝色事件view的height）
    //获取开始时间的小时，为了给y的坐标用
    NSInteger hour = start.hour;
    NSInteger minute =start.minute;
    rect =CGRectMake(0, hour * HOURHEIGHT + minute, SCREEN_W-50, durationInMinutes);
    return rect;
}
@end
