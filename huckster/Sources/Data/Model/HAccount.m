//
//  HAccount.m
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HAccount.h"



@interface HAccount ()

@property (nonatomic, copy) NSNumber *balanceEur;
@property (nonatomic, copy) NSNumber *balanceUsd;
@property (nonatomic, copy) NSNumber *balanceGbp;

@end



@implementation HAccount

- (instancetype)init
{
    if (self = [super init]) {
        self.balanceEur = @(0.0);
        self.balanceUsd = @(0.0);
        self.balanceGbp = @(0.0);
    }
    return self;
}

@end
