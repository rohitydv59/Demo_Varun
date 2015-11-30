//
//  EYWebServiceManager.m
//  Eyvee
//
//  Created by Neetika Mittal on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYWebServiceManager.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYAccountManager.h"
#import "EYCacheManager.h"
#import "EYUserInfo.h"

@interface EYWebServiceManager ()
{
    NSInteger _activityCount;
}

@property (nonatomic, strong) NSMutableArray *allTasks;

@end

@implementation EYWebServiceManager

+ (EYWebServiceManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static EYWebServiceManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        NSString *baseURL = BASE_URL ;
        sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        [sharedManager setup];
    });
    return sharedManager;
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        AFJSONResponseSerializer *responseSer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSer.removesKeysWithNullValues = YES;
        NSMutableSet *set = [[NSMutableSet alloc] initWithSet:responseSer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"text/plain"];
        [set addObject:@"text/json"];
        responseSer.acceptableContentTypes = set;
        
        self.responseSerializer = responseSer;
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSMutableSet *reqSet = [[NSMutableSet alloc] initWithSet:self.requestSerializer.HTTPMethodsEncodingParametersInURI];
        [reqSet addObject:@"POST"];
        [reqSet addObject:@"PUT"];
        [reqSet addObject:@"DELETE"];
        
        self.requestSerializer.HTTPMethodsEncodingParametersInURI = reqSet;
    }
    
    return self;
}

- (void)setup
{
    NSMutableDictionary *headerdict = [[NSMutableDictionary alloc] init];
    [headerdict setObject:kAppAuthToken forKey:kAuthTokenKey];
    
    EYUserInfo *userInfo = [EYAccountManager sharedManger].loggedInUser;
    NSString *userToken =  userInfo.userToken; //[[EYUtility shared] getUserToken];
    
    NSString *userId;
    
    if (userInfo.userId)
         userId = [NSString stringWithFormat:@"%@",userInfo.userId];
    
    if (userToken.length > 0) {
        [headerdict setObject:userToken forKey:kUserTokenKey];
    }
    if (userId.length > 0) {
        [headerdict setObject:userId forKey:kUserIdKey];
    }
//    NSLog(@"userToken is %@ userId iss %@", userToken, userId);
    
    
    [self updateDefaultHeaderWithDictionary:headerdict];
}

- (void)updateDefaultHeaderWithDictionary:(NSDictionary *)headerDict
{
    if (!headerDict)
    {
        return;
    }
    
    NSArray *allKeys = [headerDict allKeys];
    NSMutableString *headerStr = [NSMutableString stringWithFormat:@"{"];
    int i = 0;
    for (NSString *key in allKeys) {
        NSString *value = headerDict[key];
        if (value.length > 0 && ![value isKindOfClass:[NSNull class]]) {
            [headerStr appendString:[NSString stringWithFormat:@"%@:%@",key,value]];
            if (i < allKeys.count - 1) {
                [headerStr appendString:@","];
            }
            else {
                [headerStr appendString:@"}"];
            }
        }
        i++;
    }
    
    if (headerStr.length > 0) {
        [self.requestSerializer setValue:headerStr forHTTPHeaderField:kAuthorizationKey];
    }
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

- (void)createGetRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                           shouldCache:(BOOL)cache
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    [self setup];
    if (cache) {
            [self getCachedDataForRequestPath:requestPath parameters:parameters withCompletionBlock:^(id responseObject, NSError *error) {
                if (responseObject) {
                    completionBlock (responseObject, nil);
                }
                else {
                    [self createGetRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
                        if (responseObject) {
                            [[EYCacheManager manager]saveData:responseObject forUrl:requestPath params:parameters];
                        }
                        completionBlock (responseObject, error);
                    }];
                }
            }];
    }
    else {
        [self createGetRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
            completionBlock (responseObject, error);
        }];
    }
}

- (void)createGetRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    NSURLSessionDataTask *task = [self GET:requestPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock (responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock (nil, error);
    }];
    [self addTask:task];
}

- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                            shouldCache:(BOOL)cache
                    withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    if (cache) {
            [self getCachedDataForRequestPath:requestPath parameters:parameters withCompletionBlock:^(id responseObject, NSError *error) {
                if (responseObject) {
                    completionBlock (responseObject, nil);
                }
                else {
                    [self createPostRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
                        if (responseObject) {
                            [[EYCacheManager manager]saveData:responseObject forUrl:requestPath params:parameters];
                        }
                        completionBlock (responseObject, error);
                    }];
                }
            }];
    }
    else {
        [self createPostRequestWithParameters:parameters withRequestPath:requestPath withCompletionBlock:^(id responseObject, NSError *error) {
            completionBlock (responseObject, error);
        }];
    }
    
}

- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    NSURLSessionDataTask *task = [self POST:requestPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock (responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock (nil, error);
    }];
    [self addTask:task];
}

- (void)createPostRequestForProductsWithParameters:(NSDictionary *)parameters withRequestPath:(NSString *)requestPath shouldCache:(BOOL)cache payload:(id)payload withCompletionBlock:(void (^)(id, NSError *))completionBlock
{
    [self setup];
    NSError *serializationError = nil;
    NSMutableURLRequest *req = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:requestPath relativeToURL:[NSURL URLWithString:BASE_URL]] absoluteString] parameters:parameters error:&serializationError];
    if (payload && !serializationError) {
        [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:payload options:0 error:&serializationError]];
    }
    [req setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:req completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        completionBlock (responseObject, error);
    }];
    [task resume];
    [self addTask:task];
}

- (void)createPutRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    [self setup];
    NSURLSessionDataTask *task = [self PUT:requestPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock (responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock (nil, error);
    }];
    [self addTask:task];
}

- (void)createPutRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                               payload:(id)payload
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    [self setup];
    NSError *serializationError = nil;
    NSMutableURLRequest *req = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:requestPath relativeToURL:[NSURL URLWithString:BASE_URL]] absoluteString] parameters:parameters error:&serializationError];
    if (payload && !serializationError) {
        [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:payload options:0 error:&serializationError]];
    }
    [req setHTTPMethod:@"PUT"];
    
    NSLog(@"request body : %@", [[NSString alloc] initWithData:[req HTTPBody] encoding:NSUTF8StringEncoding]);
    NSLog(@"request headers : %@", req.allHTTPHeaderFields);
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:req completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        completionBlock (responseObject, error);
    }];
    [task resume];
    [self addTask:task];
}

- (void)createDeleteRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    NSURLSessionDataTask *task = [self DELETE:requestPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock (responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock (nil, error);
    }];
    [self addTask:task];
}

- (void)addTask:(NSURLSessionDataTask *)task
{    if(!self.allTasks)
    self.allTasks = [[NSMutableArray alloc] init];
    
    [self.allTasks addObject:task];
}

- (void)removeTask:(NSURLSessionDataTask *)task
{
    [self.allTasks removeObject:task];
}

- (void)cancelAllTasks
{
    for (NSURLSessionDataTask *task in self.allTasks)
    {
        [task cancel];
    }
    
    [self.allTasks removeAllObjects];
}

- (void)getCachedDataForRequestPath:(NSString *)requestPath parameters:(NSDictionary *)parameters                     withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    
    [[EYCacheManager manager]getDataForUrl:requestPath params:parameters withCompletion:^(id object) {
        if (object) {
            completionBlock (object, nil);
        }
        else {
            completionBlock (nil, [[NSError alloc] initWithDomain:@"No Data" code:200 userInfo:@{NSLocalizedDescriptionKey : @"Data not available"}]);
        }
        
    }];
}

#pragma  mark Get Data from Local Json
- (void)getLocalDataFromJsonWithPath:(NSString *)jsonPath withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonPath ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id responseJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    completionBlock(responseJson,error);
}


@end
