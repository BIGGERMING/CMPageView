//
//  CMContentView.h
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMContentView;

@protocol CMContenViewDelegate <NSObject>

- (void)contentView:(CMContentView *)contentView index:(NSInteger)index;

- (void)contentview:(CMContentView *)contentView
        sourceIndex:(NSInteger)sourceIndex
        targetIndex:(NSInteger)targetIndex
           progress:(CGFloat)progress;
@end

@interface CMContentView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                chiledVcArray:(NSArray<UIViewController *> *)chiledVcArray
                     parentVc:(UIViewController *)parentVc;

@property (nonatomic, weak) id<CMContenViewDelegate> delegate;

@end
