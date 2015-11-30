//
//  EYCustomButton.m
//  Eyvee
//
//  Created by Varun Kapoor on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYCustomButton.h"
#import "EYConstant.h"

@interface EYCustomButton()
@property (nonatomic, strong) UIImageView *bottomSep;
@property (nonatomic, strong) UIImageView *sideSep;
@end


@implementation EYCustomButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_bottomSep)
    {
        self.bottomSep = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bottomSep.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomSep];
    }
    
    if (!_sideSep)
    {
        self.sideSep = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.sideSep.backgroundColor = [UIColor whiteColor];
        [self addSubview:_sideSep];
    }
    
    float thickness = 1.0;
    CGSize size = self.bounds.size;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = kSizeCell / 2.0f;
    self.layer.borderWidth = 1.0f;
    
    self.bottomSep.frame = (CGRect) {0.0, (size.height) - thickness, roundf(size.width), thickness};
    self.sideSep.frame = (CGRect) {size.width - thickness, 0.0, thickness, size.height - thickness};
    [self.sideSep setBackgroundColor:[UIColor whiteColor]];

    [self bringSubviewToFront:_bottomSep];
    [self bringSubviewToFront:_sideSep];
}

- (void)setHidesSideSep:(BOOL)hidesSideSep
{
    _hidesSideSep = hidesSideSep;
    self.sideSep.hidden = _hidesSideSep;
}

- (void)setHidesBotSep:(BOOL)hidesBotSep
{
    _hidesBotSep = hidesBotSep;
    self.bottomSep.hidden = _hidesBotSep;
}

@end
