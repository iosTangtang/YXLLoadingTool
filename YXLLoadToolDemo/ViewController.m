//
//  ViewController.m
//  YXLLoadToolDemo
//
//  Created by Tangtang on 16/9/17.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "ViewController.h"
#import "YXLLoadTool.h"
#import <CommonCrypto/CommonCrypto.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [YXLLoadTool setLineColor:[UIColor whiteColor]];
    [YXLLoadTool setBackGroundColor:[UIColor blackColor]];
    [YXLLoadTool setCornerRadius:26.f];
    [YXLLoadTool setLineWidth:5.f];
    [YXLLoadTool setFont:[UIFont fontWithName:@"PingFang TC" size:15.f]];
    [YXLLoadTool setShowTime:2.f];
    
    [YXLLoadTool startLoading];
    
}
- (IBAction)startLoading:(id)sender {
    [YXLLoadTool startLoadingWithMessage:@"Loading"];
}

- (IBAction)succeedAction:(id)sender {
    [YXLLoadTool startLoadingWithMessage:@"succeed" status:YXLLoadSuccess];
}

- (IBAction)errorAction:(id)sender {
    [YXLLoadTool startLoadingWithMessage:@"error" status:YXLLoadError];
}

- (IBAction)infomationAction:(id)sender {
    [YXLLoadTool startLoadingWithMessage:@"infomation" status:YXLLoadInfo];
}

- (IBAction)stopLoading:(id)sender {
    [YXLLoadTool stopLoading];
}

- (IBAction)clearMask:(id)sender {
    [YXLLoadTool startLoadingWithMessage:@"clearMask Loading" maskType:YXLMaskTypeClear];
}

- (IBAction)lightMask:(id)sender {
    [YXLLoadTool startLoadingWithMessage:@"lightMask Loading" maskType:YXLMaskTypeLight];
}

- (IBAction)darkMask:(id)sender {
    [YXLLoadTool startLoadingWithMessage:@"darkMask Loading" maskType:YXLMaskTypeDark];
}

- (IBAction)imageAction:(id)sender {
    [YXLLoadTool startLoadingWithImage:[UIImage imageNamed:@"shucai"] message:@"蔬菜"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
