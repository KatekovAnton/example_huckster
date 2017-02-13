//
//  HBaseRequestController.m
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "HBaseRequestController.h"
#import "HNetworkManager.h"
#import "AFNetworking.h"



NSString * const kHRequestMethodGET       = @"GET";



@interface HBaseRequestController ()

@property (nonatomic) NSMutableArray *tasks;
@property (nonatomic) HNetworkManager *networkManager;

@end



@implementation HBaseRequestController

- (id)initWithNetworkManager:(HNetworkManager *)manager
{
    self = [super init];
    if (self) {
        self.networkManager = manager;
        self.tasks = [NSMutableArray array];
    }
    return self;
}

- (id)init
{
    self = [self initWithNetworkManager:[HNetworkManager instance]];
    return self;
}

- (BOOL)hasActiveRequest
{
    return self.tasks.count > 0;
}

- (NSURLSessionDataTask *)sendRequrestWithMethod:(NSString*)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(id responseObject, NSString *requstURL))success
                                         failure:(void (^)(NSError *error, NSString *requstURL))failure
{
    
    
    
    NSURLSessionDataTask *result = nil;
    AFHTTPSessionManager *manager = self.networkManager.sessionManager;
    
    if ([method isEqualToString:kHRequestMethodGET])
    {
        result = [manager GET:URLString
                   parameters:parameters
                      success:^(NSURLSessionDataTask *task, id response)
                  {
                      [_tasks removeObject:task];
                      id responseObject = [self handleSuccessResponce:response forRequestURL:URLString];
                      if (success) {
                          success(responseObject, URLString);
                      }
                  }
                      failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self.tasks removeObject:task];
                      [self handleError:error forTask:task];
                      if (failure) {
                          failure(error, URLString);
                      }
                  }];
    }
    [_tasks addObject:result];
    return result;
    
}

- (void)handleError:(NSError*)error forTask:(NSURLSessionDataTask*)task
{
    //do something
    NSHTTPURLResponse *responce = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
    [self handleErrorResponce:responce forTask:task];
}

- (void)handleErrorResponce:(NSHTTPURLResponse*)responce forTask:(NSURLSessionDataTask*)task
{
    
}

- (id)handleSuccessResponce:(id)responce forRequestURL:(NSString*)requestURL
{
    return nil;
}

- (void)abortLoading
{
    for (NSURLSessionDataTask *task in _tasks) {
        [task cancel];
    }
}

- (void)dealloc
{
    [self abortLoading];
}

@end
