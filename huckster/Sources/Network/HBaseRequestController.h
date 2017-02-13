//
//  HBaseRequestController.h
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>



@class HNetworkManager;



extern NSString * const kHRequestMethodGET;



@interface HBaseRequestController : NSObject

- (id)init;
- (id)initWithNetworkManager:(HNetworkManager *)manager;

/*
 *Runs an `NSURLSessionDataTask` with a `method` request.
 */
- (NSURLSessionDataTask *)sendRequrestWithMethod:(NSString*)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(id responseObject, NSString *requstURL))success
                                         failure:(void (^)(NSError *error, NSString *requstURL))failure;

/*
 *Handle error of request
 */
- (void)handleError:(NSError*)error forTask:(NSURLSessionDataTask*)task;

/*
 *Handle error responce itself
 */
- (void)handleErrorResponce:(NSHTTPURLResponse*)responce forTask:(NSURLSessionDataTask*)task;

/*
 *Handle success result of request, preform mapping of result
 *
 *@return by-default it is a result of method `performMappingForResponce: forRequsetUrl:`
 */
- (id)handleSuccessResponce:(id)responce forRequestURL:(NSString*)requestURL;

/*
 *Abort current loading process
 */

- (void)abortLoading;

@end
