//
//  HAccount.h
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HAccount : NSObject

@property (nonatomic, readonly) NSNumber *balanceEur;
@property (nonatomic, readonly) NSNumber *balanceUsd;
@property (nonatomic, readonly) NSNumber *balanceGbp;

@end
