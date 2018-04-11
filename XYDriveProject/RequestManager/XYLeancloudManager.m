//
//  XYHttpManager.m
//  XYDriveProject
//
//  Created by gaoshuhuan on 2018/3/27.
//  Copyright © 2018年 shuhuan. All rights reserved.
//

#import "XYLeancloudManager.h"

@implementation XYLeancloudManager
#pragma mark - <查询获取对象>
+ (void)requestGetObject:(NSString *)className objId:(NSString *)objId Success:(RequestSuccesslock)successBlock Failure:(RequestFailure)failureBlock{
    AVQuery *query = [AVQuery queryWithClassName:className];
    [UILoading showMessage:@"加载中……"];
    [query getObjectInBackgroundWithId:objId block:^(AVObject *object, NSError *error) {
        [UILoading hide];
        // object 就是 id 为 558e20cbe4b060308e3eb36c 的 Todo 对象实例
        if (!ICIsObjectEmpty(error)) {
            if (successBlock) {
                successBlock(object);
            }
        }else{
            if (failureBlock) {
                failureBlock(error);
            }
        }
    }];
}
#pragma mark - <添加构建对象>
+ (void)requestAddObjectClassName:(NSString *)className parames:(id)parames Success:(RequestSuccesslock)successBlock Failure:(RequestFailure)failureBlock{
    [UILoading showMessage:@"加载中……"];
    NSMutableDictionary * paramsDic =[NSMutableDictionary dictionaryWithDictionary:parames];
    AVObject * todo = [[AVObject alloc] initWithClassName:className];// 构建对象
    NSArray *keys = [paramsDic allKeys];
    for (NSString * key in keys) {
        [todo setObject:paramsDic[@"key"] forKey:key];
    }
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [UILoading hide];
        if (succeeded) {
            // 存储成功
            if (successBlock) {
                successBlock(todo);
            }
        }else{
            DLog(@"提交失败！");
            if (failureBlock) {
                failureBlock(error);
            }
        }
    }];
}

@end
