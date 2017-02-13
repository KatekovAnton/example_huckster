//
//  HRatesRequestController.h
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HBaseRequestController.h"
#import "IHConstructable.h"



@class HCurency;



typedef void (^HRatesRequestControllerHandler)(NSArray<__kindof HCurency *> *result, NSError *error);



@interface HRatesRequestController : HBaseRequestController

- (void)loadECBRatesWithCompletionHandler:(HRatesRequestControllerHandler)handler;

@end
