//
//  WriteLog.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

/*
 * 注释以下4行，则不打印:Debug、debugError、Warning、Notice级别日志
 */
#define Debug @"debug"//debug log
#define debugError @"error"
#define Warning @"warn"
#define Notice @"notice"



#define ERR_LOG 1 /* 应用程序无法正常完成操作，比如网络断开，内存分配失败等 */
#define WARN_LOG 2 /* 进入一个异常分支，但并不会引起程序错误 */
#define NOTICE_LOG 3 /* 日常运行提示信息，比如登录、退出日志 */
#define DEBUG_LOG 4 /* 调试信息，打印比较频繁，打印内容较多的日志 */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog(fmt,##__VA_ARGS__);
#else
#define DLog(fmt, ...)
#endif

#ifdef Debug
#define DebugLog(format,...) writeLog(DEBUG_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#else
#define DebugLog(fmt, ...)
#endif

#ifdef debugError
#define ErrLog(format,...) writeLog(ERR_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#else
#define ErrLog(format,...)
#endif

#ifdef Warning
#define WarLog(format,...) writeLog(WARN_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#else
#define WarLog(format,...)
#endif

#ifdef Notice
#define NoticeLog(format,...) writeLog(NOTICE_LOG,__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#else
#define NoticeLog(format,...)
#endif
#import <Foundation/Foundation.h>

@interface WriteLog : NSObject

void writeLog(int ulErrorLevel, const char *func, int lineNumber, NSString *format, ...);

@end
