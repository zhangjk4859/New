//
//  HPSingleNavController.m
//  桔子信用
//
//  Created by 张俊凯 on 16/6/7.
//  Copyright © 2016年 禾浦科技. All rights reserved.
//

#import "HPSingleNavController.h"

@interface HPSingleNavController ()

@end

@implementation HPSingleNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    self.navigationBar.barTintColor = JKNavBarColor;
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

//可以在这个方法中拦截所有push进来的控制器（所有都是自定义按钮）
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
        
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
    
    [super pushViewController:viewController animated:animated];
    
    
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
