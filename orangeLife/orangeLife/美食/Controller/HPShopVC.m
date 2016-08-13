//
//  HPShopVC.m
//  orangeLife
//
//  Created by 张俊凯 on 16/8/12.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "HPShopVC.h"


@interface HPShopVC ()<UIWebViewDelegate>
@property(nonatomic,weak)UIWebView *webView;
@end

@implementation HPShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //1.设置tabbar样式
    [self setupTabBar];
    
    //2.添加webView
    [self setupWebView];
    
    //3.添加刷新按钮
    [self addRefreshButton];
    

}

//2.添加webView
-(void)setupWebView
{
    CGRect frame = CGRectMake(0, statusBarHeight, self.view.width, self.view.height - statusBarHeight );
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:shopURL]];
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.bounces = NO;
    [webView loadRequest:request];
    webView.delegate = self;
    self.webView = webView;
}

-(void)addRefreshButton
{
    self.navigationItem. leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(backToHomePage)];
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
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"啊哦,好像网络有点问题"];
}

@end
