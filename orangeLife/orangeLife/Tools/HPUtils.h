//
//  HPUtils.h
//  orangeLife
//
//  Created by 张俊凯 on 16/8/2.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPUtils : NSObject
+(NSString *)getCurrentTime;
+(NSMutableDictionary *)getBasicDictionary;


//颜色生成图片的三种方法
+(UIImageView *)creatSystemThemeImageViewWithFrame:(CGRect)frame;
+(UIImageView *) BgImageViewFromColors:(NSArray*)colors withFrame: (CGRect)frame;
+(UIImage *)imageFromColor:(UIColor *)color andSize:(CGSize)size;
@end
