//
//  LJBarrageView.m
//  BarrageDemo
//
//  Created by 宋立军 on 2017/7/28.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LJBarrageView.h"
#import "UIView+LJBarrageBind.h"

typedef NS_ENUM(NSUInteger,BarrageShowType) {
    BarrageTypeStop,
    BarrageTypeStart
};

typedef NS_ENUM(NSUInteger,BarrageSwitchType) {
    BarrageTypeShut,
    BarrageTypeOpen
};

//默认参数
static const int LJBarrageRow = 2;
static const int LJBarrageRowHeight = 50;
static const BarrageHeightType LJBarrageHeightType = BarrageHeightTypeNormal;
static const int LJBarrageEnterInterval = 1;
static const int LJBarrageShowMax = 20;

static const int LJBarrageHeight = 49;
static const NSTextAlignment LJBarrageTextAlignment = NSTextAlignmentCenter;

static const BarrageShowType LJBarrageShowType = BarrageTypeStop;
static const BarrageSwitchType LJBarrageSwitchType = BarrageTypeShut;

@implementation BarrageStyle

@end

@interface LJBarrageView ()

@property (nonatomic, strong) NSMutableSet *reusePool;      //复用池

@property (nonatomic, strong) NSMutableArray *texts;

@property (nonatomic, assign) BarrageShowType barrageShowType;

@property (nonatomic, assign) BarrageSwitchType barrageSwitchType;

@property (nonatomic, strong) NSMutableArray *showRows;

@property (nonatomic, strong) dispatch_semaphore_t barrageMaxEnterSemaphore;

@property (nonatomic, strong) dispatch_queue_t barrageQueue;

@property (nonatomic, assign) NSInteger nextNum;

@end

@implementation LJBarrageView

- (dispatch_semaphore_t)barrageMaxEnterSemaphore {
    if (!_barrageMaxEnterSemaphore) {
        _barrageMaxEnterSemaphore = dispatch_semaphore_create(self.barrageShowMax);
    }
    return _barrageMaxEnterSemaphore;
}

- (dispatch_queue_t)barrageQueue {
    if (!_barrageQueue) {
        _barrageQueue = dispatch_queue_create("com.dispatch.ljbarrage", DISPATCH_QUEUE_SERIAL);
    }
    return _barrageQueue;
}

- (NSMutableArray *)texts {
    if (!_texts) {
        _texts = [NSMutableArray array];
    }
    return _texts;
}

- (NSMutableSet *)reusePool {
    if (!_reusePool) {
        _reusePool = [NSMutableSet set];
    }
    return _reusePool;
}

- (BarrageStyle *)barrageStyle {
    if (!_barrageStyle) {
        _barrageStyle = [[BarrageStyle alloc] init];
    }
    return _barrageStyle;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    
    self.layer.masksToBounds = YES;
    
    //默认参数
    self.barrageRow = LJBarrageRow;
    self.barrageRowHeight = LJBarrageRowHeight;
    self.barrageHeightType = LJBarrageHeightType;
    self.barrageEnterInterval = LJBarrageEnterInterval;
    self.barrageShowMax = LJBarrageShowMax;
    
    self.barrageStyle.barrageHeight = LJBarrageHeight;
    self.barrageStyle.barrageBackgroundColor = [UIColor whiteColor];
    self.barrageStyle.barrageTextAlignment = LJBarrageTextAlignment;
    self.barrageStyle.barrageFont = [UIFont systemFontOfSize:17];
    
    self.barrageShowType = LJBarrageShowType;
    self.barrageSwitchType = LJBarrageSwitchType;
}

- (void)open {
    self.barrageSwitchType = BarrageTypeOpen;
    self.hidden = NO;
}

- (void)shut {
    self.barrageSwitchType = BarrageTypeShut;
    self.texts = nil;
    self.hidden = YES;
}

