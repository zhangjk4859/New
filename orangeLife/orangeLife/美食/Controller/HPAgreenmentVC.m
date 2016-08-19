//
//  HPAgreenmentVC.m
//  桔子信用
//
//  Created by 张俊凯 on 16/6/7.
//  Copyright © 2016年 禾浦科技. All rights reserved.
//

#import "HPAgreenmentVC.h"


@interface HPAgreenmentVC ()<UIWebViewDelegate>

@property(nonatomic,weak)UIWebView *webview;

@end

@implementation HPAgreenmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加一个webView
    UIWebView * webView = [[UIWebView alloc]init];
    webView.scrollView.bounces = NO;
    webView.frame = self.view.bounds;
    webView.delegate =self;
    [self.view addSubview:webView];
    self.webview = webView;
    
    //加载数据
    [self startDownLoad];
}

-(void)startDownLoad
{
    [SVProgressHUD showWithStatus:@"数据加载中,请稍后"];
    NSMutableDictionary *params = [HPUtils getBasicDictionary];
    params[@"code"] = self.code;
    [[HPHttpManager shareManager] postReqWithBaseUrlStr:kBaseURL surfixUrlStr:kAgreementURL params:params success:^(NSDictionary *responseObject) {
        
        JKLog(@"协议返回来的字典%@",responseObject);
       NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {//返回成功
         NSString *htmlString =  responseObject[@"attr"][@"context"];
            [self.webview loadHTMLString:htmlString baseURL:nil];
            
            NSString *titleString =  responseObject[@"attr"][@"title"];
            self.navigationItem.title = titleString;
            
        }
        [SVProgressHUD dismiss];
        
        
    } failure:^(NSError *error) {
        
        JKLog(@"%@",error);
        //显示网络加载错误
        [SVProgressHUD showErrorWithStatus:@"无网络连接,请检查后网络后再重试"];
        
    }];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


-(void)dealloc{
    //销毁时取消任务和圈圈
    [SVProgressHUD dismiss];
    
}

#pragma webView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //更改字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'"];
    //更改字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
    //页面背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='rgb(230,230,230)'"];
}


@end
