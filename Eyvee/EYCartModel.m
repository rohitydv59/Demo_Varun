//
//  EYCartModel.m
//  Eyvee
//
//  Created by kartik shahzadpuri on 9/23/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYAllAPICallsManager.h"
#import "EYConstant.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"

@interface EYCartModel()
@property (nonatomic, strong) NSMutableArray * completionArr;
@end
@implementation EYCartModel

+ (EYCartModel *)sharedManager
{
    static dispatch_once_t onceToken;
    static EYCartModel *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        [sharedManager setup];
    });
    return sharedManager;
}

- (void)setup
{
    _completionArr = [NSMutableArray new];
}

- (void)setCartModel:(EYSyncCartMtlModel *)cartModel
{
    _cartModel = cartModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCartUpdatedNotification object:nil userInfo:@{@"count" : @(self.cartModel.cartProducts.count)}];
}

- (void)createCartWithCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    NSDictionary *payloadCreateCart;
    
     NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    if (userIdStr.length > 0) {
        payloadCreateCart = @{@"userId":userIdStr};
    }
    else {
        payloadCreateCart = @{@"cookie":@"123456abcd",@"userId":@"-1"};
    }
    
    [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:@{@"eventId" : @"0"} withRequestPath:kSyncCartRequestPath cache:NO payload:payloadCreateCart withCompletionBlock:^(id responseObject, EYError *error) {
        if (!error) {
            self.cartModel = responseObject;
        }
        completionBlock (responseObject, error);
    }];
}

- (BOOL)checkIfCartIdExists
{
    return ([[EYUtility shared] getCartId]);
}

- (void)operationsOnCart:(NSDictionary *)parameters requestPath:(NSString *)requestPath withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    
    //if ([self checkIfCartIdExists]) {
    
     NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    
    NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
    NSString * cookie = [[EYUtility shared] getCookie];
    NSDictionary *payload = @{@"userId":userIdStr,@"cartId": cartId,@"cookie":cookie};
    
    [self apiCallsOnCart:parameters requestPath:requestPath payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
            completionBlock (responseObject, error);
        }];
}

- (void)operationsOnCart:(NSDictionary *)parameters requestPath:(NSString *)requestPath payload:(NSDictionary *)payload withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
   
    if ([self checkIfCartIdExists]) {
        [self apiCallsOnCart:parameters requestPath:requestPath payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
            completionBlock (responseObject, error);
        }];
    }
    else {
        [self createCartWithCompletionBlock:^(id responseObject, EYError *error) {
            [self apiCallsOnCart:parameters requestPath:requestPath payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
                completionBlock (responseObject, error);
            }];
        }];
    }
}

- (void)apiCallsOnCart:(NSDictionary *)parameters requestPath:(NSString *)requestPath payload:(NSDictionary *)payload withCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:parameters withRequestPath:requestPath cache:NO payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if (!error)
            self.cartModel = responseObject;
        
        completionBlock (responseObject, error);
    }];
}

- (void)getCartItems
{

     NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    NSDictionary * payload = @{@"userId":userIdStr,@"cartId":@"2"};
    [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:@{@"eventId" : @(0)} withRequestPath:kSyncCartRequestPath cache:NO payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if (error) {
        }
        else
        {
            self.cartModel = (EYSyncCartMtlModel *)responseObject;
        }
    }];
}

- (void)getCartItemsWithCompletionBlock:(void(^)(id responseObject,EYError * error))completionBlock
{
    if (self.cartRequestState == cartRequestReceieved) {
        if (completionBlock) {
            completionBlock(_cartModel, nil);
        }
        return;
    }
    
    if (completionBlock) {
        [_completionArr addObject:completionBlock];
    }
    
    if (_cartRequestState == cartRequestInProcess) {
        return;
    }
    
    _cartRequestState = cartRequestInProcess;
    
     NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    
    NSString * userId = userIdStr?userIdStr:@"-1";
    
    NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
    NSString * cookie = [[EYUtility shared] getCookie];
    NSDictionary *payload = @{@"userId":userId,@"cartId": cartId,@"cookie":cookie};

    [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:nil withRequestPath:@"getUserCart.json" cache:NO payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if (error) {
            _cartRequestState = cartRequestError;
            for (void(^completionBlock)(id responseObject,EYError * error) in _completionArr) {
                completionBlock(nil,error);
            }
            _completionArr = [NSMutableArray new];
        }
        else
        {
            _cartRequestState = cartRequestReceieved;
            self.cartModel = (EYSyncCartMtlModel *)responseObject;
            for (void(^completionBlock)(id responseObject,EYError * error) in _completionArr) {
                completionBlock(_cartModel,nil);
            }
            
            _completionArr = [NSMutableArray new];
        }
    }];
}
//added
-(void)addProductIntoCartLocally:(EYProductsInfo*)productModel withSize:(NSString*)size
{
    bool canproductBeAdded = YES;
    if(![self getCartLocally])
    {
        _cartModel = [[EYSyncCartMtlModel alloc] init];
    }
    else
    {
        _cartModel = [self getCartLocally];
    }
    
    NSMutableArray * localArray = [[NSMutableArray alloc] initWithArray:_cartModel.cartProducts];
    if (localArray.count <= 0)
    {
        [localArray addObject:[self addingIntoCart:productModel withSize:size]];
        _cartModel.cartProducts = [localArray mutableCopy];
        [EYUtility showAlertView:@"Product added to cart successfully."];

    }
    else
    {
        
        
        for (EYSyncCartProductDetails * product in localArray)
        {
            
            if ((product.productId == productModel.productId))
            {
                canproductBeAdded = NO;
                break;
            }
        }
        if (canproductBeAdded)
        {
            [localArray addObject:[self addingIntoCart:productModel withSize:size]];
            _cartModel.cartProducts = [localArray mutableCopy];
            [EYUtility showAlertView:@"Product added to cart successfully."];

            
        }
        else
        {
            [EYUtility showAlertView:@"Product already in cart."];

        }
    }
    
    _cartModel.totalAmountPayable = [self gettingTotalAmountPayableWithCartModel:_cartModel];
    [self saveCartLocally:_cartModel];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCartUpdatedNotification object:nil userInfo:@{@"count" : @(_cartModel.cartProducts.count)}];

}

-(EYSyncCartProductDetails *) addingIntoCart:(EYProductsInfo*)productModel withSize:(NSString*)size
{
    EYSyncCartProductDetails * synchproductDetails = [[EYSyncCartProductDetails alloc] init];
    synchproductDetails.productId =productModel.productId;
    synchproductDetails.productName = productModel.productName;
    synchproductDetails.size = size;
    synchproductDetails.rentalPrice = productModel.originalPrice;
    synchproductDetails.productResizeImages = productModel.productResizeImages;
    return synchproductDetails;
}

-(NSNumber*)gettingTotalAmountPayableWithCartModel:(EYSyncCartMtlModel*)cart
{
  
    NSNumber* totalAmount;
    if (_cartModel.cartProducts.count == 0)
    {
        totalAmount = 0;
    }
    else
    {
        for (EYSyncCartProductDetails *product in cart.cartProducts) {
            totalAmount=[NSNumber numberWithFloat:([totalAmount floatValue]+ [product.rentalPrice floatValue])] ;
        }
    }
    return totalAmount;
}

- (void)saveCartLocally:(EYSyncCartMtlModel *)cartModel
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cartModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLocalCartKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (EYSyncCartMtlModel *)getCartLocally
{
    NSData * modelData = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalCartKey];
    EYSyncCartMtlModel * aModel = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
    return aModel;
}

@end
