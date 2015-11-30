//
//  EYGridProductHeaderView.m
//  Eyvee
//
//  Created by Neetika Mittal on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYGridProductHeaderView.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYGridProductHeaderView ()

@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UIImageView *bottomLineView;
@property (nonatomic, strong) UIToolbar *bgToolbar;


@end

@implementation EYGridProductHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.bgToolbar = [[UIToolbar alloc]initWithFrame:CGRectZero];
    _bgToolbar.barTintColor=[UIColor whiteColor];
    [self addSubview:_bgToolbar];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.leftBtn setTitle:NSLocalizedString(@"filter_btn_text", "") forState:UIControlStateNormal];
    [self.leftBtn.titleLabel setFont:AN_MEDIUM(13.0)];
    [self.leftBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    [self addSubview:_leftBtn];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.rightBtn setTitle:NSLocalizedString(@"sort_btn_text", "") forState:UIControlStateNormal];
    [self.rightBtn.titleLabel setFont:AN_MEDIUM(13.0)];
    [self.rightBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    [self addSubview:_rightBtn];
    
    self.lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineView.backgroundColor = kLineColor;
    [self addSubview:_lineView];
    
    self.bottomLineView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bottomLineView.backgroundColor = kLineColor;
    [self addSubview:_bottomLineView];
    
    _boldSeparatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _boldSeparatorLine.backgroundColor = kSeparatorColor;
    [self addSubview:_boldSeparatorLine];
    _boldSeparatorLine.hidden = YES;

}

- (void)updateLeftButtonTitle:(NSAttributedString *)left rightButtonTitle:(NSString *)right
{
    [self.leftBtn setAttributedTitle:left forState:UIControlStateNormal];
    [self.rightBtn setTitle:right forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    
    self.bgToolbar.frame = rect;
    
    CGFloat lineW = 2.0/[UIScreen mainScreen].scale;
    CGFloat w = floorf(rect.size.width/2.0) - lineW/2.0;
    
    CGRect btnRect = (CGRect) {0.0, 0.0, w, rect.size.height};
    self.leftBtn.frame = btnRect;
    btnRect.origin.x += w + lineW;
    self.rightBtn.frame = btnRect;
    self.lineView.frame = (CGRect) {w, 0.0, lineW, rect.size.height};
    
    self.bottomLineView.frame = (CGRect) {0.0, rect.size.height - lineW, rect.size.width, lineW};
    
    CGFloat thickness = 2.0/[UIScreen mainScreen].scale;
    _boldSeparatorLine.frame = CGRectMake(CGRectGetMaxX(self.lineView.frame), rect.size.height - thickness, rect.size.width/2-lineW, thickness);
    
}

@end
