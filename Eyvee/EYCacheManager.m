//
//  EYCacheManager.m
//  Eyvee
//
//  Created by Neetika Mittal on 08/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYCacheManager.h"
#import "TMCache.h"

@implementation EYCacheManager

+ (EYCacheManager *)manager
{
    static dispatch_once_t onceToken;
    static EYCacheManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)getDataForUrl:(NSString *)path params:(id)params withCompletion:(void(^)(id object))completion
{
    NSString *key = [self cacheKeyForURL:path cacheParams:params];
    [[TMCache sharedCache] objectForKey:key block:^(TMCache *cache, NSString *key, id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(object);
            }
        });
    }];
}

- (void)saveData:(id)data forUrl:(NSString *)path params:(id)params
{
    NSString *key = [self cacheKeyForURL:path cacheParams:params];
    [[TMCache sharedCache] setObject:data forKey:key];
}

- (void)deleteDataForURL:(NSString *)path params:(id)params withCompletion:(void(^)())completion
{
    NSString *key = [self cacheKeyForURL:path cacheParams:params];
    
    [[TMCache sharedCache] removeObjectForKey:key block:^(TMCache *cache, NSString *key, id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

- (void)clearCache:(void(^)())completion
{
    [[TMCache sharedCache] removeAllObjects:^(TMCache *cache) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

- (NSString *)cacheKeyForURL:(NSString *)path cacheParams:(id)params
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:path];
    
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSDictionary *parameters = (NSDictionary *)params;
        NSMutableArray *allKeys = [[parameters allKeys] mutableCopy];
        [allKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

        for (NSString *key in allKeys) {
            NSString *value = parameters[key];
            [string appendString:[NSString stringWithFormat:@"-%@:%@",key,value]];
        }
    }
    else if ([params isKindOfClass:[NSArray class]]) {
        for (id key in params) {
            [string appendString:@"-"];
            [string appendFormat:@"%@", key];
        }
    }
    
    return [NSString stringWithString:string];
}

@end
