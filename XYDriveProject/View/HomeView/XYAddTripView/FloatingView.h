//
//  FloatingView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/10.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DateTools.h>

#define TIMEVIEWHEIGHT 400
#define TOPGestureViewH 45
#define LEFTMargin 45
#define HOURHEIGHT 60

@interface FloatingView : UIView

-(instancetype)initWithStartDate:(NSDate *)start end:(NSDate *)end;


@end
