//
//  HttpManager.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/7.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SharedHttpManager [HttpManager sharedHttpManager]

/*! 判断是否有网 */
#ifndef kIsHaveNetwork
#define kIsHaveNetwork   [HttpManager isHaveNetwork]
#endif

/*! 判断是否为手机网络 */
#ifndef kIs3GOr4GNetwork
#define kIs3GOr4GNetwork [HttpManager is3GOr4GNetwork]
#endif

/*! 判断是否为WiFi网络 */
#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork   [HttpManager isWiFiNetwork]
#endif


/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, NetworkStatus)
{
    //未知网络
    NetworkStatusUnknown           = 0,
    // 没有网络
    NetworkStatusNotReachable,
    //手机 3G/4G 网络
    NetworkStatusReachableViaWWAN,
    // wifi 网络
    NetworkStatusReachableViaWiFi
};

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, HttpType)
{
    // get请求
    HttpTypeGet = 0,
    // post请求
    HttpTypePost,
    // put请求
    HttpTypePut,
    // delete请求
    HttpTypeDelete
};

/*! 定义请求成功的 block */
typedef void (^Success)(NSDictionary* response);
/*! 定义请求失败的 block */
typedef void (^Failure)(NSError *error);
/*! 定义上传下载进度 block */
typedef void(^UploadDownloadProgress)(CGFloat progressValue);
/*! 实时监测网络状态的 block */
typedef void(^NetworkStatusBlock)(NetworkStatus status);
@interface HttpManager : NSObject


/**
 *  POST
 */
+ (void)POSTWithURLString:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure;

/**
 * GET
 */
+ (void)GetWithURLString:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure;

//----------------以下两个方法如果需要使用可以重写

// 返回公共参数字典
+(NSDictionary *)getPublicParams;

// 返回要设置的cookie字典
+(NSDictionary*)getCookieDictionary;

//返回 要设置的公共HeaderField信息
+(NSDictionary*)getPublicHeaderField;

//返回 上传图片设置公共HeaderField信息
+(NSDictionary*)getPublicHeaderFieldImage;

//返回 支付api设置公共HeaderField信息
+(NSDictionary*)getPublicHeaderFieldPayment;

//设置公共头信息
+(void)setHeaderWithDic:(NSDictionary*)dic;
@end
