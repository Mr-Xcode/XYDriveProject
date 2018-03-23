//
//  NSMutableAttributedString+NumColor.h
//  ToGoProject
//
//  Created by ShuHuan on 2017/12/6.
//  Copyright © 2017年 TOGO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (NumColor)
+ (NSMutableAttributedString *)numColorSet:(NSString *)str Color:(UIColor *)color;
@end
