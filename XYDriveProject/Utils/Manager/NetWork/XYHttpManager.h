//
//  XYHttpManager.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/7.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

/**
 * 定义请求成功的回调 block
 */
typedef void(^XYSuccess)(NSDictionary * respons, BOOL isSuccess, NSString * message);

@interface XYHttpManager : HttpManager

#pragma mark - 提供给各个类调用的请求接口
/**
 * POST带loading
 */
+ (void)XYPOSTHaveLoading:(NSString *)ApiUrL parameters:(id)parameters requestName:(NSString *)name success:(XYSuccess)success failure:(Failure)failure;
/**
 * POST不带loading
 */
+ (void)XYPOSTNoLoading:(NSString *)ApiUrL parameters:(id)parameters requestName:(NSString *)name success:(XYSuccess)success failure:(Failure)failure;
@end
