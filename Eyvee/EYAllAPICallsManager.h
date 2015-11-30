//
//  EYAllAPICallsManager.h
//  Eyvee
//
//  Created by Neetika Mittal on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EYUtility.h"
@class EYShippingAddressMtlModel;
@class EYError;

@interface EYAllAPICallsManager : NSObject

+ (EYAllAPICallsManager *)sharedManager;
@property (nonatomic, strong) EYShippingAddressMtlModel * userLastUsedAddress;
- (void)getAllBrandsRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                              shouldCache:(BOOL)cache
                      withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getAllProductsWithoutFilterWithRequestPath:(NSString *)requestPath
                                       shouldCache:(BOOL)cache
                               withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;


- (void)getAllProductsFilteredWithPrice:(ProductsSortingWithPrice)sort
                            requestPath:(NSString *)requestPath
                            shouldCache:(BOOL)cache
                    withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getAllProductsWithCustomFilters:(NSDictionary *)filters
                            requestPath:(NSString *)requestPath
                            shouldCache:(BOOL)cache
                                payload:(NSArray *)payload
                    withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getAllProductsOnPage:(NSInteger)page
                 requestPath:(NSString *)requestPath
                 shouldCache:(BOOL)cache
         withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getBrandSizeForBrandId:(NSInteger)brandId
                   requestPath:(NSString *)requestPath
                   shouldCache:(BOOL)cache
           withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getAllBannersRequestWithParameters:(NSDictionary *)parameters
                           withRequestPath:(NSString *)requestPath
                               shouldCache:(BOOL)cache
                           isPullToRefresh:(BOOL)pullToRefresh
                       withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getAllSlidersRequestWithParameters:(NSDictionary *)parameters
                           withRequestPath:(NSString *)requestPath
                               shouldCache:(BOOL)cache
                           isPullToRefresh:(BOOL)pullToRefresh
                       withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)signUpRequestWithParameters:(NSDictionary *)parameters
                    withRequestPath:(NSString *)requestPath
                            payload:(NSDictionary *)payload
                withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)updateProfileRequestWithParameters:(NSDictionary *)parameters
                           withRequestPath:(NSString *)requestPath
                                   payload:(NSDictionary *)payload
                       withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getSiteInfoWithParameters:(NSDictionary *)parameters
                  withRequestPath:(NSString *)requestPath
                      shouldCache:(BOOL)cache
              withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)syncCartRequestWithParameters:(NSDictionary *)parameters
                      withRequestPath:(NSString *)requestPath
                                cache:(BOOL)cache
                              payload:(NSDictionary *)payload
                  withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)validateCartRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                                  payload:(NSDictionary *)payload
                      withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)convertCartToOrderRequestWithParameters:(NSDictionary *)parameters
                                withRequestPath:(NSString *)requestPath
                                        payload:(NSDictionary *)payload
                            withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getAllOrdersRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                                    cache:(BOOL)cache
                                  payload:(NSDictionary *)payload
                      withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getOrdersDetailsRequestWithParameters:(NSDictionary *)parameters
                              withRequestPath:(NSString *)requestPath
                                        cache:(BOOL)cache
                                      payload:(NSDictionary *)payload
                          withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getProductIdsInUserWishlistRequestWithParameters:(NSDictionary *)parameters
                                         withRequestPath:(NSString *)requestPath
                                                   cache:(BOOL)cache
                                                 payload:(NSDictionary *)payload
                                     withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)createWishlistRequestWithParameters:(NSDictionary *)parameters
                            withRequestPath:(NSString *)requestPath
                        withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)addProductToWishlistRequestWithParameters:(NSDictionary *)parameters
                                  withRequestPath:(NSString *)requestPath
                                            cache:(BOOL)cache
                              withCompletionBlock:(void(^)(id responseObject,EYError *error))completionBlock;

- (void)getAllUserWishlistRequestWithParameters:(NSDictionary *)parameters
                                withRequestPath:(NSString *)requestPath
                                          cache:(BOOL)cache
                            withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;
- (void)getWishlistsForProductRequestWithParameters:(NSDictionary *)parameters
                                withRequestPath:(NSString *)requestPath
                                          cache:(BOOL)cache
                            withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getAllProductsOfUserWishList:(NSDictionary *)parameters
                                withRequestPath:(NSString *)requestPath
                                          cache:(BOOL)cache
                            withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)deleteProductsFromWishlistWithParameters:(NSDictionary *)parameters
                                withRequestPath:(NSString *)requestPath
                                          cache:(BOOL)cache
                            withCompletionBlock:(void(^)(BOOL responseSuccess, EYError *error))completionBlock;

- (void)deleteAWishlistWithParameters:(NSDictionary *)parameters
                      withRequestPath:(NSString *)requestPath
                                cache:(BOOL)cache
                  withCompletionBlock:(void(^)(BOOL responseSuccess, EYError *error))completionBlock;
- (void)getSpecificProductWithParameters:(NSDictionary *)parameters
                                withRequestPath:(NSString *)requestPath
                                          cache:(BOOL)cache
                            withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)getAllUserAddressesRequestWithParameters:(NSDictionary *)parameters
                                 withRequestPath:(NSString *)requestPath
                                     shouldCache:(BOOL)cache
                             withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)addAddressRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                                payload:(NSArray *)payload
                    withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)updateAddressRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                                payload:(NSArray *)payload
                    withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)removeProductFromCartWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                                payload:(NSArray *)payload
                    withCompletionBlock:(void(^)(BOOL success, EYError *error))completionBlock;

- (void)checkShippingPincodeAvailabilityWithParameters:(NSDictionary *)parameters
                            withRequestPath:(NSString *)requestPath
                                    payload:(NSArray *)payload
                        withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;
- (void)checkBillingPincodeAvailabilityWithParameters:(NSDictionary *)parameters withRequestPath:(NSString *)requestPath payload:(NSArray *)payload withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;


- (void)resetPasswordRequestWithParameters:(NSDictionary *)parameters withRequestPath:(NSString *)requestPath payload:(NSDictionary *)payload withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)updatePasswordRequestWithParameters:(NSDictionary *)parameters withRequestPath:(NSString *)requestPath payload:(NSDictionary *)payload withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

//JSON Calls
-(id)getAllBannersJsonWithPath:(NSString*)datafilePath;


@end
