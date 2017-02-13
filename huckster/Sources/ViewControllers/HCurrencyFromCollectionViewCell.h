//
//  HCurrencyFromCollectionViewCell.h
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCurrencyCellDataSource.h"



@class HCurrency;
@class HCurrencyConverter;



@interface HCurrencyFromCollectionViewCell : UICollectionViewCell {
    IBOutlet UILabel *_labelCurrency;
    IBOutlet UILabel *_labelAvailableSum;
    IBOutlet UILabel *_labelSelectedSum;
}

@property(nonatomic, weak) id<HCurrencyCellDataSource> dataSource;
@property(nonatomic) HCurrency *currency;

- (void)update;

@end
