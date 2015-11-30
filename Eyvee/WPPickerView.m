//
//  UIPickerView.m
//  WynkPay
//
//  Created by Monis Manzoor on 16/01/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import "WPPickerView.h"
#import "EYConstant.h"

@interface WPPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIToolbar *bgToolbar;

@property (nonatomic, strong) NSString *currentCategory;

@end

@implementation WPPickerView

- (id)initWithFrame:(CGRect)frame currentCategory:(NSInteger)index categories:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
        _catArray = array;
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.picker];
        [self.picker setBackgroundColor:[UIColor clearColor]];
        
        self.picker.delegate = self;
        self.picker.dataSource = self;
        self.picker.showsSelectionIndicator = YES;
        
        [self.picker selectRow:index inComponent:0 animated:NO];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame currentDate:(NSDate *)date minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        self.datePicker.backgroundColor = [UIColor clearColor];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.maximumDate = maxDate;
        self.datePicker.minimumDate = minDate;
        self.datePicker.date = date;
        [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.datePicker];
    }
    return self;
}

- (void)setCatArray:(NSArray *)catArray
{
    if (!catArray || catArray.count == 0) {
        return;
    }
    _catArray = catArray;
    [self.picker reloadAllComponents];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    self.bgToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.bgToolbar.clipsToBounds = YES;
    [self addSubview:_bgToolbar];
}

- (void)datePickerValueChanged:(id)sender
{
    if ([_delegate respondsToSelector:@selector(pickerView:didSelectDate:)]) {
        [_delegate pickerView:self didSelectDate:self.datePicker.date];
    }
}

#pragma mark - picker view delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.catArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.catArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row > self.catArray.count) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(pickerView:didSelectCategoryAtIndex:)]) {
        [_delegate pickerView:self didSelectCategoryAtIndex:row];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgToolbar.frame = self.bounds;
    self.picker.frame = self.bounds;
    self.datePicker.frame = self.bounds;
}

@end
