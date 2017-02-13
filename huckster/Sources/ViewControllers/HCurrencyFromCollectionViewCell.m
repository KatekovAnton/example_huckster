//
//  HCurrencyFromCollectionViewCell.m
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HCurrencyFromCollectionViewCell.h"
#import "HCurrencyConverter.h"
#import "HCurrency.h"
#import "HFormatting.h"



@implementation HCurrencyFromCollectionViewCell

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
    
    double youHave = [self.dataSource availableInCurrency:self.currency];
    double selected = [self.dataSource selectedInCurrency:self.currency];
    
    NSString *youHaveString = [[HFormatting formatterForImportantValues] stringFromNumber:@(youHave)];
    _labelAvailableSum.text = [NSString stringWithFormat:@"You have %@%@", self.currency.sign, youHaveString];
    
    NSString *selectedText = [self.dataSource selectedTextInCurrency:self.currency];
    if (selectedText.length > 0) {
        _labelSelectedSum.text = [NSString stringWithFormat:@"-%@", selectedText];
    }
    else {
        NSString *selectedSum = [[HFormatting formatterForImportantValues] stringFromNumber:@(selected)];
        _labelSelectedSum.text = selectedSum;
    }
    
    if (youHave >= selected) {
        _labelAvailableSum.textColor = [UIColor blackColor];
    }
    else {
        _labelAvailableSum.textColor = [UIColor redColor];
    }
}

@end
