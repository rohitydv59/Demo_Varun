//
//  WPCustomIndicatorView.m
//  WynkPay
//
//  Created by Monis Manzoor on 09/01/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import "WPLoadingView.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface WPLoadingView()

@property (nonatomic, assign) WPLoadingViewMode mode;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation WPLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = NSLocalizedString(@"Loading_message", @"");
        self.titleLabel.font = LIGHT(16.0);
        self.titleLabel.textColor = GRAY(0.6);
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.tintColor = GRAY(0.6);
        self.activityIndicator.hidesWhenStopped = YES;
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.activityIndicator];
    }
    return self;
}

- (void)layoutSubviews
{
    if (_mode == WPLoadingViewModeInfo) {
        CGSize size = self.bounds.size;
        float x = kTableViewSidePadding;
        float w = size.width - 2.0 * x;
        
        self.containerView.frame = (CGRect){x, 0.0, w, size.height};
        self.titleLabel.frame = self.containerView.bounds;
    }
    else {
        CGSize size = self.bounds.size;
        CGSize titleSize = self.titleLabel.intrinsicContentSize;
        CGSize lSize = self.activityIndicator.bounds.size;
        
        float w = titleSize.width + kTableViewLongListPadding + lSize.width;
        float h = MAX(titleSize.height, lSize.height);
        CGRect containerRect = (CGRect) {floor((size.width - w)/2.0), floor((size.height - h)/2.0), w, h};
        
        self.containerView.frame = containerRect;
        self.activityIndicator.frame = (CGRect) {0.0, floor((h - lSize.height)/2.0), lSize};
        self.titleLabel.frame = (CGRect) {w - titleSize.width, floor((h - titleSize.height)/2.0), titleSize};
    }
}

- (void)setMode:(WPLoadingViewMode)mode withText:(NSString *)text
{
    _mode = mode;
    
    if (_mode == WPLoadingViewModeInfo) {
        [self.activityIndicator stopAnimating];
    }
    else {
        [self.activityIndicator startAnimating];
    }
    
    self.titleLabel.text = text;
    [self setNeedsLayout];
}

- (CGFloat)getHeightForText:(NSString *)text mode:(WPLoadingViewMode)mode forWidth:(CGFloat)width
{
    if (mode == WPLoadingViewModeActivity) {
        return 88.0;
    }
    else {
        CGSize size = [EYUtility sizeForString:text font:LIGHT(16.0) width:width - 2 * kTableViewSidePadding];
        return size.height + 2 * kTableViewSidePadding;
    }
}

@end
