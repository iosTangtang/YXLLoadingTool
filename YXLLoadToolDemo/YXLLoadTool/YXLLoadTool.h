//
//  YXLLoadTool.h
//  YXLLoadToolDemo
//
//  Created by Tangtang on 16/9/17.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLLoadTool : UIView 

typedef NS_ENUM(NSInteger, YXLLoadStatus) {
    YXLLoadNone,            //default
    YXLLoadSuccess,
    YXLLoadError,
    YXLLoadInfo,
    YXLLoadImage            //在自定义图片的时候使用
};

typedef NS_ENUM(NSInteger, YXLMaskType) {
    YXLMaskTypeNone = 1,        //default
    YXLMaskTypeClear,
    YXLMaskTypeLight,
    YXLMaskTypeDark
};

#pragma mark - setMethod
+ (void)setFont:(UIFont *)font;                                         //设置提示字体
+ (void)setLineColor:(UIColor *)color;                                  //设置动画线条及提示信息的颜色
+ (void)setShowTime:(CGFloat)showTime;                                  //设置出现提示信息的时候存在的时间
+ (void)setCornerRadius:(CGFloat)radius;                                //设置加载动画的半径
+ (void)setLineWidth:(CGFloat)lineWidth;                                //设置加载动画的线条宽度
+ (void)setMaskType:(YXLMaskType)maskType;                              //设置蒙版的样式
+ (void)setBackGroundColor:(UIColor *)color;                            //设置加载视图的背景颜色
+ (void)setLoadStatus:(YXLLoadStatus)loadStatus;                        //设置加载提示信息的提示图片

#pragma mark - loadingMethod
+ (void)startLoading;
+ (void)startLoadingWithMask:(YXLMaskType)maskType;

+ (void)startLoadingWithMessage:(NSString *)message;
+ (void)startLoadingWithMessage:(NSString *)message status:(YXLLoadStatus)status;
+ (void)startLoadingWithMessage:(NSString *)message maskType:(YXLMaskType)maskType;
+ (void)startLoadingWithMessage:(NSString *)message status:(YXLLoadStatus)status maskType:(YXLMaskType)maskType;

+ (void)startLoadingWithImage:(UIImage *)image;
+ (void)startLoadingWithImage:(UIImage *)image message:(NSString *)message;
+ (void)startLoadingWithImage:(UIImage *)image maskType:(YXLMaskType)maskType;
+ (void)startLoadingWithImage:(UIImage *)image message:(NSString *)message maskType:(YXLMaskType)maskType;

+ (void)stopLoading;

@end
