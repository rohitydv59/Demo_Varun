//
//  EYAccountManager.h
//  Eyvee
//
//  Created by Rohit Yadav on 19/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EYUserInfo;
@class EYError;

@interface EYAccountManager : NSObject

@property (nonatomic, strong) EYUserInfo *loggedInUser;
@property (assign, readonly) BOOL isUserLoggedIn;
@property (assign, readonly) BOOL isGuestMode;


+ (EYAccountManager *)sharedManger;
- (void)updateUserAccountInfo;
- (void)saveUserDetailsWithData:(NSDictionary *)data;
+ (void)saveData:(id)data withKey:(NSString *)key;
+ (void)removeDataForKey:(NSString *)key;
+ (id)getDataForKey:(NSString*)key;

- (void)setGuestMode;
- (void)userLoggedOut;



//for facebook login/signup
- (void)createUserViaFBWithCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;

- (void)createUserWithPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;

- (void)updateUserProfileWithParams :(NSDictionary *)params andPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;

- (void) loginUserForParams:(NSDictionary *)params andPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;

- (void) resetPasswordWithParams:(NSDictionary *)params andPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(NSString *message, EYError *error))completionBlock;

- (void) updatePasswordWithParams:(NSDictionary *)params andPayload:(NSDictionary *)payload withCompletionBlock:(void(^)(NSString *message, EYError *error))completionBlock;

@end
