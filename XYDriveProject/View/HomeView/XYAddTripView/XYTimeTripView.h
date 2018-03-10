//
//  XYTimeTripView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TIMEVIEWHEIGHT 400
#define TOPGestureViewH 45
#define LEFTMargin 45
#define HOURHEIGHT 60
typedef void(^UpSwipeGestureBlcok)(BOOL up);

@interface XYTimeTripView : UIView
@property (nonatomic, copy)UpSwipeGestureBlcok upBlcok;
@end
