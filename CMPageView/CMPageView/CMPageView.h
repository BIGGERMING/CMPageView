//
//  CMPageView.h
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMPageViewConfig;

@interface CMPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       config:(CMPageViewConfig *)config
                   titleArray:(NSArray<NSString *> *)titleArray
                chiledVcArray:(NSArray<UIViewController *> *)chiledVcArray
                     parentVc:(UIViewController *)parentVc;
@end
