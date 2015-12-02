//
//  SignUpView.m
//  Eyvee
//
//  Created by Varun Kapoor on 17/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "SignUpView.h"
#import "EYConstant.h"
#import "EYMeAfterLoginViewController.h"
#import "EYMeTableViewCell.h"
#import "EYUtility.h"
#import "EYMyOrdersViewController.h"
#import "EYAccountController.h"
#import "EYBagSummaryViewController.h"
#import "EYForgotPasswordVC.h"
#import "EYBadgedBarButtonItem.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYAllAddressVC.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"
#import "EYMeHeaderView.h"
#import "EYUserDetailsVC.h"
#import "AppDelegate.h"
#import "EYOnBoardingViewController.h"
#import "PVToast.h"

@interface SignUpView()<EYAccountControllerDelegate, UIActivityItemSource,EYOnBoardingViewControllerDelegate>

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) EYOnBoardingViewController *onboardingController;

//Arrays For Rows
@property (nonatomic,strong)NSArray *valuesInMeSection;
@property (nonatomic,strong)NSArray *valuesInAboutSection;
@property (nonatomic,strong)NSArray *imagesInMeSection;
@property (nonatomic,strong)NSArray *imagesInAboutSection;
@property (nonatomic, strong) EYBadgedBarButtonItem *rightButton;

- (IBAction)signUptapped:(id)sender;
- (IBAction)loginTapped:(id)sender;

@end

