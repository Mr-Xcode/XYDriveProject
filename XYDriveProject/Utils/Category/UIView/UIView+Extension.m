//
//  UIView+Extension.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "UIView+Extension.h"
#import "XYCoverView.h"

@implementation UIView (Extension)
#pragma mark - Frame
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}
-(CGPoint)origin
{
    return self.frame.origin;
    
}
-(void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin=origin;
    self.frame = frame;
}
#pragma mark -    返回当前view所在的控制器
- (UIViewController*) viewController
{
    for (UIResponder *res=self.nextResponder;res!=nil ;res=res.nextResponder) {
        if ([res isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)res;
        }
    }
    
    return nil;
}
-(void)setRadius:(CGFloat)radius
{
    self.layer.cornerRadius=radius;
    self.layer.masksToBounds=YES;
}
-(void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor=borderColor.CGColor;
}

#pragma mark -      删除所有子对象

- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

#pragma mark -   判断一个控件是否真正显示在主窗口

- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

#pragma mark -  快速返回对应的Xib

+ (instancetype)viewFromXib
{
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}


#pragma mark - 动画
//淡入
- (void)fadeInWithTime:(NSTimeInterval)time{
    self.alpha = 0;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
//淡出
- (void)fadeOutWithTime:(NSTimeInterval)time{
    self.alpha = 1;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//缩放
- (void)scalingWithTime:(NSTimeInterval)time andScale:(CGFloat)scale
{
    
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeScale(scale,scale);
    }];
}
//旋转
- (void)rotatingWithTime:(NSTimeInterval)time andAngle:(CGFloat)angle
{
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
    }];
}



#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
               withRadius:(CGFloat)radius viewRect:(CGRect)rect
{
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}


-(void)addShadowWithColor:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity
{
    self.layer.shadowOffset=CGSizeMake(0, 0);
    self.layer.shadowColor=color.CGColor;
    self.layer.shadowRadius=radius;
    self.layer.shadowOpacity=opacity;
    self.layer.masksToBounds=NO;
}


-(void)addShadowWithColor:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity offset:(CGSize)offset
{
    self.layer.shadowOffset=offset;
    self.layer.shadowColor=color.CGColor;
    self.layer.shadowRadius=radius;
    self.layer.shadowOpacity=opacity;
    self.layer.masksToBounds=NO;
}

-(void)hideTargetView
{
    
    if ([self isKindOfClass:[XYCoverView class]]) {
        XYCoverView *cover=(XYCoverView*)self;
        [UIView animateWithDuration:0.25 animations:^{
            cover.targetView.y=self.height;
            self.backgroundColor = RGBA(0, 0, 0, 0);
            
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        if (self.superview&&[self.superview isKindOfClass:[XYCoverView class]]) {
            [self.superview hideTargetView];
        }else{
            DLog(@"不是coverView 而且父类也不是coverView");
            [UIView animateWithDuration:.25 animations:^{
                self.y=SCREEN_H;
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
    
}
@end
