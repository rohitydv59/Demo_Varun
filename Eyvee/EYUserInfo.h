//
//  EYUserInfo.h
//  Eyvee
//
//  Created by Rohit Yadav on 19/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYUserInfo : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, assign) BOOL isFbLogin;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic, strong) NSString * userToken;
@property (nonatomic, strong) NSString *imgUrl;

@end
