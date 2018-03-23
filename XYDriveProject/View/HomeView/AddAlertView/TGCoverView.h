//
//  KCCoverView.h
//  kuaichengwuliu
//
//  Created by 刘松 on 16/4/30.
//  Copyright © 2016年 kuaicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TGCoverViewClickBackgroundHideBlock)();
@interface TGCoverView : UIView

@property (nonatomic,weak) UIView *targetView;



//点击背景可以隐藏  block只有在为YES的情况系 点击背景隐藏才会调用
+(void)showTargetView:(UIView*)targetView canHide:(BOOL)canHide clickBackgroundHideBlock:(TGCoverViewClickBackgroundHideBlock)clickBackgroundHideBlock;

//默认不能点击隐藏 
+(void)showTargetView:(UIView*)targetView;

/// 消失
//-(void)dismiss;

@end
