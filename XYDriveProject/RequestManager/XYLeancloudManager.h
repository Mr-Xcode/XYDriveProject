//
//  XYHttpManager.h
//  XYDriveProject
//
//  Created by gaoshuhuan on 2018/3/27.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestSuccesslock)(AVObject * obj);
typedef void(^RequestFailure)(NSError * error);

@interface XYLeancloudManager : NSObject

/**
 * @sel -- 构建对象
 * @parameters className 表名
 * @parameters objId 对象id
 * @parameters successBlock  成功
 * @parameters failureBlock  失败
 */
+ (void)requestAddObjectClassName:(NSString *)className parames:(id)parames Success:(RequestSuccesslock)successBlock Failure:(RequestFailure)failureBlock;

/**
 * @sel 获取对象-- 查询对象
 * @parameters className 表名
 * @parameters objId 对象id
 * @parameters successBlock  成功
 * @parameters failureBlock  失败
 */
+ (void)requestGetObject:(NSString *)className objId:(NSString *)objId Success:(RequestSuccesslock)successBlock Failure:(RequestFailure)failureBlock;

@end
