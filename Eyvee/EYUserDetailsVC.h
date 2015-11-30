//
//  EYUserDetailsVC.h
//  Eyvee
//
//  Created by Rohit Yadav on 19/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    FBSignUp = 0,
    EmailSignUp = 1,
    UpdateUserProfile = 2
}userSignUpMode;

@protocol EYUserDetailsVCDelegate <NSObject>

- (void)updateProfileSuccessful;

@end

@interface EYUserDetailsVC : UITableViewController

@property (nonatomic, assign) userSignUpMode signUpMode;
@property (nonatomic, weak) id <EYUserDetailsVCDelegate> delegate;

@end
