//
//  EDProgress.m
//  Eyvee
//
//  Created by Naman Singhal on 16/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EDProgress.h"
#import "EDProgressView.h"

@interface EDProgress ()

@property (nonatomic, strong) EDProgressView *progressView;

@end

@implementation EDProgress

+ (EDProgress *)progress
{
    static dispatch_once_t onceToken;
    static EDProgress *progress = nil;
    dispatch_once(&onceToken, ^{
        progress = [[self alloc] init];
    });
    return progress;
}

+ (void)showProgressViewInWindow:(UIWindow *)window animated:(BOOL)animated withTitle:(NSString *)title
{
    EDProgress *progress = [EDProgress progress];
    
    if (!progress.progressView) {
        EDProgressView *pView = [[EDProgressView alloc] initWithFrame:window.bounds];
        progress.progressView = pView;
        [progress.progressView showProgressViewInWindow:window animated:animated withTitle:title];
    }
    else {
        [progress.progressView showProgressViewInWindow:window animated:NO withTitle:title];
    }
}

+ (void)hideProgressViewAnimated:(BOOL)animated
{
    EDProgress *progress = [EDProgress progress];
    
    if (!progress.progressView) {
        return;
    }
    
    [progress.progressView hideProgressViewAnimated:animated completion:^(BOOL finished) {
        if (finished) {
            progress.progressView = nil;
        }
    }];
}

@end
