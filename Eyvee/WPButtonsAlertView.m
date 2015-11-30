//
//  WPButtonsAlertView.m
//  WynkPay
//
//  Created by Monis on 01/04/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import "WPButtonsAlertView.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface WPButtonsAlertView() {
    EYProductInCartInfo *productInfo;
}

@property (nonatomic, strong) UILabel *errorMessage;

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *otherButton;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation WPButtonsAlertView

+ (void)showErrorInWindow:(UIWindow *)window animated:(BOOL)animated productInfo:(EYProductInCartInfo *)info
{
    WPButtonsAlertView *errorView = [[WPButtonsAlertView alloc] initWithFrame:window.bounds productInfo:info];
    errorView.animated = animated;
    
    NSString *topText = info.productAllInfo.productName;
    NSString *bottomText = [NSString stringWithFormat:@"Product added to cart."];
    [errorView setAttributedTextForTopAndBottomDescription:topText bottomDescription:bottomText];
    
    [window addSubview:errorView];
    
    if (!animated) {
        return;
    }
    
    [errorView layoutIfNeeded];
    [errorView setIsAnimating:YES];
    
    errorView.bgView.alpha = 0.0;
    errorView.containerView.alpha = 0.0;
    errorView.containerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         errorView.bgView.alpha = 1.0;
                         errorView.containerView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [errorView setIsAnimating:NO];
                     }];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         errorView.containerView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [errorView setIsAnimating:NO];
                     }];
}

+ (void)hideErrorView:(WPButtonsAlertView *)errorView animated:(BOOL)animated
{
    if (!animated) {
        [errorView removeFromSuperview];
        return;
    }
    
    [errorView setIsAnimating:YES];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         errorView.bgView.alpha = 0.0;
                         errorView.containerView.alpha = 0.0;
                         errorView.containerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
                     }
                     completion:^(BOOL finished) {
                         [errorView removeFromSuperview];
                     }];
}

- (id)initWithFrame:(CGRect)frame productInfo:(EYProductInCartInfo *)product
{
    self = [super initWithFrame:frame];
    if (self) {
        productInfo = product;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bgView.backgroundColor = kDimOutViewColor;
        [self addSubview:_bgView];
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.containerView.backgroundColor = [UIColor lightGrayColor];
        self.containerView.layer.cornerRadius = 8.0;
        [self addSubview:self.containerView];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.containerView addSubview:_contentView];
        
        self.errorMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        self.errorMessage.numberOfLines = 0;
        self.errorMessage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.errorMessage];
        
        NSString *leftBtnText = @"SHOP MORE";
        NSString *rightBtnText = @"VIEW CART";
        
        self.dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.dismissButton.titleLabel setFont:AN_BOLD(13.0)];
        [self.dismissButton setBackgroundColor:[UIColor blackColor]];
        [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.dismissButton setTitle:leftBtnText forState:UIControlStateNormal];
        [self.dismissButton addTarget:self action:@selector(dismissButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.dismissButton];
        
        self.otherButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.otherButton.titleLabel setFont:AN_BOLD(13.0)];
        [self.otherButton setBackgroundColor:RGB(47.0, 204.0, 92.0)];
        [self.otherButton setTitle:rightBtnText forState:UIControlStateNormal];
        [self.otherButton addTarget:self action:@selector(otherButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.otherButton];
    }
    
    return self;
}

- (void)layoutSubviews
{
    if (_isAnimating) {
        return;
    }
    
    CGSize size = self.bounds.size;
    
    float containerW = size.width - 2.0 * kButtonAlertPadding;
    float contentW = containerW;
    float labelMaxW = contentW - 2.0 * kButtonAlertPadding;
    
    CGSize messageSize = [EYUtility sizeForAttributedString:self.errorMessage.attributedText width:labelMaxW];
    containerW = contentW = messageSize.width + 2 * kButtonAlertPadding;
    
    float padding = kButtonAlertPadding;
    CGFloat btnH = 48.0;
    
    float contentH = round(messageSize.height + btnH + 2.0 * padding);
    float containerH = contentH;
    
    CGRect containerFrame = (CGRect) {floorf((size.width - containerW)/2.0), floorf((size.height - containerH)/2.0), containerW, containerH};
    self.containerView.frame = containerFrame;
    
    CGRect contentRect = CGRectInset(self.containerView.bounds, 0, 0);
    self.contentView.frame = contentRect;
    
    size = self.contentView.bounds.size;
    
    self.bgView.frame = self.bounds;
    self.errorMessage.frame = (CGRect) {floor((size.width - messageSize.width)/2.0), padding, messageSize};
    self.dismissButton.frame = (CGRect) {0, size.height - btnH, size.width/2, btnH};
    self.otherButton.frame = (CGRect) {size.width/2, size.height - btnH, size.width/2, btnH};
    
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = (CGSize) {0.0, 1.0};
    self.containerView.layer.shadowRadius = 2.0;
    self.containerView.layer.shadowOpacity = 0.4;
    self.containerView.layer.cornerRadius = 8.0;
    self.containerView.clipsToBounds = YES;
    
}

- (void)setAttributedTextForTopAndBottomDescription:(NSString *)topDescription bottomDescription:(NSString *)bottomDescriptionThree
{
    self.errorMessage.attributedText = [WPButtonsAlertView attributedTextForTopMessage:topDescription bottomMessage:bottomDescriptionThree];
}

+ (NSAttributedString *)attributedTextForTopMessage:(NSString*)messageText bottomMessage:(NSString *)messageTextLast
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *string;
    if (messageText.length > 0) {
        NSDictionary *attributes = @{NSFontAttributeName : AN_REGULAR(15.0),
                                     NSForegroundColorAttributeName : kBlackTextColor,
                                     };

        string = [[NSAttributedString alloc] initWithString:messageText attributes:attributes];
        [text appendAttributedString:string];
    }
    
    if (messageTextLast.length > 0) {
        NSDictionary *attributes = @{NSFontAttributeName : AN_REGULAR(15.0),
                                     NSForegroundColorAttributeName : kRowLeftLabelColor,
                                     };

        string = [[NSAttributedString alloc] initWithString:messageTextLast attributes:attributes];
        [text appendAttributedString:string];
    }
    return text;
}

- (void)otherButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kViewCartButtonTappedNotification object:nil];
    [WPButtonsAlertView hideErrorView:self animated:self.animated];
}

- (void)dismissButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShopMoreButtonTappedNotification object:nil];
    [WPButtonsAlertView hideErrorView:self animated:self.animated];
}

@end
