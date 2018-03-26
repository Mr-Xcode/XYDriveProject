//
//  XYDateSlecteView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/6.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@interface XYDateSlecteView : UIView
@property (strong, nonatomic) JTCalendarManager *calendarManager;
- (void)toNextDay;
@end
