//
//  EYCacheManager.h
//  Eyvee
//
//  Created by Neetika Mittal on 08/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYCacheManager : NSObject

+ (EYCacheManager *)manager;
- (void)getDataForUrl:(NSString *)path params:(id)params withCompletion:(void(^)(id object))completion;
- (void)saveData:(id)data forUrl:(NSString *)path params:(id)params;
- (void)deleteDataForURL:(NSString *)path params:(id)params withCompletion:(void(^)())completion;
- (void)clearCache:(void(^)())completion;

@end
