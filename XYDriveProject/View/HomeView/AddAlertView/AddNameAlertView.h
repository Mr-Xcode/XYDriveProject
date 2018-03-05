//
//  AddNameAlertView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/2.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddClickBlock)();

@interface AddNameAlertView : UIView
@property (nonatomic, copy) AddClickBlock addBlcok;
//- (instancetype)initWithBlcok:(AddClickBlock)block;
@end
