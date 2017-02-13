//
//  HRatesRequestController.m
//  huckster
//
//  Created by Katekov Anton on 2/12/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HRatesRequestController.h"
#import "HRate.h"



@interface HRatesRequestController () <NSXMLParserDelegate> {
    NSMutableArray *_parserPath;
    NSMutableArray *_currencies;
}

@end



@implementation HRatesRequestController

- (void)cleanup
{
    [self abortLoading];
    _parserPath = nil;
    _currencies = nil;
}

- (void)loadECBRatesWithCompletionHandler:(HRatesRequestControllerHandler)handler
{
    [self cleanup];
    [self sendRequrestWithMethod:kHRequestMethodGET
                       URLString:@"stats/eurofxref/eurofxref-daily.xml"
                      parameters:nil
                         success:^(id responseObject, NSString *requstURL)
     {
         if (handler) {
             handler(responseObject, nil);
         }
     }
                         failure:^(NSError *error, NSString *requstURL)
     {
         if (handler) {
             handler(nil, error);
         }
     }];
}

- (id)performMappingForResponce:(id)responce forRequsetURL:(NSString*)requestURL
{
    if (![responce isKindOfClass:[NSXMLParser class]]) {
        return nil;
    }
    
    _currencies = [NSMutableArray array];
    NSXMLParser *parser = (NSXMLParser *)responce;
    parser.delegate = self;
    BOOL result = [parser parse];
    if (result) {
        NSArray *objects = [HRate arrayOfObjectsFromDictionaryRepresentation:_currencies];
        return objects;
    }
    return nil;
}

#pragma mark - Parsing

// TODO:
// possible improvement here
// extract tree structure navigation code
// to external object
// or use xpath

- (BOOL)isCurrencyNode
{
    if (_parserPath.count != 4) {
        return NO;
    }
    
    // TODO:
    // possible improvement here
    // look for online scheme and use it instead of hardcoded values
    
    return  [_parserPath[0] isEqualToString:@"gesmes:Envelope"] &&
            [_parserPath[1] isEqualToString:@"Cube"] &&
            [_parserPath[2] isEqualToString:@"Cube"] &&
            [_parserPath[3] isEqualToString:@"Cube"];
}

- (void)enterNode:(NSString *)node
{
    [_parserPath addObject:node];
}

- (void)leaveNode:(NSString *)node
{
    if (_parserPath.count == 0) {
        return;
    }
    if (![[_parserPath lastObject] isEqualToString:node]) {
        return;
    }
    [_parserPath removeLastObject];
}

#pragma mark - NSXMLParserDelegate <NSObject>

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _parserPath = [NSMutableArray array];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    _parserPath = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [self enterNode:elementName];
    if ([self isCurrencyNode]) {
        [_currencies addObject:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    [self leaveNode:elementName];
}

@end
