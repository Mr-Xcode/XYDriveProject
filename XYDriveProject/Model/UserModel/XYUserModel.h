//
//  XYUserModel.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/8.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYUserModel : AVObject
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * objectId;
@property (nonatomic, copy) NSString * sessionToken;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * creater;
@end
