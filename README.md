##YXLLoadTool
 这是一个仿照SVProgressHUD写的加载动画，作为对动画部分和CALayer部分的练习。工具很简单，调用方法也很简单，代码量不多，欢迎批评指正。

#####import
暂时还没未支持cocopods，后续会逐渐维护。
```
#import "YXLLoadTool.h"
```

#####简单调用加载
只需想如下这样在需要的地方调用即可。一行代码即可解决调用问题
```
[YXLLoadTool startLoading];
```

#####加载动画和标题
同样只需要一句代码即可
```
[YXLLoadTool startLoadingWithMessage:@"Loading"];
```

#####存在蒙版的加载动画
```
[YXLLoadTool startLoadingWithMessage:@"clearMask Loading" maskType:YXLMaskTypeClear];
```
目前支持三种蒙版，分别如下
```
typedef NS_ENUM(NSInteger, YXLMaskType) {
    YXLMaskTypeNone = 1,        //default
    YXLMaskTypeClear,
    YXLMaskTypeLight,
    YXLMaskTypeDark
};
```
默认为不存在蒙版

#####成功、失败、消息提示
```
[YXLLoadTool startLoadingWithMessage:@"succeed" status:YXLLoadSuccess];
```
传入对应的状态值即可调用对应的提示框

#####自定义图片提示框
```
[YXLLoadTool startLoadingWithImage:[UIImage imageNamed:@"shucai"] message:@"蔬菜"];
```
可以自己选择图片作为提示图片。

#####取消加载动画
```
[YXLLoadTool stopLoading];
```

#####自定义响应属性修改样式
```
+ (void)setFont:(UIFont *)font;                                         //设置提示字体
+ (void)setLineColor:(UIColor *)color;                                  //设置动画线条及提示信息的颜色
+ (void)setShowTime:(CGFloat)showTime;                                  //设置出现提示信息的时候存在的时间
+ (void)setCornerRadius:(CGFloat)radius;                                //设置加载动画的半径
+ (void)setLineWidth:(CGFloat)lineWidth;                                //设置加载动画的线条宽度
+ (void)setMaskType:(YXLMaskType)maskType;                              //设置蒙版的样式
+ (void)setBackGroundColor:(UIColor *)color;                            //设置加载视图的背景颜色
+ (void)setLoadStatus:(YXLLoadStatus)loadStatus;                        //设置加载提示信息的提示图片
```
提供了这些方法供使用者修改对应的属性，调整到自己满意的样式

#####备注
提示成功、失败、信息的图片都为白色的，若有需要，可以使用修改图片的加载方法修改。

#####最后
欢迎下载项目体验并批评指正。

 Create by Tangtang
                                                                                      
