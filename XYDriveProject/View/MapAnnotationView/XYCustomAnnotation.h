//
//  XYCustomAnnotation.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/8.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "AnnotatationModel.h"
#import "RoadListModel.h"

@interface XYCustomAnnotation : MAPointAnnotation

//@property (nonatomic, strong) AnnotatationModel * model;
@property (nonatomic, strong) Markers * model;

@end
