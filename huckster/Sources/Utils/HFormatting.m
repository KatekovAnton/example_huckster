//
//  HFormatting.m
//  huckster
//
//  Created by Katekov Anton on 2/13/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HFormatting.h"



@implementation HFormatting

+ (NSNumberFormatter *)formatterForImportantValues
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return formatter;
}

+ (NSNumberFormatter *)formatterForCurrencyRate
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    return formatter;
}

+ (NSAttributedString *)rateStringWithSourceCurrencySign:(NSString*)sourceSign destinationCurrencySign:(NSString *)destinationSign rate:(double)rate
{
    const CGFloat smallFont = 13;
    const CGFloat largeFont = 17;
    
    NSMutableAttributedString *stringSignFrom = [[NSMutableAttributedString alloc] initWithString:[sourceSign copy]];
    [stringSignFrom setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:smallFont]} range:NSMakeRange(0, stringSignFrom.length)];
    
    NSMutableAttributedString *stringOneEqual = [[NSMutableAttributedString alloc] initWithString:@"1 = "];
    [stringOneEqual setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:largeFont]} range:NSMakeRange(0, stringOneEqual.length)];
    
    NSMutableAttributedString *stringSignTo = [[NSMutableAttributedString alloc] initWithString:[destinationSign copy]];
    [stringSignTo setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:smallFont]} range:NSMakeRange(0, stringSignTo.length)];
    
    NSString *rateAsString = [NSString stringWithFormat:@"%.04f", rate];
    NSMutableAttributedString *stringRate = [[NSMutableAttributedString alloc] initWithString:rateAsString];
    [stringRate setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:largeFont]} range:NSMakeRange(0, rateAsString.length - 2)];
    [stringRate setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:smallFont]} range:NSMakeRange(rateAsString.length - 2, 2)];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    [result appendAttributedString:stringSignFrom];
    [result appendAttributedString:stringOneEqual];
    [result appendAttributedString:stringSignTo];
    [result appendAttributedString:stringRate];
    
    return result;
}

@end
