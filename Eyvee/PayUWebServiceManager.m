//
//  PayUWebServiceManager.m
//  Eyvee
//
//  Created by Neetika Mittal on 07/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "PayUWebServiceManager.h"
#import "PayUData.h"
#import "PayUConstant.h"
#import "Utils.h"
#import "EYPayUResponseMtlModel.h"

@interface PayUWebServiceManager ()

@property (nonatomic, copy) void (^completionBlock)(id responseObj, NSError *error);
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedData;

@end

@implementation PayUWebServiceManager

+ (PayUWebServiceManager *)sharedManger
{
    static dispatch_once_t onceToken;
    static PayUWebServiceManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:nil] init];
    });
    return sharedManager;
}

- (NSArray *)pgUrlList
{
    if (_pgUrlList) {
        return _pgUrlList;
    }
    _pgUrlList = @[@"https://mobiletest.payu.in/paytxn", @"https://mobiletest.payu.in/_payment", @"https://test.payu.in/paytxn",@"https://test.payu.in/_seamless_payment", @"https://secure.payu.in/_seamless_payment", @"https://secure.payu.in/paytxn", @"https://secure.payu.in/_payment", @"https://secure.payu.in/paytxn", @"https://mpi.onlinesbi.com/electraSECURE/vbv/MPIEntry.jsp", @"https://mpi.onlinesbi.com/electraSECURE/vbv/MPIEntry.jsp", @"https://www.citibank.co.in/servlets/TransReq", @"https://www.citibank.co.in/servlets/PgTransResp", @"https://vpos.amxvpos.com/vpcpay", @"https://ubimpi.electracard.com/electraSECURE/vbv/MPIEntry.jsp", @"https://ubimpi.electracard.com/electraSECURE/vbv/MPIEntry.jsp", @"https://ubimpi.electracard.com/electraSECURE/vbv/MPIACSResponse.jsp", @"https://secure.payu.in/ubi_pg_response.php"];
    return _pgUrlList;
}

- (void)getAllPaymentsAvailableOptionData:(PayUData *)data withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    self.completionBlock = completionBlock;
    [self callAPIWithPayment:data];
}

- (void)beginInternetBanking:(PayUData *)data withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    
}

- (void)callAPIWithPayment:(PayUData *)data
{
    NSURL *restURL = [NSURL URLWithString:PAYU_PAYMENT_ALL_AVAILABLE_PAYMENT_OPTION];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:restURL
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    theRequest.HTTPMethod = @"POST";
    NSString *hashStr = nil;
    if(HASH_KEY_GENERATION_FROM_SERVER){
#warning complete
    }
    else {
        hashStr = [Utils createCheckSumString:[NSString stringWithFormat:@"%@|%@|%@|%@",data.key,data.command,data.email,data.salt]];
        data.hashKey = hashStr;
    }
    NSMutableString *postData = [NSMutableString stringWithFormat:@"key=%@&var1=%@&command=%@&",data.key,data.email,data.command];
    [postData appendString:[NSString stringWithFormat:@"hash=%@",hashStr]];
    [theRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    _connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (_connection) {
        _receivedData=[NSMutableData data];
    } else {
        NSLog(@"Connection not created");
    }
    [_connection start];
}

#pragma mark - NSURLConnection Delegate methods

// NSURLCONNECTION Delegate methods.

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    ALog(@"didFailWithError");
    self.completionBlock (nil, error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    ALog(@"didReceiveResponse");
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == _connection && data)
    {
        [_receivedData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == _connection && _receivedData)
    {
        NSError *errorJson=nil;
        NSDictionary *respObj = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&errorJson];
        if (respObj.count == 2) {
#warning call completionblock with error
        }
        else {
            NSError *error;
            NSLog(@"response : %@",respObj);
            EYPayUResponseMtlModel *parsedResp = [MTLJSONAdapter modelOfClass:[EYPayUResponseMtlModel class] fromJSONDictionary:respObj error:&error];
            
            self.completionBlock (parsedResp, nil);
        }
    }
}

@end
