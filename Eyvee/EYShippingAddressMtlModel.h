//
//  EYShippingAddressMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 24/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "EYError.h"
@interface EYAllAddressMtlModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSArray * allAdrresses;
//+ (EYAllAddressMtlModel *) sharedManager;
//@property (nonatomic, strong) NSArray * all_Addr;
//- (void)apiCallForAllAddress:(NSDictionary *)parameters requestPath:(NSString *)requestPath withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

@end

@interface EYShippingAddressMtlModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *addressId;
@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *pincode;
@property (nonatomic, strong) NSNumber *city;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) NSNumber *country;
@property (nonatomic, strong) NSString *contactNum;
@property (nonatomic, strong) NSString *altContactNo;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSNumber *createdBy;
@property (nonatomic, strong) NSString *createdOn;
@property (nonatomic, strong) NSNumber *modifiedBy;
@property (nonatomic, strong) NSString *modifiedOn;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *stateName;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *addressType;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) EYShippingAddressMtlModel * billingAddress;
@property (nonatomic, strong) NSNumber *shippingAddressId;

@end
