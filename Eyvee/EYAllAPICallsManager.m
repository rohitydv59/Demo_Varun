//
//  EYAllAPICallsManager.m
//  Eyvee
//
//  Created by Neetika Mittal on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAllAPICallsManager.h"
#import "EYWebServiceManager.h"
#import "EYAllBrandsMtlModel.h"
#import "EYGetAllProductsMTLModel.h"
#import "EYBrandSizeMtlModel.h"
#import "EYBannersMtlModel.h"
#import "EYSlidersMtlModel.h"
#import "EYSiteInfoMtlModel.h"
#import "EYSignUpMtlModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYAllOrdersMtlModel.h"
#import "EYUserWishlistMtlModel.h"
#import "EYCacheManager.h"
#import "Mantle.h"
#import "EYError.h"
#import "EYConstant.h"
#import "EYCartModel.h"
#import "EYShippingAddressMtlModel.h"
#import "EYWishlistModel.h"

#define kBrandDataKey @"data"
#define kMessageKey @"message"
#define kStatusCodeKey @"statusCode"

@interface EYAllAPICallsManager ()

@end

@implementation EYAllAPICallsManager

+ (EYAllAPICallsManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static EYAllAPICallsManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)getAllBrandsRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                              shouldCache:(BOOL)cache
                      withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error)
        {
            NSArray *allBrands = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:allBrands]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                NSMutableArray *parsedBrands = [[NSMutableArray alloc] init];
                for (NSDictionary *specificBrand in allBrands)
                {
                    error = nil;
                    
                    EYAllBrandsMtlModel *brand = [MTLJSONAdapter modelOfClass:[EYAllBrandsMtlModel class] fromJSONDictionary:specificBrand error:&error];
                    //                brand.isSelected = NO;
                    if (!error)
                    {
                        [parsedBrands addObject:brand];
                    }
                }
                if (completionBlock)
                    completionBlock (parsedBrands, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getAllProductsWithoutFilterWithRequestPath:(NSString *)requestPath
                                       shouldCache:(BOOL)cache
                               withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPostRequestWithParameters:@{@"doNotReturnFilters" : @"true"} withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error)
        {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYGetAllProductsMTLModel *allProducts = [MTLJSONAdapter modelOfClass:[EYGetAllProductsMTLModel class] fromJSONDictionary:data error:&error];
                if (!error)
                {
                    if (completionBlock)
                        completionBlock (allProducts, nil);
                }
                else
                {
                    if (completionBlock)
                        completionBlock (nil, [self getErrorForMessage:nil error:error]);
                }
            }
        }
        else
        {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getAllProductsWithCustomFilters:(NSDictionary *)filters
                            requestPath:(NSString *)requestPath
                            shouldCache:(BOOL)cache
                                payload:(NSArray *)payload
                    withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    if (filters.count == 0) {
        filters = @{@"doNotReturnFilters" : @"false"};
    }
    
    [[EYWebServiceManager sharedManager] getLocalDataFromJsonWithPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYGetAllProductsMTLModel *allProducts = [MTLJSONAdapter modelOfClass:[EYGetAllProductsMTLModel class] fromJSONDictionary:data error:&error];
                if (!error)
                {
                    if (completionBlock)
                        completionBlock (allProducts, nil);
                }
                else {
                    if (completionBlock)
                        completionBlock (nil, [self getErrorForMessage:nil error:error]);
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getAllProductsFilteredWithPrice:(ProductsSortingWithPrice)sort
                            requestPath:(NSString *)requestPath
                            shouldCache:(BOOL)cache
                    withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPostRequestWithParameters:@{@"sortingType" : @(sort)} withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYGetAllProductsMTLModel *allProducts = [MTLJSONAdapter modelOfClass:[EYGetAllProductsMTLModel class] fromJSONDictionary:data error:&error];
                if (!error) {
                    if (completionBlock)
                        completionBlock (allProducts, nil);
                }
                else {
                    if (completionBlock)
                        completionBlock (nil, [self getErrorForMessage:nil error:error]);
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getAllProductsOnPage:(NSInteger)page
                 requestPath:(NSString *)requestPath
                 shouldCache:(BOOL)cache
         withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPostRequestWithParameters:@{@"page" : @(page)} withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYGetAllProductsMTLModel *allProducts = [MTLJSONAdapter modelOfClass:[EYGetAllProductsMTLModel class] fromJSONDictionary:data error:&error];
                if (!error) {
                    if (completionBlock)
                        completionBlock (allProducts, nil);
                }
                else {
                    if (completionBlock)
                        completionBlock (nil, [self getErrorForMessage:nil error:error]);
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getBrandSizeForBrandId:(NSInteger)brandId
                   requestPath:(NSString *)requestPath
                   shouldCache:(BOOL)cache
           withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:@{@"brandId" : @(brandId)} withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                NSMutableArray *parsedSizes = [[NSMutableArray alloc] init];
                for (NSDictionary *info in data) {
                    error = nil;
                    EYBrandSizeMtlModel *size = [MTLJSONAdapter modelOfClass:[EYBrandSizeMtlModel class] fromJSONDictionary:info error:&error];
                    if (!error) {
                        [parsedSizes addObject:size];
                    }
                }
                if (completionBlock)
                    completionBlock (parsedSizes, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getAllBannersRequestWithParameters:(NSDictionary *)parameters
                           withRequestPath:(NSString *)requestPath
                               shouldCache:(BOOL)cache
                           isPullToRefresh:(BOOL)pullToRefresh
                       withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    if (pullToRefresh) {
        [[EYCacheManager manager] deleteDataForURL:requestPath params:parameters withCompletion:^{
            [self getAllBannersRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, EYError *error) {
                if (completionBlock)
                    completionBlock (responseObject, error);
            }];
        }];
    }
    else {
        [self getAllBannersRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, EYError *error) {
            if (completionBlock)
                completionBlock (responseObject, error);
        }];
    }
}

- (void)getAllBannersRequestWithParameters:(NSDictionary *)parameters
                           withRequestPath:(NSString *)requestPath
                               shouldCache:(BOOL)cache
                       withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] getLocalDataFromJsonWithPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        
        if (!error) {
            NSArray *allBanners = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:allBanners]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                NSMutableArray *parsedBanners = [[NSMutableArray alloc] init];
                for (NSDictionary *specificBanner in allBanners) {
                    error = nil;
                    EYBannersMtlModel *banner = [MTLJSONAdapter modelOfClass:[EYBannersMtlModel class] fromJSONDictionary:specificBanner error:&error];
                    if (!error) {
                        [parsedBanners addObject:banner];
                    }
                }
                if (completionBlock)
                    completionBlock (parsedBanners, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

//-(id)getAllBannersJsonWithPath:(NSString*)datafilePath
//{
//    NSError *error;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:datafilePath ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    id responseJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSArray *allBanners = [responseJson objectForKey:kBrandDataKey];
//    NSMutableArray *parsedBanners = [[NSMutableArray alloc] init];
//    for (NSDictionary *specificBanner in allBanners)
//    {
//        error = nil;
//        EYBannersMtlModel *banner = [MTLJSONAdapter modelOfClass:[EYBannersMtlModel class] fromJSONDictionary:specificBanner error:&error];
//        if (!error)
//        {
//            [parsedBanners addObject:banner];
//        }
//    }
//    return parsedBanners;
//}


- (EYError *)getErrorForMessage:(NSString *)errorMessage error:(NSError *)error
{
    EYError *err = [[EYError alloc] initWithError:error];
    if (errorMessage.length > 0) {
        err.errorMessage = errorMessage;
    }
    return err;
}

- (BOOL)checkIfError:(id)obj
{
    BOOL isErr = NO;
    if ([obj isKindOfClass:[NSNull class]]) {
        isErr = YES;
    }
    else if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
        if ([obj count] == 0) {
          //  isErr = YES;
        }
    }
    return isErr;
}

- (void)getAllSlidersRequestWithParameters:(NSDictionary *)parameters
                           withRequestPath:(NSString *)requestPath
                               shouldCache:(BOOL)cache
                           isPullToRefresh:(BOOL)pullToRefresh
                       withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    if (pullToRefresh) {

        [[EYCacheManager manager] deleteDataForURL:requestPath params:parameters withCompletion:^{
            [self getAllSlidersRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, EYError *error) {
                if (completionBlock)
                    completionBlock (responseObject, error);
            }];
        }];
    }
    else {
        [self getAllSlidersRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, EYError *error) {
            if (completionBlock)
                completionBlock (responseObject, error);
        }];
    }
}

