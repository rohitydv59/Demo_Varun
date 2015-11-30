//
//  TickView.h
//  Credit Card Reader
//
//  Created by Monis Manzoor on 17/12/14.
//  Copyright (c) 2014 Monis Manzoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTickButton : UIButton

@property (nonatomic, assign) BOOL on;

- (CGSize)requiredSizeForWidth:(CGFloat)width;
- (void)setAttributedTitleForTickButton:(NSString *)firstString secondString:(NSString *)secondString;

@end
