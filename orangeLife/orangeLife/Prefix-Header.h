//
//  Prefix-Header.h
//  orangeLife
//
//  Created by 张俊凯 on 16/7/30.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#ifndef Prefix_Header_h
#define Prefix_Header_h

#import "HPConst.h"
#import "UIView+HPExtension.h"
#import "HPHttpManager.h"
#import "HPUtils.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "UIBarButtonItem+HPExtension.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "HPProgressView.h"
#import "HPNavigationVC.h"
#import "YTKKeyValueStore.h"
#import "ReactiveCocoa.h"
//第三方获取UUID
#import "UIDevice+FCUUID.h"


//定义一些常用字符串
#define kUserUUID   @"userUUID"


//调试状态打印日志
#ifdef DEBUG
#define JKLog(...) NSLog(__VA_ARGS__)
#else
#define JKLog(...)
#endif

#define APPID @"22739"
#define APPKEY @"3dc1f4f867584fab85a28d9b0462bd98"
//打印函数
#define JKLogFunc JKLog(@"%s",__func__)
//打印frame
#define JKLogFrame(...) JKLog(@"%@",NSStringFromCGRect(__VA_ARGS__))

//定义两个系统主题颜色
#define systemRedColor [UIColor colorWithRed:0.945 green:0.380 blue:0.498 alpha:1.000]
#define systemOrangeColor [UIColor colorWithRed:1.000 green:0.638 blue:0.273 alpha:1.000]

//统一导航栏颜色，橘黄色
#define JKNavBarColor [UIColor colorWithRed:0.986 green:0.289 blue:0.017 alpha:1.000]

//全局统一灰色
#define JKGlobeGrayColor [UIColor colorWithWhite:0.902 alpha:1.000]

//自定义颜色
#define JKRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//随机色
#define JKRandomColor JKRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
//购物网址
#define shopURL @"http://192.168.0.120/juzi/mobile/"
//#define shopURL @"http://m.baidu.com/"

//定义URL
#define kBaseURL       @"http://mobile.yuyanzhe.me/"  //正式环境
#define kZMParamsURL   @"zmxy/prames.json"            //芝麻信用参数加密处理
#define kZMSubmitURL   @"zmxy/submit"                 //授权登录

//屏幕高度
#define  JKScreenW  [UIScreen mainScreen].bounds.size.width
#define  JKScreenH  [UIScreen mainScreen].bounds.size.height

//定义网络请求超时时间
#define JKTimeoutInterval 20.0




#endif /* Prefix_Header_h */
