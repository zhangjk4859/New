//
//  HPProgressView.m
//  orangeLife
//
//  Created by 张俊凯 on 16/8/12.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "HPProgressView.h"

@interface HPProgressView()

@property(nonatomic,weak)UIView *progressView;
@end

@implementation HPProgressView

+(instancetype)progressView
{
    return [[self alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //3.1进度条底座
        UIView *progressView = [[UIView alloc]init];
        progressView.backgroundColor = [UIColor clearColor];
        [self addSubview:progressView];
        self.progressView = progressView;
        
        //3.2图层动画
        CALayer *layer = [CALayer layer];
        [progressView.layer addSublayer:layer];
        //默认是蓝色
        layer.backgroundColor = [UIColor colorWithRed:0.243 green:0.408 blue:0.722 alpha:1.000].CGColor;
        self.progresslayer = layer;
    }
    return self;
}
-(void)layoutSubviews
{
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.progresslayer.frame = CGRectMake(0, 0, 0, self.frame.size.height);
}

-(void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    
    self.progresslayer.backgroundColor = progressColor.CGColor;
}

@end
