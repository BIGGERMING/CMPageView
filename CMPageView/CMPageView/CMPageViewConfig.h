//
//  CMPageViewConfig.h
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMPageViewConfig : NSObject

// titleView高度
@property (nonatomic, assign) CGFloat titleHeight;

// titleView字体大小
@property (nonatomic, assign) CGFloat fontSize;

// titleView文字之间的间距
@property (nonatomic, assign) CGFloat titleMargin;

// titleView文字的普通颜色
@property (nonatomic, strong) UIColor *normalColor;

// titleView文字的选中颜色
@property (nonatomic, strong) UIColor *selectColor;

// titleView是否可以滚动
@property (nonatomic, assign) BOOL isScrollEnable;

@property (nonatomic, assign) BOOL isShowBottomLine;


@end
