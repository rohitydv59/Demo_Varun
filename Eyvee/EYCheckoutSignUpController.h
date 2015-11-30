//
//  EYCheckoutSignUpController.h
//  Eyvee
//
//  Created by Neetika Mittal on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EYError;
@protocol EYCheckoutSignUpControllerDelegate <NSObject>

- (void)signUpSuccessful;
- (void)loginNotSuccessfulWithError:(EYError *)error;

@end

@interface EYCheckoutSignUpController : UIViewController

@property (nonatomic, assign) id <EYCheckoutSignUpControllerDelegate> delegate;

- (void)reset;

@end
