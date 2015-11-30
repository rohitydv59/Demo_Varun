//
//  ASCalendarController.h
//  ASCalendar
//
//  Created by Naman Singhal on 28/10/15.
//  Copyright © 2015 App Street Software Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASCalendarController;

@protocol ASCalendarControllerDelegate <NSObject>

- (void)calendar:(ASCalendarController *)cont didSelectDate:(NSDate *)date;

@end

@interface ASCalendarController : UIViewController

- (void)setStartDate:(NSDate *)date numberOfDays:(NSInteger)noOfDays;

@property (nonatomic, weak) id <ASCalendarControllerDelegate> delegate;

@end
