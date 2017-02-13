//
//  HViewController.m
//  huckster
//
//  Created by Katekov Anton on 2/9/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HViewController.h"
#import "HCurrencyFromCollectionViewCell.h"
#import "HCurrencyToCollectionViewCell.h"
#import "HCurrencyConverter.h"
#import "HDataProvider.h"
#import "HInfiniteCollectionView.h"
#import "HFormatting.h"
#import "UIView+Utils.h"



@interface HViewController () <UICollectionViewDataSource, UICollectionViewDelegate, HCurrencyCellDataSource, UITextFieldDelegate> {
    HCurrency *_currencyFrom;
    HCurrency *_currencyTo;
    
    double _selected;
    NSString *_selectedText;
}

@end



@implementation HViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selected = 100;
    _text.text = @"100";
    _selectedText = _text.text;

    {
        [_collectionCurrencyFrom registerNib:[UINib nibWithNibName:@"HCurrencyFromCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HCurrencyFromCollectionViewCell"];
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)_collectionCurrencyFrom.collectionViewLayout;
        layout.itemSize = CGSizeMake(self.view.bounds.size.width, 120);
        
        _collectionCurrencyFrom.pagingEnabled = YES;
        _collectionCurrencyFrom.dataSource = self;
        _collectionCurrencyFrom.delegate = self;
    }
    {
        [_collectionCurrencyTo registerNib:[UINib nibWithNibName:@"HCurrencyToCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HCurrencyToCollectionViewCell"];
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)_collectionCurrencyTo.collectionViewLayout;
        layout.itemSize = CGSizeMake(self.view.bounds.size.width, 120);
        
        _collectionCurrencyTo.pagingEnabled = YES;
        _collectionCurrencyTo.dataSource = self;
        _collectionCurrencyTo.delegate = self;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrenciesChanged:) name:HDataProviderDidReloadRates object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadingChanged:) name:HDataProviderDidChangeLoadingState object:nil];
    
    
    [self updateSelectedCurrencies];
    [self updateLoadingState];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_text becomeFirstResponder];
}

- (void)onCurrenciesChanged:(id)notification
{
    [_collectionCurrencyTo reloadData];
    [_collectionCurrencyFrom reloadData];
    
    _pageCurrencyTo.numberOfPages = [HDataProvider sharedInstance].converter.convertableCurrencies.count;
    _pageCurrencyFrom.numberOfPages = [HDataProvider sharedInstance].converter.convertableCurrencies.count;
    
    [self updateSelectedCurrencies];
}

- (void)onLoadingChanged:(id)param
{
    [self updateLoadingState];
}

- (IBAction)onExchange:(id)sender
{
    if (_currencyFrom.identifier.length == 0) {
        return;
    }
    if (_currencyTo.identifier.length == 0) {
        return;
    }
    NSError *error = nil;
    [[HDataProvider sharedInstance].converter performConvertationWithValue:_selected fromCurrency:_currencyFrom toCurrency:_currencyTo error:&error];
    if (error != nil) {
        NSInteger code = error.code;
        if (code == kErrorCodeCurrencyConverterInsufficientFunds) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                           message:@"You don't have enough funds to perform this exchange."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert setModalPresentationStyle:UIModalPresentationPopover];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleCancel
                                                    handler:NULL]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return;
    }
    _selected = 0;
    _text.text = @"";
    _selectedText = @"0";
    [self runExchangeAnimation];
    [self updateCollectionViewsContent];
}

- (void)runExchangeAnimation
{
    _imageAnimation.image = [UIImage imageWithView:_collectionCurrencyFrom.visibleCells[0]];
    _imageAnimation.hidden = NO;
    _imageAnimation.transform = CGAffineTransformIdentity;
    _imageAnimation.alpha = 1;
    [UIView animateWithDuration:[CATransaction animationDuration]
                     animations:^
     {
         _imageAnimation.transform = CGAffineTransformMakeTranslation(0, 100);
         _imageAnimation.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         _imageAnimation.alpha = 1;
         _imageAnimation.transform = CGAffineTransformIdentity;
         _imageAnimation.hidden = YES;
     }];
}

#pragma mark - Helpers

- (HCurrency *)selectedCurrencyInCollectionView:(HInfiniteCollectionView *)collectionView
{
    NSUInteger index = (collectionView.contentOffset.x + collectionView.frame.size.width / 2) / collectionView.frame.size.width;
    HCurrency *result = [HDataProvider sharedInstance].converter.convertableCurrencies[index % collectionView.duplicateCount];
    return result;
}

