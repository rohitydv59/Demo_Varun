//
//  WPCustomIndicatorView.h
//  WynkPay
//
//  Created by Monis Manzoor on 09/01/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WPLoadingViewModeActivity = 0,
    WPLoadingViewModeInfo = 1,
} WPLoadingViewMode;

@interface WPLoadingView : UIView

- (void)setMode:(WPLoadingViewMode)mode withText:(NSString *)text;
- (CGFloat)getHeightForText:(NSString *)text mode:(WPLoadingViewMode)mode forWidth:(CGFloat)width;

@end
