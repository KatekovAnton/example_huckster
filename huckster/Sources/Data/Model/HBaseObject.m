//
//  HBaseObject.m
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HBaseObject.h"



@implementation HBaseObject

#pragma mark - EKMappingProtocol

+ (EKObjectMapping *)objectMapping
{
    return [[EKObjectMapping alloc] initWithObjectClass:self];
}

+ (HBaseObject *)objectFromDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation
{
    HBaseObject *result = [[self alloc] init];
    
    [EKMapper fillObject:result fromExternalRepresentation:dictionaryRepresentation withMapping:[self objectMapping]];
    
    return result;
}

+ (NSArray *)arrayOfObjectsFromDictionaryRepresentation:(NSArray *)dictionaryRepresentation
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:dictionaryRepresentation.count];
    
    for (NSDictionary *dictionary in dictionaryRepresentation) {
        HBaseObject *item = [self objectFromDictionaryRepresentation:dictionary];
        [result addObject:item];
    }
    
    return result;
}

@end
