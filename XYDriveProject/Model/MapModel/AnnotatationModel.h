//
//  AnnotatationModel.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoadListModel.h"

@interface AnnotatationModel : NSObject

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong)RoadListModel * roudeMoldel;

//@property (nonatomic, )

@end
