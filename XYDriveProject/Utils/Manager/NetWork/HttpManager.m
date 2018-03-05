//
//  HttpManager.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/7.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

#define TIMEOUT 15

@interface HttpManager ()
@property (nonatomic, strong) AFHTTPSessionManager * manager;
@property (nonatomic, strong) NSMutableArray * tasks;
//单例
+ (instancetype)sharedHttpManager;

@end
@implementation HttpManager

static HttpManager * instance =nil;
+ (instancetype)sharedHttpManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance =[[self alloc]init];
        instance.manager =[self createManagerAndSetting];
        instance.tasks =[NSMutableArray array];
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
#pragma mark - GET
+ (void)GetWithURLString:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure
{
    [self RequestWithType:HttpTypeGet URLString:URLString parameters:parameters success:^(NSDictionary *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
#pragma mark - POST
+ (void)POSTWithURLString:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure
{
    [self RequestWithType:HttpTypePost URLString:URLString parameters:parameters success:^(NSDictionary *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
#pragma mark - 公共请求
+(void)RequestWithType:(HttpType)type URLString:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure{
    __block NSURLSessionTask * sessionTask =nil;
    parameters =[self setPublicParams:parameters];
    [self setCookie:URLString];
    AFHTTPSessionManager * manager =SharedHttpManager.manager;
    
    [self setPublicHeaderFieldWithManager:manager];
    
    __weak __typeof(SharedHttpManager) weakSelf =SharedHttpManager;
    if (type ==HttpTypeGet) {
        sessionTask =[manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success([self dictionaryWithData:responseObject]);
            }
            [weakSelf.tasks removeObject:sessionTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
            [weakSelf.tasks removeObject:sessionTask];
        }];
    }else if (type ==HttpTypePost){
        sessionTask =[manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success([self dictionaryWithData:responseObject]);
            }
            [weakSelf.tasks removeObject:sessionTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
            [weakSelf.tasks removeObject:sessionTask];
        }];
    }else if (type == HttpTypePut){
        sessionTask=  [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success([self dictionaryWithData:responseObject]);
            }
            [weakSelf.tasks removeObject:sessionTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
            [weakSelf.tasks removeObject:sessionTask];
        }];
    }else if (type == HttpTypeDelete){
        sessionTask= [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success([self dictionaryWithData:responseObject]);
            }
            [weakSelf.tasks removeObject:sessionTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
            [weakSelf.tasks removeObject:sessionTask];
        }];
    }
    
    if (sessionTask)
    {
        [SharedHttpManager.tasks addObject:sessionTask];
    }
}
#pragma mark - 设置公共参数
+(NSDictionary*)setPublicParams:(NSDictionary*)params
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return params;
    }
    NSDictionary *dic=[self getPublicParams];
    if (dic==nil||dic.allKeys.count<=0) {
        return params;
    }
    if (params==nil) {
        params=[NSDictionary dictionary];
    }
    NSMutableDictionary *newParams =
    [[NSMutableDictionary alloc] initWithDictionary:params];
    for (NSString *key in dic) {
        [newParams setValue:dic[key] forKeyPath:key];
    }
    return newParams;
}

+(NSDictionary *)getPublicParams
{
    return nil;
}
#pragma mark - 设置cookie
+ (void)setCookie:(NSString *)newUrl
{
    NSDictionary *dic= [self getCookieDictionary];
    if (dic==nil||dic.allKeys.count==0) {
        return;
    }
    // 定义 cookie 要设定的 host
    NSURL *cookieHost = [NSURL URLWithString:newUrl];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 设定 cookie
        NSHTTPCookie *cookie = [NSHTTPCookie
                                cookieWithProperties:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 [cookieHost host], NSHTTPCookieDomain,
                                 [cookieHost path], NSHTTPCookiePath,
                                 key,NSHTTPCookieName,
                                 obj,NSHTTPCookieValue,
                                 nil
                                 ]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }];
}


+(NSDictionary*)getCookieDictionary
{
    return nil;
}
#pragma mark - 设置公共HeaderField
+(void)setPublicHeaderFieldWithManager:(AFHTTPSessionManager*)manager
{
    
    NSDictionary *dic= [self getPublicHeaderField];
    if (dic==nil||dic.allKeys.count==0) {
        return;
    }
    for (NSString *key in dic) {
        [manager.requestSerializer setValue:dic[key] forHTTPHeaderField:key];
    }
}

+(NSDictionary*)getPublicHeaderField
{
    return nil;
}
#pragma mark - 辅助类
+(AFHTTPSessionManager*)createManagerAndSetting
{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    
    /*! 打开状态栏的等待菊花 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    /*! 设置相应的缓存策略：此处选择不用加载也可以使用自动缓存【注：只有get方法才能用此缓存策略，NSURLRequestReturnCacheDataDontLoad】 */
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    /*! 这里是去掉了键值对里空对象的键值 */
    //    response.removesKeysWithNullValues = YES;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //请求队列的最大并发数
    //manager.operationQueue.maxConcurrentOperationCount = 5;
    
    //请求超时的时间
    manager.requestSerializer.timeoutInterval = TIMEOUT;;
    
#ifdef ISEncrypt
    [manager.requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
#endif
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*",@"application/octet-stream", nil];
    
    
    /*! https 参数配置 */
    //采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    // 如果服务端使用的是正规CA签发的证书, 那么以上代码则可以去掉
    return manager;
    
}
#pragma mark - NSData转化为字典
+ (NSDictionary *)dictionaryWithData:(NSData *)data {
    NSDictionary *dictionary =
    [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if (dictionary) {
        return dictionary;
    }
    return nil;
}
#pragma mark - 网络状态监测
+ (void)startNetWorkMonitoringWithBlock:(NetworkStatusBlock)networkStatusBlock
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        NetworkStatus  newNetworkStatus;
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                DLog(@"未知网络");
                newNetworkStatus=NetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"没有网络");
                newNetworkStatus=NetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"手机自带网络");
                newNetworkStatus=NetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"wifi 网络");
                newNetworkStatus=NetworkStatusReachableViaWiFi;
                break;
        }
        if (networkStatusBlock) {
            networkStatusBlock(newNetworkStatus);
        }
        
    }];
    [manager startMonitoring];
}


/*!
 *  是否有网
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)isHaveNetwork
{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

/*!
 *  是否是手机网络
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)is3GOr4GNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

/*!
 *  是否是 WiFi 网络
 *
 *  @return YES, 反之:NO
 */
+ (BOOL)isWiFiNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}
@end
