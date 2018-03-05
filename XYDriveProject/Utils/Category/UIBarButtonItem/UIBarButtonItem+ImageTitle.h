//
//  UIBarButtonItem+ImageTitle.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ImageTitle)
+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
