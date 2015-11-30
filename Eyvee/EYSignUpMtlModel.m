//
//  EYSignUpMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYSignUpMtlModel.h"

@implementation EYSignUpMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"userId",
             @"firstName" : @"firstName",
             @"lastName" : @"lastName",
             @"emailId": @"emailId",
             @"password": @"password",
             @"address" : @"address",
             @"contactNo" : @"contactNo",
             @"altContactNo" : @"altContactNo",
             @"authorizationToken" : @"authorizationToken",
             @"dateOfBirth" : @"dateOfBirth",
             @"gender" : @"gender",
             @"status" : @"status",
             @"isFb" : @"isFb",
             @"isGplus" : @"isGplus",
             @"facebookId" : @"facebookId",
             @"facebookAccessToken" : @"facebookAccessToken",
             @"isResetPassword" : @"isResetPassword",
             @"admin" : @"admin"
             };
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    return dateFormatter;
}

@end
