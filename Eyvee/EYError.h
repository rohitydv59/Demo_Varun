//
//  EYError.h
//  Eyvee
//
//  Created by Neetika Mittal on 26/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYError : NSObject

@property (nonatomic, strong) NSString *errorMessage;
- (instancetype)initWithError:(NSError *)error;

@end
