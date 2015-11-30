//
//  EYSaveCardCell.h
//  Eyvee
//
//  Created by Neetika Mittal on 03/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYBottomButton.h"

@class WPTickButton;

@interface EYSaveCardCell : UITableViewCell

@property (nonatomic, strong) NSString *amount;
//@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) EYBottomButton *payBtn;
@property (nonatomic, strong) WPTickButton *tickBtn;

+ (CGFloat)requiredHeightForWidth:(CGFloat)width andText:(NSString*)text;

@end