- (void)setCurrencyFrom:(HCurrency *)currencyFrom currencyTo:(HCurrency *)currencyTo
{
    BOOL destinationCurrencyChanged = currencyFrom != nil && _currencyTo != nil &&![currencyFrom isEqual:_currencyFrom];
    
    if (destinationCurrencyChanged) {
        NSError *error = nil;
        double newSelected = [[HDataProvider sharedInstance].converter calculateConvertationWithValue:_selected fromCurrency:_currencyFrom toCurrency:currencyFrom error:&error];
        if (error == nil) {
            _selected = newSelected;
            
            NSString *newText = [[HFormatting formatterForImportantValues] stringFromNumber:@(_selected)];
            if ([newText isEqualToString:@"0"]) {
                newText = @"";
            }
            _text.text = newText;
            _selectedText = _text.text;
        }
    }
    
    _currencyTo = currencyTo;
    _currencyFrom = currencyFrom;
    
    if (destinationCurrencyChanged) {
        [self updateCollectionViewsContent];
    }
    
    _pageCurrencyFrom.currentPage = [[HDataProvider sharedInstance].converter.convertableCurrencies indexOfObject:currencyFrom];
    _pageCurrencyTo.currentPage = [[HDataProvider sharedInstance].converter.convertableCurrencies indexOfObject:currencyTo];
    
    if ([currencyFrom isEqual:currencyTo] ||
        currencyFrom.identifier.length == 0 ||
        currencyTo.identifier.length == 0) {
        _buttonExchange.enabled = NO;
        _labelRate.text = @"";
        return;
    }
    _buttonExchange.enabled = YES;
    
    NSError *error = nil;
    double rate = [[HDataProvider sharedInstance].converter conversionRateFromCurrency:currencyFrom toCurrency:currencyTo error:&error];
    if (error != nil) {
        _labelRate.text = [error description];
        return;
    }
    
    _labelRate.attributedText = [HFormatting rateStringWithSourceCurrencySign:currencyFrom.sign destinationCurrencySign:currencyTo.sign rate:rate];
}

- (void)setNewSelectedValue:(double)value
{
    _selected = value;
    [self updateCollectionViewsContent];
}

- (void)updateCollectionViewsContent
{
    for (HCurrencyFromCollectionViewCell *cell in _collectionCurrencyFrom.visibleCells) {
        [cell update];
    }
    for (HCurrencyToCollectionViewCell *cell in _collectionCurrencyTo.visibleCells) {
        [cell update];
    }
}

- (void)updateSelectedCurrencies
{
    HCurrency *currencyFrom = [self selectedCurrencyInCollectionView:_collectionCurrencyFrom];
    HCurrency *currencyTo = [self selectedCurrencyInCollectionView:_collectionCurrencyTo];
    
    [self setCurrencyFrom:currencyFrom currencyTo:currencyTo];
}

- (void)updateLoadingState
{
    BOOL firstLoading = [HDataProvider sharedInstance].loading && [HDataProvider sharedInstance].converter.convertableRates.count == 0;
    
    _labelRate.hidden = firstLoading;
    _activityLoading.hidden = !firstLoading;
    if (firstLoading) {
        [_activityLoading startAnimating];
    }
}

#pragma mark - UICollectionViewDataSource <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [HDataProvider sharedInstance].converter.convertableCurrencies.count;
}

- (__kindof UICollectionViewCell *)collectionView:(HInfiniteCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HCurrency *cellCurrency =  [HDataProvider sharedInstance].converter.convertableCurrencies[indexPath.row % collectionView.duplicateCount];
    
    if (collectionView == _collectionCurrencyFrom) {
        HCurrencyFromCollectionViewCell *result = (HCurrencyFromCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HCurrencyFromCollectionViewCell" forIndexPath:indexPath];
        
        result.currency = cellCurrency;
        result.dataSource = self;
        
        return result;
    }
    else {
        HCurrencyToCollectionViewCell *result = (HCurrencyToCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HCurrencyToCollectionViewCell" forIndexPath:indexPath];
        
        result.currency = cellCurrency;
        result.dataSource = self;
        
        return result;
    }
}

#pragma mark - UICollectionViewDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateSelectedCurrencies];
}

#pragma mark - HCurrencyCellDataSource <NSObject>

- (double)selectedInCurrency:(HCurrency *)currency
{
    return [[HDataProvider sharedInstance].converter calculateConvertationWithValue:_selected fromCurrency:_currencyFrom toCurrency:currency error:NULL];
}

- (NSString *)selectedTextInCurrency:(HCurrency *)currency
{
    if ([currency isEqual:_currencyFrom]) {
        return _selectedText;
    }
    return nil;
}

- (double)availableInCurrency:(HCurrency *)currency
{
    return [[HDataProvider sharedInstance].converter balanceForCurrency:currency];
}

- (double)rateForDestinationCurrency:(HCurrency *)currency
{
    NSError *error = nil;
    double rate = [[HDataProvider sharedInstance].converter conversionRateFromCurrency:currency toCurrency:_currencyFrom error:&error];
    if (error == nil) {
        return rate;
    }
    return 1.0;
}

- (HCurrency *)sourceCurrency
{
    return _currencyFrom;
}

#pragma mark - UITextFieldDelegate <NSObject>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([resultString rangeOfString:@",,"].length != 0) {
        return NO;
    }
    
    _selectedText = resultString;
    NSString *doubleString = [resultString stringByReplacingOccurrencesOfString:@"," withString:@"."];
    [self setNewSelectedValue:[doubleString doubleValue]];
    return YES;
}

@end
