//
//  EYForgotPasswordVC.m
//  Eyvee
//
//  Created by Rohit Yadav on 20/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYForgotPasswordVC.h"
#import "EYAddressTextField.h"
#import "EYTextFieldCell.h"
#import "EDKeyboardAccessoryView.h"
#import "EYConstant.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"
#import "EYUtility.h"
#import "EYError.h"
#import "NSString+validation.h"

@interface EYForgotPasswordVC ()<UITextFieldDelegate,EDKeyboardAccessoryViewDelegate>
{
    NSIndexPath *indexPathToMakeFirstResponder;
}
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *oldPasswrd;
@property (nonatomic, strong) NSString *freshPasswrd;
@property (nonatomic, strong) NSString *confirmPasswrd;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) EDKeyboardAccessoryView *accView;
@property (nonatomic, strong) EYAddressTextField *currentlyEditingTf;
@end

@implementation EYForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_passwrdMode == passwordVCModeUpdate)
    {
        self.title = @"Update Password";
        [self.buttonResetPassword setTitle:@"Update Password" forState:UIControlStateNormal];
        self.headerLabel.text = @"Enter old password to change the password";
        _accView = [[EDKeyboardAccessoryView alloc]initWithFrame:(CGRect){0.0,0.0,0.0,kKeyboardAccessoryHeight} andMode:EDDoneButtonOnly];
        _accView.delegate = self;

    }
    else
    {
        self.title = @"Reset Password";
        self.headerLabel.text = @"Enter your registered email and we will send details to reset password.";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_passwrdMode == passwordVCModeUpdate) {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *userDetailCellIdentifier = @"forgotPasswordCell";
    EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:userDetailCellIdentifier];
    if (!cell)
    {
        cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userDetailCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        cell.textfield.delegate = self;
    cell.textfield.tag = indexPath.row;

    if (_passwrdMode == passwordVCModeUpdate)
    {
        if (indexPath.row == 0) //enter old Password
        {
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.secureTextEntry = NO;
            cell.textfield.inputAccessoryView = self.accView;
            [cell setLabelText:@"Old Password" andPlaceholderText:@"Required"];
            return cell;
        }
        else if (indexPath.row == 1) //enter new passwrd
        {
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.secureTextEntry = YES;
            cell.textfield.inputAccessoryView = self.accView;
            [cell setLabelText:@"New Password" andPlaceholderText:@"Required"];
            return cell;
        }
        else //confirm password
        {
            cell.textfield.returnKeyType = UIReturnKeyGo;
            cell.textfield.secureTextEntry = YES;
            cell.textfield.inputAccessoryView = self.accView;
            [cell setLabelText:@"Confirm Password" andPlaceholderText:@"Required"];
            return cell;
        }
    }
    else
    {
        cell.textfield.returnKeyType = UIReturnKeyGo;
        cell.textfield.secureTextEntry = NO;
        [cell setLabelText:@"Email" andPlaceholderText:@"Required"];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([indexPath isEqual:indexPathToMakeFirstResponder]) {
        EYTextFieldCell *tCell = (EYTextFieldCell *)cell;
        [tCell.textfield becomeFirstResponder];
    }
}
#pragma mark - keyboard accessory view delegate -
- (void)didTapDoneButton
{
    [self.view endEditing:YES];
}


#pragma mark - textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor = kTextFieldTypingColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = kRowColorWhileTyping;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_passwrdMode == passwordVCModeDefault || textField.tag == 2) {
        [textField resignFirstResponder];
        return YES;
    }
    
    indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:textField.tag + 1 inSection:0];
    EYTextFieldCell *cell = (EYTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPathToMakeFirstResponder];
    if (cell)
    {
        [cell.textfield becomeFirstResponder];
        indexPathToMakeFirstResponder = nil;
    }
    else
    {
        [self.tableView scrollToRowAtIndexPath:indexPathToMakeFirstResponder atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentlyEditingTf = (EYAddressTextField*)textField;

    textField.font = AN_REGULAR(15.0);
    textField.textColor =kBlackTextColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - IBActions -
- (IBAction)resetPasswordClicked:(id)sender
{
//    [self.view endEditing:YES];
//    [self resetPassword];
}

- (void)resetPassword
{
    if (_passwrdMode == passwordVCModeUpdate)
    {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:0];
        EYTextFieldCell *cell = (EYTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexP];
        if (cell)
        {
            self.oldPasswrd = cell.textfield.text;
        }
       
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
        EYTextFieldCell *cell2 = (EYTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath2];
        if (cell2)
        {
            self.freshPasswrd = cell2.textfield.text;
        }
        
        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:2 inSection:0];
        EYTextFieldCell *cell3 = (EYTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath3];
        if (cell3)
        {
            self.confirmPasswrd = cell3.textfield.text;
        }
       
        if ([self checkIfValid])
        {
         //make the api call
            [EYUtility showHUDWithTitle:nil];
            NSString *userEmailId = [EYAccountManager sharedManger].loggedInUser.email;
            NSNumber *userID = [EYAccountManager sharedManger].loggedInUser.userId;
            NSDictionary *payloadToBeSent = @{@"userId":userID,@"emailId":userEmailId,@"oldPassword":self.oldPasswrd,@"newPassword":self.freshPasswrd,@"confirmPassword":self.confirmPasswrd};
            [[EYAccountManager sharedManger]updatePasswordWithParams:nil andPayload:payloadToBeSent withCompletionBlock:^(NSString *message, EYError *error) {
                [EYUtility hideHUD];
                if (error) {
                    [EYUtility showAlertView:@"Update Password" message:error.errorMessage];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
    else
    {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:0];
        EYTextFieldCell *cell = (EYTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexP];
        if (cell)
        {
            self.email = cell.textfield.text;
        }
        
        if ([self.email isValidEmail]) {
            
            [EYUtility showHUDWithTitle:nil];
            NSDictionary *payload = @{@"emailId":self.email};
            [[EYAccountManager sharedManger]resetPasswordWithParams:nil andPayload:payload withCompletionBlock:^(NSString *message, EYError *error) {
                [EYUtility hideHUD];
                if (error) {
                    [EYUtility showAlertView:@"Reset Password" message:error.errorMessage];
                }
                else
                {
                    [EYUtility showAlertView:@"Reset Password" message:message];
                }
            }];
        }
        else
        {
            [EYUtility showAlertView:@"Reset Password" message:NSLocalizedString(@"not_valid_email", @"")];
        }
  
    }
}

-(BOOL)checkIfValid
{
    if (self.oldPasswrd.length && self.freshPasswrd.length && self.confirmPasswrd.length)
    {
        if ([self.freshPasswrd isEqualToString:self.confirmPasswrd])
        {
            return YES;
        }
        else
        {
            //show alert for non matching passwrds.
            [EYUtility showAlertView:@"Update Password" message:NSLocalizedString(@"passwrd_not_match", @"")];
            return NO;
        }
    }
    else
    {
        //show alert for missing fields
        if (!self.oldPasswrd.length)
        {
            [EYUtility showAlertView:@"Update Password" message:NSLocalizedString(@"oldPasswrd_not_entered", @"")];
        }
        else if (!self.freshPasswrd.length)
        {
            [EYUtility showAlertView:@"Update Password" message:NSLocalizedString(@"newPasswrd_not_entered", @"")];
 
        }
        else
        {
            [EYUtility showAlertView:@"Update Password" message:NSLocalizedString(@"confirmPasswrd_not_entered", @"")];

        }
        
        return NO;
    }
}

@end
