//
//  EYPaymentOptionCell.h
//  Eyvee
//
//  Created by Neetika Mittal on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYPaymentOptionCell : UITableViewCell

@property (nonatomic, assign) BOOL isCellSelected;
- (void)updateLabelText:(NSString *)text;
+ (CGFloat)requiredHeight;

@end
