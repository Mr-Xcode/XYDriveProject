//
//  XYSearchPlaceViewController.h
//  XYDriveProject
//
//  Created by gaoshuhuan on 2018/3/26.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYAddDelegate <NSObject>
- (void)addPoint:(Markers *)model;
@end

@interface XYSearchPlaceViewController : XYBaseViewController
@property (nonatomic, weak)id<XYAddDelegate>adddelegate;

@end
