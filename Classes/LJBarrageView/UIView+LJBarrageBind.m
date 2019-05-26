//
//  UIView+LJBarrageBind.m
//  BarrageDemo
//
//  Created by 宋立军 on 2019/5/26.
//  Copyright © 2019年 宋立军. All rights reserved.
//

#import "UIView+LJBarrageBind.h"
#import <objc/runtime.h>

@implementation UIView (LJBarrageBind)

- (id)lj_barrageText {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLj_barrageText:(id)lj_barrageText {
    objc_setAssociatedObject(self, @selector(lj_barrageText), lj_barrageText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)lj_barrageContent {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLj_barrageContent:(id)lj_barrageContent {
    objc_setAssociatedObject(self, @selector(lj_barrageContent), lj_barrageContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)lj_barrageLabel {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLj_barrageLabel:(id)lj_barrageLabel {
    objc_setAssociatedObject(self, @selector(lj_barrageLabel), lj_barrageLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
