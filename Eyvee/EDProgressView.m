//
//  WPProgressView.m
//  WynkPay
//
//  Created by Naman Singhal on 15/01/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import "EDProgressView.h"
#import "EYUtility.h"
#import "EDLoaderView.h"

@interface EDProgressView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) EDLoaderView *loader;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isShowing;
@end

@implementation EDProgressView

- (void)showProgressViewInWindow:(UIWindow *)window animated:(BOOL)animated withTitle:(NSString *)title
{
    self.titleLabel.text = title;
    self.isShowing = YES;
    
    [window addSubview:self];
    [self setNeedsLayout];
    
    if (!animated) {
        [self.layer removeAllAnimations];
        [self setIsAnimating:NO];
        
        self.bgView.alpha = 1.0;
        self.contentView.alpha = 1.0;
        return;
    }
    
    [self layoutIfNeeded];
    [self setIsAnimating:YES];
    
    self.bgView.alpha = 0.0;
    self.contentView.alpha = 0.0;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.bgView.alpha = 1.0;
                         self.contentView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [self setIsAnimating:NO];
                     }];
}

- (void)hideProgressViewAnimated:(BOOL)animated completion:(void (^)(BOOL finished))handler
{
    if (!animated) {
        [self removeFromSuperview];
        if (handler) {
            handler(YES);
        }
        return;
    }
    
    [self setIsAnimating:YES];
    [self setIsShowing:NO];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.bgView.alpha = 0.0;
                         self.contentView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (!self.isShowing) {
                             [self removeFromSuperview];
                         }
                         
                         if (handler) {
                             handler(!self.isShowing);
                         }
                     }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        [self addSubview:_bgView];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView.layer.cornerRadius = kItemCornerRadius * 2.0;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.titleLabel.numberOfLines = 0;
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.font = kAcknowledgmentGeneralTextFont;
//        self.titleLabel.textColor = kAcknowledgmentLightColor;
//        [self.contentView addSubview:self.titleLabel];
        
        self.loader = [[EDLoaderView alloc] initWithTintColor:kAppGreenColor];
        [self.contentView addSubview:_loader];
    }
    return self;
}

- (void)layoutSubviews
{
    if (_isAnimating) {
        return;
    }
    
    CGSize size = self.bounds.size;
    
//    float containerW = size.width - 4.0 * kLoaderViewTopPadding;
//    float contentW = containerW - 2.0 * kItemCornerRadius;
//    float labelMaxW = contentW - 2.0 * kLoaderViewTopPadding;
    
    CGSize loaderSize = (CGSize) {48.0, 48.0};
    
//    CGSize titleSize = [EYUtility sizeForString:self.titleLabel.text font:self.titleLabel.font width:labelMaxW];
//    contentW = MAX(titleSize.width, loaderSize.width) + 2.0 * kLoaderViewTopPadding;
//    containerW = contentW + 2.0 * kItemCornerRadius;

    float containerW = 2.0 * kLoaderViewTopPadding + loaderSize.width;
    
//    float padding = kLoaderViewTopPadding;
//    float inPadding = kLoaderViewTopPadding/2.0;
//    float contentH = round(titleSize.height + 2.0 * padding + inPadding + loaderSize.height);
    float containerH = containerW;// + 2.0 * kItemCornerRadius;
    
    CGRect containerFrame = (CGRect) {floorf((size.width - containerW)/2.0), floorf((size.height - containerH)/2.0), containerW, containerH};
    self.contentView.frame = containerFrame;
    
//    CGRect contentRect = CGRectInset(self.containerView.bounds, kItemCornerRadius, kItemCornerRadius);
//    self.contentView.frame = contentRect;
    //self.blurView.frame = contentRect;
    
//    size = self.contentView.bounds.size;
    
    self.bgView.frame = self.bounds;
    //self.titleLabel.frame = (CGRect) {floor((size.width - titleSize.width)/2.0), size.height - (padding/2) - titleSize.height, titleSize};
    
    self.loader.frame = self.contentView.bounds; //(CGPoint) {floor(size.width/2.0), padding + loaderSize.height/2.0};
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:kItemCornerRadius];
//    self.containerView.layer.shadowPath = path.CGPath;
}

@end

