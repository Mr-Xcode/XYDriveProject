//
//  XYDateSlecteView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/6.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

typedef void(^SelectDateBlcok)(NSDate * date,NSString * dateStr);

@interface XYDateSlecteView : UIView
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (nonatomic, copy) SelectDateBlcok seleDateBlock;
- (void)toNextDay;
@end
