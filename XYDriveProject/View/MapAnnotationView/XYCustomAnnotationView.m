//
//  XYCustomAnnotationView.m
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/5.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYCustomAnnotationView.h"
#import "XYCustomAnnotation.h"
#define kCalloutWidth       240.0
#define kCalloutHeight      70.0
@interface XYCustomAnnotationView ()

@property (nonatomic, strong, readwrite) XYCustomCalloutView *calloutView;

@end

@implementation XYCustomAnnotationView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
        if (!inside )
        {
            inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
        }
    return inside;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
//    if (self.annotation) {
//        XYCustomAnnotation * xyAnnotation =(XYCustomAnnotation *)self.annotation;
//        if (xyAnnotation.anType ==isDefault) {
//            self.canShowCallout =YES;
//            [super setSelected:selected animated:animated];
//            return;
//        }
//    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[XYCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.image = [UIImage imageNamed:@"building"];
        self.calloutView.title = self.model.title;
        self.calloutView.subtitle = self.model.attributes.address;
        self.calloutView.model =self.model;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