@implementation SignUpView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Account";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName : kBlackTextColor,
                                                                   NSFontAttributeName : AN_MEDIUM(16.0)};
 
   UIImage *image =[ UIImage imageNamed:@"shopping_bag"];
    _rightButton = [[EYBadgedBarButtonItem alloc] initWithImage:image target:self action:@selector(cartButtonClicked:)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
     self.tableView.backgroundColor = kSectionBgColor;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, kTabBarHeight, 0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    
    self.view.backgroundColor = kSectionBgColor;
    
    //Static Arrays
    _valuesInMeSection = [[NSArray alloc]initWithObjects:@"ORDER HISTORY",@"SAVED ADDRESSES",@"SETTINGS",@"CHANGE PASSWORD",@"LOGOUT",nil];
    _valuesInAboutSection = [[NSArray alloc]initWithObjects:@"HOW IT WORKS", @"CONTACT US",@"SEND FEEDBACK",@"SHARE THIS APP",nil];
    _imagesInMeSection = @[@"recent_orders",@"saved_address",@"settings",@"logout",@"logout"];
    _imagesInAboutSection = @[@"how_it_works",@"contact_us",@"send_feedback",@"share"];
    
    //footer view
    _footerView = [[UIView alloc]initWithFrame:CGRectZero];
    _footerView.backgroundColor = kSectionBgColor;
    _footerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _footerLabel.attributedText = [self getAttributedTextForFooterLabel];
    [self.footerView addSubview:_footerLabel];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];
    [self setTableHeaderAndFooterViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)cartButtonClicked:(id)sender
{
    EYBagSummaryViewController *bagSummary = [[EYBagSummaryViewController alloc]initWithNibName:nil bundle:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
    [self.navigationController pushViewController:bagSummary animated:YES];
}

- (void)setTableHeaderAndFooterViews
{
    _isUserLoggedIn = [[EYAccountManager sharedManger] isUserLoggedIn];
    
    if (!_isUserLoggedIn)
    {
        CGRect headerFrame = self.header.frame;
        headerFrame.size.height = 286.0;
        self.header.frame = headerFrame;
        self.header.backgroundColor = [UIColor whiteColor];
        self.tableView.tableHeaderView = self.header;
    }
    else
    {
        CGFloat heightOfProfileView = self.view.frame.size.width*kProfileAspectRatio;
        CGRect headerFrame = (CGRect){0,0,self.view.frame.size.width,heightOfProfileView};
        EYMeHeaderView *profileHeader = [[EYMeHeaderView alloc]initWithFrame:headerFrame];
        [profileHeader setTextForLabel];
        self.tableView.tableHeaderView = profileHeader;
    }
    CGSize size = self.view.bounds.size;
    NSAttributedString *attr = [self getAttributedTextForFooterLabel];
    CGSize sizeOfFooterLabel = [EYUtility sizeForAttributedString:attr width:size.width-2*kProductDescriptionPadding];
    _footerView.frame = (CGRect){0,0,size.width, 12.0 + sizeOfFooterLabel.height + kProductDescriptionPadding};
    
    self.tableView.tableFooterView = _footerView;
    
    _footerLabel.frame = (CGRect){kProductDescriptionPadding, 12.0, sizeOfFooterLabel};
    _footerLabel.numberOfLines = 0;
    
    [self.tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isUserLoggedIn)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_isUserLoggedIn)
    {
        return _valuesInAboutSection.count;
    }
    else
    {
        if (section == 0)
        {
            return _valuesInMeSection.count ;
        }
        else
        {
            return _valuesInAboutSection.count;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
    {
        cell = [[EYMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }

    if (_isUserLoggedIn)
    {
        if (indexPath.section == 0) //Me Section
        {
            cell.rowLabel.text = _valuesInMeSection[indexPath.row];
            cell.leftImage.image = [[UIImage imageNamed:_imagesInMeSection[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        }
        else //About Us Section
        {
            cell.rowLabel.text = _valuesInAboutSection[indexPath.row];
            cell.leftImage.image = [[UIImage imageNamed:_imagesInAboutSection[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
    else
    {
        cell.rowLabel.text = _valuesInAboutSection[indexPath.row];
        cell.leftImage.image = [[UIImage imageNamed:_imagesInAboutSection[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = kSectionBgColor;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectZero];
    lbl.font = AN_BOLD(14.0);
    lbl.textColor = kBlackTextColor;
    [view addSubview:lbl];
    
    if (_isUserLoggedIn)
    {
        if (section == 0)
        {
            view.frame = CGRectMake(0, 0, self.view.frame.size.width, 47.0);
            
           NSString *email = [EYAccountManager sharedManger].loggedInUser.email; //[[NSUserDefaults standardUserDefaults]objectForKey:kUserEmailKey];
            if (email) {
                lbl.text = email;
            }
            else
                lbl.text = @"xyz@email.com";
            lbl.frame = (CGRect){topPaddingInCell,0,self.view.frame.size.width-topPaddingInCell,47.0};
            
        }
        else
        {
            view.frame = CGRectMake(0, 0, self.view.frame.size.width, 47.0);
            lbl.text = @"About";
            lbl.frame = (CGRect){topPaddingInCell,0,self.view.frame.size.width-topPaddingInCell,47.0};
            
        }
        
        return view;
    }
    else
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 59.0);
        lbl.text = @"About";
        CGSize lblSize = lbl.intrinsicContentSize;
        lbl.frame = (CGRect){topPaddingInCell,(view.frame.size.height- 11.0 - lblSize.height),lblSize};
        return view;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isUserLoggedIn)
    {
        return 47.0;
    }
    else
    {
        return 59.0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isUserLoggedIn)
    {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
//                EYMyOrdersViewController *orderVC = [[EYMyOrdersViewController alloc]initWithNibName:nil bundle:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
//                [self.navigationController pushViewController:orderVC animated:YES];
                [[PVToast shared]showToastMessage:@"Disabled For Demo Version"];

            }
            else if (indexPath.row == 1)
            {
//                EYAllAddressVC *allAddress = [[EYAllAddressVC alloc]initWithNibName:nil bundle:nil];
//                allAddress.comingFromMode = comingFromMeMode;
//                [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
//                [self.navigationController pushViewController:allAddress animated:YES];
                [[PVToast shared]showToastMessage:@"Disabled For Demo Version"];

                
            }
            else if (indexPath.row == 2)
            {
                EYUserDetailsVC *userDetailsVC = [EYUtility instantiateViewWithIdentifier:@"EYUserDetailsVC"];
                userDetailsVC.signUpMode = UpdateUserProfile;
                [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
                [self.navigationController pushViewController:userDetailsVC animated:YES];
            }
            else if (indexPath.row == 3){
                EYForgotPasswordVC *forgotPasswordVC = [EYUtility instantiateViewWithIdentifier:@"EYForgotPasswordVC"];
                forgotPasswordVC.passwrdMode = passwordVCModeUpdate;
                [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
                [self.navigationController pushViewController:forgotPasswordVC animated:YES];
            }
            
            else if (indexPath.row == 4) {
                [[[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil] show];
            }
        }
        else
        {
            if (indexPath.row == 0) {
                [self howItWorksTapped];
            }
            else if (indexPath.row == 3) {
               //Share
                [EYUtility shareApp:self];
            }
        }
    }
    else
    {
        if (indexPath.row == 0) {
            [self howItWorksTapped];
        }
        else if (indexPath.row == 3)
        {
            [EYUtility shareApp:self];
        }
    }
    
    
//   else
//   {
//       if (indexPath.section == 0) {
//           switch (indexPath.row) {
//               case 3:
//               {
//                   [[[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil] show];
//               }
//                   break;
//               default:
//                   break;
//           }
//       }
//   }
}

- (void)howItWorksTapped
{
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    _onboardingController = [appd.storyboard instantiateViewControllerWithIdentifier:@"onboarding"];
    _onboardingController.delegate = self;
    _onboardingController.hideLoginAccess = YES;
    //appd.shouldShowOnboarding = NO;
    [self presentViewController:_onboardingController animated:YES completion:^{
    }];
}


#pragma mark - UIAlertViewDelegate -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kUserLoggedInKey];
        [[EYAccountManager sharedManger]userLoggedOut];
        [self setTableHeaderAndFooterViews];
    }
}


#pragma mark - IBActions -
-(IBAction)signUpButtonClicked:(id)sender
{
    _isUserLoggedIn = YES;
    [self.tableView reloadData];
}

-(IBAction)facebookSignUpButtonClicked:(id)sender
{
////    EYMeAfterLoginViewController *meAfterLoginVc = [[EYMeAfterLoginViewController alloc]initWithNibName:nil bundle:nil];
////    [self.navigationController pushViewController:meAfterLoginVc animated:YES];
//    
//    _isUserLoggedIn = YES;
//    [self.tableView reloadData];

}

-(IBAction)emailSignUpButtonClicked:(id)sender
{
    
}

-(NSAttributedString*)getAttributedTextForFooterLabel
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *dict1 = @{NSFontAttributeName : AN_REGULAR(12.0),
                            NSForegroundColorAttributeName : kAppLightGrayColor,
                            NSParagraphStyleAttributeName : style
                            };
    NSDictionary *dict2 = @{NSFontAttributeName : AN_MEDIUM(12.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style
                            };
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Copyright 2015 Eyvee." attributes:dict1];
    [attr appendAttributedString:str];
    str = [[NSAttributedString alloc] initWithString:@"Terms " attributes:dict2];
    [attr appendAttributedString:str];
    str = [[NSAttributedString alloc] initWithString:@"& " attributes:dict1];
    [attr appendAttributedString:str];
    str = [[NSAttributedString alloc] initWithString:@"Privacy Policy" attributes:dict2];
    [attr appendAttributedString:str];
    
    return attr;
}

- (IBAction)signUptapped:(id)sender
{
    EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
    accCont.delegate = self;
    accCont.currentMode = kSignupMode;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
    [self.navigationController pushViewController:accCont animated:YES];
}

- (IBAction)loginTapped:(id)sender
{
    EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
    accCont.delegate = self;
    accCont.currentMode = kLoginMode;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
    [self.navigationController pushViewController:accCont animated:YES];
}

- (void)userSignUpSuccessful
{
    [self setTableHeaderAndFooterViews];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark UIActivityView Controller delegates
-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return @"";
}

-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}

-(NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType
{
    return @"Test";
}

@end
