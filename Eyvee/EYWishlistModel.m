//
//  WishlistModel.m
//  Eyvee
//
//  Created by Varun Kapoor on 01/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYWishlistModel.h"
#import "EYAllAPICallsManager.h"
#import "EYConstant.h"
#import "EYGetAllProductsMTLModel.h"

@interface EYWishlistModel()
@property (nonatomic, strong) NSMutableArray * completionArr;
@end
@implementation EYWishlistModel

+ (EYWishlistModel *)sharedManager
{
    static dispatch_once_t onceToken;
    static EYWishlistModel *sharedManager = nil;
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

- (void)setAllProductsInWishlist:(EYGetAllProductsMTLModel *)allProductsInWishlist
{
    _allProductsInWishlist = allProductsInWishlist;
    [[NSNotificationCenter defaultCenter]postNotificationName:kWishListUpdateNotification object:nil userInfo:@{@"count":@(self.allProductsInWishlist.productsInfo.count)}];
}

-(void)updateProductIdsOfWishlist               // for fav button
{
    [[EYAllAPICallsManager sharedManager] getProductIdsInUserWishlistRequestWithParameters:nil withRequestPath:kGetProductIdsInUserWishlist cache:NO payload:nil withCompletionBlock:^(id responseObject, EYError *error) {
        if (!error && responseObject)
        {
            _productIdsArray = (NSArray *)responseObject;
        }
    }];
}

- (void)updateProductIdsOfWishlistWithCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYAllAPICallsManager sharedManager] getProductIdsInUserWishlistRequestWithParameters:nil withRequestPath:kGetProductIdsInUserWishlist cache:NO payload:nil withCompletionBlock:^(id responseObject, EYError *error) {
        if (!error)
        {
            if (responseObject)
            {
                _productIdsArray = (NSArray *)responseObject;
                if (completionBlock)
                    completionBlock(_productIdsArray ,nil);
            }
            else
            {
                _productIdsArray = nil;
                if (completionBlock)
                    completionBlock(_productIdsArray ,nil);

            }
        }
        else
            if (completionBlock)
                completionBlock(nil,error);
        
    }];
}

- (void)updateWishListModel
{
    [[EYAllAPICallsManager sharedManager] getAllUserWishlistRequestWithParameters:nil withRequestPath:kGetAllUserWishlistsRequestPath cache:NO withCompletionBlock:^(id responseObject, EYError *error) {
        if (!error && responseObject)
        {
            self.wishlistModel = (EYAllWishlistMtlModel *)responseObject;
        }

    }];
}

- (void)updateWishListModelWithCompletionBlock:(void(^)(id responseObject, EYError *error))completionBlock
{
    [[EYAllAPICallsManager sharedManager] getAllUserWishlistRequestWithParameters:nil withRequestPath:kGetAllUserWishlistsRequestPath cache:NO withCompletionBlock:^(id responseObject, EYError *error) {
        if (!error && responseObject)
        {
            self.wishlistModel = (EYAllWishlistMtlModel *)responseObject;
            if (completionBlock)
                completionBlock(_wishlistModel,nil);
        }
        else
            if (completionBlock)
                completionBlock(nil,error);
        
    }];
}

- (void)getWishlistItemsWithCompletionBlock:(void(^)(id responseObject,EYError * error))completionBlock
{
    if (completionBlock) {
        [_completionArr addObject:completionBlock];
    }
    
    if (_wishlistRequestState == wishlistRequestInProcess) {
        return;
    }
    
    _wishlistRequestState = wishlistRequestInProcess;
    
    [[EYAllAPICallsManager sharedManager] getAllProductsOfUserWishList:nil withRequestPath:kGetAllProductsOfUserWishList cache:NO withCompletionBlock:^(id responseObject, EYError *error)
     {
         if (!error)
         {
             _wishlistRequestState = wishlistRequestReceieved;
             self.allProductsInWishlist = (EYGetAllProductsMTLModel *)responseObject;
             
             for (void(^completionBlock)(id responseObject,EYError * error) in _completionArr) {
                 if (completionBlock)
                     completionBlock(_allProductsInWishlist,nil);
             }
             
             _completionArr = [NSMutableArray new];
             
         }
         else
         {
             _wishlistRequestState = wishlistRequestError;
             for (void(^completionBlock)(id responseObject,EYError * error) in _completionArr) {
                 if (completionBlock)
                     completionBlock(nil,error);
             }         }
         _completionArr = [NSMutableArray new];
     }];
}


- (void)saveWishListLocally:(EYUserWishlistMtlModel *)wishlistModel
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:wishlistModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLocalWishlistKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (EYUserWishlistMtlModel *)getWishlistLocally
{
    NSData * modelData = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalWishlistKey];
    EYUserWishlistMtlModel * aModel = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
    return aModel;
}



@end
