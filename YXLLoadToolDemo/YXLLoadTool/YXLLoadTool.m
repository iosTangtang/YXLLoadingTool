//
//  YXLLoadTool.m
//  YXLLoadToolDemo
//
//  Created by Tangtang on 16/9/17.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "YXLLoadTool.h"
#import "YXLLoadAnimateView.h"

@interface YXLLoadTool ()

@property (nonatomic, strong) UIFont                *font;
@property (nonatomic, strong) UIColor               *lineColor;
@property (nonatomic, strong) UIColor               *backGroundColor;
@property (nonatomic, assign) CGFloat               radius;
@property (nonatomic, assign) CGFloat               lineWidth;
@property (nonatomic, assign) CGFloat               showTime;
@property (nonatomic, assign) YXLMaskType           maskType;
@property (nonatomic, assign) YXLLoadStatus         loadStatus;
@property (nonatomic, strong) YXLLoadAnimateView    *loadView;
@property (nonatomic, strong) UIControl             *bgView;
@property (nonatomic, strong) UIView                *loadBackView;
@property (nonatomic, strong) UILabel               *messageLabel;
@property (nonatomic, strong) UIImageView           *statusImage;
@property (nonatomic, strong) NSTimer               *timer;

@end

@implementation YXLLoadTool

static YXLLoadTool *loadTool = nil;

#pragma mark - Single Method
+ (YXLLoadTool *)toolManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadTool = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    });
    
    return loadTool;
}

#pragma mark - lazyLoad
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIControl alloc] initWithFrame:self.frame];
        _bgView.alpha = 0.5;
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return _bgView;
}

- (YXLLoadAnimateView *)loadView {
    if (!_loadView) {
        _loadView = [[YXLLoadAnimateView alloc] init];
    }
    
    _loadView.lineWidth = self.lineWidth;
    _loadView.lineColor = self.lineColor;
    _loadView.radius = self.radius;
    
    [_loadView sizeToFit];
    
    if (!_loadView.superview) {
        [self.loadBackView addSubview:_loadView];
        _loadView.center = CGPointMake(self.loadBackView.bounds.size.width / 2.0, _loadView.bounds.size.height / 2.0);
    }
    
    return _loadView;
}

- (UIView *)loadBackView {
    if (!_loadBackView) {
        _loadBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _loadBackView.layer.masksToBounds = YES;
        //自适应父视图
        _loadBackView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _loadBackView.layer.cornerRadius = 10.f;
        _loadBackView.bounds = CGRectMake(0, 0, (self.radius + self.lineWidth / 2 + 5) * 2, (self.radius + self.lineWidth / 2 + 5) * 2);
    }
    
    _loadBackView.backgroundColor = self.backGroundColor;
    
    //默认视图大小 即没有label的动画视图大小
    _loadBackView.center = self.center;
    
    return _loadBackView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.adjustsFontSizeToFitWidth = YES;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (!_messageLabel.superview) {
        [self.loadBackView addSubview:_messageLabel];
    }
    
    _messageLabel.textColor = self.lineColor;
    _messageLabel.font = self.font;
    
    return _messageLabel;
}

- (UIImageView *)statusImage {
    if (!_statusImage) {
        _statusImage = [[UIImageView alloc] init];
        _statusImage.hidden = YES;
    }
    
    if (!_statusImage.superview) {
        [self.loadBackView addSubview:_statusImage];
    }
    
    return _statusImage;
}

#pragma mark - initlialize Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //default
        if ([UIFont respondsToSelector:@selector(preferredFontForTextStyle:)]) {
            _font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        } else {
            _font = [UIFont systemFontOfSize:14.0f];
        }
        _lineColor = [UIColor whiteColor];
        _radius = 30.f;
        _lineWidth = 4.f;
        _maskType = YXLMaskTypeNone;
        _backGroundColor = [UIColor grayColor];
        _loadStatus = YXLLoadNone;
        _showTime = 2.f;
        
    }
    
    return self;
}

#pragma mark - setMethod
+ (void)setFont:(UIFont *)font {
    [[self toolManager] setFont:font];
}

+ (void)setLineColor:(UIColor *)color {
    [[self toolManager] setLineColor:color];
}

+ (void)setShowTime:(CGFloat)showTime {
    [[self toolManager] setShowTime:showTime];
}

+ (void)setCornerRadius:(CGFloat)radius {
    [[self toolManager] setRadius:radius];
}

+ (void)setLineWidth:(CGFloat)lineWidth {
    [[self toolManager] setLineWidth:lineWidth];
}

+ (void)setMaskType:(YXLMaskType)maskType {
    [[self toolManager] setMaskType:maskType];
}

