//
//  WPKeyboardAccessoryView.m
//  WynkPay
//
//  Created by Nikhil on 12/22/14.
//  Copyright (c) 2014 BSB. All rights reserved.
//

#import "EDKeyboardAccessoryView.h"
#import "EYConstant.h"

@interface EDKeyboardAccessoryView()

@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, assign) EDAccessoryViewMode mode;

@end

@implementation EDKeyboardAccessoryView

- (id)initWithFrame:(CGRect)frame andMode:(EDAccessoryViewMode)mode
{
    self = [super initWithFrame:frame];
    self.mode = mode;
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];

    self.toolBar.tintColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    self.toolBar.barStyle = UIBarStyleDefault;

    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = 32.0;
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPreviousButton:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_right"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapNextButton:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStylePlain target:self action:@selector(didTapDoneButton:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"CLOSE" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelButton:)];

    NSDictionary *barButtonAttributes = @{NSFontAttributeName : AN_MEDIUM(14.0),
                                          NSForegroundColorAttributeName : kBlackTextColor};

    [doneButton setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
    [cancelButton setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];

    
    NSArray *barItems = [[NSArray alloc] init];
    if (self.mode == EDDoneButtonOnly)
    {
        barItems = @[flexSpace , doneButton];
    }
    else if (self.mode == EDCancelAndDoneButton)
    {
         barItems = @[cancelButton,flexSpace , doneButton];
    }
    else
    {
        barItems = @[previousButton, fixed, nextButton, flexSpace, doneButton];
    }
    
    [_toolBar setItems:barItems animated:YES];
    
    [self addSubview:_toolBar];
    
    self.previousButton = previousButton;
    self.nextButton = nextButton;
    self.doneButton = doneButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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

- (void)didTapCancelButton:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didTapCancelButton)]) {
        [_delegate didTapCancelButton];
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
