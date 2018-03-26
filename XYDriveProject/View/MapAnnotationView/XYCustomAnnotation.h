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

typedef NS_ENUM(NSUInteger, AnnotationType){
    isDefault,//默认显示的
    isAdd,//长按添加的
};

@interface XYCustomAnnotation : MAPointAnnotation

//@property (nonatomic, strong) AnnotatationModel * model;
@property (nonatomic, strong) Markers * model;
@property (nonatomic, assign)AnnotationType anType;

@end
