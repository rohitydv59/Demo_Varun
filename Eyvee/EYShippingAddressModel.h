//
//  EYShippingAddressModel.h
//  Eyvee
//
//  Created by Disha Jain on 28/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EYAllAddressMtlModel;
@class EYError;

@interface EYShippingAddressModel : NSObject
@property (nonatomic, strong) EYAllAddressMtlModel * allAddressModel;
+ (EYShippingAddressModel *) sharedManager;
- (void)apiCallForAllAddress:(NSDictionary *)parameters requestPath:(NSString *)requestPath withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

@end
