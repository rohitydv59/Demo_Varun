//
//  ASMonthViewController.m
//  ASCalendar
//
//  Created by Naman Singhal on 28/10/15.
//  Copyright © 2015 App Street Software Pvt. Ltd. All rights reserved.
//

#import "ASMonthViewController.h"

@interface ASMonthViewController ()

@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;

@property (nonatomic, strong) NSMutableArray *dates;

@property (nonatomic, strong) NSMutableArray *verticalLines;
@property (nonatomic, strong) NSMutableArray *horizontalLines;

@property (nonatomic, strong) NSMutableArray *dayLabels;
@property (nonatomic, strong) NSMutableArray *dateLabels;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSInteger nofOfDays;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, strong) NSDate *ninetyDay;

@end

@interface ASDate : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) ASDateType type;
@property (nonatomic, strong) NSString *displayString;
@end

@implementation ASMonthViewController

- (id)initWithMonth:(NSInteger)month year:(NSInteger)year calendar:(NSCalendar *)calendar
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _month = month;
        _year = year;
        _calendar = calendar;
        
        if (_month == 0) {
            _month = 1;
        }
        
        if (_year == 0) {
            _year = 1970;
        }
        
        if (!_calendar) {
            _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        }
        
        [self setupDates];
        
        _separatorColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        _dayTitleColor = [UIColor blackColor];
        _dayTitleFont = [UIFont systemFontOfSize:14.0];
        _dayTitleBG = [UIColor whiteColor];
        
        _dateFont = [UIFont systemFontOfSize:14.0];
        _dateColor = [UIColor darkGrayColor];
        _dateSelectedColor = [UIColor whiteColor];
        _dateDisabledColor = [UIColor lightGrayColor];
        _dateBG = [UIColor colorWithWhite:0.95 alpha:1.0];
        _dateSelectedBG = [UIColor darkGrayColor];
    }
    return self;
}

