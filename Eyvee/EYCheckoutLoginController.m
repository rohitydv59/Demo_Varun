//
//  EYCheckoutLoginController.m
//  Eyvee
//
//  Created by Neetika Mittal on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "EYCheckoutLoginController.h"
#import "EYConstant.h"
#import "EYAllAPICallsManager.h"
#import "EYFacebookLogin.h"
#import "EYAccountManager.h"
#import "AppDelegate.h"
#import "EYUserDetailsVC.h"
#import "EYError.h"
//#import "EYSignUpMtlModel.h"
#import "EYForgotPasswordVC.h"
#import "NSString+validation.h"


@interface EYCheckoutLoginController () <UITextFieldDelegate, EYUserDetailsVCDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTf;
@property (nonatomic, weak) IBOutlet UITextField *passwordTf;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollViewHConstraint;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (IBAction)signInButtonTapped:(id)sender;
- (IBAction)loginWithFacebookBtnTapped:(id)sender;

@end

@implementation EYCheckoutLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reset
{
    self.emailTf.text = nil;
    self.passwordTf.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.emailTf]) {
        [self.passwordTf becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        [self signInButtonTapped:nil];
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

- (IBAction)signInButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *email = self.emailTf.text;
    NSString *pwd = self.passwordTf.text;
    
    if (email.length == 0) {
        [EYUtility showAlertView:@"Oops!" message:@"Email is required."];
        return;
    }
    
    if (pwd.length == 0) {
        [EYUtility showAlertView:@"Oops!" message:@"Password is required."];
        return;
    }
    
    [EYUtility showHUDWithTitle:nil];
    NSDictionary *payload = @{
                              @"emailId": email,
                              @"password": pwd,
                              @"isFb": @"false"
                              };

    [self performSelector:@selector(checkingLogin:) withObject:payload afterDelay:1.5];
}

-(void) checkingLogin:(NSDictionary *) payload
{
    [EYUtility hideHUD];
    NSString * email = [payload objectForKey:@"emailId"];
    NSString * pwd = [payload objectForKey:@"password"];
    if ([email isEqualToString:@"user123@gmail.com"]&& [pwd isEqualToString:@"user123"])
    {

        __weak typeof (self) weakSelf = self;
        [[EYAccountManager sharedManger]loginUserForParams:nil andPayload:payload withCompletionBlock:^(bool success, EYError *error) {
            [weakSelf processLogin:success withError:error];
        }];
        
    }
    else
    {
        [EYUtility showAlertView:@"Oops!" message:@"incorrect login."];
        return;
        
    }

}
- (IBAction)loginWithFacebookBtnTapped:(id)sender
{
    [self.view endEditing:YES];
    self.emailTf.text = nil;
    self.passwordTf.text = nil;
    
    [EYUtility showHUDWithTitle:nil];
    
    __weak typeof (self) weakSelf = self;
    [[EYAccountManager sharedManger]createUserViaFBWithCompletionBlock:^(bool success, EYError *error) {
        [weakSelf processFbUserLogin:success withError:error];
    }];

    
}

- (IBAction)resetPasswordBtnTapped:(id)sender
{
    EYForgotPasswordVC *forgotPasswordVC = [EYUtility instantiateViewWithIdentifier:@"EYForgotPasswordVC"];
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}

#pragma mark - update profile delegate -

- (void)updateProfileSuccessful
{
    if ([_delegate respondsToSelector:@selector(loginSuccessful)]) {
        [_delegate loginSuccessful];
    }
}

#pragma mark - process response -

- (void)processFbUserLogin:(BOOL)success withError :(EYError *)error
{
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

- (void)processLogin:(BOOL)success withError :(EYError *)error{
    [EYUtility hideHUD];
    if(success && !error)
    {
        if ([_delegate respondsToSelector:@selector(loginSuccessful)]) {
            [_delegate loginSuccessful];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(loginNotSuccessfulWithError:)]) {
            [_delegate loginNotSuccessfulWithError:error];
        }
    }
}


@end
