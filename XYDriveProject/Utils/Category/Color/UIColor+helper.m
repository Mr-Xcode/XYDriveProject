//
//  UIColor+helper.m
//  CarCar2.0
//
//  Created by shuhuan.Gao on 13-10-12.
//  Copyright (c) 2015年 shuhuan.Gao. All rights reserved.
//

#import "UIColor+helper.h"
@implementation UIColor (helper)

+(UIColor *)colorWithString:(NSString *)colorString {
    if ([colorString length] != 7 || ![colorString hasPrefix:@"#"]) {
        return nil;
    }
    UIColor *color = nil;
    NSScanner *scanner = [[NSScanner alloc] initWithString:[colorString substringFromIndex:1]];
    unsigned hexValue;
    if ([scanner scanHexInt:&hexValue] && [scanner isAtEnd]) {
        int r = ((hexValue & 0xFF0000) >> 16);
        int g = ((hexValue & 0x00FF00) >>  8);
        int b = ( hexValue & 0x0000FF)       ;
        color = [self colorWithRed:((float)r / 255)
                             green:((float)g / 255)
                              blue:((float)b / 255)
                             alpha:1.0];
    }
    return color;
}
@end
