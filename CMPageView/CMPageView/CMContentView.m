//
//  CMContentView.m
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import "CMContentView.h"

#import "CMTitleView.h"
static NSString *const CellID = @"UICollectionViewCell";

@interface CMContentView ()<UICollectionViewDataSource,UICollectionViewDelegate,CMTitleViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIViewController *parentVc;

@property (nonatomic, strong) NSArray<UIViewController *> *chiledVcArray;

@property (nonatomic, assign) CGFloat startOffetX;

@property (nonatomic, assign) BOOL forbidDelegate; // 禁止调用 ContenViewDelegate 

@end

@implementation CMContentView

- (instancetype)initWithFrame:(CGRect)frame chiledVcArray:(NSArray<UIViewController *> *)chiledVcArray parentVc:(UIViewController *)parentVc
{
    if (self = [super initWithFrame:frame]) {
        
        self.chiledVcArray = chiledVcArray;
        
        self.parentVc = parentVc;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.collectionView];
    
    // 添加到父控制器
    for (UIViewController *childVc in self.chiledVcArray) {
        [_parentVc addChildViewController:childVc];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellID];
        
    }
    return _collectionView;
}

- (void)collectionViewDidEndScroll
{
    // collectionView停止下标
    NSInteger index = _collectionView.contentOffset.x / _collectionView.bounds.size.width;
    
    // 代理改变titleView位置
    if ([self.delegate respondsToSelector:@selector(contentView:index:)]) {
        [self.delegate contentView:self index:index];
    }

}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{    
    return _chiledVcArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    // 移除
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }

    UIViewController *childVc = self.chiledVcArray[indexPath.item];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];

    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self collectionViewDidEndScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) { // 没有减速状态,拖动时很快,减速为0 也要改变titleView位置
        [self collectionViewDidEndScroll];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.forbidDelegate = NO;

    self.startOffetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == self.startOffetX || self.forbidDelegate) { // 没有拖动 或 只点击title时
        return;
    }
    
    CGFloat progress = 0;
    NSInteger targetIndex = 0;
    NSInteger sourceIndex = self.startOffetX / _collectionView.bounds.size.width;
    
    if (_collectionView.contentOffset.x > _startOffetX) { // 左滑
        targetIndex = sourceIndex + 1;
        progress = (_collectionView.contentOffset.x - _startOffetX) / _collectionView.bounds.size.width;
    } else { // 右滑
        targetIndex = sourceIndex - 1;
        progress = (_startOffetX - _collectionView.contentOffset.x) / _collectionView.bounds.size.width;
    }

    if ([self.delegate respondsToSelector:@selector(contentview:sourceIndex:targetIndex:progress:)]) {
        [self.delegate contentview:self sourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
    }
}

#pragma mark - CMTitleViewDelegate
- (void)titleViewDelegate:(CMTitleView *)titleView currentIndex:(NSInteger)currentIndex
{
    self.forbidDelegate = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    
    // 滚动collectionView到下标位置
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

@end
