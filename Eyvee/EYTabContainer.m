//
//  EYTabContainer.h
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYTabContainer.h"
#import "AppDelegate.h"
#import "EYSideMenuController.h"
#import "EYTabbar.h"
#import "EYConstant.h"
#import "EYHomeViewController.h"
#import "EYFavoritesViewController.h"
#import "EYTabButton.h"
#import "EYUtility.h"
#import "SignUpView.h"
#import "EYGridTableViewController.h"
#import "EYGridProductController.h"
#import "EYThankyouViewController.h"
#import "WishlistSignupViewController.h"
#import "EYOnBoardingViewController.h"
#import "EYAccountManager.h"

typedef enum {
    PVContainerModeNone = 0,
    PVContainerModeTabHidden = 1,
    PVContainerModeSideMenu = 2
} PVContainerMode;

@interface EYTabContainer () <UIGestureRecognizerDelegate, UINavigationControllerDelegate, EYOnBoardingViewControllerDelegate>

@property (nonatomic, strong) EYSideMenuController *menuVC;
@property (nonatomic, strong) EYOnBoardingViewController *onboardingController;
@property (nonatomic, strong) EYTabbar *tabView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, assign) BOOL onboardingShown;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) PVContainerMode mode;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePan;

@property (nonatomic, strong) UIControl *customOverlay;
@property (nonatomic, strong) UINavigationController *shareNavVC;

@end

