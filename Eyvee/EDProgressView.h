//
//  WPProgressView.h
//  WynkPay
//
//  Created by Naman Singhal on 15/01/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDProgressView : UIView

- (void)showProgressViewInWindow:(UIWindow *)window animated:(BOOL)animated withTitle:(NSString *)title;
- (void)hideProgressViewAnimated:(BOOL)animated completion:(void (^)(BOOL finished))handler;

@end
