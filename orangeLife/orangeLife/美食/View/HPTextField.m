//
//  HPTextField.m
//  桔子信用
//
//  Created by 张俊凯 on 16/5/31.
//  Copyright © 2016年 禾浦科技. All rights reserved.
//

#import "HPTextField.h"

@implementation HPTextField

//两件事情，第一件，光标颜色设置成白色，占位文字设置成白色

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tintColor = [UIColor whiteColor];//光标颜色
        self.textColor = [UIColor blackColor];//文字颜色
        self.clearButtonMode = UITextFieldViewModeAlways;//右边的小叉号
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.tintColor = [UIColor whiteColor];
    self.textColor = [UIColor blackColor];
    self.clearButtonMode = UITextFieldViewModeAlways;
}

@end
