//
//  HDataProvider.m
//  huckster
//
//  Created by Katekov Anton on 2/9/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HDataProvider.h"
#import "HNetworkManager.h"
#import "HRatesRequestController.h"
#import "HCurrencyConverter.h"
#import "HAccount.h"
#import "HRate.h"



NSString * const HDataProviderDidChangeLoadingState = @"HDataProviderDidChangeLoadingState";
NSString * const HDataProviderDidReloadRates        = @"HDataProviderDidReloadRates";



@interface HDataProvider () {
    HRatesRequestController *_ratesRequest;
}

@end



@implementation HDataProvider

+ (HDataProvider *)sharedInstance
{
    static HDataProvider *sharedInstance = nil;
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [HDataProvider new];
        }
    }
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        [HNetworkManager initializeWithBaseURL:[NSURL URLWithString:@"https://www.ecb.europa.eu/"]];
        
        _account = [[HAccount alloc] init];
        _converter = [[HCurrencyConverter alloc] initWithAccount:self.account];
        [_converter reset];
        
        [self reloadRates];
    }
    return self;
}

- (void)reloadRates
{
    _loading = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:HDataProviderDidChangeLoadingState object:self];
    [_ratesRequest abortLoading];
    _ratesRequest = [HRatesRequestController new];
    __weak typeof(self) __weakself = self;
    [_ratesRequest loadECBRatesWithCompletionHandler:^(NSArray<__kindof HRate *> *result, NSError *error)
     {
         [__weakself onRatesLoaded:result withError:error];
     }];
}

- (void)onRatesLoaded:(NSArray *)rates withError:(NSError *)error
{
    _loading = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:HDataProviderDidChangeLoadingState object:self];
    
    NSTimeInterval reloadDelay = 1;
    if (rates.count != 0) {
        reloadDelay = 30;
        [self.converter setRates:rates];
        [[NSNotificationCenter defaultCenter] postNotificationName:HDataProviderDidReloadRates object:self];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reloadDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadRates];
    });
}

@end
