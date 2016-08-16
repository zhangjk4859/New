//
//  HPErrorView.m
//  orangeLife
//
//  Created by 张俊凯 on 16/8/16.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "HPErrorView.h"

@implementation HPErrorView

+(instancetype)errorView
{
    HPErrorView *errorView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    
    return errorView;
}
- (IBAction)refreshAction {
    
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
