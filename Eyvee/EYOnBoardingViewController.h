//
//  EYOnBoardingViewController.h
//  Eyvee
//
//  Created by Naman Singhal on 28/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EYOnBoardingViewControllerDelegate <NSObject>

- (void) signUpSuccessful;
- (void) signInSuccessful;

@end

@interface EYOnBoardingViewController : UIViewController

@property (nonatomic, weak) id <EYOnBoardingViewControllerDelegate> delegate;
@property (nonatomic) BOOL hideLoginAccess;
@end
