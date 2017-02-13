//
//  HCurrencyCellDataSource.h
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#ifndef HCurrencyCellDataSource_h
#define HCurrencyCellDataSource_h



@class HCurrency;



@protocol HCurrencyCellDataSource <NSObject>

- (double)selectedInCurrency:(HCurrency *)currency;
- (NSString *)selectedTextInCurrency:(HCurrency *)currency;
- (double)availableInCurrency:(HCurrency *)currency;
- (double)rateForDestinationCurrency:(HCurrency *)currency;
- (HCurrency *)sourceCurrency;

@end


#endif /* HCurrencyCellDataSource_h */