+ (void)setBackGroundColor:(UIColor *)color {
    [[self toolManager] setBackGroundColor:color];
}

+ (void)setLoadStatus:(YXLLoadStatus)loadStatus {
    [[self toolManager] setLoadStatus:loadStatus];
}

#pragma mark - loadingMethod
+ (void)startLoading {
    [[self toolManager] yxl_startLoadingWithMessage:nil status:[self toolManager].loadStatus maskType:[self toolManager].maskType];
}

+ (void)startLoadingWithMask:(YXLMaskType)maskType {
    YXLMaskType defaultMaskType = [self toolManager].maskType;
    [[self toolManager] yxl_startLoadingWithMessage:nil status:[self toolManager].loadStatus maskType:maskType];
    [[self toolManager] setMaskType:defaultMaskType];
}

+ (void)startLoadingWithMessage:(NSString *)message {
    [[self toolManager] yxl_startLoadingWithMessage:message status:[self toolManager].loadStatus maskType:[self toolManager].maskType];
}

+ (void)startLoadingWithMessage:(NSString *)message status:(YXLLoadStatus)status {
    YXLLoadStatus defaultStatus = [self toolManager].loadStatus;
    [[self toolManager] yxl_startLoadingWithMessage:message status:status maskType:[self toolManager].maskType];
    [[self toolManager] setLoadStatus:defaultStatus];
}

+ (void)startLoadingWithMessage:(NSString *)message maskType:(YXLMaskType)maskType {
    YXLMaskType defaultMaskType = [self toolManager].maskType;
    [[self toolManager] yxl_startLoadingWithMessage:message status:[self toolManager].loadStatus maskType:maskType];
    [[self toolManager] setMaskType:defaultMaskType];
}

+ (void)startLoadingWithMessage:(NSString *)message status:(YXLLoadStatus)status maskType:(YXLMaskType)maskType {
    YXLMaskType defaultMaskType = [self toolManager].maskType;
    YXLLoadStatus defaultStatus = [self toolManager].loadStatus;
    [[self toolManager] yxl_startLoadingWithMessage:message status:status maskType:maskType];
    [[self toolManager] setMaskType:defaultMaskType];
    [[self toolManager] setLoadStatus:defaultStatus];
}

+ (void)startLoadingWithImage:(UIImage *)image {
    [self toolManager].statusImage.image = image;
    YXLLoadStatus defaultStatus = [self toolManager].loadStatus;
    [[self toolManager] setLoadStatus:YXLLoadImage];
    [self startLoading];
    [[self toolManager] setLoadStatus:defaultStatus];
}

+ (void)startLoadingWithImage:(UIImage *)image message:(NSString *)message {
    [self toolManager].statusImage.image = image;
    YXLLoadStatus defaultStatus = [self toolManager].loadStatus;
    [[self toolManager] setLoadStatus:YXLLoadImage];
    [self startLoadingWithMessage:message];
    [[self toolManager] setLoadStatus:defaultStatus];
}

+ (void)startLoadingWithImage:(UIImage *)image maskType:(YXLMaskType)maskType {
    [self toolManager].statusImage.image = image;
    YXLLoadStatus defaultStatus = [self toolManager].loadStatus;
    [[self toolManager] setLoadStatus:YXLLoadImage];
    [self startLoadingWithMask:maskType];
    [[self toolManager] setLoadStatus:defaultStatus];
}

+ (void)startLoadingWithImage:(UIImage *)image message:(NSString *)message maskType:(YXLMaskType)maskType {
    [self toolManager].statusImage.image = image;
    YXLLoadStatus defaultStatus = [self toolManager].loadStatus;
    [[self toolManager] setLoadStatus:YXLLoadImage];
    [self startLoadingWithMessage:message maskType:maskType];
    [[self toolManager] setLoadStatus:defaultStatus];
}

#pragma mark - Stop loading method
+ (void)stopLoading {
    [[self toolManager] yxl_stopLoading];
}

