//
//  EYFacebookLogin.m
//  Eyvee
//
//  Created by Neetika Mittal on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "EYFacebookLogin.h"
#import "EYError.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYFacebookLogin ()

@property (nonatomic, strong) FBSDKLoginManager *loginManager;

@end

@implementation EYFacebookLogin

+ (EYFacebookLogin *)sharedManger
{
    static dispatch_once_t onceToken;
    static EYFacebookLogin *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:nil] init];
        [sharedManager setUp];
    });
    return sharedManager;
}

- (void)setUp
{
    self.loginManager = [[FBSDKLoginManager alloc] init];
    self.loginManager.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

- (void)loginWithCompletionBlock:(void(^)(NSDictionary *dict, EYError *error))completionBlock
{
    [EYUtility hideHUD];
    [self.loginManager logInWithReadPermissions:@[@"public_profile",@"user_photos"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            completionBlock (nil, [[EYError alloc] initWithError:error]);
        } else if (result.isCancelled) {
            EYError *err = [[EYError alloc] init];
            err.errorMessage = @"Login is cancelled. Please try again later.";
            completionBlock (nil, err);
        } else {
            [self getProfileDetailsForUserToken:result.token.tokenString WithCompletionBlock:^(NSMutableDictionary *fbDict, EYError *error) {
                if (error) {
                    completionBlock (nil, error);
                }
                else{
                    [fbDict setObject:result.token.userID forKey:@"facebookId"];
                    [fbDict setObject:result.token.tokenString forKey:@"facebookAccessToken"];
                    [fbDict setObject:@"true" forKey:@"isFb"];
                    completionBlock (fbDict, nil);
                }
            }];
        }
    }];
    
//    [self.loginManager
//     logInWithReadPermissions: @[@"public_profile",@"email"]
//     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//         if (error) {
//             completionBlock (nil, [[EYError alloc] initWithError:error]);
//         } else if (result.isCancelled) {
//             EYError *err = [[EYError alloc] init];
//             err.errorMessage = @"Login is cancelled. Please try again later.";
//             completionBlock (nil, err);
//         } else {
//             [self getProfileDetailsForUserToken:result.token.tokenString WithCompletionBlock:^(NSMutableDictionary *fbDict, EYError *error) {
//                 if (error) {
//                     completionBlock (nil, error);
//                 }
//                 else{
//                     [fbDict setObject:result.token.userID forKey:@"facebookId"];
//                     [fbDict setObject:result.token.tokenString forKey:@"facebookAccessToken"];
//                     [fbDict setObject:@"true" forKey:@"isFb"];
//                    completionBlock (fbDict, nil);
//                 }
//             }];
//         }
//     }];
}

- (void)getProfileDetailsForUserToken:(NSString *)token WithCompletionBlock:(void(^)(NSMutableDictionary *fbDict, EYError *error))completionBlock
{
    [EYUtility showHUDWithTitle:nil];
    NSDictionary *params = @{@"fields":@"email, name, first_name, last_name"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params tokenString:token version:@"v2.5" HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (error) {
             completionBlock (nil, [[EYError alloc] initWithError:error]);
         }
         else{
             NSString *email = [result valueForKey:@"email"];
             NSString *firstName = [result valueForKey:@"first_name"];
             NSString *lastName = [result valueForKey:@"last_name"];
             NSString *fullName = [result valueForKey:@"name"];
           
             NSMutableDictionary *fbData = [[NSMutableDictionary alloc]init];
             if (email)
                 [fbData setObject:email forKey:@"emailId"];
             if (firstName)
                 [fbData setObject:firstName forKey:@"firstName"];
             if (lastName)
                 [fbData setObject:lastName forKey:@"lastName"];
             if (fullName)
                 [fbData setObject:fullName forKey:@"fullName"];
             
             completionBlock(fbData, nil);
         }
     }];
}

@end
