//
//  UIView+Extension.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
// 分类不能添加成员属性
// @property如果在分类里面，只会自动生成get,set方法的声明，不会生成成员属性，和方法的实现
@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat centerX;
@property(nonatomic, assign) CGFloat centerY;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGPoint origin;

//返回当前view所在的控制器
- (UIViewController *)viewController;

//    删除所有子对象
- (void)removeAllSubviews;

// 判断一个控件是否真正显示在主窗口
- (BOOL)isShowingOnKeyWindow;

// 快速返回对应的Xib转换后的View
+ (instancetype)viewFromXib;

#pragma mark - 动画相关

//淡入
- (void)fadeInWithTime:(NSTimeInterval)time;
//淡出
- (void)fadeOutWithTime:(NSTimeInterval)time;
//缩放
- (void)scalingWithTime:(NSTimeInterval)time andScale:(CGFloat)scale;
//旋转
- (void)rotatingWithTime:(NSTimeInterval)time andAngle:(CGFloat)angle;



#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
               withRadius:(CGFloat)radius
                 viewRect:(CGRect)rect;



@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, strong) UIColor *borderColor;

//添加四周阴影

-(void)addShadowWithColor:(UIColor*)color radius:(CGFloat)radius opacity:(CGFloat)opacity offset:(CGSize)offset;

//隐藏背景view
-(void)hideTargetView;

@end
