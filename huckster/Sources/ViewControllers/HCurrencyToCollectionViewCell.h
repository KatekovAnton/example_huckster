//
//  HCurrencyToCollectionViewCell.h
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCurrencyCellDataSource.h"



@class HCurrency;



@interface HCurrencyToCollectionViewCell : UICollectionViewCell {
    IBOutlet UILabel *_labelCurrency;
    IBOutlet UILabel *_labelAvailableSum;
    IBOutlet UILabel *_labelSelectedSum;
    IBOutlet UILabel *_labelRate;
}

@property(nonatomic, weak) id<HCurrencyCellDataSource> dataSource;
@property(nonatomic) HCurrency *currency;

- (void)update;

@end
