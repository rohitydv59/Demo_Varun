//
//  EYUserWishlistMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 22/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYUserWishlistMtlModel.h"
#import "EYConstant.h"

@implementation EYAllWishlistMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"allWishlists" : @"data"
             };
}

+ (NSValueTransformer *)allWishlistsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYUserWishlistMtlModel class]];
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_allWishlists forKey:@"allWishlists"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _allWishlists = [decoder decodeObjectForKey:@"allWishlists"];
    return self;
}

@end
@implementation EYUserWishlistMtlModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userWishlistId" : @"userWishlistId",
             @"wishlistName" : @"wishlistName",
             @"userId" : @"userId",
             @"productId" : @"productId",
             @"productIds" : @"productIds",
             @"products" : @"products",
             @"eventName" : @"eventName",
             @"isActive" : @"isActive",
             @"createdBy" : @"createdBy",
             @"modifiedBy" : @"modifiedBy",
             @"createdOn" : @"createdOn",
             @"modifiedOn" : @"modifiedOn",
             @"productInfo" : @"productInfo",
             @"productsList" : @"productsList"
             };
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_userWishlistId forKey:@"userWishlistId"];
    [encoder encodeObject:_wishlistName forKey:@"wishlistName"];
    [encoder encodeObject:_userId forKey:@"userId"];
    [encoder encodeObject:_productId forKey:@"productId"];
    [encoder encodeObject:_productIds forKey:@"productIds"];
    [encoder encodeObject:_products forKey:@"products"];
    [encoder encodeObject:_eventName forKey:@"eventName"];
    [encoder encodeObject:_isActive forKey:@"isActive"];
    [encoder encodeObject:_createdBy forKey:@"createdBy"];
    [encoder encodeObject:_modifiedBy forKey:@"modifiedBy"];
    [encoder encodeObject:_createdOn forKey:@"createdOn"];
    [encoder encodeObject:_modifiedOn forKey:@"modifiedOn"];
    [encoder encodeObject:_productInfo forKey:@"productInfo"];
    [encoder encodeObject:_productsList forKey:@"productsList"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _userWishlistId = [decoder decodeObjectForKey:@"userWishlistId"];
    _wishlistName = [decoder decodeObjectForKey:@"wishlistName"];
    _userId = [decoder decodeObjectForKey:@"userId"];
    _productId = [decoder decodeObjectForKey:@"productId"];
    _productIds = [decoder decodeObjectForKey:@"productIds"];
    _products = [decoder decodeObjectForKey:@"products"];
    _eventName = [decoder decodeObjectForKey:@"eventName"];
    _isActive = [decoder decodeObjectForKey:@"isActive"];
    _createdBy = [decoder decodeObjectForKey:@"createdBy"];
    _modifiedBy = [decoder decodeObjectForKey:@"modifiedBy"];
    _createdOn = [decoder decodeObjectForKey:@"createdOn"];
    _modifiedOn = [decoder decodeObjectForKey:@"modifiedOn"];
    _productInfo = [decoder decodeObjectForKey:@"productInfo"];
    _productsList = [decoder decodeObjectForKey:@"productsList"];
    
    return self;
}

@end
