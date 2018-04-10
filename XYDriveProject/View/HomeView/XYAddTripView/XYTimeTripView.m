//
//  XYTimeTripView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/1.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYTimeTripView.h"
#import "XYDateSlecteView.h"
#import "TimeTableViewCell.h"

@interface XYTimeTripView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIView *gridView;
@property (strong, nonatomic) UIView *bcView;
@property (nonatomic, assign) CGFloat pressViewWidth;
@property (nonatomic, strong) NSMutableArray * addViews;
@property (nonatomic, weak) UIView * moveView;
@property (nonatomic, strong)XYDateSlecteView * dateSelView;
@property (nonatomic, strong)UIView * topTapView;
@property (nonatomic, strong)FloatingView * adView;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic,strong) NSArray * markers;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, weak)UILabel * headTimeLable;

@property (nonatomic, strong)UITableView * timeTableView;
/**
 *  保存可见的视图
 */
@property (nonatomic, strong) NSMutableArray *visibleImageViews;

/**
 *  保存可重用的
 */
@property (nonatomic, strong) NSMutableArray *reusedImageViews;

/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *scrollView;

/**
 *  所有的图片名
 */
@property (nonatomic, strong) NSArray *imageNames;
@end

@implementation XYTimeTripView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame markers:(NSArray *)array{
    self =[super initWithFrame:frame];
    if (self) {
        self.markers =array;
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.addViews =[NSMutableArray array];
    [self addSubview:self.dateSelView];
    [self addSubview:self.topTapView];
//    [self setupScrollView];
    self.date =self.dateSelView.calendarManager.date;
    [self addSubview:self.timeTableView];
    
//    UIScrollView * scrollV =[[UIScrollView alloc]init];
//    scrollV.frame =CGRectMake(0, CGRectGetMaxY(self.dateSelView.frame), SCREEN_W, self.bounds.size.height-self.dateSelView.bounds.size.height-TOPGestureViewH);
//    scrollV.bounces =NO;
//    scrollV.backgroundColor =[UIColor whiteColor];
//    [self addSubview:scrollV];
//    self.scrollView =scrollV;
//    [self addGesture];
//
//    UIView * temp =[self getGridView];
//    [self.scrollView addSubview:temp];
//    self.scrollView.contentSize =CGSizeMake(SCREEN_W, temp.height+15);
//
//    NSInteger hourPoint =3;
//    NSInteger time =78;//假设为分钟
//
//
//    [self pressAddView:CGPointMake(LEFTMargin, hourPoint * HOURHEIGHT) height:time];
    
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
        WeakSelf;
        self.dateSelView =[[XYDateSlecteView alloc]initWithFrame:CGRectMake(0,TOPGestureViewH, SCREEN_W, 135)];
//        CGFloat r = RND_COLOR;
//        CGFloat g = RND_COLOR;
//        CGFloat b = RND_COLOR;
//        self.dateSelView.backgroundColor =[UIColor colorWithRed:r green:g blue:b alpha:1];
        self.dateSelView.backgroundColor =[UIColor whiteColor];
        self.dateSelView.seleDateBlock = ^(NSDate *date,NSString * dateStr) {
//            weakSelf.date =date;
            weakSelf.headTimeLable.text =dateStr;
        };
    }
    return _dateSelView;
}
- (FloatingView *)adView{
    if (!_adView) {
        self.adView =[[FloatingView alloc]init];
    }
    return _adView;
}
#pragma mark - <UISCrollView>
// 添加UIScrollView
- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateSelView.frame), SCREEN_W, self.bounds.size.height-self.dateSelView.bounds.size.height-TOPGestureViewH)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor =[UIColor whiteColor];
    scrollView.bounces =NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;

    UIView * temp =[self getGridView];
    [self.scrollView addSubview:temp];
    scrollView.contentSize = CGSizeMake(SCREEN_W*1, temp.frame.size.height+15);
}

