//
//  EYTabButton.m
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYTabButton.h"
#import "EYConstant.h"

@interface EYTabButton ()


@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation EYTabButton

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
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imgView.contentMode = UIViewContentModeCenter;
    [self addSubview:_imgView];
    
    self.lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineView.backgroundColor = [UIColor clearColor];
    [self addSubview:_lineView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = kAppGreenColor;
    label.font = AN_REGULAR(11.0);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"";
    label.hidden = YES;
    label.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wishlistUpdated:) name:kWishListUpdateNotification object:nil];
    
    self.badgeLabel = label;
    [self addSubview:_badgeLabel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    
    CGFloat underlineH = kUnderlineViewHeight;
    
    CGSize imgSize = self.imgView.image.size;
    self.imgView.frame = (CGRect) {floorf((rect.size.width - imgSize.width)/2.0), floorf((rect.size.height - underlineH - imgSize.height)/2.0), imgSize};
    
    self.lineView.frame = (CGRect) {0.0, rect.size.height - underlineH, rect.size.width, underlineH};
    
    [self bringSubviewToFront:self.badgeLabel];
    
    CGSize size = self.badgeLabel.intrinsicContentSize;
    if (size.width < 16.0) {
        size.width = 16.0;
    }
    if (size.height < 16.0) {
        size.height = 16.0;
    }
    
    CGSize mainSize = self.bounds.size;
    CGRect imgFrame = (CGRect) {MACenteredOrigin(mainSize.width, imgSize.width), MACenteredOrigin(mainSize.height, imgSize.height), imgSize};
    
    float x = CGRectGetMaxX(imgFrame) - floor(size.width/2.0);
    float y = CGRectGetMinY(imgFrame) - floor(size.height/2.0);
    
    self.badgeLabel.frame = (CGRect) {x, y, size};
    self.badgeLabel.layer.cornerRadius = size.height/2.0;
}

- (void)setUnSelectedImage:(UIImage *)image tintColor:(UIColor *)color
{
    self.tintColor = color;
    [self updateUnselectedImage:image];
    [self setNeedsLayout];
}

- (void)updateUnselectedImage:(UIImage *)image
{
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.imgView.tintColor = [UIColor clearColor];
    [self.lineView setBackgroundColor:[UIColor clearColor]];
    self.imgView.image = image;
}

- (void)updateSelectedImage:(UIImage *)image
{
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imgView.tintColor = self.tintColor;
    [self.lineView setBackgroundColor:self.tintColor];
    self.imgView.image = image;
}

- (void)setIsBtnSelected:(BOOL)isBtnSelected
{
    _isBtnSelected = isBtnSelected;
    if (_isBtnSelected) {
        [self updateSelectedImage:self.imgView.image];
    }
    else {
        [self updateUnselectedImage:self.imgView.image];
    }
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

- (void)wishlistUpdated:(NSNotification *)aNotification
{
    NSDictionary *dict = aNotification.userInfo;
    NSInteger count = [dict[@"count"] integerValue];
    if (self.tag == 3) {
    [self setBadgeText:[NSString stringWithFormat:@"%i", (int)count]];
    }
}


@end
