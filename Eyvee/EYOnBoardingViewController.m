//
//  EYOnBoardingViewController.m
//  Eyvee
//
//  Created by Naman Singhal on 28/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYOnBoardingViewController.h"
#import "EYConstant.h"
#import "EYAccountManager.h"
#import "EYAccountController.h"
#import "EYUtility.h"

@interface EYOnBoardingViewController () <UIScrollViewDelegate, EYAccountControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;


@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;
@property (nonatomic, weak) IBOutlet UIButton *getStartedButton;
@property (nonatomic, weak) IBOutlet UIButton *continueButton;
@property (nonatomic, weak) IBOutlet UIButton * signupLaterButton;

@property (nonatomic, weak) IBOutlet UIImageView *imgV1;
@property (nonatomic, weak) IBOutlet UIImageView *imgV2;
@property (nonatomic, weak) IBOutlet UIImageView *imgV3;
@property (nonatomic, weak) IBOutlet UIImageView *imgV4;
@property (nonatomic, weak) IBOutlet UIImageView *imgV5;

@property (nonatomic, weak) IBOutlet UIView *segView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *eyveeLabel;

@property (nonatomic, weak) IBOutlet UIButton *rentButton;
@property (nonatomic, weak) IBOutlet UIButton *wearButton;
@property (nonatomic, weak) IBOutlet UIButton *returnButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *eyveeBottomSpacing;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *segControlCenter;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *underlineWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *underlineX;

@end

