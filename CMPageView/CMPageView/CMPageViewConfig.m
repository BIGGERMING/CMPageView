//
//  CMPageViewConfig.m
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import "CMPageViewConfig.h"

@implementation CMPageViewConfig
- (instancetype)init
{
    if (self = [super init]) {
        // 默认配置
        _titleHeight    = 40;
        
        _normalColor    = [UIColor whiteColor];
        
        _selectColor    = [UIColor redColor];
        
        _fontSize       = 15;
        
        _titleMargin    = 30;
        
        _isScrollEnable = NO;
    }
    return self;
}

@end
