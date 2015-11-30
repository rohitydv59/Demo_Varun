//
//  UIPickerView.h
//  WynkPay
//
//  Created by Monis Manzoor on 16/01/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPPickerView;

@protocol WPPickerDelegate <NSObject>

@optional
- (void)pickerView:(WPPickerView *)aView didSelectCategoryAtIndex:(NSInteger)rowNo;
- (void)pickerView:(WPPickerView *)aView didSelectDate:(NSDate *)date;

@end

@interface WPPickerView : UIView

@property (nonatomic, weak) id <WPPickerDelegate> delegate;
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;
@property (nonatomic, strong) NSArray *catArray;

- (id)initWithFrame:(CGRect)frame currentDate:(NSDate *)date minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;
- (id)initWithFrame:(CGRect)frame currentCategory:(NSInteger)index categories:(NSArray *)array;

@end
