//
//  BackGroundGestureView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackGroundGestureView : UIView

@property (nonatomic,copy)  void(^endBlock)();

@property (nonatomic,weak) UIView *personView;
@end
