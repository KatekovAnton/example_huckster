//
//  HCurrencyToCollectionViewCell.m
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HCurrencyToCollectionViewCell.h"
#import "HCurrencyConverter.h"
#import "HCurrency.h"
#import "HFormatting.h"



@implementation HCurrencyToCollectionViewCell

- (void)setCurrency:(HCurrency *)currency
{
    _currency = currency;
    [self update];
}

- (void)setDataSource:(id<HCurrencyCellDataSource>)dataSource
{
    _dataSource = dataSource;
    [self update];
}

- (void)update
{
    _labelCurrency.text = self.currency.identifier;
    
    NSString *youHaveString = [[HFormatting formatterForImportantValues] stringFromNumber:@([self.dataSource availableInCurrency:self.currency])];
    _labelAvailableSum.text = [NSString stringWithFormat:@"You have %@%@", self.currency.sign, youHaveString];
    
    NSString *selectedText = [[HFormatting formatterForImportantValues] stringFromNumber:@([self.dataSource selectedInCurrency:self.currency])];
    _labelSelectedSum.text = [NSString stringWithFormat:@"+%@", selectedText];
    
    HCurrency *currencyFrom = [self.dataSource sourceCurrency];
    if ([currencyFrom isEqual:self.currency]) {
        _labelRate.text = @"";
    }
    else {
        double rate = [self.dataSource rateForDestinationCurrency:self.currency];
        
        NSString *rateString = [[HFormatting formatterForCurrencyRate] stringFromNumber:@(rate)];
        _labelRate.text = [NSString stringWithFormat:@"%@1 = %@%@", self.currency.sign, currencyFrom.sign, rateString];
    }
}

@end
