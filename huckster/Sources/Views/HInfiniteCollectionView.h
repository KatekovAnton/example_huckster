//
//  HInfiniteCollectionView.h
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HInfiniteCollectionView : UICollectionView

@property (nonatomic, readonly) NSUInteger duplicateCount;

- (NSIndexPath *)realIndexPathAtIndexPath:(NSIndexPath *)indexPath;

@end
