//
//  HCurrencyConverter.h
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCurrency.h"



@class HAccount;
@class HRate;



extern NSString * const kErrorDomainCurrencyConverter;
extern NSInteger const kErrorCodeCurrencyConverterInvalidCurrency;
extern NSInteger const kErrorCodeCurrencyConverterInsufficientFunds;



@interface HCurrencyConverter : NSObject

@property (nonatomic, readonly) HAccount *account;
@property (nonatomic, copy) NSArray<__kindof HRate *> *rates;
@property (nonatomic, readonly) NSArray<__kindof HRate *> *convertableRates;
@property (nonatomic, readonly) NSArray<__kindof HCurrency *> *convertableCurrencies;

- (id)initWithAccount:(HAccount *)account;

- (BOOL)performConvertationWithValue:(double)value fromCurrency:(HCurrency *)from toCurrency:(HCurrency *)to error:(NSError **)error;
- (double)calculateConvertationWithValue:(double)value fromCurrency:(HCurrency *)from toCurrency:(HCurrency *)to error:(NSError **)error;
- (double)conversionRateFromCurrency:(HCurrency *)from toCurrency:(HCurrency *)to error:(NSError **)error;
- (double)balanceForCurrency:(HCurrency *)currency;

- (void)reset;

@end
