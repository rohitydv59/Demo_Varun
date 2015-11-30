//
//  EYLogInBeforeWishlistViewController.h
//  Eyvee
//
//  Created by Disha Jain on 05/11/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EYLogInBeforeWishlistViewController;

@protocol EYLogInBeforeWishlistViewControllerDelegate <NSObject>
- (void)buttonSignUpPressed;
- (void)buttonLoginPressed;

@end


@interface EYLogInBeforeWishlistViewController : UIViewController
@property (nonatomic, weak) id <EYLogInBeforeWishlistViewControllerDelegate> delegate;

@end