#pragma mark - Master start/stop Method
- (void)yxl_startLoadingWithMessage:(NSString *)message status:(YXLLoadStatus)status maskType:(YXLMaskType)maskType {
    //停用计时器
    [self.timer invalidate];
    self.timer = nil;
    
    [self bgView];
    if (!self.superview) {
        [self.bgView addSubview:self];
        [self addSubview:self.loadBackView];
    }
    
    [self loadView];
    
    [self messageLabel];
    self.messageLabel.text = message;
    
    if (maskType) {
        self.maskType = maskType;
        if (self.maskType != YXLMaskTypeNone) {
            self.bgView.userInteractionEnabled = YES;
        }
        else {
            self.bgView.userInteractionEnabled = NO;
        }
        //更新背景视图的颜色
        [self yxl_updateBackViewColor];
    }
    
    //-------调整LoadBackView的大小-------
    [self yxl_updateLoadBackViewFrame];
    
    self.loadStatus = status;
    [self yxl_changeStatus];
    
    //回到主线程更新视图层次(重要)
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIWindow *window = [UIApplication sharedApplication].windows[0];
        [window addSubview:strongSelf.bgView];
        
        [strongSelf.bgView.superview bringSubviewToFront:strongSelf];
    
    }];
    
    if (self.loadStatus != YXLLoadNone) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.timer = [NSTimer timerWithTimeInterval:strongSelf.showTime target:strongSelf selector:@selector(yxl_stopLoading)
                                                     userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:strongSelf.timer forMode:NSRunLoopCommonModes];
        }];
    }
    
}

- (void)yxl_updateLoadBackViewFrame {
    NSString *message = self.messageLabel.text;
    
    if (!message) {
        return;
    }
    
    CGSize containerSize = CGSizeMake(180, 280);
    CGRect messageRect = [message boundingRectWithSize:containerSize options:NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading |
                          NSStringDrawingTruncatesLastVisibleLine
                                            attributes:@{NSFontAttributeName : self.messageLabel.font}
                                               context:NULL];
    self.messageLabel.frame = CGRectMake(0, 0, messageRect.size.width, ceil(messageRect.size.height));

    //originalBounds需为原始的bounds, 即动画的大小
    CGRect originalBounds = CGRectMake(0, 0, (self.radius + self.lineWidth / 2 + 5) * 2, (self.radius + self.lineWidth / 2 + 5) * 2);
    self.loadBackView.bounds = CGRectMake(0, 0, MAX(originalBounds.size.width, messageRect.size.width + 10),
                                          MAX(originalBounds.size.height + messageRect.size.height + 10, originalBounds.size.height));
    
    //调整label的位置
    self.messageLabel.center = CGPointMake(self.loadBackView.bounds.size.width / 2.0,
                                           self.loadBackView.bounds.size.height - 8 - self.messageLabel.frame.size.height / 2.0);
    
    //调整动画的位置
    self.loadView.center = CGPointMake(self.loadBackView.bounds.size.width / 2.0, _loadView.bounds.size.height / 2.0);
    
    [self.loadBackView setNeedsDisplay];
    
}

- (void)yxl_changeStatus {
    self.loadView.hidden = YES;
    self.statusImage.hidden = NO;
    
    NSBundle *mainBundle = [NSBundle bundleForClass:[YXLLoadTool class]];
    NSURL *url = [mainBundle URLForResource:@"YXLLoadImage" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    
    NSString *imagePath = nil;
    
    switch (self.loadStatus) {
        case YXLLoadNone:
            self.loadView.hidden = NO;
            self.statusImage.hidden = YES;
            break;
        case YXLLoadInfo: {
            imagePath = [imageBundle pathForResource:@"info" ofType:@"png"];
            self.statusImage.image = [UIImage imageWithContentsOfFile:imagePath];
            break;
        }
        case YXLLoadError: {
            imagePath = [imageBundle pathForResource:@"error" ofType:@"png"];
            self.statusImage.image = [UIImage imageWithContentsOfFile:imagePath];
            break;
        }
        case YXLLoadSuccess: {
            imagePath = [imageBundle pathForResource:@"succeed" ofType:@"png"];
            self.statusImage.image = [UIImage imageWithContentsOfFile:imagePath];
            break;
        }
        default:
            break;
    }
    
    self.statusImage.bounds = CGRectMake(0, 0, self.loadView.bounds.size.width / 4 * 3, self.loadView.bounds.size.height / 4 * 3);
    self.statusImage.center = CGPointMake(self.loadBackView.bounds.size.width / 2.0, self.loadView.bounds.size.height / 2.0);
    [self.statusImage setNeedsDisplay];
}

- (void)yxl_updateBackViewColor {
    //更新maskType的样式
    switch (self.maskType) {
        case YXLMaskTypeClear:
            _bgView.backgroundColor = [UIColor clearColor];
            break;
        case YXLMaskTypeLight:
            _bgView.backgroundColor = [UIColor lightGrayColor];
            break;
        case YXLMaskTypeDark:
            _bgView.backgroundColor = [UIColor blackColor];
            break;
        default:
            _bgView.backgroundColor = [UIColor clearColor];
            break;
    }
}

- (void)yxl_stopLoading {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.statusImage removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
        [weakSelf removeFromSuperview];
        weakSelf.alpha = 1;
    }];

}

- (void)setTimer:(NSTimer *)timer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (timer) {
        _timer = timer;
    }
}

@end
