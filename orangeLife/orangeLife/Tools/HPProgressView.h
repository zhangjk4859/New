//
//  HPProgressView.h
//  orangeLife
//
//  Created by 张俊凯 on 16/8/12.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPProgressView : UIView
/**进度条颜色*/
@property(nonatomic,strong)UIColor *progressColor;
/** 进度条图层 */
@property(nonatomic,weak)CALayer *progresslayer;
+(instancetype)progressView;
@end
