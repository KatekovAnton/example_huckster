//
//  HNetworkManager.h
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>



@class AFHTTPSessionManager;



@interface HNetworkManager : NSObject

@property (nonatomic, readonly) AFHTTPSessionManager *sessionManager;

+ (HNetworkManager *)instance;

+ (HNetworkManager *)initializeWithBaseURL:(NSURL *)url;

- (NSString*)URLStringWithRelatedPath:(NSString*)relatedPath;

@end
