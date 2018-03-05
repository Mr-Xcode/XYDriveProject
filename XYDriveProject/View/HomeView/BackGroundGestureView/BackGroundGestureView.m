//
//  BackGroundGestureView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/2/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "BackGroundGestureView.h"

@implementation BackGroundGestureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.45];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]init];
        [pan addTarget:self action:@selector(hide2:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}
-(void)hide
{
    if (self.endBlock) {
        self.endBlock();
    }
    self.endBlock = nil;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)hide2:(UIPanGestureRecognizer*)pan
{
    if (pan.state==UIGestureRecognizerStateBegan) {
        CGFloat v=[pan velocityInView:pan.view].x;
        DLog(@"v----------------------::::%lf",v);
        if (v<-500) {
            [self hide];
            DLog(@"速度较大隐藏");
        }
    }
    else if (pan.state==UIGestureRecognizerStateChanged) {
        CGFloat x=[ pan translationInView:pan.view].x;
        [pan setTranslation:CGPointZero inView:pan.view];
        //        DLog(@"x---------移动中-----------------:%lf",x);
        [self changePersonViewWithX:x];
    }else if (pan.state==UIGestureRecognizerStateEnded||pan.state==UIGestureRecognizerStateCancelled) {
        CGFloat x=_personView.x;
        DLog(@"x--------------------------:%lf",x);
        if (x<-_personView.width/2) {
            [self hide];
            DLog(@"结束隐藏");
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                _personView.x=0;
            }];
        }
    }
}

-(void)changePersonViewWithX:(CGFloat)x
{
    CGFloat width=self.personView.width;
    CGFloat endX=_personView.x+x;
    if (endX>0) {
        endX=0;
    }
    if (endX<=-width) {
        endX=-width;
    }
    _personView.x=endX;
    
    CGFloat alpha=(endX+_personView.width)/_personView.width;
    self.alpha=alpha;
    
}

@end
