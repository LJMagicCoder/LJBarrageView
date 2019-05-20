//
//  UILabel+LJBarrageBind.h
//  BarrageDemo
//
//  Created by 宋立军 on 2019/5/21.
//  Copyright © 2019年 宋立军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LJBarrageBind)

//传入的弹幕文字
@property (nonatomic, copy) id lj_barrageText;

//绑定内容
@property (nonatomic, strong) id lj_barrageContent;

@end
