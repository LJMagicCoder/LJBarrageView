//
//  LJBarrageView.h
//  BarrageDemo
//
//  Created by 宋立军 on 2017/7/28.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LJBarrageShowStyleType) {
    LJBarrageShowStyleTypeShowTime,             //按时间显示(一共显示多长时间)
    LJBarrageShowStyleTypeVelocity,             //按速度显示(像素/s)
    LJBarrageShowStyleTypeVelocityScreenThan    //按速度与屏幕比例显示(1屏幕/s)
};

typedef NS_ENUM(NSUInteger,BarrageHeightType) {
    BarrageHeightTypeNormal,                    //正常按行高进入
    BarrageHeightTypeRandom                     //随机高度进入
};

@protocol LJBarrageViewDelegate <NSObject>

@optional   

//重构弹幕样式
- (UILabel *)refactoringLabel:(UILabel *)label text:(id)text;

@end

@interface BarrageStyle : NSObject

//弹幕高度
@property (nonatomic, assign) CGFloat barrageHeight;

//弹幕背景
@property (nonatomic, strong) UIColor *barrageBackgroundColor;

//弹幕文本对齐方式
@property(nonatomic) NSTextAlignment barrageTextAlignment;

//弹幕字体大小
@property (nonatomic, strong) UIFont *barrageFont;

@end

@interface LJBarrageView : UIView

//弹幕协议
@property (nonatomic, weak) id <LJBarrageViewDelegate> delegate;

//弹幕显示风格
@property (nonatomic, assign) LJBarrageShowStyleType barrageShowStyle;

//弹幕相应风格的参数
@property (nonatomic, assign) CGFloat styleParameter;

//弹幕行数(0为不分行)
@property (nonatomic, assign) NSInteger barrageRow;

//弹幕行高度
@property (nonatomic, assign) NSInteger barrageRowHeight;

//弹幕行高度样式(默认正常)
@property (nonatomic, assign) BarrageHeightType barrageHeightType;

//弹幕进入间隔时间
@property (nonatomic, assign) CGFloat barrageEnterInterval;

//弹幕最大显示个数
@property (nonatomic, assign) NSInteger barrageShowMax;

/* - 弹幕样式 - */
@property (nonatomic, strong) BarrageStyle *barrageStyle;

/* - 弹幕输入 - */

//弹幕文字(可以传入NSString/NSMutableAttributedString)
@property (nonatomic, copy) id barrageText;

//弹幕文字及富文本组(可以传入NSString/NSMutableAttributedString混合组)
@property (nonatomic, copy) NSArray *barrageTexts;

/*!@brief 打开弹幕 */
- (void)open;

/*!@brief 关闭弹幕 */
- (void)shut;

@end
