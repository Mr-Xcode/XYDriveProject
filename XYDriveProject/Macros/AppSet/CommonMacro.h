//
//  CommonMacro.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h
//版本
#define APPVersion [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]

//window
#define XYKeyWindow  [UIApplication sharedApplication].windows.firstObject

//weakself
#define WeakSelf __weak typeof(self) weakSelf=self


//沙盒快速设置
#define XYUserDefaultSetObjectWithKey(key,obj)  [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];[[NSUserDefaults standardUserDefaults] synchronize]

//快速取出值
#define XYUserDefaultGetObjectForKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

//删除key
#define XYUserDefaultremoveObjectForKey(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key] ;[[NSUserDefaults standardUserDefaults] synchronize]

//转字符串
#define StringFromInt(value) [NSString stringWithFormat:@"%d",value]
#define StringFromDouble(value)  [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", value] ]stringValue]
#define StringFromInteger(value) [NSString stringWithFormat:@"%ld",value]

//地图等级
#define MapZommLevel 16

#endif /* CommonMacro_h */
