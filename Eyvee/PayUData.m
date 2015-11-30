//
//  PayUData.m
//  Eyvee
//
//  Created by Neetika Mittal on 07/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "PayUData.h"
#import "EYUtility.h"
#import "PayUWebServiceManager.h"
#import "PayUConstant.h"
#import "Utils.h"
#import "EYPayUResponseMtlModel.h"

@implementation PayUData

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialiseParams];
    }
    return self;
}

- (void)initialiseParams
{
    self.key = @"gtKFFx";
    self.transactionId = [[EYUtility shared] randomStringWithLength:15];
    self.appTitle = @"evyee";
    self.salt = @"eCwWELxi";
    self.udf1 = @"";
    self.udf2 = @"";
    self.udf3 = @"";
    self.udf4 = @"";
    self.udf5 = @"";
}

- (void)getAllPaymentsAvailableOptionDataWithCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    [[PayUWebServiceManager sharedManger] getAllPaymentsAvailableOptionData:self withCompletionBlock:^(id responseObject, NSError *error) {
        completionBlock (responseObject, error);
    }];
}

- (NSURLRequest *)getRequestForCardWithCardNumber:(NSString *)cardNum expiryMonth:(NSString *)month expiryYear:(NSString *)year name:(NSString *)nameOnCard cvv:(NSString *)cvv saveCard:(BOOL)saveCard
{
    NSURL *restURL = [NSURL URLWithString:PAYU_PAYMENT_BASE_URL];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:restURL
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    theRequest.HTTPMethod = @"POST";
    NSMutableString *postData = [[NSMutableString alloc] init];
    [postData appendFormat:@"%@=%@&",PARAM_SALT,self.salt];
    [postData appendFormat:@"%@=%@&",PARAM_PG,CARD_TYPE];
    [postData appendFormat:@"%@=CC&",PARAM_BANK_CODE];
    [postData appendFormat:@"%@=%.0f&",PARAM_TOTAL_AMOUNT,self.totalAmount];
    [postData appendFormat:@"%@=%@&",PARAM_TXID,self.transactionId];
    [postData appendFormat:@"%@=%@&",PARAM_SURL,self.sURL];
    [postData appendFormat:@"%@=%@&",PARAM_FURL,self.fURL];
    [postData appendFormat:@"%@=%@&",PARAM_CURL,self.cUrl];
    [postData appendFormat:@"%@=%@&",PARAM_KEY,self.key];
    [postData appendFormat:@"%@=%@&",PARAM_PRODUCT_INFO,self.productInfo];
    [postData appendFormat:@"%@=%@&",PARAM_FIRST_NAME,self.firstName];
    [postData appendFormat:@"%@=%@&",PARAM_EMAIL,self.email];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_1,self.udf1];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_2,self.udf2];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_3,self.udf3];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_4,self.udf4];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_5,self.udf5];
    [postData appendFormat:@"%@=%@&",PARAM_STORE_YOUR_CARD,@(saveCard)];
    [postData appendFormat:@"%@=%@&",PARAM_STORE_CARD_NAME,nameOnCard];
    [postData appendFormat:@"%@=%@&",PARAM_CARD_NUMBER,cardNum];
    [postData appendFormat:@"%@=%@&",PARAM_CARD_NAME,nameOnCard];
    [postData appendFormat:@"%@=%@&",PARAM_CARD_CVV,cvv];
    [postData appendFormat:@"%@=%@&",PARAM_CARD_EXPIRY_MONTH,month];
    [postData appendFormat:@"%@=%@&",PARAM_CARD_EXPIRY_YEAR,year];
    [postData appendFormat:@"%@=%@&",PARAM_DEVICE_TYPE,IOS_SDK];

    // offer left
    
    //checksum calculation.
    
    NSString *checkSum = nil;
    if(!HASH_KEY_GENERATION_FROM_SERVER){
        
        NSString *inputStr = [NSString stringWithFormat:@"%@|%@|%.0f|%@|%@|%@|%@|%@|%@|%@|%@||||||%@",self.key,self.transactionId,self.totalAmount,self.productInfo,self.firstName,self.email,self.udf1,self.udf2,self.udf3,self.udf4,self.udf5,self.salt];
        checkSum = [Utils createCheckSumString:inputStr];
    }
    else
    {
        //        if ([[[SharedDataManager sharedDataManager] hashDict] valueForKey:PAYMENT_HASH_OLD]) {
        //            checkSum = [[[SharedDataManager sharedDataManager] hashDict] valueForKey:PAYMENT_HASH_OLD];
        //        } else {
        //            checkSum = [[[SharedDataManager sharedDataManager] hashDict] valueForKey:PAYMENT_HASH];
        //        }
    }
    [postData appendFormat:@"%@=%@",PARAM_HASH,checkSum];
    [theRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    return theRequest;
}

- (NSURLRequest *)getRequestForNetbanking:(EYPayUResponseDetailsMtlModel *)detailModel
{
    NSURL *restURL = [NSURL URLWithString:PAYU_PAYMENT_BASE_URL];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:restURL
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    theRequest.HTTPMethod = @"POST";
    NSMutableString *postData = [[NSMutableString alloc] init];
    
    [postData appendFormat:@"%@=%.0f&",PARAM_TOTAL_AMOUNT,self.totalAmount];
    [postData appendFormat:@"%@=NB&",PARAM_PG];
    [postData appendFormat:@"%@=%@&",PARAM_TXID,self.transactionId];
    [postData appendFormat:@"%@=%@&",PARAM_BANK_CODE,detailModel.code];
    [postData appendFormat:@"%@=%@&",PARAM_DEVICE_TYPE,IOS_SDK];
    [postData appendFormat:@"%@=%@&",PARAM_SURL,self.sURL];
    [postData appendFormat:@"%@=%@&",PARAM_FURL,self.fURL];
    [postData appendFormat:@"%@=%@&",PARAM_KEY,self.key];
    [postData appendFormat:@"%@=%@&",PARAM_PRODUCT_INFO,self.productInfo];
    [postData appendFormat:@"%@=%@&",PARAM_FIRST_NAME,self.firstName];
    [postData appendFormat:@"%@=%@&",PARAM_EMAIL,self.email];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_1,self.udf1];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_2,self.udf2];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_3,self.udf3];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_4,self.udf4];
    [postData appendFormat:@"%@=%@&",PARAM_UDF_5,self.udf5];
    // offer left
    NSString *checkSum = nil;
    if(!HASH_KEY_GENERATION_FROM_SERVER){
        
        NSString *inputStr = [NSString stringWithFormat:@"%@|%@|%.0f|%@|%@|%@|%@|%@|%@|%@|%@||||||%@",self.key,self.transactionId,self.totalAmount,self.productInfo,self.firstName,self.email,self.udf1,self.udf2,self.udf3,self.udf4,self.udf5,self.salt];
        checkSum = [Utils createCheckSumString:inputStr];
    }
    else
    {
        //        if ([[[SharedDataManager sharedDataManager] hashDict] valueForKey:PAYMENT_HASH_OLD]) {
        //            checkSum = [[[SharedDataManager sharedDataManager] hashDict] valueForKey:PAYMENT_HASH_OLD];
        //        } else {
        //            checkSum = [[[SharedDataManager sharedDataManager] hashDict] valueForKey:PAYMENT_HASH];
        //        }
    }
    
    
    [postData appendFormat:@"%@=%@",PARAM_HASH,checkSum];
    [theRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    return theRequest;
}

@end
