//
//  ASCalendarController.m
//  ASCalendar
//
//  Created by Naman Singhal on 28/10/15.
//  Copyright © 2015 App Street Software Pvt. Ltd. All rights reserved.
//

#import "ASCalendarController.h"
#import "ASMonthViewController.h"
#import "EYConstant.h"

@interface ASCalendarController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, ASMonthViewControllerDelegate>

@property (nonatomic, strong) UIImageView *topBar;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *monthLabel;

@property (nonatomic, strong) UIPageViewController *pgCont;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) UIColor *baseColor;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSInteger numberOfDays;

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation ASCalendarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        self.startDate = nil;
        self.numberOfDays = 4;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.baseColor = kSeparatorColor;
    
    self.topBar = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.topBar.backgroundColor = self.baseColor;
    [self.view addSubview:_topBar];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.leftButton setImage:[UIImage imageNamed:@"arrow_left"]forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor blackColor]];
    [self.leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.rightButton setImage:[UIImage imageNamed:@"calender_right"] forState:UIControlStateNormal];
    [self.rightButton setTintColor:[UIColor blackColor]];
    [self.rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.font = AN_BOLD(12.0);
    self.monthLabel.textColor = kAppLightGrayColor;
    [self.view addSubview:_monthLabel];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.toolbar.translucent = NO;
    self.toolbar.barTintColor = kBlackTextColor;
    [self.view addSubview:_toolbar];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped:)];
    NSDictionary *barButtonAttributes = @{NSFontAttributeName : AN_BOLD(13.0),
                                          NSForegroundColorAttributeName : [UIColor whiteColor]};
    [done setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbar.items = @[flex, done];
    
    self.pgCont = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey : @(1.0)}];
    self.pgCont.dataSource = self;
    self.pgCont.delegate = self;
    self.pgCont.view.backgroundColor = self.baseColor;
    
    NSDate *today = [NSDate date];
    NSDateComponents *todayComp = [_calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];

    ASMonthViewController *monthVC = [self monthControllerForMonth:todayComp.month year:todayComp.year];
    [self.pgCont setViewControllers:@[monthVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pgCont];
    [self.view addSubview:self.pgCont.view];
    [self.pgCont didMoveToParentViewController:self];
    
    [self updateTopBar];
}

- (ASMonthViewController *)monthControllerForMonth:(NSInteger)month year:(NSInteger)year
{
    ASMonthViewController *monthVC = [[ASMonthViewController alloc] initWithMonth:month year:year calendar:self.calendar];
    [monthVC setStartDate:self.startDate numberOfDays:self.numberOfDays];
    monthVC.delegate = self;
    
    monthVC.separatorColor = self.baseColor;
    monthVC.dayTitleBG = [UIColor whiteColor];
    monthVC.dayTitleColor = kBlackTextColor;
    monthVC.dayTitleFont = AN_BOLD(12.0);
    monthVC.dateFont = AN_REGULAR(14.0);
    monthVC.dateColor = kBlackTextColor;
    monthVC.dateBG = kDateBackground;
    monthVC.dateDisabledColor = kAppLightGrayColor;
    monthVC.dateSelectedColor = [UIColor whiteColor];
    monthVC.dateSelectedBG = kBlackTextColor;
    
    return monthVC;
}

- (void)updateTopBar
{
    ASMonthViewController *controller = self.pgCont.viewControllers[0];
    self.monthLabel.text = [[controller monthTitle]uppercaseString];
    self.leftButton.enabled = !controller.isFirstMonth;
    self.rightButton.enabled = !controller.isLastMonth;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;

    float topHeight = 44.0;
    
    self.toolbar.frame = (CGRect) {0.0, 0.0, size.width, topHeight};
    
    self.leftButton.frame = (CGRect) {0.0, topHeight, topHeight, topHeight};
    self.rightButton.frame = (CGRect) {size.width - topHeight, topHeight, topHeight, topHeight};
    self.topBar.frame = (CGRect) {0.0, topHeight, size.width, topHeight};
    self.monthLabel.frame = (CGRect) {topHeight, topHeight, size.width - 2.0 * topHeight, topHeight};
    
    self.pgCont.view.frame = (CGRect) {0.0, topHeight * 2.0, size.width, size.height - topHeight};
}

#pragma mark - User actions

- (void)leftButtonTapped:(id)sender
{
    UIViewController *vc = self.pgCont.viewControllers[0];
    ASMonthViewController *monthVC = [self nexControllerForController:vc index:-1];
    if (!monthVC) {
        return;
    }
    
    __weak typeof (self) weakself = self;
    [self.pgCont setViewControllers:@[monthVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        [weakself updateTopBar];
    }];
}

- (void)rightButtonTapped:(id)sender
{
    UIViewController *vc = self.pgCont.viewControllers[0];
    ASMonthViewController *monthVC = [self nexControllerForController:vc index:1];
    if (!monthVC) {
        return;
    }
    
    __weak typeof (self) weakself = self;
    [self.pgCont setViewControllers:@[monthVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        [weakself updateTopBar];
    }];
}

#pragma mark - Exposed Methods

- (void)setStartDate:(NSDate *)date numberOfDays:(NSInteger)noOfDays
{
    if (date) {
        NSDateComponents *comp = [_calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        self.startDate = [_calendar dateFromComponents:comp];
    }
    else {
        self.startDate = nil;
    }

    if (noOfDays > 0) {
        self.numberOfDays = noOfDays;
    }
    
    for (ASMonthViewController *cont in self.pgCont.viewControllers) {
        [cont setStartDate:self.startDate numberOfDays:self.numberOfDays];
    }
}

#pragma mark - Page controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return [self nexControllerForController:viewController index:-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self nexControllerForController:viewController index:1];
}

- (ASMonthViewController *)nexControllerForController:(UIViewController *)cont index:(NSInteger)index
{
    ASMonthViewController *monthVC = (ASMonthViewController *)cont;
    
    if (index > 0 && monthVC.isLastMonth) {
        return nil;
    }
    
    if (index < 0 && monthVC.isFirstMonth) {
        return nil;
    }
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setMonth:index];
    
    NSDate *firstDate = [self.calendar dateByAddingComponents:comp toDate:monthVC.firstDate options:0];
    comp = [_calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:firstDate];
    
    return [self monthControllerForMonth:comp.month year:comp.year];
}

#pragma mark - Page controller delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self updateTopBar];
}

#pragma mark - Month controller delegate

- (void)monthController:(ASMonthViewController *)vc dateTapped:(NSDate *)date dateType:(ASDateType)type
{
    [self setStartDate:date numberOfDays:0];
    
    if (type == ASDateTypeNext) {
        [self rightButtonTapped:nil];
    }
    else if (type == ASDateTypePrevious) {
        [self leftButtonTapped:nil];
    }

}

- (void)doneButtonTapped:(id)sender
{
    if ([_delegate respondsToSelector:@selector(calendar:didSelectDate:)]) {
        [_delegate calendar:self didSelectDate:self.startDate];
    }
}

@end