@implementation EYOnBoardingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    self.segControlCenter.constant = self.view.bounds.size.width;
    
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.pageIndicatorTintColor = GRAYA(1.0, 0.5);
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    self.getStartedButton.backgroundColor = GRAYA(0.0, 0.4);
    self.getStartedButton.layer.borderColor = GRAYA(1.0, 1.0).CGColor;
    self.getStartedButton.layer.borderWidth = 2.0;
    
    self.continueButton.backgroundColor = GRAYA(0.0, 0.4);
    self.continueButton.layer.borderColor = GRAYA(1.0, 1.0).CGColor;
    self.continueButton.layer.borderWidth = 2.0;
    
    self.loginButton.backgroundColor = GRAYA(0.0, 0.4);
    self.loginButton.layer.borderColor = GRAYA(1.0, 1.0).CGColor;
    self.loginButton.layer.borderWidth = 2.0;
    
    self.signupButton.backgroundColor = kAppGreenColor;
    
    _continueButton.hidden = !_hideLoginAccess;
    _signupButton.hidden = _hideLoginAccess;
    _loginButton.hidden = _hideLoginAccess;
    _signupLaterButton.hidden = _hideLoginAccess;
    
    
    
}
-(void)setUp
{
    self.imgV1.image = [UIImage imageNamed:@"on-1.jpg"];
    self.imgV2.image = [UIImage imageNamed:@"on-2.jpg"];
    self.imgV3.image = [UIImage imageNamed:@"on-3.jpg"];
    self.imgV4.image = [UIImage imageNamed:@"on-4.jpg"];
    self.imgV5.image = [UIImage imageNamed:@"on-5.jpg"];
    
    [self.getStartedButton setTitle:NSLocalizedString(@"get_started_btn", "") forState:UIControlStateNormal];
    [self.getStartedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getStartedButton.titleLabel.font = AN_BOLD(15.0);
    
    self.eyveeLabel.text = NSLocalizedString(@"onboard_main_lbl", "");
    self.eyveeLabel.textColor = [UIColor whiteColor];
    self.eyveeLabel.font = AN_BOLD(48.0);
    
    [self.rentButton setTitle:NSLocalizedString(@"rent_btn","") forState:UIControlStateNormal];
    [self.rentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rentButton.titleLabel.font = AN_BOLD(15.0);
    
    [self.wearButton setTitle:NSLocalizedString(@"wear_btn","") forState:UIControlStateNormal];
    [self.wearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.wearButton.titleLabel.font = AN_BOLD(15.0);
    
    [self.returnButton setTitle:NSLocalizedString(@"return_btn", "") forState:UIControlStateNormal];
    [self.returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.returnButton.titleLabel.font = AN_BOLD(15.0);
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTapped:(id)sender
{
    EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
    accCont.currentMode = kLoginMode;
    accCont.delegate = self;
    accCont.isPresented = YES;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:accCont];
    //navController.navigationBar.barStyle = UIBarStyleDefault;
    //navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)continueButtonTapped:(id)sender
{
    [[EYAccountManager sharedManger] updateUserAccountInfo];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)signupButtonTapped:(id)sender
{
    EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
    accCont.currentMode = kSignupMode;
    accCont.delegate = self;
    accCont.isPresented = YES;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:accCont];
    //navController.navigationBar.barStyle = UIBarStyleDefault;
    //navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)skipButtonTapped:(id)sender
{
    //[[EYAccountManager sharedManger] setGuestMode];
    [[EYAccountManager sharedManger] updateUserAccountInfo];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)getStartedButtonTapped:(id)sender
{
    CGPoint point = self.scrollView.contentOffset;
    float w = self.scrollView.bounds.size.width;
    point.x = w * 1.0;
    
    [self setContentOffset:point];
}

- (IBAction)scrollButtonTapped:(id)sender
{
    CGPoint point = self.scrollView.contentOffset;
    float w = self.scrollView.bounds.size.width;
    
    if (sender == self.rentButton) {
        point.x = w * 1.0;
    }
    else if (sender == self.wearButton) {
        point.x = w * 2.0;
    }
    else if (sender == self.returnButton) {
        point.x = w * 3.0;
    }
    
    [self setContentOffset:point];
}

- (void)setContentOffset:(CGPoint)point
{
    self.view.userInteractionEnabled = NO;
    
    [UIView
     animateWithDuration:0.5 delay:0.0
     usingSpringWithDamping:0.8
     initialSpringVelocity:0.0
     options:UIViewAnimationOptionBeginFromCurrentState
     animations:^{
         self.scrollView.contentOffset = point;
         [self.view layoutIfNeeded];
     }
     completion:^(BOOL finished) {
         self.view.userInteractionEnabled = YES;
     }];
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    float x = point.x / scrollView.bounds.size.width;
    if (x < 0.0) {
        x = 0.0;
    }
    else if (x > 4.0) {
        x = 4.0;
    }
    
    NSInteger pageNum = round(x);
    self.pageControl.currentPage = pageNum;

    float topSpace = MIN(self.headerView.bounds.size.height - self.segView.bounds.size.height, 104.0);
    float minScale = 0.6;
    float buttonMinAlpha = 0.5;
    
    if (x >= 0.0 && x <= 1.0) {
        self.imgV2.alpha = x;
        self.imgV3.alpha = 0.0;
        self.imgV4.alpha = 0.0;
        self.imgV5.alpha = 0.0;
        
        self.segControlCenter.constant = (1.0 - x) * scrollView.bounds.size.width;
        self.eyveeBottomSpacing.constant = topSpace/2.0 * x + 52.0 * (1.0 - x);
        
        float scale = 1.0 - (1.0 - minScale) * x;
        self.eyveeLabel.transform = CGAffineTransformMakeScale(scale, scale);
        
        self.underlineWidth.constant = self.rentButton.bounds.size.width;
        self.underlineX.constant = self.rentButton.frame.origin.x;
        
        self.rentButton.alpha = 1.0;
        self.wearButton.alpha = buttonMinAlpha;
        self.returnButton.alpha = buttonMinAlpha;
    }
    else if (x <= 2.0) {
        self.imgV2.alpha = 1.0;
        self.imgV3.alpha = x - 1.0;
        self.imgV4.alpha = 0.0;
        self.imgV5.alpha = 0.0;
        
        self.segControlCenter.constant = 0.0;
        self.eyveeBottomSpacing.constant = topSpace/2.0;
        self.eyveeLabel.transform = CGAffineTransformMakeScale(minScale, minScale);
        
        self.underlineWidth.constant = self.rentButton.bounds.size.width * (2.0 - x) + self.wearButton.bounds.size.width * (x - 1.0);
        self.underlineX.constant = self.wearButton.frame.origin.x * (x - 1.0) + self.rentButton.frame.origin.x * (2.0 - x);
        
        self.rentButton.alpha = (2.0 - x) + (x - 1.0) * buttonMinAlpha;
        self.wearButton.alpha = (2.0 - x) * buttonMinAlpha + (x - 1.0);
        self.returnButton.alpha = buttonMinAlpha;
    }
    else if (x <= 3.0) {
        self.imgV2.alpha = 1.0;
        self.imgV3.alpha = 1.0;
        self.imgV4.alpha = x - 2.0;
        self.imgV5.alpha = 0.0;
        
        self.segControlCenter.constant = 0.0;
        self.eyveeBottomSpacing.constant = topSpace/2.0;
        self.eyveeLabel.transform = CGAffineTransformMakeScale(minScale, minScale);
        
        self.underlineWidth.constant = self.wearButton.bounds.size.width * (3.0 - x) + self.returnButton.bounds.size.width * (x - 2.0);
        self.underlineX.constant = self.returnButton.frame.origin.x * (x - 2.0) + self.wearButton.frame.origin.x * (3.0 - x);
        
        self.rentButton.alpha = buttonMinAlpha;
        self.wearButton.alpha = (3.0 - x) + (x - 2.0) * buttonMinAlpha;
        self.returnButton.alpha = (3.0 - x) * buttonMinAlpha + (x - 2.0);
    }
    else {
        self.imgV2.alpha = 1.0;
        self.imgV3.alpha = 1.0;
        self.imgV4.alpha = 1.0;
        self.imgV5.alpha = x - 3.0;
        
        self.segControlCenter.constant = (3.0 - x) * scrollView.bounds.size.width;
        self.eyveeBottomSpacing.constant = topSpace/2.0 * (4.0 - x) + 52.0 * (x - 3.0);
        
        float scale = 1.0 - (1.0 - minScale) * (4.0 - x);
        self.eyveeLabel.transform = CGAffineTransformMakeScale(scale, scale);
        
        self.underlineWidth.constant = self.returnButton.bounds.size.width;
        self.underlineX.constant = self.returnButton.frame.origin.x;
        
        self.rentButton.alpha = buttonMinAlpha;
        self.wearButton.alpha = buttonMinAlpha;
        self.returnButton.alpha = 1.0;
    }
}

#pragma mark - EYAccountController delegate -

- (void)userSignUpSuccessful
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
//    if ([_delegate respondsToSelector:@selector(signUpSuccessful)]) {
//        [_delegate signUpSuccessful];
//    }
   // [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userSignInSuccessfulWithAccountController:(EYAccountController *)account
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
//    if ([_delegate respondsToSelector:@selector(signInSuccessful)]) {
//        [_delegate signInSuccessful];
//    }
   // [self dismissViewControllerAnimated:YES completion:nil];
}

@end
