//
//  NSMutableAttributedString+NumColor.m
//  ToGoProject
//
//  Created by ShuHuan on 2017/12/6.
//  Copyright © 2017年 TOGO. All rights reserved.
//

#import "NSMutableAttributedString+NumColor.h"

@implementation NSMutableAttributedString (NumColor)

+ (NSMutableAttributedString *)numColorSet:(NSString *)str Color:(UIColor *)color{
    NSMutableAttributedString *AttributeDesAmountStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    for (int i = 0; i < str.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [str substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [AttributeDesAmountStr setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(i, 1)];
        }
        
    }
    return AttributeDesAmountStr;
}
@end
