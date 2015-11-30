//
//  EYCartModel.h
//  Eyvee
//
//  Created by kartik shahzadpuri on 9/23/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EYGetAllProductsMTLModel.h"

@class EYSyncCartMtlModel;
@class EYSyncCartProductDetails, EYError;

typedef enum {
    cartRequestNeedToSend,
    cartRequestInProcess,
    cartRequestReceieved,
    cartRequestError
} CartRequestState;


@interface EYCartModel : NSObject
@property (nonatomic, strong) EYSyncCartMtlModel * cartModel;
@property (nonatomic) CartRequestState cartRequestState;
+ (EYCartModel *) sharedManager;
//- (void)getCartItems;
- (void)getCartItemsWithCompletionBlock:(void(^)(id responseObject,EYError * error))completionBlock;

// call this when you want only userId and cartId in payload
- (void)operationsOnCart:(NSDictionary *)parameters requestPath:(NSString *)requestPath withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

- (void)operationsOnCart:(NSDictionary *)parameters requestPath:(NSString *)requestPath payload:(NSDictionary *)payload withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;
- (void)createCartWithCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock;

//added:

-(void)addProductIntoCartLocally:(EYProductsInfo*)productModel withSize:(NSString*)size;
- (EYSyncCartMtlModel *)getCartLocally;
- (void)saveCartLocally:(EYSyncCartMtlModel *)cartModel;
-(NSNumber*)gettingTotalAmountPayableWithCartModel:(EYSyncCartMtlModel*)cart;


@end
