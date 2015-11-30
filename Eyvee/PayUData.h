//
//  PayUData.h
//  Eyvee
//
//  Created by Neetika Mittal on 07/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EYPayUResponseDetailsMtlModel;

@interface PayUData : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, assign) float totalAmount;
@property (nonatomic, strong) NSString *productInfo;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *sURL;
@property (nonatomic, strong) NSString *cUrl;
@property (nonatomic, strong) NSString *fURL;
@property (nonatomic, strong) NSString *appTitle;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSString *udf1;
@property (nonatomic, strong) NSString *udf2;
@property (nonatomic, strong) NSString *udf3;
@property (nonatomic, strong) NSString *udf4;
@property (nonatomic, strong) NSString *udf5;
@property (nonatomic, strong) NSString *hashKey;
@property (nonatomic, strong) NSString *command;

- (void)getAllPaymentsAvailableOptionDataWithCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;
- (NSURLRequest *)getRequestForNetbanking:(EYPayUResponseDetailsMtlModel *)detailModel;

- (NSURLRequest *)getRequestForCardWithCardNumber:(NSString *)cardNum expiryMonth:(NSString *)month expiryYear:(NSString *)year name:(NSString *)nameOnCard cvv:(NSString *)cvv saveCard:(BOOL)saveCard;

@end
