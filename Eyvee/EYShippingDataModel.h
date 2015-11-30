//
//  EYShippingDataModel.h
//  Eyvee
//
//  Created by Disha Jain on 24/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYShippingDataModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *houseNumber;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *billingHouseNo;
@property (nonatomic, strong) NSString *billingAddressLine2;
@property (nonatomic, strong) NSString *billingCity;
@property (nonatomic, strong) NSString *billingPostalCode;

@end
