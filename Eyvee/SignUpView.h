//
//  SignUpView.h
//  Eyvee
//
//  Created by Varun Kapoor on 17/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpView : UITableViewController
@property(nonatomic, weak) IBOutlet UIButton * signUpButton;
@property(nonatomic, weak) IBOutlet UIButton * facebookSignUpButton;
@property(nonatomic, weak) IBOutlet UIButton * emailSignUpButton;
@property(nonatomic, weak) IBOutlet UILabel * label;
@property(nonatomic, strong) IBOutlet UIView * header;
@property (nonatomic,assign)BOOL isUserLoggedIn;

-(IBAction)signUpButtonClicked:(id)sender;
-(IBAction)facebookSignUpButtonClicked:(id)sender;
-(IBAction)emailSignUpButtonClicked:(id)sender;

@end
