//
//  CMPageView.m
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import "CMPageView.h"

#import "CMTitleView.h"
#import "CMContentView.h"
#import "CMPageViewConfig.h"
@interface CMPageView ()

@property (nonatomic, strong) CMPageViewConfig *config;

@property (nonatomic, strong) CMTitleView *titleView;

@property (nonatomic, strong) CMContentView *contentView;

@property (nonatomic, strong) UIViewController *parentVc;

@property (nonatomic, strong) NSArray<NSString *> *titleArray;

@property (nonatomic, strong) NSArray<UIViewController *> *chiledVcArray;

@end

@implementation CMPageView

- (instancetype)initWithFrame:(CGRect)frame config:(CMPageViewConfig *)config titleArray:(NSArray<NSString *> *)titleArray chiledVcArray:(NSArray<UIViewController *> *)chiledVcArray parentVc:(UIViewController *)parentVc
{
    if (self = [super initWithFrame:frame]) {
        
        self.config         = config;
        self.titleArray     = titleArray;
        self.chiledVcArray  = chiledVcArray;
        self.parentVc       = parentVc;
        
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.titleView];
    
    [self addSubview:self.contentView];
}

#pragma mark - getter
- (CMTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[CMTitleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.config.titleHeight)
                                                 config:self.config
                                             titleArray:self.titleArray];
        _titleView.backgroundColor = [UIColor orangeColor];
        
        _titleView.delegate = self.contentView;
    }
    return _titleView;
}

- (CMContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[CMContentView alloc] initWithFrame:CGRectMake(0, _config.titleHeight, self.bounds.size.width, self.bounds.size.height - _config.titleHeight)
                                              chiledVcArray:self.chiledVcArray
                                                   parentVc:_parentVc];
        _contentView.backgroundColor = [UIColor purpleColor];
        _contentView.delegate = self.titleView;
    }
    return _contentView;
}
@end
