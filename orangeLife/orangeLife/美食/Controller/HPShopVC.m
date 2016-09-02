//
//  HPShopVC.m
//  orangeLife
//
//  Created by 张俊凯 on 16/8/12.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "HPShopVC.h"
#import "WebViewJavascriptBridge.h"
#import "HPSesameVC.h"
#import "HPAlipayCertifyVC.h"
#import "HPErrorView.h"


@interface HPShopVC ()<UIWebViewDelegate>
@property(nonatomic,weak)UIWebView *webView;
@property WebViewJavascriptBridge* bridge;
@property(nonatomic,weak)UIView *errorView;
@end

@implementation HPShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //1.设置tabbar样式
    [self setupTabBar];
    
    //2.添加webView
    [self setupWebView];
    
    //3.添加导航刷新按钮
    [self addRefreshButton];
    
    //4.设置桥接模式
    [self setupBridge];
    
    
    
    

}



//2.添加webView
-(void)setupWebView
{
    CGRect frame = CGRectMake(0, statusBarHeight, self.view.width, self.view.height - statusBarHeight );
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:webView];
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.bounces = NO;
    //webView.delegate = self;
    self.webView = webView;
    //加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:shopURL]];
    
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}


//4.设置桥接模式
-(void)setupBridge
{
    //4.1.如果已经生成，返回
    if (_bridge) { return; }
    
    //4.2.先开启日志模式
    [WebViewJavascriptBridge enableLogging];
    
    
    //4.3.开始搭桥
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    //4.4.JS调用OC的方法
    [_bridge registerHandler:@"zjk" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        //JKLog(@"----------JS调用成功");
        
        HPAlipayCertifyVC *aliVC = [HPAlipayCertifyVC new];
        [self.navigationController pushViewController:aliVC animated:YES];
        
        
    }];
    
    //4.5.设置webView代理
    [_bridge setWebViewDelegate:self];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(void)addRefreshButton
{
    //添加按钮
//    self.navigationItem. leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(backToHomePage)];
}

//即将出现隐藏导航栏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
}
-(void)backToHomePage
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:shopURL]];
    [self.webView loadRequest:request];
}

//1.设置tabbar样式
-(void)setupTabBar
{
    //选中是绿色
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : JKRGBColor(222, 62, 89)} forState:UIControlStateSelected];
    
    //未选中是深灰色
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : JKRGBColor(170, 170, 170)} forState:UIControlStateNormal];
}

#pragma mark UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"加载中"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [self.view insertSubview:webView aboveSubview:self.errorView];
   
    if (self.errorView) {
        [UIView animateWithDuration:0.8 animations:^{
            self.errorView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.errorView removeFromSuperview];
        }];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"啊哦,好像网络有点问题,请检查网络设置再重新打开APP"];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title  = @"加载失败";
    [self addNetworkErrorView];
}

-(void)addNetworkErrorView
{
    //如果没有添加过，再添加
    if (!self.errorView) {
        
        HPErrorView *errorView = [HPErrorView errorView];
        self.errorView = errorView;
        errorView.frame = self.view.bounds;
        [self.view addSubview:errorView];
        errorView.clickBlock = ^{
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:shopURL]];
            [self.webView loadRequest:request];
        };
    }
    
}

@end
