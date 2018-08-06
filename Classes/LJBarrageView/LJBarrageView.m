//
//  LJBarrageView.m
//  BarrageDemo
//
//  Created by 宋立军 on 2017/7/28.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LJBarrageView.h"

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
    self.hidden = YES;
}

- (void)showBarrageWithRow:(NSInteger)row text:(id)text enter:(void (^)(NSInteger row))enter finishShow:(void (^)(void))finishShow {
    
    CGFloat maxY = [self getBarrageHeightWithRow:row];
    
    UILabel *label = [self getReuseBarrageLabel];
    
    if ([text isKindOfClass:[NSMutableAttributedString class]]) {
        NSMutableAttributedString *attributedText = text;
        if (attributedText.length) label.attributedText = attributedText;
    } else if ([text isKindOfClass:[NSString class]]){
        NSString *stringText = text;
        if (stringText.length) label.text = stringText;
    }
    
    [label sizeToFit];
    
    if ([self.delegate respondsToSelector:@selector(refactoringLabel:text:)]) label = [self.delegate refactoringLabel:label text:text];
    
    CGFloat barrageWidth = label.bounds.size.width + 10;
    label.frame = CGRectMake(self.frame.size.width, maxY, barrageWidth, self.barrageStyle.barrageHeight);
    
    CGFloat intervalTime  = [self getIntervalTimeWithBarrageWidth:barrageWidth];
    CGFloat showTime = [self getShowTimeWithBarrageWidth:barrageWidth];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(intervalTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (enter) enter(row);
    });
    
    [UIView animateWithDuration:showTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        label.frame = CGRectMake(- barrageWidth, maxY, barrageWidth, self.barrageStyle.barrageHeight);
        
    } completion:^(BOOL finished) {
        
        [self.reusePool addObject:label];
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

- (UILabel *)getBarrageLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.barrageStyle.barrageHeight)];
    label.font = self.barrageStyle.barrageFont;
    label.backgroundColor = self.barrageStyle.barrageBackgroundColor;
    label.textAlignment = self.barrageStyle.barrageTextAlignment;
    [self addSubview:label];
    
    return label;
}

-(UILabel *)getReuseBarrageLabel{
    
    @synchronized (self) {
        
        UILabel *label = [self.reusePool anyObject];
        if (label) {
            [self.reusePool removeObject:label];
            return label;
        }
        label = [self getBarrageLabel];
        return label;
    }
}

- (void)setBarrageText:(NSString *)barrageText {
    [self.texts addObject:barrageText];
    [self start];
}

- (void)setBarrageMutableText:(NSMutableAttributedString *)barrageMutableText {
    [self.texts addObject:barrageMutableText];
    [self start];
}

- (void)setBarrageTexts:(NSArray *)barrageTexts {
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
    
    self.barrageShowType = BarrageTypeStart;
    
    if (self.texts.count <= self.nextNum) return;
    
    id text = [self.texts[self.nextNum] mutableCopy];
    
    self.nextNum++;
    
    __block id blockText = text;
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.barrageEnterInterval * NSEC_PER_SEC)), self.barrageQueue, ^{
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        dispatch_semaphore_wait(strongSelf.barrageMaxEnterSemaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf showBarrageWithRow:row text:blockText enter:^(NSInteger row) {
                
                [strongSelf clearOutWithShowRow:row];
                if ([strongSelf isCanShow]) {
                    [strongSelf showWithRow:[strongSelf loadShowRow]];
                }
                blockText = nil;
            } finishShow:^{
                
                [strongSelf.texts removeObjectAtIndex:0];
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

- (CGFloat)getBarrageHeightWithRow:(NSInteger)row {
    
    switch (self.barrageHeightType) {
        case BarrageHeightTypeNormal:
            
            return self.barrageRowHeight *row;
        case BarrageHeightTypeRandom:
        {
            NSInteger arcInt = [[NSString stringWithFormat:@"%f",(int)self.frame.size.height - self.barrageStyle.barrageHeight] integerValue];
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
