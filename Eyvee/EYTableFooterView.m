//
//  EYTableFooterView.m
//  Eyvee
//
//  Created by Rohit Yadav on 20/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYTableFooterView.h"
#import "EYConstant.h"

@interface EYTableFooterView()

@end

@implementation EYTableFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bottomBtn.backgroundColor = kGreenColor;
    [self.bottomBtn.titleLabel setText:@"Update Profile"];
    [self addSubview:self.bottomBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat kSidePadding = 30.0;
    CGFloat kButtonheight = 48.0;
    CGFloat kTopPadding = 20.0;
    self.bottomBtn.frame = (CGRect){kSidePadding, kTopPadding, (size.width- 2*kSidePadding), kButtonheight};
}

@end
