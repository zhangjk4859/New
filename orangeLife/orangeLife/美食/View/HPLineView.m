//
//  HPLineView.m
//  桔子信用
//
//  Created by 张俊凯 on 16/6/25.
//  Copyright © 2016年 禾浦科技. All rights reserved.
//

#import "HPLineView.h"

@implementation HPLineView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.4;
    }
    return self;
}

-(void)awakeFromNib{
    self.alpha = 0.4;
}

@end
