//
//  EYCheckoutLoginController.h
//  Eyvee
//
//  Created by Neetika Mittal on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EYError;
@protocol EYCheckoutLoginControllerDelegate <NSObject>

- (void)loginSuccessful;
- (void)loginNotSuccessfulWithError:(EYError *)error;

@end

@interface EYCheckoutLoginController : UIViewController

@property (nonatomic, weak) id <EYCheckoutLoginControllerDelegate>delegate;

- (void)reset;

@end
