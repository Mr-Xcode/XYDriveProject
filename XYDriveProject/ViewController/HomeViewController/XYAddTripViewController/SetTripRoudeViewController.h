//
//  SetTripRoudeViewController.h
//  XYDriveProject
//
//  Created by ShuHuan on 2018/3/8.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotatationModel.h"

@interface SetTripRoudeViewController : XYBaseViewController
//@property (nonatomic, strong) AnnotatationModel * model;
@property (nonatomic, strong) Markers * model;
@property (nonatomic, copy) NSString * objId;
@property (nonatomic, strong)AVObject * tripObject;

@end
