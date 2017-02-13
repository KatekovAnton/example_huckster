//
//  HDataProvider.h
//  huckster
//
//  Created by Katekov Anton on 2/9/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>



@class HAccount;
@class HCurrencyConverter;



extern NSString * const HDataProviderDidChangeLoadingState;
extern NSString * const HDataProviderDidReloadRates;



@interface HDataProvider : NSObject 

@property (nonatomic, readonly) BOOL loading;
@property (nonatomic, readonly) HAccount *account;
@property (nonatomic, readonly) HCurrencyConverter *converter;

+ (HDataProvider *)sharedInstance;

@end
