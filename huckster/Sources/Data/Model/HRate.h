//
//  HRate.h
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HBaseObject.h"



@interface HRate : HBaseObject

@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSNumber *rate;

@end
