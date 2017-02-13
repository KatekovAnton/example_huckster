//
//  HBaseObject.h
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"



@interface HBaseObject : NSObject <EKMappingProtocol>

+ (HBaseObject *)objectFromDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;
+ (NSArray *)arrayOfObjectsFromDictionaryRepresentation:(NSArray *)dictionaryRepresentation;

@end
