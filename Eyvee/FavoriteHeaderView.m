//
//  FavoriteHeaderView.m
//  Eyvee
//
//  Created by Varun Kapoor on 21/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "FavoriteHeaderView.h"
#import "EYConstant.h"

@interface FavoriteHeaderView()

@end
@implementation FavoriteHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    
    _headerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _headerButton.backgroundColor = [UIColor blackColor];
    [_headerButton setTitle:@"+  MAKE A NEW LIST" forState:UIControlStateNormal];
    [_headerButton setTintColor:[UIColor whiteColor]];
    _headerButton.titleLabel.font = AN_MEDIUM(15.0);
    [self addSubview:_headerButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    [_headerButton setFrame:rect];
    
}

- (CGFloat)requiredH
{
//    CGFloat padding = kTableViewSidePadding;
    CGFloat h = 72;
    return h;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
