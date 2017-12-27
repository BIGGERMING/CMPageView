//
//  CMTitleView.h
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMPageViewConfig,CMTitleView;

@protocol CMTitleViewDelegate <NSObject>

- (void)titleViewDelegate:(CMTitleView *)titleView
             currentIndex:(NSInteger)currentIndex;

@end

@interface CMTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       config:(CMPageViewConfig *)config
                   titleArray:(NSArray<NSString *> *)titleArray;

@property (nonatomic, weak) id<CMTitleViewDelegate> delegate;

@end
