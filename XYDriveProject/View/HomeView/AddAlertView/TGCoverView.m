
//
//  KCCoverView.m
//  kuaichengwuliu
//
//  Created by 刘松 on 16/4/30.
//  Copyright © 2016年 kuaicheng. All rights reserved.
//

#import "TGCoverView.h"


@interface TGCoverView ()


@property (nonatomic,copy)TGCoverViewClickBackgroundHideBlock clickBackgroundHideBlock ;

@end

@implementation TGCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.225];
        self.backgroundColor = RGBA(0, 0, 0, 0);
    }
    return self;
}
+(void)showTargetView:(UIView*)targetView
{
    [self showTargetView:targetView canHide:YES clickBackgroundHideBlock:nil];
}
//显示
+(void)showTargetView:(UIView*)targetView canHide:(BOOL)canHide clickBackgroundHideBlock:(TGCoverViewClickBackgroundHideBlock)clickBackgroundHideBlock
{
    
//    UIView *view=[[[UIApplication sharedApplication] windows]firstObject];
    UIView *view=[UIApplication sharedApplication].keyWindow.rootViewController.view;
    TGCoverView *cover= [[TGCoverView alloc]init];
    cover.frame=view.bounds;
    cover.targetView=targetView;
    targetView.x=0;
    targetView.width=cover.width;
    targetView.y=cover.height-targetView.height;
    [cover addSubview:targetView];
    [view addSubview:cover];
    targetView.y=cover.height;
    
    if (IS_iPhoneX) {
        UIView *XView=[[UIView alloc]init];
        XView.backgroundColor=[UIColor whiteColor];
        XView.frame=CGRectMake(0, targetView.height, SCREEN_W , 34);
        [targetView addSubview:XView];
    }
    
    if (canHide) {
        cover.clickBackgroundHideBlock=clickBackgroundHideBlock;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:cover action:@selector(handleGesture:)];
        [cover addGestureRecognizer:tap];
    }
    [UIView animateWithDuration:0.25 animations:^{
        targetView.y=cover.height-targetView.height;
        if (IS_iPhoneX) {
            targetView.y=cover.height-targetView.height-34;
        }else{
            targetView.y=cover.height-targetView.height;
        }
    }];
    
}

///// 消失
//-(void)hideTargetView
//{
//
//    [UIView animateWithDuration:0.25 animations:^{
//        self.targetView.y=self.height;
//        self.alpha = 0;
//
//    }completion:^(BOOL finished) {
//        [self removeFromSuperview];
//
//
//    }];
//}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
//    self.alpha=0.2;
    self.backgroundColor = RGBA(0, 0, 0, 0.2);
}
-(void)didMoveToWindow
{
    [UIView animateWithDuration:0.1 animations:^{
//        self.alpha = 1;
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
    }];
    
}
-(void)handleGesture:(UIGestureRecognizer*)gesture
{
    if (gesture.state==UIGestureRecognizerStateEnded) {
        
        if ([gesture locationInView:self].y<self.targetView.y) {
            if (self.clickBackgroundHideBlock) {
                self.clickBackgroundHideBlock();
            }
            [self hideTargetView];
        }
    }
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//    [self dismiss];
//}
-(void)dealloc
{
    DLog(@"%s",__func__);
}

@end
