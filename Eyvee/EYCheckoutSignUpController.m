//
//  EYCheckoutSignUpController.m
//  Eyvee
//
//  Created by Neetika Mittal on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYCheckoutSignUpController.h"
#import "EYAllAPICallsManager.h"
#import "EYConstant.h"
#import "EYFacebookLogin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "EYUtility.h"
#import "EYError.h"
#import "EYAccountManager.h"
#import "EYUserDetailsVC.h"
#import "AppDelegate.h"
#import "NSString+validation.h"

@interface EYCheckoutSignUpController () <UITextFieldDelegate, EYUserDetailsVCDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTf;
@property (nonatomic, weak) IBOutlet UITextField *passwordTf;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordTf;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollViewHConstraint;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (IBAction)signUpBtnTapped:(id)sender;
- (IBAction)loginWithFacebookBtnTapped:(id)sender;

@end

@implementation EYCheckoutSignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailTf.delegate = self;
    self.passwordTf.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)reset
{
    self.emailTf.text = nil;
    self.passwordTf.text = nil;
    self.confirmPasswordTf.text = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - keyboard notifications

- (void)keyboardWillShowNotification:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    double animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    self.scrollViewHConstraint.constant = keyboardRect.size.height;
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve << 16 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHideNotification:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    double animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    self.scrollViewHConstraint.constant = 0.0;
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve << 16 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
    }];
}

#pragma mark - UItextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTf) {
        [self.passwordTf becomeFirstResponder];
    }
    else if (textField == self.passwordTf) {
        [self.confirmPasswordTf becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        [self signUpBtnTapped:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textColor = kTextFieldTypingColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.textColor = kBlackTextColor;
}

- (IBAction)signUpBtnTapped:(id)sender
{
    return;
    
    [self.view endEditing:YES];
    
    NSString *email = self.emailTf.text;
    NSString *pswd = self.passwordTf.text;
    NSString *confirmPass = self.confirmPasswordTf.text;
    
    if (email.length == 0) {
        [EYUtility showAlertView:@"Oops!" message:@"Email is required."];
        return;
    }
    if (!email.isValidEmail) {
        [EYUtility showAlertView:@"Oops!" message:NSLocalizedString(@"invalid_email", @"")];
        return;
    }
    
    if (pswd.length == 0) {
        [EYUtility showAlertView:@"Oops!" message:@"Password is required."];
        return;
    }
    
    if (![pswd isEqualToString:confirmPass]) {
        [EYUtility showAlertView:@"Oops!" message:@"Passwords don't match. Please retype the password."];
        self.passwordTf.text = nil;
        self.confirmPasswordTf.text = nil;
        [self.passwordTf becomeFirstResponder];
        return;
    }
    
    NSDictionary *payLoad = @{@"emailId": email,
                              @"password": pswd};
    
    [EYUtility showHUDWithTitle:@"Verifying"];
     __weak typeof (self) weakSelf = self;
    [[EYAccountManager sharedManger]createUserWithPayload:payLoad withCompletionBlock:^(bool success, EYError *error) {
        [EYUtility hideHUD];
        [weakSelf processSignup:success withError:error];
    }];
    
}

- (IBAction)loginWithFacebookBtnTapped:(id)sender
{
    [self.view endEditing:YES];
    self.emailTf.text = nil;
    self.passwordTf.text = nil;
    
    [EYUtility showHUDWithTitle:@"Verifying"];
    __weak typeof (self) weakSelf = self;
    
    [[EYAccountManager sharedManger]createUserViaFBWithCompletionBlock:^(bool success, EYError *error) {
        [weakSelf processFbUserLogin:success withError:error];
    }];
    

}


#pragma mark - update profile delegate -
- (void)updateProfileSuccessful
{
    if ([_delegate respondsToSelector:@selector(signUpSuccessful)])
    {
        [_delegate signUpSuccessful];
    }
}


#pragma mark - process response -
- (void)processFbUserLogin:(BOOL)success withError :(EYError *)error{
    if (success) {
        AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
        EYUserDetailsVC *userDetail = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"EYUserDetailsVC"];
        userDetail.signUpMode = FBSignUp;
        userDetail.delegate = self;
        [self.navigationController pushViewController:userDetail animated:YES];
    }
    else
    {
        [EYUtility showAlertView:error.errorMessage];
    }
    [EYUtility hideHUD];
}

- (void)processSignup:(BOOL)success withError :(EYError *)error{
    [EYUtility hideHUD];
    if (success) {
        AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
        EYUserDetailsVC *userDetail = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"EYUserDetailsVC"];
        userDetail.signUpMode = EmailSignUp;
        userDetail.delegate = self;
        [self.navigationController pushViewController:userDetail animated:YES];
    }
    else
    {
        [EYUtility showAlertView:error.errorMessage];
    }
}


@end
