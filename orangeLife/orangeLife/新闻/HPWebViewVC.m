//
//  HPWebViewVC.m
//  orangeLife
//
//  Created by 张俊凯 on 16/8/2.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "HPWebViewVC.h"
#import <WebKit/WebKit.h>

@interface HPWebViewVC ()
/**
 *  进度条layer
 */
@property(nonatomic,strong)CALayer *progresslayer;
@property(nonatomic,weak)WKWebView *webView;
@end

@implementation HPWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.添加webView
    [self setupWebView];
    
    //2.设置返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back" target:self action:@selector(Canccel)];
    //3.设置进度条
    [self setupProgressView];
}

//1.添加webView
-(void)setupWebView
{
    CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height - tabBarBarHeight);
    WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
    [self.view addSubview:webView];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.link]];
    [webView loadRequest:request];
     //webView.delegate = self;
    self.webView = webView;
    
}

//3.设置进度条
-(void)setupProgressView
{

   HPProgressView *progressView  = [HPProgressView progressView];
    progressView.frame = CGRectMake(0, normalHeight, self.view.width, 3);
    self.progresslayer = progressView.progresslayer;
    [self.view addSubview:progressView];
    
}

//KVO监听进度条方法实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
       //监听变化值
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        
        //隐式动画，随着改变而改变
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        
        //加载完毕，layer消失
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//控制器销毁移除监听
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

//返回按钮方法实现
- (void)Canccel
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
