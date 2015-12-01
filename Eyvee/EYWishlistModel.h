//
//  WishlistModel.h
//  Eyvee
//
//  Created by Varun Kapoor on 01/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EYUserWishlistMtlModel.h"

@class EYAllWishlistMtlModel;
@class EYError;
@class EYGetAllProductsMTLModel;
typedef enum {
    wishlistRequestNeedToSend,
    wishlistRequestInProcess,
    wishlistRequestReceieved,
    wishlistRequestError
} WishlistRequestState;

@interface EYWishlistModel : NSObject
@property (nonatomic, strong) EYAllWishlistMtlModel * wishlistModel;
@property (nonatomic, strong) EYGetAllProductsMTLModel * allProductsInWishlist;
//@property (nonatomic) NSInteger badgeCount;

@property (nonatomic, strong) NSArray * productIdsArray;
@property (nonatomic) WishlistRequestState wishlistRequestState;

+ (EYWishlistModel *) sharedManager;
- (void)updateWishListModel;
- (void)updateWishListModelWithCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;
- (void)updateProductIdsOfWishlist;
- (void)updateProductIdsOfWishlistWithCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;
- (void)getWishlistItemsWithCompletionBlock:(void(^)(id responseObject,EYError * error))completionBlock;

- (void)saveWishListLocally:(EYGetAllProductsMTLModel *)wishlistModel;
- (EYGetAllProductsMTLModel *)getWishlistLocally;

- (void)saveWishListProductIdsLocally:(NSArray *)wishListProductIdsArray;
- (NSArray *)getWishlistProductIdsLocally;

@end
