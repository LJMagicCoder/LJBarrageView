# LJBarrageView是一款支持长连接不断传入数据的弹幕。

对该轮子有什么不满或者建议可以在[简书](https://www.jianshu.com/p/975946afc03d)的评论区里留言给我。

支持 pod 'LJBarrageView'

其中在UIView+LJBarrageTool.h里提供了简单集成的方法。

    /*!
    @brief 初始化默认参数弹幕视图
    @result 返回弹幕视图
    @discussion 初始化弹幕视图(默认开启弹幕视图)(默认为按时间显示，显示时长为5s)
    @param frame 弹幕视图的位置
    */
    + (LJBarrageView *)lj_creatNormalWithFrame:(CGRect)frame;

    /*!
    @brief 初始化弹幕视图
    @result 返回弹幕视图
    @discussion 初始化弹幕视图(默认开启弹幕视图)
    @param frame 弹幕视图的位置
    @param barrageShowStyle 弹幕显示风格
    @param styleParameter 弹幕相应风格的参数
    @param barrageRow 弹幕行数(0为不分行)
    @param barrageHeightType 弹幕行高度样式(默认正常)
    @param barrageEnterInterval 弹幕进入间隔时间
    @param barrageShowMax 弹幕最大显示个数
    */
    + (LJBarrageView *)lj_creatBarrageViewWithFrame:(CGRect)frame 
                                   BarrageShowStyle:(LJBarrageShowStyleType)barrageShowStyle
                                     StyleParameter:(CGFloat)styleParameter
                                         BarrageRow:(NSInteger)barrageRow
                                  barrageHeightType:(BarrageHeightType)barrageHeightType
                               barrageEnterInterval:(CGFloat)barrageEnterInterval
                                     barrageShowMax:(NSInteger)barrageShowMax;

    @end

    @interface LJBarrageView (LJBarrageTool)

    /*!@brief 弹幕文字(可以传入NSString/NSMutableAttributedString) */
    - (void)lj_addBarrageText:(id)barrageText;

    /*!@brief 弹幕文字及富文本组(可以传入NSString/NSMutableAttributedString混合组) */
    - (void)lj_addBarrageTexts:(NSArray *)barrageTexts;

    /*!
    @brief 弹幕样式
    @param barrageHeight 弹幕高度
    @param barrageBackgroundColor 弹幕背景
    @param barrageTextAlignment 弹幕文本对齐方式
    @param barrageFont 弹幕字体大小
     */
    - (void)lj_modificationBarrageStyleWithBarrageHeight:(CGFloat)barrageHeight
                                  barrageBackgroundColor:(UIColor *)barrageBackgroundColor
                                    barrageTextAlignment:(NSTextAlignment)barrageTextAlignment
                                             barrageFont:(UIFont *)barrageFont;

    @end


通过LJBarrageView.h里的参数进行详细的设置，也可以通过协议对样式进行重构。

