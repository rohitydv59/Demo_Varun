//
//  WPKeyboardAccessoryView.m
//  WynkPay
//
//  Created by Nikhil on 12/22/14.
//  Copyright (c) 2014 BSB. All rights reserved.
//

#import "WPKeyboardAccessoryView.h"
#import "EYConstant.h"

@interface WPKeyboardAccessoryView()

@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation WPKeyboardAccessoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    
    return self;
}

- (void)setup:(CGRect)frame
{
    self.toolBar = [[UIToolbar alloc] initWithFrame:frame];
    self.toolBar.tintColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    self.toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = 30.0;
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPreviousButton:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapNextButton:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapDoneButton:)];
    
    NSArray *barItems = @[doneButton, flexSpace, previousButton, fixed, nextButton];
    [_toolBar setItems:barItems animated:YES];
    
    [self addSubview:_toolBar];
    
    self.previousButton = previousButton;
    self.nextButton = nextButton;
    self.doneButton = doneButton;
}

- (void)layoutSubviews
{
    self.toolBar.frame = self.bounds;
}

#pragma mark - Button Actions

- (void)didTapPreviousButton:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didTapPreviousButton)]) {
        [_delegate didTapPreviousButton];
    }
}

- (void)didTapNextButton:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didTapNextButton)]) {
        [_delegate didTapNextButton];
    }
}

- (void)didTapDoneButton:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didTapDoneButton)]) {
        [_delegate didTapDoneButton];
    }
}

#pragma mark - Public Methods

- (void)disablePrevious
{
    self.nextButton.enabled = YES;
    self.previousButton.enabled = NO;
}

- (void)disableNext
{
    self.nextButton.enabled = NO;
    self.previousButton.enabled = YES;
}

- (void)enableAll
{
    self.nextButton.enabled = YES;
    self.previousButton.enabled = YES;
}

- (void)disableAll
{
    self.nextButton.enabled = NO;
    self.previousButton.enabled = NO;
}

- (void)disablePreviousAndNext
{
    self.nextButton.enabled = NO;
    self.previousButton.enabled = NO;
}
@end
