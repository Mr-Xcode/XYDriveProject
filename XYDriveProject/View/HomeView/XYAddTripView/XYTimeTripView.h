//
//  XYTimeTripView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatingView.h"

typedef void(^UpSwipeGestureBlcok)(BOOL up);

@interface XYTimeTripView : UIView
- (instancetype)initWithFrame:(CGRect)frame markers:(NSArray *)array;
@property (nonatomic, copy)UpSwipeGestureBlcok upBlcok;
@end
