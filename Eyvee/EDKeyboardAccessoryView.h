//
//  WPKeyboardAccessoryView.h
//  WynkPay
//
//  Created by Nikhil on 12/22/14.
//  Copyright (c) 2014 BSB. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    EDAllButtons,
    EDDoneButtonOnly,
    EDCancelAndDoneButton
} EDAccessoryViewMode;

@protocol EDKeyboardAccessoryViewDelegate <NSObject>

@optional
- (void)didTapNextButton;
- (void)didTapPreviousButton;
- (void)didTapCancelButton;

@required
- (void)didTapDoneButton;

@end

@interface EDKeyboardAccessoryView : UIView

@property (nonatomic, weak) id <EDKeyboardAccessoryViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andMode:(EDAccessoryViewMode)mode;

- (void)disablePrevious;
- (void)disableNext;
- (void)enableAll;
- (void)disableAll;
- (void)disablePreviousAndNext;

@end
