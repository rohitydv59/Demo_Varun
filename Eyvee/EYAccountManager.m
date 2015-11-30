//
//  EYAccountManager.m
//  Eyvee
//
//  Created by Rohit Yadav on 19/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYAccountManager.h"
#import "EYFacebookLogin.h"
#import "EYAllAPICallsManager.h"
#import "EYCartModel.h"
#import "EYWishlistModel.h"
#import "EYUserInfo.h"
#import "EYConstant.h"
#import "EYError.h"

@implementation EYAccountManager

+ (EYAccountManager *)sharedManger
{
    static dispatch_once_t onceToken;
    static EYAccountManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:nil] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

+ (void)saveData:(id)data withKey:(NSString *)key
{
    if (!data) {
        return;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:data forKey:key];
    [prefs synchronize];
}

+ (void)removeDataForKey:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:key];
    [prefs synchronize];
}

+ (id)getDataForKey:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    id data = [prefs objectForKey:key];
    return data;
}


- (void)updateUserAccountInfo
{
    self.loggedInUser = [[EYUserInfo alloc] init];
    
    _loggedInUser.email = [EYAccountManager getDataForKey:kEmailIdKey];
    _loggedInUser.phoneNumber = [EYAccountManager getDataForKey:kContactNoKey];
     _loggedInUser.accessToken = [EYAccountManager getDataForKey:kAuthorizationTokenKey];
    _loggedInUser.firstName = [EYAccountManager getDataForKey:kFirstNameKey];
    _loggedInUser.lastName = [EYAccountManager getDataForKey:kLastNameKey];
    
    NSNumber *userID = [EYAccountManager getDataForKey:kUserId];
    if ([userID isKindOfClass:[NSNull class]] || userID < [NSNumber numberWithInt:1] ) {
        _loggedInUser.userId = [NSNumber numberWithInt:-1];
    }
    else
    _loggedInUser.userId  = [EYAccountManager getDataForKey:kUserId];
    
    _loggedInUser.isFbLogin = [EYAccountManager getDataForKey:kIsFbLogin];
    _loggedInUser.userToken = [EYAccountManager getDataForKey:kUserTokenKey];
    _loggedInUser.fullName = [EYAccountManager getDataForKey:kFullNameKey];
    
    _isUserLoggedIn = [_loggedInUser.accessToken length] > 0;
    _isGuestMode = (!_isUserLoggedIn && [[EYAccountManager getDataForKey:@"isGuest"] isEqualToString:@"yes"]) ? YES : NO;
}

- (void)userLoggedOut
{
    // user account keys
    [EYAccountManager removeDataForKey:kEmailIdKey];
    [EYAccountManager removeDataForKey:kContactNoKey];
    [EYAccountManager removeDataForKey:kAuthorizationTokenKey];
    [EYAccountManager removeDataForKey:kFirstNameKey];
    [EYAccountManager removeDataForKey:kLastNameKey];
    [EYAccountManager removeDataForKey:kUserId];
    [EYAccountManager removeDataForKey:kIsFbLogin];
    [EYAccountManager removeDataForKey:kUserTokenKey];
    [EYAccountManager removeDataForKey:kFullNameKey];
   
    //api related keys
    [EYAccountManager removeDataForKey:kCartIdKey];
    [EYAccountManager removeDataForKey:kCookieKey];
    [EYAccountManager removeDataForKey:kPinCodeKey];
    [EYAccountManager removeDataForKey:kLocalAddressKey];
    
    EYCartModel * cart = [EYCartModel sharedManager];
    cart.cartModel = nil;
    EYWishlistModel * wishlist = [EYWishlistModel sharedManager];
    wishlist.wishlistModel = nil;
    wishlist.allProductsInWishlist = nil;
    wishlist.productIdsArray = nil;
    [self updateUserAccountInfo];
}

