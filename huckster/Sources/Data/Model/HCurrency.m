//
//  HCurrency.m
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HCurrency.h"



@implementation HCurrency

+ (NSArray *)convertableCurrencies
{
    // TODO:
    // possible improvement here
    // move list of available currencies to external storage
    // and add its currency signs there £ $ €
    
    static NSArray *sharedConvertableCurrencies = nil;
    @synchronized (self) {
        if (sharedConvertableCurrencies == nil) {
            sharedConvertableCurrencies = @[[[HCurrency alloc] initWithIdentifier:@"USD" andSign:@"$"],
                                            [[HCurrency alloc] initWithIdentifier:@"GBP" andSign:@"£"],
                                            [self baseCurrency]];
        }
    }
    return sharedConvertableCurrencies;
    
    
}

+ (HCurrency *)baseCurrency
{
    return [[HCurrency alloc] initWithIdentifier:@"EUR" andSign:@"€"];
}

- (instancetype)initWithIdentifier:(NSString *)identifier andSign:(NSString *)sign
{
    if (self = [super init]) {
        _identifier = [identifier copy];
        _sign = [sign copy];
    }
    return self;
}

- (BOOL)isEqual:(HCurrency *)object
{
    return [self.identifier isEqualToString:object.identifier];
}

- (NSUInteger)hash
{
    return self.identifier.hash;
}

@end

