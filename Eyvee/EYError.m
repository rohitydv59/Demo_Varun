//
//  EYError.m
//  Eyvee
//
//  Created by Neetika Mittal on 26/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYError.h"

@implementation EYError

- (instancetype)initWithError:(NSError *)error
{
    self = [super init];
    if (self) {
        if (error) {
            self.errorMessage = [self messageTextForErrorCode:error.code];
            if (self.errorMessage.length == 0 && error) {
                self.errorMessage = error.domain;
            }
        }
    }
    return self;
}

- (NSString *)messageTextForErrorCode:(NSInteger)errorCode
{
    NSString *errorText = @"";
    switch (errorCode) {
        case kCFURLErrorTimedOut:
            errorText = NSLocalizedString(@"time_out_err", @"");
            break;

        case kCFErrorHTTPConnectionLost:
        case kCFURLErrorNetworkConnectionLost:
            errorText = NSLocalizedString(@"internet_stopped_working", @"");
            break;
            
        case kCFHostErrorHostNotFound:
        case kCFHostErrorUnknown:
        case kCFURLErrorCannotFindHost:
        case kCFURLErrorCannotConnectToHost:
        case kCFURLErrorNotConnectedToInternet:
            errorText = NSLocalizedString(@"no_internet_conn", @"");
            break;
            
        default:
            break;
    }
    return errorText;
}


@end