- (void)showBarrageWithRow:(NSInteger)row text:(id)text enter:(void (^)(NSInteger row))enter finishShow:(void (^)(void))finishShow {
    
    UIView *view = [self getReuseBarrageLabel];
    view.lj_barrageText = text;
    
    if ([text isKindOfClass:[NSMutableAttributedString class]]) {
        NSMutableAttributedString *attributedText = text;
        if (attributedText.length) view.lj_barrageLabel.attributedText = attributedText;
    } else if ([text isKindOfClass:[NSString class]]){
        NSString *stringText = text;
        if (stringText.length) view.lj_barrageLabel.text = stringText;
    }
    
    [view.lj_barrageLabel sizeToFit];
    
    CGFloat maxY = [self getBarrageHeightWithRow:row rowHeight:self.barrageStyle.barrageHeight];

    CGFloat barrageWidth = view.lj_barrageLabel.bounds.size.width + 10;
    view.frame = CGRectMake(self.frame.size.width, maxY, barrageWidth, self.barrageStyle.barrageHeight);
    view.lj_barrageLabel.frame = view.bounds;
    
    if ([self.delegate respondsToSelector:@selector(refactoringView:text:)]) view = [self.delegate refactoringView:view text:text];
    
    CGFloat setMaxY = [self getBarrageHeightWithRow:row rowHeight:view.frame.size.height];
    view.frame = CGRectMake(self.frame.size.width, setMaxY, view.frame.size.width, view.frame.size.height);

    CGFloat intervalTime  = [self getIntervalTimeWithBarrageWidth:barrageWidth];
    CGFloat showTime = [self getShowTimeWithBarrageWidth:barrageWidth];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(intervalTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (enter) enter(row);
    });
    
    [UIView animateWithDuration:showTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        view.frame = CGRectMake(- view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self.reusePool addObject:view];
        if (finishShow) finishShow();
    }];
}

- (CGFloat)getIntervalTimeWithBarrageWidth:(CGFloat)barrageWidth {
    
    CGFloat viewWidth = self.frame.size.width;
    
    if (self.barrageShowStyle == LJBarrageShowStyleTypeShowTime)
        return (barrageWidth / (viewWidth + barrageWidth)) * self.styleParameter;
    
    if (self.barrageShowStyle == LJBarrageShowStyleTypeVelocity)
        return barrageWidth / self.styleParameter;
    
    if (self.barrageShowStyle == LJBarrageShowStyleTypeVelocityScreenThan)
        return barrageWidth / viewWidth / self.styleParameter;
    
    return 0;
}

- (CGFloat)getShowTimeWithBarrageWidth:(CGFloat)barrageWidth {
    
    CGFloat viewWidth = self.frame.size.width;
    
    if (self.barrageShowStyle == LJBarrageShowStyleTypeShowTime)
        return self.styleParameter;
    
    if (self.barrageShowStyle == LJBarrageShowStyleTypeVelocity)
        return viewWidth / self.styleParameter;
    
    if (self.barrageShowStyle == LJBarrageShowStyleTypeVelocityScreenThan)
        return (viewWidth + barrageWidth) / viewWidth / self.styleParameter;
    
    return 0;
}

- (UIView *)getBarrageView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.barrageStyle.barrageHeight)];
    view.lj_barrageLabel = [[UILabel alloc] init];
    [view addSubview:view.lj_barrageLabel];
    view.lj_barrageLabel.frame = view.bounds;
    view.lj_barrageLabel.font = self.barrageStyle.barrageFont;
    view.backgroundColor = self.barrageStyle.barrageBackgroundColor;
    view.lj_barrageLabel.textAlignment = self.barrageStyle.barrageTextAlignment;
    view.userInteractionEnabled = NO;
    [self addSubview:view];
    
    return view;
}

- (UIView *)getReuseBarrageLabel{
    
    @synchronized (self) {
        
        UIView *view = [self.reusePool anyObject];
        if (view) {
            [self.reusePool removeObject:view];
            return view;
        }
        view = [self getBarrageView];
        return view;
    }
}

- (void)setBarrageText:(NSString *)barrageText {
    if (self.barrageSwitchType == BarrageTypeShut) return;
    [self.texts addObject:barrageText];
    [self start];
}

- (void)setBarrageTexts:(NSArray *)barrageTexts {
    if (self.barrageSwitchType == BarrageTypeShut) return;
    [self.texts addObjectsFromArray:barrageTexts];
    [self start];
}

