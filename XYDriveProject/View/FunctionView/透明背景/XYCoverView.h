//
//  XYCoverView.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XYCoverViewClickBackGroungHideBlcok)();
@interface XYCoverView : UIView

@property (nonatomic, weak)UIView * targetView;
+(void)showTargetView:(UIView *)targetView CanHide:(BOOL)canhide ClickBackGroundHideBlock:(XYCoverViewClickBackGroungHideBlcok)block;
+(void)showTargetView:(UIView *)targetView;

@end
