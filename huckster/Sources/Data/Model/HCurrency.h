//
//  HCurrency.h
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#ifndef HCurrency_h
#define HCurrency_h

#import <Foundation/Foundation.h>



@interface HCurrency : NSObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *sign;

+ (NSArray<__kindof HCurrency *> *)convertableCurrencies;
+ (HCurrency *)baseCurrency;

@end


#endif /* HCurrencyTpes_h */
