//
//  EYGridProductHeaderView.h
//  Eyvee
//
//  Created by Neetika Mittal on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYGridProductHeaderView : UIView

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic,strong) UIView * boldSeparatorLine;

- (void)updateLeftButtonTitle:(NSAttributedString *)left rightButtonTitle:(NSString *)right;

@end
