//
//  UIBarButtonItem+ImageTitle.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "UIBarButtonItem+ImageTitle.h"

@implementation UIBarButtonItem (ImageTitle)
+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain   target:target   action:action];
    return item;
}
@end
