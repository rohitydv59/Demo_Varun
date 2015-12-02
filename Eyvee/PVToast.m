//
//  MAToastView.m
//  MyAirtel
//
//  Created by Naman Singhal on 21/04/15.
//  Copyright (c) 2015 Nishit Sharma. All rights reserved.
//

#import "PVToast.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface MAToastView : UIView {
    float _margin;
    float _offset;
}

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UILabel *label;

@end

@interface PVToast () {
    float _autoHideDuration;
}

@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic, strong) MAToastView *toastView;

@end

@implementation PVToast

+ (PVToast *)shared
{
    static dispatch_once_t onceToken;
    static PVToast *shared=nil;
    dispatch_once(&onceToken,^{
        shared = [[PVToast allocWithZone:nil] init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.queue = [[NSMutableArray alloc] init];
        _autoHideDuration = 1.5;
    }
    return self;
}

- (void)showToastMessage:(NSString *)message
{
    if (message.length == 0) {
        return;
    }
    
    [self.queue addObject:message];
    
    if (_toastView) {
        return;
    }
    
    [self processQueue];
}

- (void)processQueue
{
    if (self.queue.count == 0) {
        [self hide];
        return;
    }
    
    NSString *current = self.queue[0];
    [self.queue removeObjectAtIndex:0];
    [self showCurrentMessage:current];
}

- (void)handleToastTap:(UIGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateRecognized) {
        [self.queue removeAllObjects];
        [self hide];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)showCurrentMessage:(NSString *)message
{
    BOOL needAnimation = NO;
    
    if (!_toastView) {
        _toastView = [[MAToastView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastTap:)];
        [_toastView addGestureRecognizer:tap];
        needAnimation = YES;
    }
    
    [_toastView setMessage:message];
    _toastView.alpha = 0.0;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _toastView.alpha = 1.0;
                     }
                     completion:nil];
    
    [self performSelector:@selector(processQueue) withObject:nil afterDelay:_autoHideDuration];
}

- (void)hide
{
    UIView *toast = _toastView;
    _toastView = nil;
    
    [UIView animateWithDuration:0.2 animations:^{
        toast.alpha = 0.0;
    } completion:^(BOOL finished) {
        [toast removeFromSuperview];
    }];
}

@end

@implementation MAToastView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _margin = 12.0;
        _offset = 2.0;
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.numberOfLines = 0;
        self.label.font = REGULAR(14.0);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor whiteColor];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)setMessage:(NSString *)message
{
    self.label.text = message;
    
    UIFont *font = self.label.font;
    float y = 0.8;
    
    CGSize size = [EYUtility sizeForString:message font:font width:kBigContentWidth - 2.0 * _margin];
    
    float w = size.width + 2.0 * _margin;
    float h = size.height + 2.0 * _margin;
    
    self.frame = (CGRect) {0.0, 0.0, w, h};
    
    if (_label.superview == nil) {
        if ([UIBlurEffect class]) {
            [self setupBlurView];
        }
        else {
            self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
            CGRect rect = self.bounds;
            rect = CGRectInset(rect, _margin, _margin);
            rect.origin.y -= _offset;
            self.label.frame = rect;
            [self addSubview:_label];
        }
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    float position = round(y * window.bounds.size.height);
    self.center = (CGPoint) {window.bounds.size.width/2.0, position};
}

- (void)setupBlurView
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.bounds];
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:blurEffectView];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    vibrancyEffectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [vibrancyEffectView setFrame:self.bounds];

    CGRect rect = self.bounds;
    rect = CGRectInset(rect, _margin, _margin);
    rect.origin.y -= _offset;
    self.label.frame = rect;
    
    [[vibrancyEffectView contentView] addSubview:self.label];
    [[blurEffectView contentView] addSubview:self.label];
}

@end
