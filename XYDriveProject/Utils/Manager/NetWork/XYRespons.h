//
//  XYRespons.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/7.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYRespons : NSObject
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * status;
@property (nonatomic,strong) NSDictionary * data;
@end
