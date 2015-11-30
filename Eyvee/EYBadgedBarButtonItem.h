//
//  EYBadgedBarButtonItem.h
//  Eyvee
//
//  Created by Rohit Yadav on 16/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface EYBadgedBarButtonItem : UIBarButtonItem

- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;
- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action tintColor:(UIColor *)color;

@end
