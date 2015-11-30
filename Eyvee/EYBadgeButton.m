//
//  EYBadgeButton.m
//  Eyvee
//
//  Created by Rohit Yadav on 16/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYBadgeButton.h"
#import "EYConstant.h"

@interface EYBadgeButton ()

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation EYBadgeButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = kAppGreenColor;
        label.font = AN_REGULAR(11.0);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"";
        label.hidden = YES;
        label.clipsToBounds = YES;
        
        self.badgeLabel = label;
        [self addSubview:_badgeLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self bringSubviewToFront:self.badgeLabel];
    
    CGSize size = self.badgeLabel.intrinsicContentSize;
    if (size.width < 16.0) {
        size.width = 16.0;
    }
    if (size.height < 16.0) {
        size.height = 16.0;
    }
    
    CGSize imgSize = [self imageForState:self.state].size;
    CGSize mainSize = self.bounds.size;
    CGRect imgFrame = (CGRect) {MACenteredOrigin(mainSize.width, imgSize.width), MACenteredOrigin(mainSize.height, imgSize.height), imgSize};
    
    float x = CGRectGetMaxX(imgFrame) - floor(size.width/2.0);
    float y = CGRectGetMinY(imgFrame) - floor(size.height/2.0);
    
    self.badgeLabel.frame = (CGRect) {x, y, size};
    self.badgeLabel.layer.cornerRadius = size.height/2.0;
}

- (void)setBadgeText:(NSString *)badgeText
{
    if (badgeText.length == 0 || [badgeText isEqualToString:@"0"]) {
        self.badgeLabel.hidden = YES;
        self.badgeLabel.text = nil;
        [self setNeedsLayout];
    }
    else {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = badgeText;
        [self setNeedsLayout];
    }
}

- (CGSize)requiredSize
{
    CGSize imgSize = [self imageForState:UIControlStateNormal].size;
    CGSize badgeSize = [self.badgeLabel intrinsicContentSize];
    
    if (badgeSize.width < 16.0) {
        badgeSize.width = 16.0;
    }
    if (badgeSize.height < 16.0) {
        badgeSize.height = 16.0;
    }
    
    return (CGSize) {imgSize.width, imgSize.height};
}

@end
