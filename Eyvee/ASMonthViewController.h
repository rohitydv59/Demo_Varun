//
//  ASMonthViewController.h
//  ASCalendar
//
//  Created by Naman Singhal on 28/10/15.
//  Copyright © 2015 App Street Software Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ASDateTypeCurrent = 0,
    ASDateTypePrevious = -1,
    ASDateTypeNext = 1
} ASDateType;

@class ASMonthViewController;

@protocol ASMonthViewControllerDelegate <NSObject>

- (void)monthController:(ASMonthViewController *)vc dateTapped:(NSDate *)date dateType:(ASDateType)type;

@end

@interface ASMonthViewController : UIViewController

- (id)initWithMonth:(NSInteger)month year:(NSInteger)year calendar:(NSCalendar *)calendar;
- (void)setStartDate:(NSDate *)date numberOfDays:(NSInteger)noOfDays;

@property (nonatomic, weak) id <ASMonthViewControllerDelegate> delegate;

@property (nonatomic, strong, readonly) NSDate *firstDate;
@property (nonatomic, strong, readonly) NSString *monthTitle;

@property (nonatomic, assign, readonly) BOOL isFirstMonth;
@property (nonatomic, assign, readonly) BOOL isLastMonth;

@property (nonatomic, strong) UIColor *separatorColor;

@property (nonatomic, strong) UIColor *dayTitleColor;
@property (nonatomic, strong) UIFont *dayTitleFont;
@property (nonatomic, strong) UIColor *dayTitleBG;

@property (nonatomic, strong) UIFont *dateFont;
@property (nonatomic, strong) UIColor *dateColor;
@property (nonatomic, strong) UIColor *dateSelectedColor;
@property (nonatomic, strong) UIColor *dateDisabledColor;
@property (nonatomic, strong) UIColor *dateBG;
@property (nonatomic, strong) UIColor *dateSelectedBG;

@end
