//
//  EYWebServiceManager.h
//  Eyvee
//
//  Created by Neetika Mittal on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface EYWebServiceManager : AFHTTPSessionManager

+ (EYWebServiceManager *)sharedManager;

- (void)createGetRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                           shouldCache:(BOOL)cache
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;
- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                            shouldCache:(BOOL)cache
                    withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)createPostRequestForProductsWithParameters:(NSDictionary *)parameters
                                   withRequestPath:(NSString *)requestPath
                                       shouldCache:(BOOL)cache
                                           payload:(id)payload
                               withCompletionBlock:(void (^)(id responseObject, NSError *error))completionBlock;

- (void)createPutRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)createPutRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                               payload:(id)payload
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)createDeleteRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                      withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)getLocalDataFromJsonWithPath:(NSString *)jsonPath withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)setup;

@end
