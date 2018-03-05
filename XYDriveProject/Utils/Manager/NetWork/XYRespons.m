//
//  XYRespons.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/7.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYRespons.h"

@implementation XYRespons
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"msg",@"message",@"status",@"status",@"data",@"body", nil];
}
@end
