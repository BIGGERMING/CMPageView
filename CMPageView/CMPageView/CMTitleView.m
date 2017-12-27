//
//  CMTitleView.m
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import "CMTitleView.h"

#import "CMPageViewConfig.h"
#import "CMContentView.h"

@interface CMTitleView()<CMContenViewDelegate>

@property (nonatomic, strong) CMPageViewConfig *config;

@property (nonatomic, strong) UIScrollView *titleScrollView;

@property (nonatomic, strong) NSArray<NSString *> *titleArray;

@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabelArray;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CMTitleView

- (instancetype)initWithFrame:(CGRect)frame config:(CMPageViewConfig *)config titleArray:(NSArray<NSString *> *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        
        self.config     = config;
        self.titleArray = titleArray;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - getter
- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.scrollsToTop = NO;
    }
    return _titleScrollView;
}

- (NSMutableArray<UILabel *> *)titleLabelArray
{
    if (!_titleLabelArray) {
        _titleLabelArray = [[NSMutableArray alloc] init];
    }
    return _titleLabelArray;
}

- (NSInteger)currentIndex
{
    if (!_currentIndex) {
        _currentIndex = 0;
    }
    return _currentIndex;
}

#pragma mark - methods
- (void)setupUI
{
    [self addSubview:self.titleScrollView];
    
    [self setupTitleLabel];
    
    [self setupLabelFrame];
}

- (void)setupTitleLabel
{
    [_titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger i, BOOL * _Nonnull stop) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = i;
        titleLabel.text = title;
        titleLabel.textColor = i == 0 ? _config.selectColor : _config.normalColor;
        titleLabel.font = [UIFont systemFontOfSize:_config.fontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [titleLabel addGestureRecognizer:tap];
        titleLabel.userInteractionEnabled = YES;
        
        [self.titleLabelArray addObject:titleLabel];
        [self.titleScrollView addSubview:titleLabel];
    }];
}

- (void)setupLabelFrame
{
    [_titleLabelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull titleLabel, NSUInteger i, BOOL * _Nonnull stop) {
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        CGFloat labelW = 0;

        if (_config.isScrollEnable) { // 滚动
            NSDictionary *dict = @{
                                   NSFontAttributeName : titleLabel.font
                                   };
            labelW = [_titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:dict context:nil].size.width;
            
            labelX = i == 0 ? _config.titleMargin * 0.5 : CGRectGetMaxX(_titleLabelArray[i - 1].frame) + _config.titleMargin;
            
        } else { // 不滚动
            
            labelW = self.bounds.size.width / _titleLabelArray.count;
            labelX = labelW * i;
        }
        
        titleLabel.frame = CGRectMake(labelX, labelY, labelW, _config.titleHeight);
    }];
    
    if (_config.isScrollEnable) { // 滚动
        _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(_titleLabelArray.lastObject.frame) + _config.titleMargin * 0.5, 0);
    }
}

- (void)titleLabelClick:(UITapGestureRecognizer *)tap
{
    UILabel *targetLabel = (UILabel *)tap.view;
    
    if (!targetLabel) {
        return;
    }
    
    if (targetLabel.tag == _currentIndex) { // 重复点击不执行后续代码
        return;
    }
    
    UILabel *sourceLabel  = _titleLabelArray[self.currentIndex];
    sourceLabel.textColor = _config.normalColor;
    targetLabel.textColor  = _config.selectColor;
    
    _currentIndex = targetLabel.tag;
    
    // 点击的label居中显示
    [self moveTargetLabelToCenter:targetLabel];
    
    if ([self.delegate respondsToSelector:@selector(titleViewDelegate:currentIndex:)]) {
        
        // 联动collectionView
        [self.delegate titleViewDelegate:self currentIndex:_currentIndex];
    }
}

- (void)moveTargetLabelToCenter:(UILabel *)targetLabel
{
    if (!self.config.isScrollEnable) {
        
        return;
    }
    
    // 文字居中
    CGFloat offsetX = targetLabel.center.x - self.bounds.size.width * 0.5;
    
    // 临界值判断
    if (offsetX < 0){
        offsetX = 0;
    } else if (offsetX > _titleScrollView.contentSize.width - _titleScrollView.bounds.size.width) {
        
        offsetX = _titleScrollView.contentSize.width - _titleScrollView.bounds.size.width;
    }
    
    [_titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (NSArray *)getRGBWithColor:(UIColor *)color
{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    
    [color getRed:&red green:&green blue:&blue alpha:nil];
    
    NSArray *array = @[@(red),@(green),@(blue)];
    return array;
}

#pragma mark - CMContenViewDelegate
- (void)contentView:(CMContentView *)contentView index:(NSInteger)index
{
    _currentIndex = index;
    
    [self moveTargetLabelToCenter:_titleLabelArray[index]];
}

- (void)contentview:(CMContentView *)contentView sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress {
    // 下标超出,固定为 0
    if (targetIndex < 0) {
        targetIndex = 0;
    }
#warning 当前页面全部呈现 紧接着滑动到下个页面 字体颜色会有问题
    UILabel *sourceLabel = self.titleLabelArray[sourceIndex];
    UILabel *targetLabel = self.titleLabelArray[targetIndex];

    // 颜色渐变
    NSArray *normalRGB = [self getRGBWithColor:_config.normalColor];
    NSArray *selectRGB = [self getRGBWithColor:_config.selectColor];
    
    CGFloat deltaR = [selectRGB[0] integerValue] - [normalRGB[0] integerValue];
    CGFloat deltaG = [selectRGB[1] integerValue] - [normalRGB[1] integerValue];
    CGFloat deltaB = [selectRGB[2] integerValue] - [normalRGB[2] integerValue];

    sourceLabel.textColor = [UIColor colorWithRed:[selectRGB[0] integerValue] - progress *deltaR
                                            green:[selectRGB[1] integerValue] - progress *deltaG
                                             blue:[selectRGB[2] integerValue] - progress *deltaB
                                            alpha:1];
    targetLabel.textColor = [UIColor colorWithRed:[normalRGB[0] integerValue] + progress *deltaR
                                            green:[normalRGB[1] integerValue] + progress *deltaG
                                             blue:[normalRGB[2] integerValue] + progress *deltaB
                                            alpha:1];
}
@end
