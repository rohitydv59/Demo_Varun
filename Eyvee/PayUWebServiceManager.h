//
//  PayUWebServiceManager.h
//  Eyvee
//
//  Created by Neetika Mittal on 07/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PayUData;

@interface PayUWebServiceManager : NSObject

@property (nonatomic,strong) NSArray *pgUrlList;

+ (PayUWebServiceManager *)sharedManger;
- (void)getAllPaymentsAvailableOptionData:(PayUData *)data withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

@end