- (void)setupDates
{
    NSDate *today = [NSDate date];
    NSDateComponents *todayComp = [_calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    self.today = [_calendar dateFromComponents:todayComp];
    
    NSDateComponents *ninetyComp = [[NSDateComponents alloc] init];
    [ninetyComp setDay:90];
    self.ninetyDay = [_calendar dateByAddingComponents:ninetyComp toDate:self.today options:0];
    ninetyComp = [_calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.ninetyDay];
    
    self.nofOfDays = 4;
    
    _isLastMonth = NO;
    _isFirstMonth = NO;
    
    if (todayComp.month == _month && todayComp.year == _year) {
        _isFirstMonth = YES;
    }
    if (ninetyComp.month == _month && ninetyComp.year == _year) {
        _isLastMonth = YES;
    }
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    [components setMonth:_month];
    [components setYear:_year];
    
    NSDate *date = [_calendar dateFromComponents:components];
    _firstDate = date;
    
    NSInteger weekday = [_calendar component:NSCalendarUnitWeekday fromDate:date];
    weekday = ((weekday + 5) % 7) + 1;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    _monthTitle = [formatter stringFromDate:date];
    
    self.dates = [[NSMutableArray alloc] initWithCapacity:42];
    
    for (NSInteger i = 1; i < weekday; i++)
    {
        NSDateComponents *comp = [[NSDateComponents alloc] init];
        [comp setDay:i - weekday];
        
        ASDate *asDate = [[ASDate alloc] init];
        asDate.date = [_calendar dateByAddingComponents:comp toDate:date options:0];
        asDate.displayString = [NSString stringWithFormat:@"%i", (int)[_calendar component:NSCalendarUnitDay fromDate:asDate.date]];
        asDate.type = ASDateTypePrevious;
        [self.dates addObject:asDate];
    }
    
    NSDateComponents *nextMonth = [[NSDateComponents alloc] init];
    [nextMonth setMonth:1];
    
    NSDate *nextMonthDate = [_calendar dateByAddingComponents:nextMonth toDate:date options:0];
    NSDate *current = date;
    
    while ([current compare:nextMonthDate] == NSOrderedAscending)
    {
        ASDate *asDate = [[ASDate alloc] init];
        asDate.date = current;
        asDate.displayString = [NSString stringWithFormat:@"%i", (int)[_calendar component:NSCalendarUnitDay fromDate:asDate.date]];
        asDate.type = ASDateTypeCurrent;
        [self.dates addObject:asDate];
        
        NSDateComponents *comp = [[NSDateComponents alloc] init];
        [comp setDay:1];
        current = [_calendar dateByAddingComponents:comp toDate:current options:0];
    }
    
    for (NSInteger i = self.dates.count; i < 42; i++)
    {
        ASDate *asDate = [[ASDate alloc] init];
        asDate.date = current;
        asDate.displayString = [NSString stringWithFormat:@"%i", (int)[_calendar component:NSCalendarUnitDay fromDate:asDate.date]];
        asDate.type = ASDateTypeNext;
        [self.dates addObject:asDate];
        
        NSDateComponents *comp = [[NSDateComponents alloc] init];
        [comp setDay:1];
        current = [_calendar dateByAddingComponents:comp toDate:current options:0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dayLabels = [[NSMutableArray alloc] init];
    NSArray *dayTitles = @[@"MO", @"TU", @"WE", @"TH", @"FR", @"SA", @"SU"];
    
    for (NSInteger i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = _dayTitleBG;
        label.font = _dayTitleFont;
        label.textColor = _dayTitleColor;
        label.text = dayTitles[i];
        [self.view addSubview:label];
        [self.dayLabels addObject:label];
    }
    
    self.dateLabels = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.dates.count; i++) {
        ASDate *asDate = self.dates[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = _dateBG;
        label.font = _dateFont;
        label.textColor = _dateColor;
        label.text = asDate.displayString;
        label.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateTapped:)];
        [label addGestureRecognizer:tap];
        
        label.userInteractionEnabled = YES;
        
        [self.view addSubview:label];
        [self.dateLabels addObject:label];
    }
    
    [self udpateDates];
    
    self.verticalLines = [[NSMutableArray alloc] init];
    self.horizontalLines = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 6; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = self.separatorColor;
        [self.view addSubview:view];
        [self.verticalLines addObject:view];
    }
    
    for (NSInteger i = 0; i < 6; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = self.separatorColor;
        [self.view addSubview:view];
        [self.horizontalLines addObject:view];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    float x = 0.0;
    float y = 0.0;
    float itemW = size.width/7.0;
    float itemH = size.height/8.0;
    
    x = 0.0;
    y = 0.0;
    
    for (UILabel *label in self.dayLabels) {
        label.frame = (CGRect) {round(x), round(y), round(x + itemW) - round(x), round(y + itemH) - round(y)};
        x += itemW;
    }
    
    y = itemH;
    x = 0.0;
    
    for (NSInteger i = 0; i < 6; i++) {
        x = 0.0;
        for (NSInteger j = 0; j < 7; j++) {
            UILabel *label = self.dateLabels[j + i * 7];
            label.frame = (CGRect) {round(x), round(y), round(x + itemW) - round(x), round(y + itemH) - round(y)};
            x += itemW;
        }
        y += itemH;
    }
    
    x = itemW;
    y = 0.0;
    
    for (UIImageView *view in self.verticalLines) {
        view.frame = (CGRect) {round(x), 0.0, 1.0, size.height};
        x += itemW;
    }
    
    x = 0.0;
    y = itemH;
    
    for (UIImageView *view in self.horizontalLines) {
        view.frame = (CGRect) {0.0, round(y), size.width, 1.0};
        y += itemH;
    }
}


- (void)setStartDate:(NSDate *)date numberOfDays:(NSInteger)noOfDays
{
    if (date) {
        self.startDate = date;
    }
    else {
        self.startDate = nil;
    }
    
    if (noOfDays > 0) {
        self.nofOfDays = noOfDays;
    }
    
    [self udpateDates];
}

- (void)udpateDates
{
    if (!_dateLabels) {
        return;
    }
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:self.nofOfDays];
    NSDate *endDate = (self.startDate) ? [self.calendar dateByAddingComponents:comp toDate:self.startDate options:0] : nil;
    
    for (NSInteger i = 0; i < self.dates.count; i++) {
        ASDate *current = self.dates[i];
        UILabel *label = self.dateLabels[i];
        
        if ([current.date compare:self.today] == NSOrderedAscending ||
            [current.date compare:self.ninetyDay] == NSOrderedDescending || [current.date compare:self.ninetyDay] == NSOrderedSame)
        {
            label.userInteractionEnabled = NO;
            label.textColor = _dateDisabledColor;
            label.backgroundColor = _dateBG;
        }
        else if (current.type == ASDateTypeNext || current.type == ASDateTypePrevious) {
            label.userInteractionEnabled = YES;
            label.textColor = _dateDisabledColor;
            label.backgroundColor = _dateBG;
        }
        else {
            label.userInteractionEnabled = YES;
            label.textColor = _dateColor;
            label.backgroundColor = _dateBG;
        }
        
        if (self.startDate) {
            if ([self.startDate compare:current.date] != NSOrderedDescending &&
                [endDate compare:current.date] == NSOrderedDescending)
            {
                label.backgroundColor = _dateSelectedBG;
                label.textColor = _dateSelectedColor;
            }
        }
    }
}
- (void)dateTapped:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    NSInteger tag = label.tag;
    ASDate *date = self.dates[tag];
    
    if ([_delegate respondsToSelector:@selector(monthController:dateTapped:dateType:)]) {
        [_delegate monthController:self dateTapped:date.date dateType:date.type];
    }
}

@end

@implementation ASDate

@end
