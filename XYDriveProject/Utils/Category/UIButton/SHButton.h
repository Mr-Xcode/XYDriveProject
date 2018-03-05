//
//  SHButton.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHButton : UIButton
//设置此属性 在设置text和iamge之前 可避免一些问题 如（ios8刚开始在中间 高亮时位置才显示对）
@property (nonatomic,assign) CGRect titleRect;
@property (nonatomic,assign) CGRect imageRect;
@end
