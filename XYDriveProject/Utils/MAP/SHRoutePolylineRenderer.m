//
//  SHRoutePolylineRenderer.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/4.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "SHRoutePolylineRenderer.h"

@implementation SHRoutePolylineRenderer
-(instancetype)initWithMultiPolyline:(MAMultiPolyline *)multiPolyline
{
    
    if (self=[super initWithMultiPolyline:multiPolyline]) {
        
        
        self.lineWidth = 5.0;
        self.lineJoinType = kMALineJoinRound;
        self.lineCapType  = kMALineCapRound;
        
        self.strokeColors = @[RGB(0x0C57D4),RGB(0x2575FC)];
        //        self.strokeColors = @[RGB(0x000000),RGB(0x2575FC)];
        self.gradient = YES;
    }
    return self;
}

@end
