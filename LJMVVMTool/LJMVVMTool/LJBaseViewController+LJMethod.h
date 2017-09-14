//
//  LJBaseViewController+LJMethod.h
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/6.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LJBaseViewController.h"

@interface LJBaseViewController (LJMethod)

-(void)holdObject:(LJBaseViewModel *)vm;

@end

@interface LJBaseViewModel (LJMethod)

- (LJBaseViewController *)setHoldObject;

@end
