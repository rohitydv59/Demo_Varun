//
//  EYSignUpMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYSignUpMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *emailId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSArray *address;
@property (nonatomic, strong) NSNumber *contactNo;
@property (nonatomic, strong) NSNumber *altContactNo;
@property (nonatomic, strong) NSString *authorizationToken;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *isFb;
@property (nonatomic, strong) NSNumber *isGplus;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *facebookAccessToken;
@property (nonatomic, strong) NSNumber *isResetPassword;
@property (nonatomic, strong) NSNumber *admin;

@end
