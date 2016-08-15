//
//  HPUtils.m
//  orangeLife
//
//  Created by 张俊凯 on 16/8/2.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "HPUtils.h"

@implementation HPUtils
+(NSString *)getCurrentTime
{
    NSDate  * senddate=[NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormat stringFromDate:senddate];
}

////获取公共字典
//+(NSMutableDictionary *)getBasicDictionary
//{
//    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
//    NSString *tableName = @"user_table";
//    // 创建名为user_table的表，如果已存在，则忽略该操作
//    [store createTableWithName:tableName];
//    
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    
//    params[@"mobileCode"] = [store getStringById:kUserUUID fromTable:tableName];
//    params[@"version"] = @"2";//安卓
//    params[@"versionName"] = @"1.1";//安卓
//    params[@"type"] =@"jvzhi" ;
//    params[@"device"] = @(0);//安卓，数字
//    params[@"license"] = [[NSUserDefaults standardUserDefaults]valueForKey:kUserLicence];
//    params[@"mac"] = [self getMacaddress];
//    
//    //params[@"sim"] = ;
//    //params[@"simState"] = ;
//    
//    //设置GPS
//    NSMutableDictionary *GPSDic = [NSMutableDictionary dictionary];
//    GPSDic[@"lat"] = [[NSUserDefaults standardUserDefaults]objectForKey:kUserLatitude];
//    GPSDic[@"lng"] = [[NSUserDefaults standardUserDefaults]objectForKey:kUserLongitude];
//    GPSDic[@"accuracy"] = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAccuracy];
//    GPSDic[@"locationType"] = @(0) ;
//    GPSDic[@"time"] = @(0);
//    
//    
//    params[@"point"] = GPSDic;    //GPS信息   必
//    
//    return params;
//}

@end
