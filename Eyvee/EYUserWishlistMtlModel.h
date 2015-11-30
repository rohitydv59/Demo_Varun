//
//  EYUserWishlistMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 22/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYAllWishlistMtlModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSArray * allWishlists;
@end


@interface EYUserWishlistMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *userWishlistId;
@property (nonatomic, strong) NSString *wishlistName;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSArray *productIds;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSNumber *createdBy;
@property (nonatomic, strong) NSString *createdOn;
@property (nonatomic, strong) NSNumber *modifiedBy;
@property (nonatomic, strong) NSString *modifiedOn;
@property (nonatomic, strong) NSString *productInfo;
@property (nonatomic, strong) NSArray *productsList;


@end
