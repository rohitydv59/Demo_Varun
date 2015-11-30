//
//  EYTabButton.h
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYTabButton : UIControl

@property (nonatomic, assign) BOOL isBtnSelected;
- (void)setUnSelectedImage:(UIImage *)image tintColor:(UIColor *)color;
- (void)setBadgeText:(NSString *)badgeText;

@end
