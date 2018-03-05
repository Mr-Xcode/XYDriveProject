//
//  XYHttpManager.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/7.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYHttpManager.h"
#import "InterfaceDfine.h"
#import "XYRespons.h"
extern NSString * XYRequest_URL;

@implementation XYHttpManager
+ (void)XYPOSTHaveLoading:(NSString *)ApiUrL parameters:(id)parameters requestName:(NSString *)name success:(XYSuccess)success failure:(Failure)failure{
    [self writeLogRequestInfoWithURLString:ApiUrL parameters:parameters name:name];
    [self POSTWithURLString:ApiUrL parameters:parameters success:^(NSDictionary *response) {
        [self handleSuccessWithSuccess:success response:response url:ApiUrL name:name];
    } failure:^(NSError *error) {
        [self handleFailureWithFailure:failure error:error url:ApiUrL showError:YES name:name];
    }];
}
+ (void)XYPOSTNoLoading:(NSString *)ApiUrL parameters:(id)parameters requestName:(NSString *)name success:(XYSuccess)success failure:(Failure)failure{
    
}
#pragma mark - 打印请求信息
+(void)writeLogRequestInfoWithURLString:(NSString*)urlString parameters:(NSDictionary*)parameters name:(NSString*)name
{
    NSString *str=[NSString stringWithFormat:@"\n=============================请求参数信息==================================\n    请求地址：%@ \n    请求接口名称：%@ \n    请求参数：\n    %@\n************************************************************************************",urlString,name, parameters];
    
    DLog(@"%@",str );
    
}
+(void)handleSuccessWithSuccess:(XYSuccess)success response:(NSDictionary*)response url:(NSString*)url name:(NSString*)name{
    XYRespons * res =[XYRespons mj_objectWithKeyValues:response];
    if (success) {
        success(response,[res.status isEqualToString:@"0"],res.msg);
    }
}
#pragma mark - 处理失败结果
+(void)handleFailureWithFailure:(Failure)failure error:(NSError*)error url:(NSString*)url showError:(BOOL)showError  name:(NSString*)name
{
    if (showError) {
//        [UIToast showMessageToCenter:error.localizedDescription];
    }
    NSString *str=[NSString stringWithFormat:@"\n=============================请示失败信息==================================\n    请求地址：%@\n    请求接口名称：%@ \n    请求失败原因:%@\n************************************************************************************",url,name,error.localizedDescription];
    DLog(@"%@",str);
    
    if (failure) {
        failure(error);
    }
}
@end
