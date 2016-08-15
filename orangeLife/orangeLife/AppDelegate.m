//
//  AppDelegate.m
//  orangeLife
//
//  Created by 张俊凯 on 16/7/30.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "AppDelegate.h"
#import "HPBasicViewController.h"
#import "HPTabBarVC.h"
#import "HPShopVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1.创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    //2.创建根控制器
    //2.1创建视图
    //HPTabBarVC *tabBarVC = [[HPTabBarVC alloc] init];
    HPShopVC *shopVC = [[HPShopVC alloc] init];
    HPNavigationVC *nav = [[HPNavigationVC alloc] initWithRootViewController:shopVC];
    self.window.rootViewController = nav;
    
    //3.存储UUID
    [self storeUUID];
    
    return YES;
}

//首次启动检查存储UUID
-(void)storeUUID
{
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    NSString *tableName = @"user_table";
    // 创建名为user_table的表，如果已存在，则忽略该操作
    [store createTableWithName:tableName];
    
    NSString *uuid = [store getStringById:kUserUUID fromTable:tableName];
    if (uuid == nil) {
        
        NSString *UUIDString = [[UIDevice currentDevice] uuid];
        [store putString:UUIDString withId:kUserUUID intoTable:tableName];
    }
    JKLog(@"%@ %lu",uuid,(unsigned long)uuid.length);
    
}


@end
