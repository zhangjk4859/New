//
//  HPUtils.m
//  orangeLife
//
//  Created by 张俊凯 on 16/8/2.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "HPUtils.h"

//为获取MAC地址而服务的头文件
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation HPUtils
+(NSString *)getCurrentTime
{
    NSDate  * senddate=[NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormat stringFromDate:senddate];
}

//获取公共字典
+(NSMutableDictionary *)getBasicDictionary
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    NSString *tableName = @"user_table";
    // 创建名为user_table的表，如果已存在，则忽略该操作
    [store createTableWithName:tableName];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"mobileCode"] = [store getStringById:kUserUUID fromTable:tableName];
    params[@"version"] = @"2";//安卓
    params[@"versionName"] = @"1.1";//安卓
    params[@"type"] =@"jvzhi" ;
    params[@"device"] = @(0);//安卓，数字
    //params[@"license"] = @"testLicense";//license为空
    params[@"mac"] = [self getMacaddress];
    
    //设置GPS
    NSMutableDictionary *GPSDic = [NSMutableDictionary dictionary];
    GPSDic[@"lat"] = @"37.785834";//GPS信息为空
    GPSDic[@"lng"] = @"-122.406417";
    GPSDic[@"accuracy"] = @"5";
    GPSDic[@"locationType"] = @(0) ;
    GPSDic[@"time"] = @(0);
    
    
    params[@"point"] = GPSDic;    //GPS信息   必
    
    return params;
}

//获取MAC地址
+ (NSString *)getMacaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
    
}

//两个方法，直接返回一个系统级别的imageView
+(UIImageView *)creatSystemThemeImageViewWithFrame:(CGRect)frame
{
    NSMutableArray *colorArray = [@[systemRedColor,systemOrangeColor] mutableCopy];
    return  [self BgImageViewFromColors:colorArray withFrame:frame];
    
}

//通过多个颜色生成一个渐变的图片视图
+(UIImageView *) BgImageViewFromColors:(NSArray*)colors withFrame: (CGRect)frame

{
    
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        
        [ar addObject:(id)c.CGColor];
        
    }
    
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    CGPoint start;
    
    CGPoint end;
    
    //    start = CGPointMake(0.0, frame.size.height);
    //
    //    end = CGPointMake(frame.size.width, 0.0);
    
    start = CGPointMake(JKScreenW * 0.5, frame.size.height);
    end = CGPointMake(frame.size.width, JKScreenW * 0.5);
    
    
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    return imageView;
    
}

//通过单个颜色生成图片
+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0,size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
