//
//  EYForgotPasswordVC.h
//  Eyvee
//
//  Created by Rohit Yadav on 20/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    passwordVCModeDefault = 0,
    passwordVCModeUpdate = 1
}passwordVCMode;
@interface EYForgotPasswordVC : UITableViewController
@property (assign, nonatomic) passwordVCMode passwrdMode;
@property (weak, nonatomic) IBOutlet UIButton *buttonResetPassword;
@end
