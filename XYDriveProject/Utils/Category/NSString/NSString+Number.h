//
//  NSString+Number.h
//  ToGoProject
//
//  Created by togo on 2017/6/5.
//  Copyright © 2017年 Shuhuan.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Number)

//忽略小点数后两位全是  .00  的情况
@property (nonatomic,copy,readonly) NSString *ignoreDecimal;

//保留两位小数
@property (nonatomic,copy,readonly) NSString *decimal2f;

//返回米或者公里数
@property (nonatomic,copy,readonly)NSString *kmDistance;




@end
