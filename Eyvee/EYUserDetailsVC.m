//
//  EYUserDetailsVC.m
//  Eyvee
//
//  Created by Rohit Yadav on 19/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYUserDetailsVC.h"
#import "EYTextFieldCell.h"
#import "EYAddressTextField.h"
#import "EDKeyboardAccessoryView.h"
#import "EYTableFooterView.h"
#import "EYConstant.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"
#import "EYUtility.h"
#import "EYError.h"
#import "NSString+validation.h"

@interface EYUserDetailsVC ()<UITextFieldDelegate, EDKeyboardAccessoryViewDelegate>

@property (nonatomic, strong) EDKeyboardAccessoryView *accView;
@property (nonatomic, strong) EYTableFooterView *footerView;
@property (nonatomic, strong) NSString *firstName, *lastName, *phoneNumber, *fullName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) UIButton *saveAccountBtn;


@end

@implementation EYUserDetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _accView = [[EDKeyboardAccessoryView alloc]initWithFrame:(CGRect){0.0,0.0,0.0,kKeyboardAccessoryHeight} andMode:EDDoneButtonOnly];
    _accView.delegate = self;
    
    self.email = [EYAccountManager sharedManger].loggedInUser.email;
    
    self.saveAccountBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveAccountBtn.titleLabel setFont:AN_BOLD(13.0)];
    
    if (self.signUpMode == UpdateUserProfile) {
        [self.saveAccountBtn setTitle:@"UPDATE MY ACCOUNT" forState:UIControlStateNormal];
    }
    else
        [self.saveAccountBtn setTitle:@"CREATE MY ACCOUNT" forState:UIControlStateNormal];
    
    [self.saveAccountBtn setBackgroundColor:kAppGreenColor];
    [self.saveAccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveAccountBtn addTarget:self action:@selector(updateProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = @"Account";
    
    if (self.signUpMode == UpdateUserProfile) {
        self.navigationItem.hidesBackButton = NO;
    }
    else{
        self.navigationItem.hidesBackButton = YES;
    }
    self.email = [EYAccountManager sharedManger].loggedInUser.email;
    self.fullName = [EYAccountManager sharedManger].loggedInUser.fullName;
    self.phoneNumber = [EYAccountManager sharedManger].loggedInUser.phoneNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat kBottomButtonHeight = 48.0;
    CGSize size = self.view.bounds.size;
    
    self.saveAccountBtn.frame = (CGRect) {0.0, [UIScreen mainScreen].bounds.size.height - kBottomButtonHeight , size.width, kBottomButtonHeight};
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.view addSubview:self.saveAccountBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.saveAccountBtn removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userDetailCellIdentifier = @"userDetailCellIdentifier";
    EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:userDetailCellIdentifier];
    if (!cell)
    {
        cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userDetailCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textfield.delegate = self;
    cell.textfield.inputAccessoryView = self.accView;
    [cell configUserDetailsCellForIndexPath:indexPath];
    if (indexPath.row == 1) {
        if (self.email) {
            cell.textfield.userInteractionEnabled = NO;
        }
        [cell setTextInTextfield:self.email ForIndexPath:indexPath];
    }
    else if (indexPath.row == 2){
        NSString *prefixCode = @"+91";
        if (self.phoneNumber) {
            [cell setTextInTextfield:self.phoneNumber ForIndexPath:indexPath];
        }
        else
        {
            [cell setTextInTextfield:prefixCode ForIndexPath:indexPath];
        }
    }
    else if (indexPath.row == 0){
        [cell setTextInTextfield:self.fullName ForIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}


#pragma mark - keyboard accessory view delegate -
- (void)didTapDoneButton
{
    [self.view endEditing:YES];
}

#pragma mark - IBActions -
- (IBAction)updateProfileClicked:(id)sender
{
    
    if (self.fullName.length == 0){
        [EYUtility showAlertView:@"Account" message:@"Please enter your name"];
        return;
    }
    else if (![self.email isValidEmail]) {
    [EYUtility showAlertView:@"Account" message:@"Please enter valid email"];
        return;
    }
    else if (self.phoneNumber.length < 13){
        [EYUtility showAlertView:@"Account" message:@"Please enter valid phone number"];
        return;
    }
    NSString *string = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    NSMutableDictionary *payload = [NSMutableDictionary new];
    if (self.email) {
        [payload setObject:self.email forKey:@"emailId"];
    }
    if (self.fullName) {
        [payload setObject:self.fullName forKey:@"fullName"];
    }
    if (self.phoneNumber) {
        [payload setObject:self.phoneNumber forKey:@"contactNo"];
    }
    [payload setObject:string forKey:@"userId"];
    
    [EYUtility showHUDWithTitle:nil];
    [[EYAccountManager sharedManger]updateUserProfileWithParams:nil andPayload:payload withCompletionBlock:^(bool success, EYError *error) {
        [EYUtility hideHUD];
        if (error) {
            [EYUtility showAlertView:error.errorMessage];
        }
        else
        {
            //[EYUtility showAlertView:@"Successfull"];

            if ([_delegate respondsToSelector:@selector(updateProfileSuccessful)]) {
                [_delegate updateProfileSuccessful];
            }
            else
                [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UITextfieldDelegates -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor = kTextFieldTypingColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = kRowColorWhileTyping;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor =kBlackTextColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = [UIColor whiteColor];
    [self didTapReturn:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self makeNextTfFirstResponder:textField.tag];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    EYAddressTextField *addressTextField =  (EYAddressTextField*)textField;
    NSString *text = [addressTextField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (addressTextField.tag == 2)
    {
        if (newLength > [textField.text length])
        {
            if ([textField.text length] < 3 && ![textField.text isAllDigits])
            {
                return NO;
            }
        }
        else
        {
            if ([textField.text length] == 3)
            {
                return NO;
            }
        }
        if (text.length>13)
        {
            return NO;
        }
        self.phoneNumber = text;
    }
    
        
    return YES;
}


- (void)makeNextTfFirstResponder:(NSInteger )index
{
    EYTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(index+2) inSection:0]];
    if ([cell isKindOfClass:[EYTextFieldCell class]]) {
        [cell.textfield becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
    }
}

- (void)didTapReturn:(UITextField *)textfield
{
    if (textfield.tag == 0) {
        self.fullName = textfield.text;
    }
    else if (textfield.tag == 1)   {
        self.email = textfield.text;
    }
    else if (textfield.tag == 2){
        self.phoneNumber = textfield.text;
    }
}

@end
