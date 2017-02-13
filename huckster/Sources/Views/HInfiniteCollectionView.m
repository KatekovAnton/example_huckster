//
//  HInfiniteCollectionView.m
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
// 
//  Adapted version of
//  https://github.com/masoapps/infinite-uicollectionview
//

#import "HInfiniteCollectionView.h"
#import <objc/runtime.h>



@interface HInfiniteCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) BOOL firstTimeFlag;
@property (nonatomic) NSInteger indexOffset;
@property (nonatomic, weak, nullable) id <UICollectionViewDelegate> delegateBackup;
@property (nonatomic, weak, nullable) id <UICollectionViewDataSource> dataSourceBackup;

@end



@implementation HInfiniteCollectionView

- (NSUInteger)duplicateCount
{
    return 3;
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [super setDelegate:self];
    self.delegateBackup = delegate;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource
{
    [super setDataSource:self];
    self.dataSourceBackup = dataSource;
    self.firstTimeFlag = YES;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // forwarding to delegate
    {
        struct objc_method_description hasMethod = protocol_getMethodDescription(@protocol(UICollectionViewDelegate), [anInvocation selector], NO, NO);
        if (hasMethod.name != NULL &&
            [self.delegateBackup respondsToSelector:[anInvocation selector]]) {
            [anInvocation invokeWithTarget:self.delegateBackup];
            return;
        }
    }
    // forwarding to dataSource
    {
        struct objc_method_description hasMethod = protocol_getMethodDescription(@protocol(UICollectionViewDataSource), [anInvocation selector], NO, NO);
        if (hasMethod.name != NULL &&
            [self.dataSourceBackup respondsToSelector:[anInvocation selector]]) {
            [anInvocation invokeWithTarget:self.dataSourceBackup];
            return;
        }
    }
    
    [super forwardInvocation:anInvocation];
}

- (void)centerAfterScroll
{
    if (self.dataSource == nil) {
        return;
    }
    
    if (![self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    CGPoint currentOffset = self.contentOffset;
    CGFloat cellWidth = layout.itemSize.width;
    CGFloat contentWidth = cellWidth * (CGFloat)[self numberOfItemsInSection:0]; // assuming only one section
    CGFloat centerOffsetX = (contentWidth - self.bounds.size.width) / 2.0;
    CGFloat distFromCenter = centerOffsetX - currentOffset.x;
    
    if (fabs(distFromCenter) > (contentWidth / 4)) {
        CGFloat cellcount = distFromCenter/cellWidth;
        NSInteger shiftCells = (NSInteger)((cellcount > 0) ? floor(cellcount) : ceil(cellcount));
        CGFloat offsetCorrection = (fabs(cellcount - (int)cellcount)) * cellWidth;
        
        if (currentOffset.x < centerOffsetX) {
            self.contentOffset = CGPointMake(centerOffsetX - offsetCorrection, currentOffset.y);
        }
        else if (currentOffset.x > centerOffsetX) {
            self.contentOffset = CGPointMake(centerOffsetX + offsetCorrection, currentOffset.y);
        }
        
        self.indexOffset += shiftCells;
        
        [self reloadData];
        
    }
}

- (NSInteger)externalIndex:(NSInteger)indexToCorrect
{
    NSInteger numberOfCells = [self numberOfItemsInSection:0];
    if (numberOfCells == 0) {
        return 0;
    }
    
    if (indexToCorrect < numberOfCells && indexToCorrect >= 0) {
        return indexToCorrect;
    }
    else {
        CGFloat countInIndex = (CGFloat)indexToCorrect / (CGFloat)numberOfCells;
        NSInteger flooredValue = (NSInteger)floor(countInIndex);
        CGFloat offset = numberOfCells * flooredValue;
        return indexToCorrect - offset;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.firstTimeFlag) {
        [self centerAfterScroll];
        self.firstTimeFlag = NO;
    }
}

- (BOOL)isCloseToBorder
{
    if (self.contentOffset.x < 10) {
        return YES;
    }
    if (self.contentOffset.x + self.bounds.size.width > self.contentSize.width - 10) {
        return YES;
    }
    return NO;
}

#pragma mark - UICollectionViewDataSource <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self duplicateCount] * [self.dataSourceBackup collectionView:collectionView
                                                  numberOfItemsInSection:section];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row - self.indexOffset;
    index = [self externalIndex:index];
    index = index % ([self numberOfItemsInSection:0] / [self duplicateCount]);
    
    return [self.dataSourceBackup collectionView:collectionView
                          cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self isCloseToBorder]) {
        [self centerAfterScroll];
    }
    
    if ([self.delegateBackup respondsToSelector:_cmd]) {
        [self.delegateBackup scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate || [self isCloseToBorder]) {
        [self centerAfterScroll];
    }
    
    if ([self.delegateBackup respondsToSelector:_cmd]) {
        [self.delegateBackup scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerAfterScroll];
    
    if ([self.delegateBackup respondsToSelector:_cmd]) {
        [self.delegateBackup scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self centerAfterScroll];
    
    if ([self.delegateBackup respondsToSelector:_cmd]) {
        [self.delegateBackup scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end


