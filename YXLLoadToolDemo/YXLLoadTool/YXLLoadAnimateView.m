//
//  YXLLoadAnimateView.m
//  YXLLoadToolDemo
//
//  Created by Tangtang on 16/9/17.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "YXLLoadAnimateView.h"
#import "YXLLoadTool.h"

@interface YXLLoadAnimateView ()

@property (nonatomic, strong)CAShapeLayer   *loadAnimateLayer;

@end

@implementation YXLLoadAnimateView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self p_setupLayer];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self p_setupLayer];
    }
    else {
        [_loadAnimateLayer removeFromSuperlayer];
        _loadAnimateLayer = nil;
    }
}

- (void)p_setupLayer {
    CAShapeLayer *layer = [self loadAnimateLayer];
    [self.layer addSublayer:layer];
    
    //调整位置
    CGFloat widthDifference = self.bounds.size.width - layer.bounds.size.width;
    CGFloat heightDifference = self.bounds.size.height - layer.bounds.size.height;
    
    layer.position = CGPointMake(self.bounds.size.width - layer.bounds.size.width / 2 - widthDifference / 2,
                                 self.bounds.size.height - layer.bounds.size.height / 2 - heightDifference / 2);
}

#pragma mark - lazy Load
- (CAShapeLayer *)loadAnimateLayer {
    if (_loadAnimateLayer) {
        return _loadAnimateLayer;
    }
    
    CGPoint center = CGPointMake(self.radius + self.lineWidth / 2 + 5, self.radius + self.lineWidth / 2 + 5);
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithArcCenter:center
                                                          radius:self.radius
                                                      startAngle:(CGFloat) (M_PI*3/2)
                                                        endAngle:(CGFloat) (M_PI/2+M_PI*5)
                                                       clockwise:YES];
    
    //创建CAShapeLayer
    _loadAnimateLayer = [CAShapeLayer layer];
    _loadAnimateLayer.frame = CGRectMake(0, 0, center.x * 2, center.y * 2);
    _loadAnimateLayer.fillColor = self.backgroundColor.CGColor;
    _loadAnimateLayer.lineWidth = self.lineWidth;
    _loadAnimateLayer.strokeColor = self.lineColor.CGColor;
    _loadAnimateLayer.lineCap = kCALineCapRound;
    _loadAnimateLayer.lineJoin = kCALineJoinRound;
    _loadAnimateLayer.contentsScale = [[UIScreen mainScreen] scale];
    
    //建立贝塞尔曲线与CAShapeLayer之间的关联
    _loadAnimateLayer.path = bezier.CGPath;
    
    NSBundle *mainBundle = [NSBundle bundleForClass:[YXLLoadTool class]];
    NSURL *url = [mainBundle URLForResource:@"YXLLoadImage" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    
    NSString *imagePath = [imageBundle pathForResource:@"angle-mask" ofType:@"png"];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (__bridge id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    maskLayer.frame = _loadAnimateLayer.bounds;
    _loadAnimateLayer.mask = maskLayer;
    
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 1.f;
    animation.fromValue = @0;
    animation.toValue = @(2*M_PI);
    animation.repeatCount = INFINITY;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;                    //防止出现动画结束之后跳回原位的动画不流畅现象
    
    [_loadAnimateLayer.mask addAnimation:animation forKey:@"transform.rotation"];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.f;
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = linearCurve;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @0.015;
    strokeStartAnimation.toValue = @0.515;
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0.485;
    strokeEndAnimation.toValue = @0.985;
    
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    [_loadAnimateLayer addAnimation:animationGroup forKey:@"progress"];
    
    return _loadAnimateLayer;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    _loadAnimateLayer.strokeColor = lineColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _loadAnimateLayer.lineWidth = lineWidth;
}

- (void)setRadius:(CGFloat)radius {
    if (radius != _radius) {
        _radius = radius;
        [_loadAnimateLayer removeFromSuperlayer];
        _loadAnimateLayer = nil;
        
        if (self.superview) {
            [self p_setupLayer];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius + self.lineWidth / 2 + 5) * 2, (self.radius + self.lineWidth / 2 + 5) * 2);
}

@end
