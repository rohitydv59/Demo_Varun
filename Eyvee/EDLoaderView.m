//
//  EDLoaderView.m
//  EazyDiner
//
//  Created by Shubham Mandal on 18/06/15.
//  Copyright (c) 2015 Pulkit Arora. All rights reserved.
//

#import "EDLoaderView.h"
#import "MRActivityIndicatorView.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface EDLoaderView ()

@property (nonatomic, assign) EDLoaderMode mode;
@property (nonatomic, strong) MRActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *lblLoader;

@end

@implementation EDLoaderView

- (id)init
{
    return [self initWithTintColor:kAppGreenColor];
}

- (id)initWithTintColor:(UIColor *)color
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];

        self.indicatorView = [[MRActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [self.indicatorView setTintColor:color];
        [self addSubview:self.indicatorView];
        [self.indicatorView startAnimating];
        
        float h = 48.0 + 2.0 * kLoaderViewTopPadding;
        float w = 48.0 + 2.0 * kLoaderViewTopPadding;
        [self setFrame:(CGRect) {0.0, 0.0, w, h}];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden) {
        [self.indicatorView stopAnimating];
    }
    else {
        [self.indicatorView startAnimating];
    }
}

- (void)layoutSubviews
{
    CGRect rect = self.bounds;
    
    float y = kLoaderViewTopPadding;
    CGSize size = CGSizeMake(48, 48);
    
    float x = MACenteredOrigin(rect.size.width, size.width);
    self.indicatorView.frame = (CGRect){x,y,size};
}

@end
