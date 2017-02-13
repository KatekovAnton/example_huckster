//
//  HNumberFormatting.h
//  huckster
//
//  Created by Katekov Anton on 2/13/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HFormatting : NSObject

+ (NSNumberFormatter *)formatterForImportantValues;
+ (NSNumberFormatter *)formatterForCurrencyRate;

+ (NSAttributedString *)rateStringWithSourceCurrencySign:(NSString*)sourceSign destinationCurrencySign:(NSString *)destinationSign rate:(double)rate;

@end