- (void)getAllSlidersRequestWithParameters:(NSDictionary *)parameters
                           withRequestPath:(NSString *)requestPath
                               shouldCache:(BOOL)cache
                       withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
//    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
    [[EYWebServiceManager sharedManager] getLocalDataFromJsonWithPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *allSliders = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:allSliders]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                NSMutableArray *parsedSliders = [[NSMutableArray alloc] init];
                for (NSDictionary *specificSlider in allSliders) {
                    error = nil;
                    EYSlidersMtlModel *slider = [MTLJSONAdapter modelOfClass:[EYSlidersMtlModel class] fromJSONDictionary:specificSlider error:&error];
                    if (!error) {
                        [parsedSliders addObject:slider];
                    }
                }
                if (completionBlock)
                    completionBlock (parsedSliders, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}


- (void)signUpRequestWithParameters:(NSDictionary *)parameters
                    withRequestPath:(NSString *)requestPath
                            payload:(NSDictionary *)payload
                withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPostRequestForProductsWithParameters:parameters withRequestPath:requestPath shouldCache:NO payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data] || !data) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                if (completionBlock) {
                    completionBlock(responseObject,nil);
                }
//                EYSignUpMtlModel *signUp = [MTLJSONAdapter modelOfClass:[EYSignUpMtlModel class] fromJSONDictionary:data error:&error];
//                if (signUp.authorizationToken.length > 0 && signUp.userId) {
//                    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kUserLoggedInKey];
//                    [[NSUserDefaults standardUserDefaults] setObject:signUp.authorizationToken forKey:kUserTokenKey];
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",signUp.userId] forKey:kUserIdKey];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//                    completionBlock (signUp, nil);
//                }
//                else {
//                    NSString *message = responseObject[kMessageKey];
//                    completionBlock (nil, [self getErrorForMessage:message error:error]);
//                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)resetPasswordRequestWithParameters:(NSDictionary *)parameters withRequestPath:(NSString *)requestPath payload:(NSDictionary *)payload withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager]createPutRequestWithParameters:parameters withRequestPath:requestPath payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data] || !data) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                if (completionBlock) {
                    completionBlock(responseObject,nil);
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)updatePasswordRequestWithParameters:(NSDictionary *)parameters withRequestPath:(NSString *)requestPath payload:(NSDictionary *)payload withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager]createPutRequestWithParameters:parameters withRequestPath:requestPath payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data] || !data) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                if (completionBlock) {
                    completionBlock(responseObject,nil);
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)updateProfileRequestWithParameters:(NSDictionary *)parameters
                    withRequestPath:(NSString *)requestPath
                            payload:(NSDictionary *)payload
                withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager]createPutRequestWithParameters:parameters withRequestPath:requestPath payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data] || !data) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                if (completionBlock) {
                    completionBlock(responseObject,nil);
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getSiteInfoWithParameters:(NSDictionary *)parameters
                  withRequestPath:(NSString *)requestPath
                      shouldCache:(BOOL)cache
              withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
//    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
    [[EYWebServiceManager sharedManager] getLocalDataFromJsonWithPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error)
        {
            NSDictionary *siteInfo = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:siteInfo]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYSiteInfoMtlModel *siteMdl = [MTLJSONAdapter modelOfClass:[EYSiteInfoMtlModel class] fromJSONDictionary:siteInfo error:&error];
                if (completionBlock)
                    completionBlock (siteMdl, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)syncCartRequestWithParameters:(NSDictionary *)parameters
                      withRequestPath:(NSString *)requestPath
                                cache:(BOOL)cache
                              payload:(NSDictionary *)payload
                  withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPostRequestForProductsWithParameters:parameters withRequestPath:requestPath shouldCache:cache payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error)
        {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            NSNumber * statusCode = [responseObject objectForKey:@"statusCode"];
            if ([self checkIfError:data] || !([statusCode isEqualToNumber:@(200)] || [statusCode isEqualToNumber:@(216)]))
            {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYSyncCartMtlModel *siteMdl = [MTLJSONAdapter modelOfClass:[EYSyncCartMtlModel class] fromJSONDictionary:data error:&error];
                if (!error) {
                    [[NSUserDefaults standardUserDefaults] setObject:siteMdl.cartId forKey:kCartIdKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    EYCartModel * cartModel = [EYCartModel sharedManager];
                    cartModel.cartModel = siteMdl;
                }
                if (completionBlock)
                    completionBlock (siteMdl, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)validateCartRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                                  payload:(NSDictionary *)payload
                      withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPostRequestForProductsWithParameters:parameters withRequestPath:requestPath shouldCache:NO payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error)
        {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYSyncCartMtlModel *siteMdl = [MTLJSONAdapter modelOfClass:[EYSyncCartMtlModel class] fromJSONDictionary:data error:&error];
                if (completionBlock)
                    completionBlock (siteMdl, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)convertCartToOrderRequestWithParameters:(NSDictionary *)parameters
                                withRequestPath:(NSString *)requestPath
                                        payload:(NSDictionary *)payload
                            withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPostRequestForProductsWithParameters:parameters withRequestPath:requestPath shouldCache:NO payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error)
        {
            NSDictionary *data = [[responseObject objectForKey:kBrandDataKey] objectAtIndex:0];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYSyncCartMtlModel *siteMdl = [MTLJSONAdapter modelOfClass:[EYSyncCartMtlModel class] fromJSONDictionary:data error:&error];
                if (completionBlock)
                    completionBlock (siteMdl, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

// could be used to get all orders and all orders for a particular cart id
- (void)getAllOrdersRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                                    cache:(BOOL)cache
                                  payload:(NSDictionary *)payload
                      withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *data = [responseObject objectForKey:kBrandDataKey];
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *innerData = (NSDictionary *)data;
                if ([self checkIfError:data]) {
                    NSString *message = responseObject[kMessageKey];
                    if (completionBlock)
                        completionBlock (nil, [self getErrorForMessage:message error:error]);
                }
                else {
                    EYAllOrdersMtlModel *orderMdl = [MTLJSONAdapter modelOfClass:[EYAllOrdersMtlModel class] fromJSONDictionary:innerData error:&error];
                    if (completionBlock)
                        completionBlock (orderMdl, nil);
                }
            }
            else {
                NSMutableArray *parsedData = [[NSMutableArray alloc] init];
                for (NSDictionary *innerData in data) {
                    
                        EYAllOrdersMtlModel *orderMdl = [MTLJSONAdapter modelOfClass:[EYAllOrdersMtlModel class] fromJSONDictionary:innerData error:&error];
                        if (!error) {
                            [parsedData addObject:orderMdl];
                        }
                    
                }
                if (parsedData.count == 0) {
                    NSString *message = responseObject[kMessageKey];
                    if (completionBlock)
                        completionBlock (nil, [self getErrorForMessage:message error:error]);
                }
                else {
                    if (completionBlock)
                        completionBlock (parsedData, nil);
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getOrdersDetailsRequestWithParameters:(NSDictionary *)parameters
                              withRequestPath:(NSString *)requestPath
                                        cache:(BOOL)cache
                                      payload:(NSDictionary *)payload
                          withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error)
        {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYAllOrdersMtlModel *orderMdl = [MTLJSONAdapter modelOfClass:[EYAllOrdersMtlModel class] fromJSONDictionary:data error:&error];
                if (completionBlock)
                    completionBlock (orderMdl, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getProductIdsInUserWishlistRequestWithParameters:(NSDictionary *)parameters
                              withRequestPath:(NSString *)requestPath
                                        cache:(BOOL)cache
                                      payload:(NSDictionary *)payload
                          withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{    
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                if (completionBlock)
                    completionBlock (data, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)createWishlistRequestWithParameters:(NSDictionary *)parameters
                                         withRequestPath:(NSString *)requestPath
                                     withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPutRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            id data = [responseObject objectForKey:kBrandDataKey];
            NSNumber * statusCode = [responseObject objectForKey:kStatusCodeKey];
            
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                if (statusCode.intValue == 209)                         // wishlist already exists
                {
                    //NSLog(@"wishlist already created");
                    if (completionBlock)
                        completionBlock (data, nil);                        // data is null
                }
                else
                {
                    if (responseObject)
                    {
                        //NSLog(@"new wishlist created");
                        EYWishlistModel * manager = [EYWishlistModel sharedManager];
                        [manager updateWishListModelWithCompletionBlock:^(id responseObject, EYError *error) {
                            if (!error && responseObject)
                            {
                                if (completionBlock)
                                    completionBlock((EYAllWishlistMtlModel *)responseObject,error);
                            }
                            else
                            {
                                if (completionBlock)
                                    completionBlock(nil,error);
                            }
                        }];
                    }
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)addProductToWishlistRequestWithParameters:(NSDictionary *)parameters
                                         withRequestPath:(NSString *)requestPath
                                                   cache:(BOOL)cache
                                     withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    
    [[EYWebServiceManager sharedManager] createPutRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error){
        
        if (!error) {
            NSNumber *successCode = responseObject[@"statusCode"];
            if ([successCode isEqualToNumber:[NSNumber numberWithInt:200]])
            {
                EYWishlistModel * manager = [EYWishlistModel sharedManager];
                [manager updateProductIdsOfWishlistWithCompletionBlock:^(id responseObject, EYError *error)
                 {
                     NSLog(@"updateProductIdsOfWishlistWithCompletionBlock added %@------- error %@", responseObject, error);
                 }];
                
                NSString *productId = parameters[@"productId"];
                if (productId) {
                    NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[EYWishlistModel sharedManager].productIdsArray];
                    [arr addObject:productId];
                    [EYWishlistModel sharedManager].productIdsArray = [[NSArray alloc] initWithArray:arr];
                }
                
                EYWishlistModel * wishListModel = [EYWishlistModel sharedManager];
                wishListModel.wishlistRequestState = wishlistRequestNeedToSend;
                [wishListModel getWishlistItemsWithCompletionBlock:nil];
                
                if (completionBlock) {
                    completionBlock (responseObject, nil);
                }
            }
            else
            {
                if (completionBlock) {
                    NSString *message = responseObject[kMessageKey];
                    completionBlock (responseObject, [self getErrorForMessage:message error:error]);
                }
            }
        }
        else
        {
            if (completionBlock) {
                completionBlock (responseObject, [self getErrorForMessage:nil error:error]);
            }
        }
    }];
}

-(void) getAllProductsOfUserWishList:(NSDictionary *)parameters withRequestPath:(NSString *)requestPath cache:(BOOL)cache withCompletionBlock:(void (^)(id, EYError *))completionBlock
{
    [[EYWebServiceManager sharedManager] createPostRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error && responseObject)
        {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            EYGetAllProductsMTLModel *allProducts = [MTLJSONAdapter modelOfClass:[EYGetAllProductsMTLModel class] fromJSONDictionary:data error:&error];
            if (!error)
            {
                if (completionBlock)
                    completionBlock (allProducts, nil);
            }
            else
            {
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:nil error:error]);
            }

        }
        else
        {
            //NSLog(@"getAllProductsOfUserWishList error is %@", error);
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);

        }
    }];
}

