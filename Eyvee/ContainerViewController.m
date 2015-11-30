    //
//  ContainerViewController.m
//  Eyvee
//
//  Created by Varun Kapoor on 14/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "ContainerViewController.h"
#import "FilterViewController.h"
#import "EYUtility.h"
#import "EYFilterDataModel.h"

@interface ContainerViewController ()

@property(nonatomic, weak) IBOutlet UIButton *applyFiltersButton;
@property(nonatomic, weak) IBOutlet UIView * childView;

-(IBAction)applyFiltersButtonClicked:(id)sender;

@property (nonatomic, strong) NSArray *childViewControllersArray;
@property (nonatomic, strong) FilterViewController *fvc;
@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupCloseAndResetButton];
    self.childViewControllersArray = [self getChildViewControllers];
    [self _transitionToChildViewController:[self.childViewControllersArray objectAtIndex:0]];
}

- (void)setupNavigationBar
{
    self.navigationItem.title = @"Filter";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : kBlackTextColor,
                                                                    NSFontAttributeName : AN_MEDIUM(16)};
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)setupCloseAndResetButton
{
    CGSize leftBtnSize = [EYUtility sizeForString:@"Close" font:AN_REGULAR(16)];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(12, 24, leftBtnSize.width + 12, leftBtnSize.height);
    [leftButton setTitle:@"Close" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton.titleLabel setFont:AN_REGULAR(16)];
    [leftButton setTitleColor:kAppGreenColor forState:UIControlStateNormal];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    CGSize rightBtnSize = [EYUtility sizeForString:@"Reset" font:AN_REGULAR(16)];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(self.view.bounds.size.width - (rightBtnSize.width + 20), 24, rightBtnSize.width, rightBtnSize.height);
    [rightButton setTitle:@"Reset" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(resetClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton.titleLabel setFont:AN_REGULAR(16)];
    [rightButton setTitleColor:kAppGreenColor forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBtn;

}

- (void)backClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetClicked:(id)sender
{
    [self.fvc resettingPreferencesFilter];
    [self.appliedFilterModel initialisingFilterModel];
    
    if (_delegate && [self.delegate respondsToSelector:@selector(resettingPageCount)]) {
        [self.delegate resettingPageCount];
    }
    
    if (_delegate && [self.delegate respondsToSelector:@selector(passingNewAppliedFilters:)]) {
        [self.delegate passingNewAppliedFilters:self.appliedFilterModel];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *) getChildViewControllers
{
    NSMutableArray *childViewControllers = [[NSMutableArray alloc] init];
    self.fvc = [EYUtility instantiateViewWithIdentifier:@"FilterViewController"];
    self.fvc.allProductsWithFilterModel = self.allProductsWithFilterModel;
    self.fvc.appliedFilterModel = self.appliedFilterModel;
    [childViewControllers addObject:self.fvc];

    return @[self.fvc];
}


-(IBAction)applyFiltersButtonClicked:(id)sender
{
    if (_delegate && [self.delegate respondsToSelector:@selector(resettingPageCount)])
    {
        [self.delegate resettingPageCount];
    }
    
    if (_delegate && [self.delegate respondsToSelector:@selector(passingNewAppliedFilters:)])
    {
        self.fvc.appliedFilterModel.rentalPeriod = self.fvc.localFiterModel.rentalPeriod;
        self.fvc.appliedFilterModel.startDate = self.fvc.localFiterModel.startDate;
        
        self.fvc.appliedFilterModel.priceRange = [NSMutableDictionary dictionaryWithDictionary:self.fvc.localFiterModel.priceRange];
        self.fvc.appliedFilterModel.occasions = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.occasions];
        self.fvc.appliedFilterModel.sizes = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.sizes];
        self.fvc.appliedFilterModel.colors = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.colors];
        self.fvc.appliedFilterModel.otherFilters = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.otherFilters];
        self.fvc.appliedFilterModel.topDesigners = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.topDesigners];
        
        self.fvc.appliedFilterModel.occasionsIdArray = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.occasionsIdArray];
        self.fvc.appliedFilterModel.sizeIdArray = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.sizeIdArray];
        self.fvc.appliedFilterModel.colorIdArray = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.colorIdArray];
        self.fvc.appliedFilterModel.topDesignerIdArray = [NSMutableArray arrayWithArray:self.fvc.localFiterModel.topDesignerIdArray];
        
        [self.delegate passingNewAppliedFilters:self.fvc.appliedFilterModel];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)_transitionToChildViewController:(UIViewController *)toViewController
{
    UIViewController *fromViewController = ([self.childViewControllers count] > 0 ? self.childViewControllers[0] : nil);
    if (toViewController == fromViewController || ![self isViewLoaded])
    {
        return;
    }
    
    UIView *toView = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame = self.childView.bounds;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self.childView addSubview:toView];
    [fromViewController.view removeFromSuperview];
    [fromViewController removeFromParentViewController];
    [toViewController didMoveToParentViewController:self];
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    for (UIViewController *cont in self.childViewControllersArray)
    {
        cont.view.frame = (CGRect){0, 0, self.childView.frame.size};
    }
}
@end
