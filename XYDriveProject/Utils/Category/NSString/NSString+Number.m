
//
//  NSString+Number.m
//  ToGoProject
//
//  Created by togo on 2017/6/5.
//  Copyright © 2017年 Shuhuan.Gao. All rights reserved.
//

#import "NSString+Number.h"

@implementation NSString (Number)

-(NSString *)ignoreDecimal
{

    double f=self.doubleValue;
    if (fmod(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmod(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
    
}
-(NSString *)decimal2f
{
    
    return [NSString stringWithFormat:@"%.2f",[self doubleValue]];
}
-(NSString *)kmDistance
{
    double meter =self.doubleValue;
    NSString * meterStr;
    if (self.length>0)
    {
        if (meter >1000) {
            double lastMeter = meter/1000 ;
            meterStr= [NSString stringWithFormat:@"%.1f公里",lastMeter];
        }else{
            meterStr = [NSString stringWithFormat:@"%.0f米",meter];
        }
    }else{
        meterStr= [NSString stringWithFormat:@"0米"];
    }
    return meterStr;

}
@end
