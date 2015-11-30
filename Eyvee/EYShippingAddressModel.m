//
//  EYShippingAddressModel.m
//  Eyvee
//
//  Created by Disha Jain on 28/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYShippingAddressModel.h"
#import "EYAllAPICallsManager.h"

@implementation EYShippingAddressModel

+ (EYShippingAddressModel *)sharedManager
{
    static dispatch_once_t onceToken;
    static EYShippingAddressModel *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)apiCallForAllAddress:(NSDictionary *)parameters requestPath:(NSString *)requestPath withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYAllAPICallsManager sharedManager]getAllUserAddressesRequestWithParameters:nil withRequestPath:requestPath shouldCache:NO withCompletionBlock:^(id responseObject, EYError *error)
     {
         if (completionBlock)
         {
             completionBlock (responseObject, error);
 
         }
         
     }];
}

@end
