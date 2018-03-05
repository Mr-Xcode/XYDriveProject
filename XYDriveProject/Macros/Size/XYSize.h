//
//  XYSize.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#ifndef XYSize_h
#define XYSize_h

// 屏幕尺寸
#define SCREEN_W    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H    ([UIScreen mainScreen].bounds.size.height)

//view尺寸
#define VIEW_W self.view.bounds.size.width
#define VIEW_H self.view.bounds.size.height

#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 屏幕比例
#define SCREEN_SCALE (DeviceWidth/320.0)
#define WF_SCALE(value) (value*SCREEN_SCALE)                     //返回相应比例参数

#endif /* XYSize_h */
