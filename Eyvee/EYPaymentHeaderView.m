//
//  EYPaymentHeaderView.m
//  Eyvee
//
//  Created by Neetika Mittal on 03/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYPaymentHeaderView.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYPaymentHeaderView () {
    NSInteger _count;
    NSString *_amount;
}

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation EYPaymentHeaderView

- (instancetype)initWithFrame:(CGRect)frame itemCount:(NSInteger)count price:(NSString *)amt
{
    self = [super initWithFrame:frame];
    if (self) {
        _amount = amt;
        _count = count;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.leftLabel.text = @"Order";
    self.leftLabel.font = REGULAR(14.0);
    self.leftLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    [self addSubview:_leftLabel];

    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.rightLabel.font = BOLD(15.0);
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.text = [NSString stringWithFormat:@"%ld %@, %@",(long)_count,(_count == 0) ? @"Item" : @"Items",_amount];
    self.rightLabel.textColor = [UIColor blackColor];
    [self addSubview:_rightLabel];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = RGB(240, 241, 245);
    [self addSubview:_bottomView];
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.bottomLabel.font = REGULAR(12.0);
    self.bottomLabel.text = @"SELECT PAYMENT METHOD";
    self.bottomLabel.textColor = [UIColor blackColor];
    [self.bottomView addSubview:_bottomLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    
    CGFloat padding = kTableViewSidePadding;
    
    CGSize bottomLablSize = self.bottomLabel.intrinsicContentSize;
    CGFloat bottomViewH = bottomLablSize.height + 2 * padding;
    
    self.bottomView.frame = (CGRect) {0.0, rect.size.height - bottomViewH, rect.size.width, bottomViewH};
    self.bottomLabel.frame = (CGRect) {floorf((rect.size.width - bottomLablSize.width)/2.0), floorf((bottomViewH - bottomLablSize.height)/2.0), bottomLablSize};
    
    rect.size.height -= bottomViewH;
    
    CGSize leftLblSize = self.leftLabel.intrinsicContentSize;
    self.leftLabel.frame = (CGRect) {padding, floorf((rect.size.height - leftLblSize.height)/2.0), leftLblSize};
    
    CGSize rightLblSize = self.rightLabel.intrinsicContentSize;
    self.rightLabel.frame = (CGRect) {rect.size.width - padding - rightLblSize.width, floorf((rect.size.height - rightLblSize.height)/2.0), rightLblSize};
}

- (CGFloat)requiredH
{
    CGFloat padding = kTableViewSidePadding;
    CGFloat h = REGULAR(12.0).lineHeight + 2 * padding + BOLD(15.0).lineHeight + 2 * padding;
    return h;
}

@end