// this will not return product data
- (void)getAllUserWishlistRequestWithParameters:(NSDictionary *)parameters
                                         withRequestPath:(NSString *)requestPath
                                                   cache:(BOOL)cache
                                     withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data])
            {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else
            {
               EYWishlistModel * model = [EYWishlistModel sharedManager];
               EYAllWishlistMtlModel *userWishlistMdl = [MTLJSONAdapter modelOfClass:[EYAllWishlistMtlModel class] fromJSONDictionary:(NSDictionary *)responseObject error:&error];
                model.wishlistModel = userWishlistMdl;
                if (completionBlock)
                    completionBlock (userWishlistMdl, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getWishlistsForProductRequestWithParameters:(NSDictionary *)parameters
                                    withRequestPath:(NSString *)requestPath
                                              cache:(BOOL)cache
                                withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            EYWishlistModel * model = [EYWishlistModel sharedManager];
            EYAllWishlistMtlModel *userWishlistMdl = [MTLJSONAdapter modelOfClass:[EYAllWishlistMtlModel class] fromJSONDictionary:(NSDictionary *)responseObject error:&error];
            model.wishlistModel = userWishlistMdl;
            if (completionBlock)
                completionBlock (userWishlistMdl, nil);
            
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)deleteProductRequestWithParameters:(NSDictionary *)parameters
                                withRequestPath:(NSString *)requestPath
                            withCompletionBlock:(void(^)(EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createDeleteRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status isEqualToString:@"SUCCESS"]) {
                if (completionBlock)
                    completionBlock (nil);
            }
            else {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock ([self getErrorForMessage:message error:nil]);
            }
        }
        else {
            if (completionBlock)
                completionBlock ([self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)deleteProductsFromWishlistWithParameters:(NSDictionary *)parameters
                                 withRequestPath:(NSString *)requestPath
                                           cache:(BOOL)cache
                             withCompletionBlock:(void(^)(BOOL responseSuccess, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createDeleteRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSNumber *statusCode = [responseObject objectForKey:@"statusCode"];
            if ([statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
                
                EYWishlistModel * manager = [EYWishlistModel sharedManager];
                [manager updateProductIdsOfWishlistWithCompletionBlock:^(id responseObject, EYError *error)
                 {
                 }];
                
                NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[EYWishlistModel sharedManager].productIdsArray];
                NSString *productId = parameters[@"productId"];
                
                if ([arr containsObject:productId])
                {
                    [arr removeObject:productId];
                    [EYWishlistModel sharedManager].productIdsArray = [[NSArray alloc] initWithArray:arr];
                }
                
                EYWishlistModel * wishListModel = [EYWishlistModel sharedManager];
                wishListModel.wishlistRequestState = wishlistRequestNeedToSend;
                [wishListModel getWishlistItemsWithCompletionBlock:nil];

                if (completionBlock) {
                    completionBlock (YES,nil);
                }
                
            }
            else {
                if (completionBlock) {
                    NSString *message = responseObject[kMessageKey];
                    completionBlock (NO,[self getErrorForMessage:message error:nil]);
                }
            }
        }
        else {
            if (completionBlock) {
                completionBlock (NO,[self getErrorForMessage:nil error:error]);
            }
        }
    }];
}

- (void)deleteAWishlistWithParameters:(NSDictionary *)parameters
                            withRequestPath:(NSString *)requestPath
                                      cache:(BOOL)cache
                        withCompletionBlock:(void(^)(BOOL responseSuccess, EYError *error))completionBlock
{
    
    [[EYWebServiceManager sharedManager] createDeleteRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status isEqualToString:@"SUCCESS"]) {
                if (completionBlock)
                    completionBlock (YES,nil);
            }
            else {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (NO,[self getErrorForMessage:message error:nil]);
            }
        }
        else {
            if (completionBlock)
                completionBlock (NO,[self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)getAllUserAddressesRequestWithParameters:(NSDictionary *)parameters
                           withRequestPath:(NSString *)requestPath
                               shouldCache:(BOOL)cache
                       withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *allAddr = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:allAddr]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYAllAddressMtlModel *addrMdl = [MTLJSONAdapter modelOfClass:[EYAllAddressMtlModel class] fromJSONDictionary:(NSDictionary *)responseObject error:&error];
                if (completionBlock)
                    completionBlock (addrMdl, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

- (void)addAddressRequestWithParameters:(NSDictionary *)parameters
                            withRequestPath:(NSString *)requestPath
                                payload:(NSArray *)payload
                        withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPutRequestWithParameters:parameters withRequestPath:requestPath payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            id allData = [responseObject objectForKey:kBrandDataKey];
            id data = [allData objectForKey:@"address"];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                NSMutableArray * allAddresses = [NSMutableArray new];
                
                for (NSDictionary * addresDic in (NSArray *)data) {
                    EYShippingAddressMtlModel *addrMdl = [MTLJSONAdapter modelOfClass:[EYShippingAddressMtlModel class] fromJSONDictionary:addresDic error:&error];
                    [allAddresses addObject:addrMdl];
                }
                EYAllAddressMtlModel * allAddrs = [[EYAllAddressMtlModel alloc] init];
                allAddrs.allAdrresses = [self getShippingAddressFromAddreses:allAddresses];
                if (completionBlock)
                    completionBlock (allAddrs, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];

    
}

- (void)updateAddressRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                                payload:(NSArray *)payload
                    withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createPutRequestWithParameters:parameters withRequestPath:requestPath payload:payload withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            id allData = [responseObject objectForKey:kBrandDataKey];
            id data = [allData objectForKey:@"address"];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                NSMutableArray * allAddresses = [NSMutableArray new];
                
                for (NSDictionary * addresDic in (NSArray *)data) {
                    EYShippingAddressMtlModel *addrMdl = [MTLJSONAdapter modelOfClass:[EYShippingAddressMtlModel class] fromJSONDictionary:addresDic error:&error];
                    [allAddresses addObject:addrMdl];
                }
                EYAllAddressMtlModel * allAddrs = [[EYAllAddressMtlModel alloc] init];
                allAddrs.allAdrresses = [self getShippingAddressFromAddreses:allAddresses];
                if (completionBlock)
                    completionBlock (allAddrs, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
    
    
}

- (NSArray *)getShippingAddressFromAddreses:(NSArray *)allAddresses
{
    NSMutableArray * allShippingAddreses = [NSMutableArray new];
    
    for (EYShippingAddressMtlModel * billingAddrs in allAddresses) {
        if ([billingAddrs.shippingAddressId isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [allShippingAddreses addObject:billingAddrs];
        }
    }
    
    for (EYShippingAddressMtlModel * billingAddrs in allAddresses)
    {
        if (![billingAddrs.shippingAddressId isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            for (EYShippingAddressMtlModel * shippingAddress in allShippingAddreses) {
                if ([billingAddrs.shippingAddressId isEqualToNumber:shippingAddress.addressId]) {
                    shippingAddress.billingAddress = billingAddrs;
                }
            }
        }
    }
    allAddresses = [[NSArray alloc] initWithArray:allShippingAddreses];
    return allAddresses;
}

- (void)getSpecificProductWithParameters:(NSDictionary *)parameters
                         withRequestPath:(NSString *)requestPath
                                   cache:(BOOL)cache
                     withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:cache withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = [responseObject objectForKey:kBrandDataKey];
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                EYProductsInfo * product = [MTLJSONAdapter modelOfClass:[EYProductsInfo class] fromJSONDictionary:data error:&error];
                if (completionBlock)
                    completionBlock (product, nil);
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
    
    
}

- (void)removeProductFromCartWithParameters:(NSDictionary *)parameters
                            withRequestPath:(NSString *)requestPath
                                    payload:(NSArray *)payload
                        withCompletionBlock:(void(^)(bool success, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createDeleteRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status isEqualToString:@"SUCCESS"]) {
                if (completionBlock)
                    completionBlock (YES,nil);
            }
            else {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (NO,[self getErrorForMessage:message error:nil]);
            }
        }
        else {
            if (completionBlock)
                completionBlock (NO,[self getErrorForMessage:nil error:error]);
        }
    }];
}



