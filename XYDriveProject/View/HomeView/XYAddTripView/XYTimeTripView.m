//
//  XYTimeTripView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYTimeTripView.h"
#import "XYDateSlecteView.h"

@interface XYTimeTripView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UIView *gridView;
@property (strong, nonatomic) UIView *bcView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat pressViewWidth;
@property (nonatomic, assign) CGPoint bPoint;
@property (nonatomic, assign) CGRect bRect;
@property (nonatomic, weak) UIView * moveView;
@property (nonatomic, strong)XYDateSlecteView * dateSelView;
@property (nonatomic, strong)UIView * topTapView;
@end

@implementation XYTimeTripView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self addSubview:self.dateSelView];
    [self addSubview:self.topTapView];
    UIScrollView * scrollV =[[UIScrollView alloc]init];
    scrollV.frame =CGRectMake(0, CGRectGetMaxY(self.dateSelView.frame), SCREEN_W, self.bounds.size.height-self.dateSelView.bounds.size.height-TOPGestureViewH);
//    scrollV.pagingEnabled=YES;
    scrollV.bounces =NO;
    scrollV.backgroundColor =[UIColor whiteColor];
    [self addSubview:scrollV];
    self.scrollView =scrollV;
    [self addGesture];
    
    UIView * temp =[self getGridView];
    [self.scrollView addSubview:temp];
    self.scrollView.contentSize =CGSizeMake(SCREEN_W, temp.height+30);
    
}
- (UIView *)topTapView{
    if (!_topTapView) {
        self.topTapView =[[UIView alloc]init];
        self.topTapView.frame =CGRectMake(0, 0, SCREEN_W, TOPGestureViewH);
        self.topTapView.backgroundColor =[UIColor redColor];
        UISwipeGestureRecognizer * recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [self.topTapView addGestureRecognizer:recognizerUp];
        
        UISwipeGestureRecognizer * recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self.topTapView addGestureRecognizer:recognizerDown];
        
        //单击的手势
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        tapRecognize.numberOfTapsRequired = 1;
        tapRecognize.delegate = self;
        [tapRecognize setEnabled :YES];
        [tapRecognize delaysTouchesBegan];
        [tapRecognize cancelsTouchesInView];
        
        [self.topTapView addGestureRecognizer:tapRecognize];
    }
    return _topTapView;
}
- (XYDateSlecteView *)dateSelView{
    if (!_dateSelView) {
        self.dateSelView =[[XYDateSlecteView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_W, 135)];
//        CGFloat r = RND_COLOR;
//        CGFloat g = RND_COLOR;
//        CGFloat b = RND_COLOR;
//        self.dateSelView.backgroundColor =[UIColor colorWithRed:r green:g blue:b alpha:1];
        self.dateSelView.backgroundColor =[UIColor whiteColor];
    }
    return _dateSelView;
}
- (UIView *)getGridView{
    UIView * view =[[UIView alloc]init];
    CGFloat totalHeight =0;
    for (int ii =0; ii<24; ii++) {
        //横线
        UIView * line =[[UIView alloc]init];
        line.frame =CGRectMake(50, 15+60*ii, SCREEN_W-50, .5);
        line.backgroundColor =[UIColor grayColor];
        [view addSubview:line];
        
        //时间lable
        UILabel * timeL =[[UILabel alloc]init];
        timeL.text =[NSString stringWithFormat:@"%d:00",ii];
        timeL.frame =CGRectMake(10, line.centerY, 50, 20);
        timeL.size = [timeL.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        timeL.font =TextFont_12;
        [view addSubview:timeL];
        line.frame = CGRectMake(CGRectGetMaxX(timeL.frame)+5, 15+60*ii, SCREEN_W-timeL.size.width -10 -5 , .5);
        timeL.centerY =line.centerY;
        totalHeight +=60;
    }
    view.height =totalHeight;
    return view;
}
- (void)addGesture{
    //初始化一个长按手势
    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
    longPressGest.delegate =self;
    //长按等待时间
    longPressGest.minimumPressDuration = 1;
    
    //长按时候,手指头可以移动的距离
    longPressGest.allowableMovement = 30;
    [self.scrollView addGestureRecognizer:longPressGest];
    
//    //拖拽
//    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
//    [self.scrollView addGestureRecognizer:panGest];

    
}
- (void)pressView:(CGPoint)point{
    UIView * tempView =[[UIView alloc]init];
    tempView.frame =CGRectMake(45, point.y, SCREEN_W - 45, 60);
    tempView.backgroundColor =[UIColor blueColor];
    [self.scrollView addSubview:tempView];
    self.moveView =tempView;
    //拖拽
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    [self.moveView addGestureRecognizer:panGest];
    
}
-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    
    NSLog(@"%ld",longPressGest.state);
    if (longPressGest.state==UIGestureRecognizerStateBegan) {
        NSLog(@"长按手势开启");
        CGPoint longPressPoint =[longPressGest locationInView:self.scrollView];
        BOOL isZai =CGRectContainsPoint(self.moveView.frame, longPressPoint);
        if (isZai) {
            DLog(@"和上次点击的在同一个区域，则不再创建");
            return;
        }
        [self pressView:longPressPoint];
        self.bPoint =longPressPoint;
    } else {
        NSLog(@"长按手势结束");
        
    }
    
}
-(void)panView:(UIPanGestureRecognizer *)recognizer{
    
//    // Figure out where the user is trying to drag the view.
//    CGPoint translation = [recognizer translationInView:self];
//    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
//                                    recognizer.view.center.y + translation.y);//    限制屏幕范围：
//    newCenter.y = MAX(recognizer.view.frame.size.height/2, newCenter.y);
//    newCenter.y = MIN(self.frame.size.height - recognizer.view.frame.size.height/2,  newCenter.y);
//    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
//    newCenter.x = MIN(self.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
//    recognizer.view.center = newCenter;
//    [recognizer setTranslation:CGPointZero inView:self];
    
    
//    //拖拽的距离(距离是一个累加)
//    CGPoint trans = [panGest translationInView:panGest.view];
//    NSLog(@"%@",NSStringFromCGPoint(trans));
//
//    //设置图片移动
//    CGPoint center =  self.moveView.center;
//    center.x += trans.x;
//    center.y += trans.y;
//    self.moveView.center = center;
//    self.moveView.x =45;
//
//    //清除累加的距离
//    [panGest setTranslation:CGPointZero inView:panGest.view];
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        if (self.upBlcok) {
            self.upBlcok(NO);
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.frame =CGRectMake(0, CGRectGetMaxY(self.superview.frame)-TOPGestureViewH-64, SCREEN_W, self.bounds.size.height);
        }];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        if (self.upBlcok) {
            self.upBlcok(YES);
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.frame =CGRectMake(0, CGRectGetMaxY(self.superview.frame)-TIMEVIEWHEIGHT-64, SCREEN_W, self.bounds.size.height);
        }];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
    }
}
#pragma UIGestureRecognizer Handles
-(void) handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"---单击手势-------");
    if (self.upBlcok) {
        self.upBlcok(YES);
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame =CGRectMake(0, CGRectGetMaxY(self.superview.frame)-TIMEVIEWHEIGHT-64, SCREEN_W, self.bounds.size.height);
    }];
}

/**
 *  多个手势同时存在的代理,不能忘记
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}
@end
