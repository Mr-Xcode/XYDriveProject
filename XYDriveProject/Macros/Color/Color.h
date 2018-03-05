//
//  Color.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#ifndef Color_h
#define Color_h

#define RGB(rgbValue)                                                          \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0         \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0            \
blue:((float)(rgbValue & 0xFF)) / 255.0                     \
alpha:1.0]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
//随机颜色
#define RND_COLOR ((double)arc4random() / RAND_MAX)

#endif /* Color_h */
