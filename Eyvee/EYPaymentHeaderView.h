//
//  EYPaymentHeaderView.h
//  Eyvee
//
//  Created by Neetika Mittal on 03/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYPaymentHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame itemCount:(NSInteger)count price:(NSString *)amt;
- (CGFloat)requiredH;

@end
