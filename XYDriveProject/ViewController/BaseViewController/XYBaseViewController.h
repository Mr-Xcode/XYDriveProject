//
//  XYBaseViewController.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
//左右导航按钮回调
typedef void(^NavBtnAction)(UIButton *button);

@interface XYBaseViewController : UIViewController
/*
 * property
 */
@property (copy, nonatomic) NavBtnAction leftItemAction;
@property (copy, nonatomic) NavBtnAction rightItemAction;

/*
 *
 * SEL
 *
 */
/*
 * 设置默认返回按钮
 */
- (void)setDefaultLeftBtn;
/**
 *  设置navigationBarTitle
 */
- (void)setNavigationBarTitle:(NSString *)title;

/**
 *  设置navigation背景透明
 */
- (void)setNavigationBackGroudDiaphanous;

/**
 *  设置navigation背景不透明
 */
- (void)setNavigationBackGroudOpaque;

#pragma mark ===== leftBarButton

/**
 *  设置navigation左按钮（图片）
 *
 *  @param image     normal图片
 *  @param highImage 高亮图片
 */
- (void)setNavigationBarLeftItemimage:(NSString *)image highImage:(NSString *)highImage;

/**
 *  设置navigation左按钮（文字）
 *
 *  @param title 按钮文字
 */
- (void)setNavigationBarLeftItemButttonTitle:(NSString *)title;

/**
 *  设置navigation左按钮（图片 + 文字）
 *
 *  @param title 文字
 *  @param image 图片
 */
- (void)setNavigationBarLeftItemButtonTitle:(NSString *)title image:(NSString *)image;

#pragma mark ===== rightBarButton
/**
 *  设置navigation右按钮
 *
 *  @param image     正常图片
 *  @param highImage 高亮图片
 */
- (void)setNavigationBarRightItemimage:(NSString *)image highImage:(NSString *)highImage;
/**
 *  设置navigation右按钮（文字）
 *
 *  @param title 按钮文字
 */
- (void)setNavigationBarRightItemButttonTitle:(NSString *)title;

/**
 *  设置navigation右按钮（图片 + 文字）
 *
 *  @param title 文字
 *  @param image 图片
 */
- (void)setNavigationBarRightItemButtonTitle:(NSString *)title image:(NSString *)image;
@end