- (void)saveUserDetailsWithData:(NSDictionary *)data
{
    if ([[data allKeys] containsObject:kUserId]) {
        [EYAccountManager saveData:data[kUserId] withKey:kUserId];
    }
    if ([[data allKeys] containsObject:kContactNoKey]) {
        [EYAccountManager saveData:data[kContactNoKey] withKey:kContactNoKey];
    }
    if ([[data allKeys] containsObject:kEmailIdKey]) {
        [EYAccountManager saveData:data[kEmailIdKey] withKey:kEmailIdKey];
    }
    if ([[data allKeys] containsObject:kAuthorizationTokenKey]) {
        [EYAccountManager saveData:data[kAuthorizationTokenKey] withKey:kAuthorizationTokenKey];
    }
    if ([[data allKeys] containsObject:kFirstNameKey]) {
        [EYAccountManager saveData:data[kFirstNameKey] withKey:kFirstNameKey];
    }
    if ([[data allKeys] containsObject:kLastNameKey]) {
        [EYAccountManager saveData:data[kLastNameKey] withKey:kLastNameKey];
    }
    if ([[data allKeys] containsObject:kIsFbLogin]) {
        [EYAccountManager saveData:data[kIsFbLogin] withKey:kIsFbLogin];
    }
    if ([[data allKeys]containsObject:kAuthorizationTokenKey]) {
        [EYAccountManager saveData:data[kAuthorizationTokenKey] withKey:kUserTokenKey];
         [EYAccountManager removeDataForKey:@"isGuest"];
    }
    if ([[data allKeys]containsObject:kFullNameKey]) {
        [EYAccountManager saveData:data[kFullNameKey] withKey:kFullNameKey];
    }
    [self updateUserAccountInfo];
}

- (void)setGuestMode
{
    [EYAccountManager saveData:@"yes" withKey:@"isGuest"];
}


- (void)createUserViaFBWithCompletionBlock:(void(^)(bool success, EYError *error))completionBlock
{
    [[EYFacebookLogin sharedManger]loginWithCompletionBlock:^(NSDictionary *dict, EYError *error) {
        if (!error) {
            [[EYAllAPICallsManager sharedManager] signUpRequestWithParameters:nil withRequestPath:kSignInRequestPath payload:dict withCompletionBlock:^(id responseObject, EYError *error)
             {
                 [EYUtility hideHUD];
                 if (!error) {
                     NSDictionary *dict = responseObject[@"data"];
                     [self saveUserDetailsWithData:dict];
                     [self updateUserAccountInfo];
                     if (completionBlock) {
                         completionBlock(YES, nil);
                     }
                 }
                 else
                 {
                     if (completionBlock) {
                         completionBlock(NO,error);
                     }
                 }
                 
             }];
        }
        else
        {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];
}


- (void)createUserWithPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(bool success, EYError *error))completionBlock
{
     [[EYAllAPICallsManager sharedManager] signUpRequestWithParameters:nil withRequestPath:kSignUpRequestPath payload:payload withCompletionBlock:^(id responseObject, EYError *error)
      {
          if (responseObject && !error)
          {
                  NSDictionary *dict = responseObject[@"data"];
                  [self saveUserDetailsWithData:dict];
                  [self updateUserAccountInfo];
                  if (completionBlock) {
                      completionBlock(YES, nil);
                  }
              }
              else
              {
                  if (completionBlock) {
                      completionBlock(NO,error);
                  }
              }

      }];
}

- (void)updateUserProfileWithParams :(NSDictionary *)params andPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(bool success, EYError *error))completionBlock
{
    [[EYAllAPICallsManager sharedManager]updateProfileRequestWithParameters:params withRequestPath:kUpdateUserProfile payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if (responseObject && !error)
        {
            NSDictionary *dict = responseObject[@"data"];
            [self saveUserDetailsWithData:dict];
            [self updateUserAccountInfo];
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        }
        else
        {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];
}


- (void) loginUserForParams:(NSDictionary *)params andPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(bool success, EYError *error))completionBlock
{
    [[EYAllAPICallsManager sharedManager]signUpRequestWithParameters:nil withRequestPath:kSignInRequestPath payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        
        [EYUtility hideHUD];
        if(responseObject && !error)
        {
            NSDictionary *dict = responseObject[@"data"];
            [self saveUserDetailsWithData:dict];
            [self updateUserAccountInfo];
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        }
        else
        {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];
}

- (void) resetPasswordWithParams:(NSDictionary *)params andPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(NSString *message, EYError *error))completionBlock
{
    [[EYAllAPICallsManager sharedManager]resetPasswordRequestWithParameters:params withRequestPath:kResetPasswordPath payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if(responseObject && !error)
        {
            NSLog(@"response object : %@",responseObject);
            if (completionBlock) {
                completionBlock(responseObject[@"message"], nil);
            }
        }
        else
        {
            if (completionBlock) {
                completionBlock(nil,error);
            }
        }
    }];
}

- (void) updatePasswordWithParams:(NSDictionary *)params andPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(NSString *message, EYError *error))completionBlock
{
    [[EYAllAPICallsManager sharedManager]updatePasswordRequestWithParameters:params withRequestPath:kUpdatePasswordPath payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if(responseObject && !error)
        {
            NSLog(@"response object : %@",responseObject);
            if (completionBlock) {
                completionBlock(responseObject[@"message"], nil);
            }
        }
        else
        {
            if (completionBlock) {
                completionBlock(nil,error);
            }
        }
    }];
}



@end
