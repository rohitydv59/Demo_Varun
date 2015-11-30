//
//  WishlistSignupViewController.m
//  Eyvee
//
//  Created by Varun Kapoor on 19/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "WishlistSignupViewController.h"
#import "EYAccountController.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface WishlistSignupViewController ()<EYAccountControllerDelegate>

@end

@implementation WishlistSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)signUpClicked:(id)sender
{
    EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
    accCont.delegate = self;
    accCont.currentMode = kSignupMode;
    [self.navigationController pushViewController:accCont animated:YES];
}

- (IBAction)loginClicked:(id)sender
{
    EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
    accCont.delegate = self;
    accCont.currentMode = kLoginMode;
    [self.navigationController pushViewController:accCont animated:YES];
}

- (void)userSignUpSuccessful
{
    if ([self.delegate respondsToSelector:@selector(signUpSuccessfullFromWishlist)])
    {
        [self.delegate signUpSuccessfullFromWishlist];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