- (UIView *)getGridView{
    UIView * view =[[UIView alloc]init];
    CGFloat totalHeight =0;
    for (int ii =0; ii<24; ii++) {
        //横线
        UIView * line =[[UIView alloc]init];
        line.frame =CGRectMake(50, 15+HOURHEIGHT*ii, SCREEN_W-50, .5);
        line.backgroundColor =[UIColor grayColor];
        [view addSubview:line];
        
        //时间lable
        UILabel * timeL =[[UILabel alloc]init];
        timeL.text =[NSString stringWithFormat:@"%d:00",ii];
        timeL.frame =CGRectMake(10, line.centerY, 50, 20);
        timeL.size = [timeL.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        timeL.font =TextFont_12;
        [view addSubview:timeL];
        line.frame = CGRectMake(CGRectGetMaxX(timeL.frame)+5, 15+HOURHEIGHT*ii, SCREEN_W-timeL.size.width -10 -5 , .5);
        timeL.centerY =line.centerY;
        totalHeight +=HOURHEIGHT;
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
    
}
- (void)pressAddView:(CGPoint)point height:(CGFloat)height{
    
    UIView * tempView =[[UIView alloc]init];
    tempView.frame =CGRectMake(LEFTMargin, 15+point.y, SCREEN_W - LEFTMargin, height);
    tempView.backgroundColor =[UIColor blueColor];
    [self.scrollView addSubview:tempView];
    self.moveView =tempView;
    [self.addViews addObject:tempView];
    
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =tempView.bounds;
    [button addTarget:self action:@selector(jumpNextDay) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:button];
    
    
    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
    [tempView addGestureRecognizer:longPressGest];
    //拖拽
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    [self.moveView addGestureRecognizer:panGest];
    
}
-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    
    NSLog(@"%ld",longPressGest.state);
    if (longPressGest.state==UIGestureRecognizerStateBegan) {
        NSLog(@"长按手势开启");
        CGPoint longPressPoint =[longPressGest locationInView:self.scrollView];
        if (!ICIsObjectEmpty(self.addViews)) {
            for (UIView * view in self.addViews) {
                if (CGRectContainsPoint(view.frame, longPressPoint)) {
                    //如果遍历到长按的点在已添加的view里面，则不再创建
                    DLog(@"和上次点击的在同一个区域，则不再创建");
                    return;
                }
            }
            [self pressAddView:longPressPoint height:HOURHEIGHT];
        }else{
            [self pressAddView:longPressPoint height:HOURHEIGHT];
        }
    }else if (longPressGest.state==UIGestureRecognizerStateChanged){
        
    }
    else {
        NSLog(@"长按手势结束");
        
    }
    
}
-(void)panView:(UIPanGestureRecognizer *)recognizer{
    
    UIView * panView =recognizer.view;
    
    //拖拽的距离(距离是一个累加)
    CGPoint trans = [recognizer translationInView:panView];
//    NSLog(@"%@",NSStringFromCGPoint(trans));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame =panView.frame;
        frame.origin.x +=trans.x;
        frame.origin.y +=trans.y;
        panView.frame =frame;
        
    }else if (recognizer.state ==UIGestureRecognizerStateEnded || recognizer.state ==UIGestureRecognizerStateCancelled){
        CGFloat x=panView.origin.x;
        if (x <=LEFTMargin) {
            x =LEFTMargin;
        }else if (x >SCREEN_W -panView.frame.size.width){
            x =SCREEN_W -panView.frame.size.width;
        }
        
        CGFloat y =panView.origin.y;
        if (y <=15) {
            y =15;
        }else if (y >self.scrollView.contentSize.height -panView.frame.size.height){
            y =self.scrollView.contentSize.height -panView.frame.size.height;
        }
        [UIView animateWithDuration:0.5 animations:^{
            panView.frame =CGRectMake(x, y, panView.frame.size.width, panView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }

    //清除累加的距离
    [recognizer setTranslation:CGPointZero inView:self.scrollView];
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
- (void)jumpNextDay{
    [self.dateSelView toNextDay];
}

/**
 *  多个手势同时存在的代理,不能忘记
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}
#pragma mark 创建cell的快照
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    // 用cell的图层生成UIImage，方便一会显示
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 自定义这个快照的样子（下面的一些参数可以自己随意设置）
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}
#pragma mark - <TableView>
- (UITableView *)timeTableView{
    if (!_timeTableView) {
        self.timeTableView =[[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        self.timeTableView.frame= CGRectMake(0,CGRectGetMaxY(self.dateSelView.frame), SCREEN_W, self.bounds.size.height-self.dateSelView.bounds.size.height-TOPGestureViewH);
        self.timeTableView.delegate =self;
        self.timeTableView.dataSource =self;
        self.timeTableView.estimatedRowHeight = 60;
        self.timeTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [self.timeTableView registerNib:[UINib nibWithNibName:@"TimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.timeTableView.estimatedSectionFooterHeight=0;
        self.timeTableView.estimatedSectionHeaderHeight=0;
    }
    return _timeTableView;
}
#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier =@"cell";
    TimeTableViewCell *cell=(TimeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[TimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 37;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //    if (section==(self.dataList.count-1)) {
    //        return 10;
    //    }
    return CGFLOAT_MIN;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        
        UIView * view =[[UIView alloc]init];
        view.frame =CGRectMake(0, 0, self.bounds.size.width, 37);
        view.backgroundColor =[UIColor whiteColor];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:self.date];
        
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 35)];
        
        label1.font =TextFont_14;
        label1.textColor =[UIColor whiteColor];
        label1.text=[NSString stringWithFormat:@"    %@",strDate];
        
        label1.backgroundColor=[UIColor blackColor];
        self.headTimeLable =label1;
        [view addSubview:label1];
        
        return view ;
    }
    return nil;
    
}
@end
