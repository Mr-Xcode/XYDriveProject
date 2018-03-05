//
//  XYCoverView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYCoverView.h"

@interface XYCoverView ()

@property (nonatomic, copy)XYCoverViewClickBackGroungHideBlcok  clickBackGroungHideBlcok;

@end
@implementation XYCoverView
- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =RGBA(0, 0, 0, 0);
    }
    return self;
}

+(void)showTargetView:(UIView *)targetView CanHide:(BOOL)canhide ClickBackGroundHideBlock:(XYCoverViewClickBackGroungHideBlcok)block{
    UIView *view=[[[UIApplication sharedApplication] windows]firstObject] ;
    XYCoverView *cover= [[XYCoverView alloc]init];
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
    
    if (canhide) {
        cover.clickBackGroungHideBlcok=block;
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
+(void)showTargetView:(UIView *)targetView{
    [self showTargetView:targetView CanHide:NO ClickBackGroundHideBlock:nil];
}
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
            if (self.clickBackGroungHideBlcok) {
                self.clickBackGroungHideBlcok();
            }
            [self hideTargetView];
        }
    }
}

@end
