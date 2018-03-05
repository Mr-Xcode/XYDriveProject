//
//  XYCustomAnnotationView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "XYCustomCalloutView.h"

@interface XYCustomAnnotationView : MAAnnotationView
@property (nonatomic, readonly) XYCustomCalloutView *calloutView;

@end