- (void)start {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.barrageSwitchType == BarrageTypeOpen && self.barrageShowType == BarrageTypeStop && [self isCanShow])
            [self showWithRow:[self loadShowRow]];
    });
}

- (void)showWithRow:(NSInteger)row {
    
    if (self.barrageSwitchType == BarrageTypeShut) return;
    self.barrageShowType = BarrageTypeStart;
    
    if (!self.texts || self.texts.count <= self.nextNum) return;
    
    id text = [self.texts[self.nextNum] mutableCopy];
    
    self.nextNum++;
    
    __block id blockText = text;
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.barrageEnterInterval * NSEC_PER_SEC)), self.barrageQueue, ^{
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        dispatch_semaphore_wait(strongSelf.barrageMaxEnterSemaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf showBarrageWithRow:row text:blockText enter:^(NSInteger row) {
                
                [strongSelf clearOutWithShowRow:row];
                if ([strongSelf isCanShow]) {
                    [strongSelf showWithRow:[strongSelf loadShowRow]];
                }
                blockText = nil;
            } finishShow:^{
                
                if (strongSelf.texts && strongSelf.texts.count) [strongSelf.texts removeObjectAtIndex:0];
                strongSelf.nextNum--;
                if (!strongSelf.nextNum) {
                    strongSelf.barrageShowType = BarrageTypeStop;
                }
                dispatch_semaphore_signal(strongSelf.barrageMaxEnterSemaphore);
            }];
            
            if ([strongSelf isCanShow]) {
                
                [strongSelf showWithRow:[strongSelf loadShowRow]];
            }
        });
    });
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@YES];
}

- (BOOL)isCanShow {
    return self.texts.count > self.nextNum && [self isHaveFreeLine];
}

- (CGFloat)getBarrageHeightWithRow:(NSInteger)row rowHeight:(CGFloat)rowHeight {
    
    switch (self.barrageHeightType) {
        case BarrageHeightTypeNormal:
            
            return rowHeight *row;
        case BarrageHeightTypeRandom:
        {
            NSInteger arcInt = [[NSString stringWithFormat:@"%f",(int)self.frame.size.height - rowHeight] integerValue];
            if (arcInt) return arc4random() % arcInt;
            return 0;
        }
        default:
            return 0;
    }
}

- (void)clearOutWithShowRow:(NSInteger)row {
    
    @synchronized (self.showRows) {
        if (row >= 0) self.showRows[row] = @NO;
    }
}

- (NSInteger)loadShowRow {
    
    @synchronized (self.showRows) {
        
        NSInteger num = 0;
        
        __block NSInteger blockNum = num;
        
        for (int i = 0; i < self.showRows.count; i++) {
            if (![self.showRows[i] boolValue]) {
                blockNum = i;
                [self.showRows replaceObjectAtIndex:i withObject:@YES];
                break;
            }
        }
        return blockNum;
    }
}

- (BOOL)isHaveFreeLine {
    
    @synchronized (self.showRows) {
        
        return [self.showRows containsObject:@NO];
    }
}

- (void)setBarrageRow:(NSInteger)barrageRow {
    
    @synchronized (self.showRows) {
        
        _barrageRow = barrageRow;
        
        self.showRows = [NSMutableArray array];
        
        for (int i = 0; i < barrageRow; i++) {
            [self.showRows addObject:@NO];
        }
    }
}

- (void)setDelegate:(id<LJBarrageViewDelegate>)delegate {
    _delegate = delegate;
    [self loadTapGesture];
}

- (void)loadTapGesture {
    
    if ([_delegate respondsToSelector:@selector(clickBarrageWithView:text:)]) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBarrage:)];
        gesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture];
    }
}

- (void)clickBarrage:(UITapGestureRecognizer*)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    for(UIView *subView in self.subviews){
        if([subView isKindOfClass:[UIView class]]){
            CALayer *layer = subView.layer.presentationLayer;
            if(CGRectContainsPoint(layer.frame, touchPoint)){
                UIView *view = (UIView *)subView;
                if ([self.delegate respondsToSelector:@selector(clickBarrageWithView:text:)]) {
                    [self.delegate clickBarrageWithView:view text:view.lj_barrageText];
                }
            }
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
