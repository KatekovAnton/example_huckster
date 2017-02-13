//
//  HNetworkManager.m
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HNetworkManager.h"
#import "AFNetworking.h"
#import "AFNetworkActivityLogger.h"



@interface HNetworkManager ()

@property (nonatomic, copy) NSURL *baseURL;

@end


@implementation HNetworkManager

static HNetworkManager *sharedHNetworkManagerInstance = nil;

+ (HNetworkManager *)instance
{
    return sharedHNetworkManagerInstance;
}

+ (HNetworkManager *)initializeWithBaseURL:(NSURL *)url
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHNetworkManagerInstance = [[self alloc] initWithBaseURL:url];
        [[AFNetworkActivityLogger sharedLogger] startLogging];
#ifdef DEBUG
        [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelDebug;
#else
        [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelOff;
#endif
    });
    return sharedHNetworkManagerInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _baseURL = url;
        [self initiliazeNetwork];
    }
    return self;
}

- (void)initiliazeNetwork
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL sessionConfiguration:configuration];
    _sessionManager.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
}

- (NSString *)URLStringWithRelatedPath:(NSString *)relatedPath
{
    return [[self.baseURL absoluteString] stringByAppendingString:relatedPath];
}

@end
