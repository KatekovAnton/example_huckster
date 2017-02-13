//
//  HCurrencyConverter.m
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HCurrencyConverter.h"
#import "HCurrency.h"
#import "HAccount.h"
#import "HRate.h"



NSString * const kErrorDomainCurrencyConverter = @"kErrorDomainCurrencyConverter";
NSInteger const kErrorCodeCurrencyConverterInvalidCurrency = 1;
NSInteger const kErrorCodeCurrencyConverterInsufficientFunds = 2;



@interface HAccount (HCurrencyConverter_private)

@property (nonatomic, copy) NSNumber *balanceEur;
@property (nonatomic, copy) NSNumber *balanceUsd;
@property (nonatomic, copy) NSNumber *balanceGbp;

@end



@interface HCurrencyConverter () {
    NSMutableDictionary *_ratesByCurrency;
}

@end



@implementation HCurrencyConverter

- (id)initWithAccount:(HAccount *)account
{
    if (self = [super init]) {
        _account = account;
    }
    return self;
}

- (BOOL)performConvertationWithValue:(double)value fromCurrency:(HCurrency *)from toCurrency:(HCurrency *)to error:(NSError **)error
{
    double currentBalance = [self balanceForCurrency:from];
    if (currentBalance < value) {
        *error =  [NSError errorWithDomain:kErrorDomainCurrencyConverter
                                      code:kErrorCodeCurrencyConverterInsufficientFunds
                                  userInfo:nil];
        return NO;
    }
    
    double newCurrentBalance = currentBalance - value;
    
    NSError *internalError = nil;
    double convertedValue = [self calculateConvertationWithValue:value fromCurrency:from toCurrency:to error:&internalError];
    if (internalError != nil) {
        *error = internalError;
        return NO;
    }
    
    double newBalanceForDestinationCurrency = [self balanceForCurrency:to] + convertedValue;
    
    [self setBalance:newCurrentBalance forCurrency:from];
    [self setBalance:newBalanceForDestinationCurrency forCurrency:to];
    
    return YES;
}

- (double)currencyRate:(HCurrency *)currency error:(NSError **)error
{
    HRate *rate = _ratesByCurrency[currency.identifier];
    if (rate == nil) {
        if (![currency isEqual:[HCurrency baseCurrency]]) {
            *error =  [NSError errorWithDomain:kErrorDomainCurrencyConverter
                                          code:kErrorCodeCurrencyConverterInvalidCurrency
                                      userInfo:@{@"currency" : currency}];
        }
        return 1.0;
    }
    else {
        return rate.rate.doubleValue;
    }
}

- (double)calculateConvertationWithValue:(double)value fromCurrency:(HCurrency *)from toCurrency:(HCurrency *)to error:(NSError **)error
{
    NSError *errorInternal = nil;
    double rate = [self conversionRateFromCurrency:from toCurrency:to error:error];
    if (errorInternal != nil) {
        if (error != NULL) {
            *error = errorInternal;
        }
        return 0.0;
    }
    
    return value * rate;
}

- (double)conversionRateFromCurrency:(HCurrency *)from toCurrency:(HCurrency *)to error:(NSError **)error
{
    if ([from isEqual:to]) {
        return 1.0;
    }
    NSError *errorInternal = nil;
    double rateValueFrom = [self currencyRate:from error:&errorInternal];
    if (errorInternal != nil) {
        if (error != NULL) {
            *error = errorInternal;
        }
        return 1.0;
    }
    double rateValueTo = [self currencyRate:to error:error];
    if (errorInternal != nil) {
        if (error != NULL) {
            *error = errorInternal;
        }
        return 1.0;
    }
    
    return rateValueTo / rateValueFrom;
}

- (void)setRates:(NSArray<__kindof HRate *> *)rates
{
    _rates = [rates copy];
    [self updateConvertableRates];
}

- (void)updateConvertableRates
{
    if (self.rates == nil) {
        return;
    }
    
    _ratesByCurrency = [NSMutableDictionary dictionary];
    NSMutableArray *rates = [NSMutableArray arrayWithCapacity:[HCurrency convertableCurrencies].count];
    NSMutableArray *currencies = [NSMutableArray arrayWithCapacity:[HCurrency convertableCurrencies].count];
    for (HCurrency *currency in [HCurrency convertableCurrencies]) {
        for (HRate *rate in self.rates) {
            if ([rate.currency isEqualToString:currency.identifier]) {
                [rates addObject:rate];
                [currencies addObject:currency];
                [_ratesByCurrency setObject:rate forKey:currency.identifier];
                break;
            }
        }
    }
    [currencies addObject:[HCurrency baseCurrency]];
    
    _convertableRates = rates;
    _convertableCurrencies = currencies;
}

// TODO:
// possible improvement here
// add error:(NSError **)error; to indicate wrong currency

- (double)balanceForCurrency:(HCurrency *)currency
{
    if ([currency.identifier isEqualToString:@"USD"]) {
        return self.account.balanceUsd.doubleValue;
    }
    if ([currency.identifier isEqualToString:@"EUR"]) {
        return self.account.balanceEur.doubleValue;
    }
    if ([currency.identifier isEqualToString:@"GBP"]) {
        return self.account.balanceGbp.doubleValue;
    }

    return 0.0;
}

// TODO:
// possible improvement here
// add error:(NSError **)error; to indicate wrong currency
// or invalid negative balance

- (void)setBalance:(double)balance forCurrency:(HCurrency *)currency
{
    if ([currency.identifier isEqualToString:@"USD"]) {
        self.account.balanceUsd = @(balance);
    }
    if ([currency.identifier isEqualToString:@"EUR"]) {
        self.account.balanceEur = @(balance);
    }
    if ([currency.identifier isEqualToString:@"GBP"]) {
        self.account.balanceGbp = @(balance);
    }
}

- (void)reset
{
    self.account.balanceEur = @(100.0);
    self.account.balanceUsd = @(100.0);
    self.account.balanceGbp = @(100.0);
}

@end