- (void)checkShippingPincodeAvailabilityWithParameters:(NSDictionary *)parameters
                                       withRequestPath:(NSString *)requestPath
                                               payload:(NSArray *)payload
                                   withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:NO withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = (NSDictionary *)responseObject;
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                if ([[data objectForKey:@"statusCode"]  isEqualToNumber:[NSNumber numberWithInt:200]] ) {
                    if (completionBlock)
                        completionBlock(responseObject,nil);
                }
                else {
                    NSString *message = data[kMessageKey];
                    if (completionBlock)
                        completionBlock (nil, [self getErrorForMessage:message error:error]);
                }
                
            }
        }
        else {
            if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}
- (void)checkBillingPincodeAvailabilityWithParameters:(NSDictionary *)parameters
                                      withRequestPath:(NSString *)requestPath
                                              payload:(NSArray *)payload
                                  withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYWebServiceManager sharedManager] createGetRequestWithParameters:parameters withRequestPath:requestPath shouldCache:NO withCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *data = (NSDictionary *)responseObject;
            if ([self checkIfError:data]) {
                NSString *message = responseObject[kMessageKey];
                if (completionBlock)
                    completionBlock (nil, [self getErrorForMessage:message error:error]);
            }
            else {
                
                if ([[data objectForKey:@"statusCode"]  isEqualToNumber:[NSNumber numberWithInt:206]] ) {
                    NSString *message = data[kMessageKey];
                    if (completionBlock)
                        completionBlock (responseObject, [self getErrorForMessage:message error:error]);
                }
                else {
                    if (completionBlock)
                        completionBlock(responseObject,nil);
                }
            }
        }
        else {
            if (completionBlock)
                completionBlock (nil, [self getErrorForMessage:nil error:error]);
        }
    }];
}

@end
