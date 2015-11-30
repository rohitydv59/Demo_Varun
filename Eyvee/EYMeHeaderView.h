//
//  EYMeHeaderView.h
//  Eyvee
//
//  Created by Disha Jain on 19/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYMeHeaderView : UIView

@property (nonatomic, strong) UIImageView *imgBackgroud;
@property (nonatomic, strong) UILabel *lblName;

- (void)setTextForLabel;

@end
