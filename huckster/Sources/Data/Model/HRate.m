//
//  HRate.m
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HRate.h"



@implementation HRate

+ (EKObjectMapping *)objectMapping
{
    EKObjectMapping *result = [super objectMapping];
    
    [result mapKeyPath:@"currency" toProperty:@"currency"];
    [result mapKeyPath:@"rate"
            toProperty:@"rate"
        withValueBlock:^id _Nullable(NSString * _Nonnull key, id  _Nullable value) {
            return @([value floatValue]);
    }];
    
    return result;
}

@end
