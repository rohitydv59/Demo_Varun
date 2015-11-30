//
//  EYMonthYearPicker.h
//  Eyvee
//
//  Created by Rohit Yadav on 30/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EYMonthYearPickerModeMonthAndYear,  // Display month and year
    EYMonthYearPickerModeYear           // Display just the year
} EYMonthYearPickerMode;


@interface EYMonthYearPicker : UIControl <NSCoding>

// The mode of the date picker - see the NTMonthYearPickerMode enum
// Default is NTMonthYearPickerModeMonthAndYear
@property (nonatomic) EYMonthYearPickerMode datePickerMode;

// The locale used by the date picker
// Default is [NSLocale currentLocale]. Setting nil returns to default
@property (nonatomic, retain) NSLocale *locale;

// The calendar to use for the date picker
// Default is [NSCalendar currentCalendar]. Setting nil returns to default
@property (nonatomic, copy) NSCalendar *calendar;

// The date displayed by the date picker
// Default is current date when picker is created
@property (nonatomic, retain) NSDate *date;

// The minimum date that the date picker should show
// Default is nil (Jan 1, 0001 in the UI)
@property (nonatomic, retain) NSDate *minimumDate;

// The maximum date that the date picker should show
// Default is nil (Dec 31, 10000 in the UI)
@property (nonatomic, retain) NSDate *maximumDate;

// Sets the date to display in the date picker
// If animated is YES, animate the wheels to display the new date
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end
