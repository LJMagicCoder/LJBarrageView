//
//  UIView+LJBarrageTool.m
//  BarrageDemo
//
//  Created by 宋立军 on 2017/7/28.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "UIView+LJBarrageTool.h"

@implementation UIView (LJBarrageTool)

+ (LJBarrageView *)lj_creatNormalWithFrame:(CGRect)frame {
    
    LJBarrageView *barrageView = [[LJBarrageView alloc] initWithFrame:frame];
    barrageView.barrageShowStyle = LJBarrageShowStyleTypeShowTime;
    barrageView.styleParameter = 5;
    
    [barrageView open];
    
    return barrageView;
}

+ (LJBarrageView *)lj_creatBarrageViewWithFrame:(CGRect)frame
                               BarrageShowStyle:(LJBarrageShowStyleType)barrageShowStyle
                                 StyleParameter:(CGFloat)styleParameter
                                     BarrageRow:(NSInteger)barrageRow
                              barrageHeightType:(BarrageHeightType)barrageHeightType
                           barrageEnterInterval:(CGFloat)barrageEnterInterval
                                 barrageShowMax:(NSInteger)barrageShowMax
{
    
    LJBarrageView *barrageView = [[LJBarrageView alloc] initWithFrame:frame];
    
    barrageView.barrageShowStyle = barrageShowStyle;
    barrageView.styleParameter = styleParameter;
    barrageView.barrageRow = barrageRow;
    barrageView.barrageHeightType = barrageHeightType;
    barrageView.barrageEnterInterval = barrageEnterInterval;
    barrageView.barrageShowMax = barrageShowMax;
    
    [barrageView open];

    return barrageView;
}

@end

@implementation LJBarrageView (LJBarrageTool)

//弹幕文字
- (void)lj_addBarrageText:(id)barrageText {
    self.barrageText = barrageText;
}

//弹幕文字及富文本组
- (void)lj_addBarrageTexts:(NSArray *)barrageTexts {
    self.barrageTexts = barrageTexts;
}

//弹幕样式
- (void)lj_modificationBarrageStyleWithBarrageHeight:(CGFloat)barrageHeight
                              barrageBackgroundColor:(UIColor *)barrageBackgroundColor
                                barrageTextAlignment:(NSTextAlignment)barrageTextAlignment
                                         barrageFont:(UIFont *)barrageFont
{
    self.barrageStyle.barrageHeight = barrageHeight;
    self.barrageStyle.barrageBackgroundColor = barrageBackgroundColor;
    self.barrageStyle.barrageTextAlignment = barrageTextAlignment;
    self.barrageStyle.barrageFont = barrageFont;
}

@end

