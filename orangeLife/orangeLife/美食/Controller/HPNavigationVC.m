//
//  HPNavigationVC.m
//  orangeLife
//
//  Created by 张俊凯 on 16/8/14.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "HPNavigationVC.h"

@interface HPNavigationVC ()

@end

@implementation HPNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏颜色
    self.navigationBar.barTintColor = JKNavBarColor;
    //设置导航栏字体为白色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


//可以在这个方法中拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.childViewControllers.count > 0) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15] ;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        btn.size = CGSizeMake(70, 30);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        
        [btn setImage:[UIImage imageNamed:@"common_title_bar_ic_back_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"common_title_bar_ic_back_pressed"] forState:UIControlStateHighlighted];
        
        //添加按钮动作
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc]initWithCustomView:btn];
        
    }
    
    [super pushViewController:viewController animated:animated];
    
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}




@end
