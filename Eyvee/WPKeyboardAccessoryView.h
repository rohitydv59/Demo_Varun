//
//  WPKeyboardAccessoryView.h
//  WynkPay
//
//  Created by Nikhil on 12/22/14.
//  Copyright (c) 2014 BSB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPKeyboardAccessoryViewDelegate <NSObject>

- (void)didTapDoneButton;

@optional

- (void)didTapNextButton;
- (void)didTapPreviousButton;

@end

@interface WPKeyboardAccessoryView : UIView

@property (nonatomic, weak) id <WPKeyboardAccessoryViewDelegate> delegate;

- (void)disablePrevious;
- (void)disableNext;
- (void)enableAll;
- (void)disableAll;
- (void)disablePreviousAndNext;

@end
