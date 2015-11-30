//
//  EDProgress.h
//  Eyvee
//
//  Created by Naman Singhal on 16/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDProgress : NSObject

+ (void)showProgressViewInWindow:(UIWindow *)window animated:(BOOL)animated withTitle:(NSString *)title;
+ (void)hideProgressViewAnimated:(BOOL)animated;

@end
