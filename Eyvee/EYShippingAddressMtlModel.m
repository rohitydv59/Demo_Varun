//
//  EYShippingAddressMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 24/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYShippingAddressMtlModel.h"
#import "EYError.h"
#import "EYAllAPICallsManager.h"
@implementation EYAllAddressMtlModel

//+ (EYAllAddressMtlModel *)sharedManager
//{
//    static dispatch_once_t onceToken;
//    static EYAllAddressMtlModel *sharedManager = nil;
//    dispatch_once(&onceToken, ^{
//        sharedManager = [[self alloc] init];
//    });
//    return sharedManager;
//}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_allAdrresses forKey:@"allAddress"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _allAdrresses = [decoder decodeObjectForKey:@"allAddress"];
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        NSMutableArray * allShippingAddreses = [NSMutableArray new];
        
        for (EYShippingAddressMtlModel * billingAddrs in _allAdrresses) {
            if ([billingAddrs.shippingAddressId isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [allShippingAddreses addObject:billingAddrs];
            }
        }
        
        for (EYShippingAddressMtlModel * billingAddrs in _allAdrresses)
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
        _allAdrresses = [[NSArray alloc] initWithArray:allShippingAddreses];
        
    }
    return self;
}
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"allAdrresses" : @"data"
             };
}

+ (NSValueTransformer *)allAdrressesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYShippingAddressMtlModel class]];
}

//- (void)apiCallForAllAddress:(NSDictionary *)parameters requestPath:(NSString *)requestPath withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
//{
//    [[EYAllAPICallsManager sharedManager]getAllUserAddressesRequestWithParameters:nil withRequestPath:requestPath shouldCache:NO withCompletionBlock:^(id responseObject, EYError *error)
//     {
//         if (!error)
//         {
//             _all_Addr = (EYAllAddressMtlModel *)responseObject;
//         }
//          completionBlock (responseObject, error);
//    
//     }];
//}

@end

@implementation EYShippingAddressMtlModel

-(id)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        if (_contactNum.length > 0) {
            
        }
        else
            _contactNum = @"";
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"addressId" : @"addressId",
             @"addressLine1" : @"addressLine1",
             @"addressLine2" : @"addressLine2",
             @"pincode" : @"pincode",
             @"city" : @"city",
             @"state" : @"state",
             @"country" : @"country",
             @"contactNum" : @"contactNum",
             @"altContactNo" : @"altContactNo",
             @"isActive" : @"isActive",
             @"createdOn" : @"createdOn",
             @"modifiedOn" : @"modifiedOn",
             @"createdBy" : @"createdBy",
             @"modifiedBy" : @"modifiedBy",
             @"cityName" : @"cityName",
             @"stateName" : @"stateName",
             @"countryName" : @"countryName",
             @"userId" : @"userId",
             @"addressType" : @"addressType",
             @"fullName" : @"fullName",
             @"shippingAddressId" : @"shippingAddressId"
             };
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_addressId forKey:@"addressId"];
    [encoder encodeObject:_addressLine1 forKey:@"addressLine1"];
    [encoder encodeObject:_addressLine2 forKey:@"addressLine2"];
    [encoder encodeObject:_pincode forKey:@"pincode"];
    [encoder encodeObject:_city forKey:@"city"];
    [encoder encodeObject:_state forKey:@"state"];
    [encoder encodeObject:_country forKey:@"country"];
    [encoder encodeObject:_contactNum forKey:@"contactNum"];
    [encoder encodeObject:_altContactNo forKey:@"altContactNo"];
    [encoder encodeObject:_isActive forKey:@"isActive"];
    [encoder encodeObject:_createdOn forKey:@"createdOn"];
    [encoder encodeObject:_modifiedOn forKey:@"modifiedOn"];
    [encoder encodeObject:_createdBy forKey:@"createdBy"];
    [encoder encodeObject:_modifiedBy forKey:@"modifiedBy"];
    [encoder encodeObject:_cityName forKey:@"cityName"];
    [encoder encodeObject:_stateName forKey:@"stateName"];
    [encoder encodeObject:_countryName forKey:@"countryName"];
    [encoder encodeObject:_userId forKey:@"userId"];
    [encoder encodeObject:_addressType forKey:@"addressType"];
    [encoder encodeObject:_fullName forKey:@"fullName"];
    [encoder encodeObject:_shippingAddressId forKey:@"shippingAddressId"];
    [encoder encodeObject:_billingAddress forKey:@"billingAddress"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    _addressId = [decoder decodeObjectForKey:@"addressId"];
    _addressLine1 = [decoder decodeObjectForKey:@"addressLine1"];
    _addressLine2 = [decoder decodeObjectForKey:@"addressLine2"];
    _pincode = [decoder decodeObjectForKey:@"pincode"];
    _city = [decoder decodeObjectForKey:@"city"];
    _state = [decoder decodeObjectForKey:@"state"];
    _country = [decoder decodeObjectForKey:@"country"];
    _contactNum = [decoder decodeObjectForKey:@"contactNum"];
    _altContactNo = [decoder decodeObjectForKey:@"altContactNo"];
    _isActive = [decoder decodeObjectForKey:@"isActive"];
    _createdOn = [decoder decodeObjectForKey:@"createdOn"];
    _modifiedOn = [decoder decodeObjectForKey:@"modifiedOn"];
    _cityName = [decoder decodeObjectForKey:@"cityName"];
    _stateName = [decoder decodeObjectForKey:@"stateName"];
    _countryName = [decoder decodeObjectForKey:@"countryName"];
    _userId = [decoder decodeObjectForKey:@"userId"];
    _addressType = [decoder decodeObjectForKey:@"addressType"];
    _fullName = [decoder decodeObjectForKey:@"fullName"];
    _shippingAddressId = [decoder decodeObjectForKey:@"shippingAddressId"];
    _billingAddress = [decoder decodeObjectForKey:@"billingAddress"];
    return self;
}

//+ (NSValueTransformer *)contactNumJSONTransformer
//{
//       return [MTLValueTransformer transformerUsingForwardBlock:^id(id number, BOOL *success, NSError *__autoreleasing *error) {
//           if ([number isKindOfClass:[NSNumber class]])
//               return number;
//           else
//               return nil;
//        }];
//        
//}


@end