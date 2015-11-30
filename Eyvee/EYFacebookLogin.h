//
//  EYFacebookLogin.h
//  Eyvee
//
//  Created by Neetika Mittal on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@class EYError;

@interface EYFacebookLogin : NSObject

+ (EYFacebookLogin *)sharedManger;
- (void)loginWithCompletionBlock:(void(^)(NSDictionary *dict, EYError *error))completionBlock;
//- (void)loginWithCompletionBlock:(void(^)(FBSDKLoginManagerLoginResult *responseObject, EYError *error))completionBlock;
//- (void)getProfileDetailsForUserToken:(NSString *)token WithCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;

@end
