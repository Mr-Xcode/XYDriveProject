//
//  RoadListModel.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/24.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Attributes :NSObject
@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * day;
@property (nonatomic, copy)NSString * city;
@property (nonatomic, copy)NSString * lat;
@property (nonatomic, copy)NSString * lng;
@property (nonatomic, copy)NSString * remark;

@property (nonatomic, copy)NSString * driveDistance;
@property (nonatomic, copy)NSString * driveTime;
@end
@interface Markers :NSObject
@property (nonatomic, strong)Attributes * attributes;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * start;
@property (nonatomic, copy)NSString * end;
@property (nonatomic, copy)NSString * objId;

@end

@interface RoadListModel : AVObject<AVSubclassing>
@property (nonatomic, strong)Markers * markers;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * objectId;
@property (nonatomic, copy)NSString * startDate;
@property (nonatomic, copy)NSString * userId;

@end
