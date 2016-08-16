//
//  HPErrorView.h
//  orangeLife
//
//  Created by 张俊凯 on 16/8/16.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPErrorView : UIView
+(instancetype)errorView;
/** 刷新按钮点击的blcok */
@property(nonatomic,copy)void(^clickBlock)();
@end
