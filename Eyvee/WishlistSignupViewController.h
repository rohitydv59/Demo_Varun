//
//  WishlistSignupViewController.h
//  Eyvee
//
//  Created by Varun Kapoor on 19/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishlistSignupViewController.h"

@protocol WishlistSignUpDelegate <NSObject>

-(void) signUpSuccessfullFromWishlist;

@end

@interface WishlistSignupViewController : UIViewController

-(IBAction)signUpClicked:(id)sender;
-(IBAction)loginClicked:(id)sender;

@property (nonatomic ,weak) id  <WishlistSignUpDelegate> delegate;

@end