@implementation EYTabContainer

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mode = PVContainerModeNone;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_contentView];
    
    self.tabView = [[EYTabbar alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tabView];
    
    [self initialiseChildViews];
    [self activateIndex:0];
    
    self.overlayView = [[UIControl alloc] initWithFrame:CGRectZero];
    [self.overlayView addTarget:self action:@selector(overlayTouched:) forControlEvents:UIControlEventTouchDown];
    self.overlayView.backgroundColor = kOverlayViewColor;
    
    self.menuVC = [[EYSideMenuController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:self.menuVC];

    [self.view addSubview:_menuVC.view];
    [self.menuVC didMoveToParentViewController:self];
    
    UIScreenEdgePanGestureRecognizer *swipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgeSwipe:)];
    swipeGesture.edges = UIRectEdgeLeft;
    swipeGesture.delegate = self;
    [self.view addGestureRecognizer:swipeGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTab) name:kTabbarShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTab) name:kTabbarHideNotification object:nil];
    
    self.edgePan = swipeGesture;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    if (appd.splashView) {
        [appd.window bringSubviewToFront:appd.splashView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![EYAccountManager sharedManger].isUserLoggedIn && ![EYAccountManager sharedManger].isGuestMode) {
        AppDelegate *appd = [[UIApplication sharedApplication] delegate];
        if (appd.shouldShowOnboarding) {
        _onboardingController = [appd.storyboard instantiateViewControllerWithIdentifier:@"onboarding"];
        _onboardingController.delegate = self;
            self.onboardingShown = YES;
            appd.shouldShowOnboarding = NO;
        [self presentViewController:_onboardingController animated:NO completion:^{
            if (appd.splashView) {
                [appd.splashView removeFromSuperview];
                appd.splashView = nil;
            }
        }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect rect = self.view.bounds;
    self.contentView.frame = rect;
    
    float overlayX = kSideMenuWidth;
    
    CGRect tabFrame = (CGRect) {0.0, rect.size.height - kTabBarHeight, rect.size.width, kTabBarHeight};
    CGRect overlayFrame = (CGRect) {0.0, 0.0, rect.size};
    CGRect sideFrame = (CGRect) {-overlayX, 0.0, overlayX, rect.size.height};
    
    if (_mode == PVContainerModeTabHidden) {
        tabFrame.origin.y += kTabBarHeight + 1.0;
        self.overlayView.alpha = 0.0;
    }
    else if (_mode == PVContainerModeSideMenu) {
        overlayFrame.origin.x += overlayX;
        sideFrame.origin.x += overlayX;
        self.overlayView.alpha = 1.0;
    }
    else {
        self.overlayView.alpha = 0.0;
    }
    
    self.tabView.frame = tabFrame;
    self.menuVC.view.frame = sideFrame;
    self.overlayView.frame = overlayFrame;
    
   
    for (UIView *view in self.contentView.subviews) {
        view.frame = self.contentView.bounds;
    }
}

- (void)initialiseChildViews
{
    self.currentIndex = NSIntegerMin;
    EYHomeViewController *home = [[EYHomeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *homeNC = [[UINavigationController alloc]initWithRootViewController:home];
    homeNC.delegate = self;
    
    EYGridTableViewController *grid = [[EYGridTableViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *gridNC = [[UINavigationController alloc]initWithRootViewController:grid];
    gridNC.delegate = self;
    
    SignUpView *signUp = [EYUtility instantiateViewWithIdentifier:@"SignUpView"];
    UINavigationController *meNC = [[UINavigationController alloc]initWithRootViewController:signUp];
    meNC.delegate = self;
    
    EYGridProductController *fav = [[EYGridProductController alloc] initWithNibName:nil bundle:nil];
    fav.productCategory = GETProductsFromWishlist;
    UINavigationController *favNC = [[UINavigationController alloc]initWithRootViewController:fav];
    favNC.delegate = self;
    
    self.controllers = @[homeNC, gridNC, meNC, favNC];
    
    for (EYTabButton *btn in self.tabView.btns) {
        [btn addTarget:self action:@selector(tabBarButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
}

#pragma mark - User actions

- (void)overlayTouched:(id)sender
{
    [self updateMode:PVContainerModeNone animated:YES];
}

- (void)tabBarButtonTapped:(id)sender
{
    EYTabButton *button = (EYTabButton *)sender;
    [self activateIndex:button.tag];
}

- (void)activateIndex:(NSInteger)index
{
    for (EYTabButton *btn in self.tabView.btns) {
        if (btn.tag == index)
        {
            btn.isBtnSelected = YES;
        }
        else
        {
            btn.isBtnSelected = NO;
        }
    }
    [self setCurrentViewControllerAtIndex:index];
}

#pragma mark - Gestures

- (void)handleEdgeSwipe:(UIScreenEdgePanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self updateMode:PVContainerModeSideMenu animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer != self.edgePan) {
        return NO;
    }
    
    UIViewController *current = (_currentIndex >= 0 && _currentIndex < self.controllers.count - 1) ? self.controllers[_currentIndex] : nil;
    if (current && [current isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nv = (UINavigationController *)current;
        if (nv.childViewControllers.count == 1) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Child controller handling

- (void)setCurrentViewControllerAtIndex:(NSInteger)index
{
    if (index < 0 || index > self.controllers.count - 1) {
        return;
    }
    
    UIViewController *current = (_currentIndex >= 0 && _currentIndex <= self.controllers.count - 1) ? self.controllers[_currentIndex] : nil;

    if (_currentIndex == index) {
        if (current && [current isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nv = (UINavigationController *)current;
            [nv popToRootViewControllerAnimated:YES];
        }
        return;
    }
    if (current)
    {
        [current willMoveToParentViewController:nil];
        [current.view removeFromSuperview];
        [current removeFromParentViewController];
        UINavigationController *nv = (UINavigationController *)current;
        [nv popToRootViewControllerAnimated:YES];
    }
    
    _currentIndex = index;
    
    UIViewController *vc = self.controllers[index];
    
    [self addChildViewController:vc];
    [self.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    [self.view setNeedsLayout];
}

- (void)showTab
{
    if (self.navigationController.childViewControllers.count != 1) {
        [self updateMode:PVContainerModeNone animated:YES];
    }
}

- (void)hideTab
{
    if (self.navigationController.childViewControllers.count != 1) {
        [self updateMode:PVContainerModeTabHidden animated:YES];
    }
}

- (void)updateMode:(PVContainerMode)mode animated:(BOOL)animated
{
    if (_mode == mode) {
        return;
    }
    
    _mode = mode;
    [self.view setNeedsLayout];
    
    if (!animated) {
        return;
    }
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)userLoggedIn
{
    [self activateIndex:0];
}

#pragma mark - EYOnboarding Controller Delegate -
- (void)signInSuccessful
{
    NSLog(@"Signin successful");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpSuccessful
{
    NSLog(@"signup successful");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

