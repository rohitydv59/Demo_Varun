    //
//  EYAccountController.m
//  Eyvee
//
//  Created by Neetika Mittal on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAccountController.h"
#import "EYCheckoutLoginController.h"
#import "EYCheckoutSignUpController.h"
#import "EYUtility.h"
#import "WPButtonsAlertView.h"
#import "EYReviewOrderVC.h"
#import "EYAllAPICallsManager.h"
#import "EYConstant.h"
#import "EYAllAddressVC.h"
#import "EYShippingAddressMtlModel.h"
#import "EYShippingDetailsViewController.h"
#import "EYSyncCartMtlModel.h"
#import "EYCartModel.h"
#import "EYWebServiceManager.h"
#import "EYError.h"
#import "EYWishlistModel.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"
#import "EYConstant.h"

@interface EYAccountController () <EYCheckoutLoginControllerDelegate, EYCheckoutSignUpControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *lineBelowSignUp;
@property (nonatomic, weak) IBOutlet UIImageView *lineBelowLogin;

@property (weak, nonatomic) IBOutlet UIButton *buttonSignUp;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

@property (weak, nonatomic) IBOutlet UIView *signupView;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (nonatomic, strong) EYCheckoutSignUpController *signUpCont;
@property (nonatomic, strong) EYCheckoutLoginController *loginCont;

- (IBAction)signUpBtnTapped:(id)sender;
- (IBAction)loginBtnTapped:(id)sender;

@end

@implementation EYAccountController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : kBlackTextColor,
                                                                    NSFontAttributeName : AN_MEDIUM(16)};
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    if (_isPresented) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cross_img"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
        self.navigationItem.leftBarButtonItem = backButton;
        self.navigationController.navigationBar.translucent = NO;

    }
    else {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//        self.navigationController.navigationBar.translucent = NO;
    }
    
    if (_currentMode == kLoginMode) {
        [self openLoginController];
    }
    else {
        [self openSignUpController];
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString:@"signup"]) {
        self.signUpCont = (EYCheckoutSignUpController *)[segue destinationViewController];
        self.signUpCont.delegate = self;
    }
    else if ([segueName isEqualToString:@"login"]) {
        self.loginCont = (EYCheckoutLoginController *)[segue destinationViewController];
        self.loginCont.delegate = self;
    }
}

- (void)backBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openSignUpController
{
    [self.loginCont.view endEditing:YES];
    [self.signUpCont.view endEditing:YES];
    
    self.loginView.hidden = YES;
    self.signupView.hidden = NO;
    
    [self.signUpCont reset];
   
    [_buttonSignUp setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    [_buttonLogin setTitleColor:kPlaceholderColor forState:UIControlStateNormal];
    
    self.lineBelowSignUp.hidden = NO;
    self.lineBelowLogin.hidden = YES;
}

- (void)openLoginController
{
    [self.loginCont.view endEditing:YES];
    [self.signUpCont.view endEditing:YES];
    
    self.loginView.hidden = NO;
    self.signupView.hidden = YES;
    
    [self.loginCont reset];
    
    [self.buttonSignUp setTitleColor:kPlaceholderColor forState:UIControlStateNormal];
    [self.buttonLogin setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    
    self.lineBelowSignUp.hidden = YES;
    self.lineBelowLogin.hidden = NO;
}

- (IBAction)signUpBtnTapped:(id)sender
{
    [self openSignUpController];
}

- (IBAction)loginBtnTapped:(id)sender
{
    [self openLoginController];
}

- (void)loginNotSuccessfulWithError:(EYError *)error
{
    [EYUtility showAlertView:error.errorMessage];
}

- (void)signUpSuccessful
{
    [self makeRequiredCalls];
    
}
- (void)loginSuccessful
{
    [self makeRequiredCalls];
}

- (void)makeRequiredCalls
{
    EYCartModel * cartManager = [EYCartModel sharedManager];
    cartManager.cartRequestState = cartRequestNeedToSend;
    [EYUtility showHUDWithTitle:nil];

    [cartManager getCartItemsWithCompletionBlock:^(id responseObject, EYError *error) {
        [EYUtility hideHUD];
        [self updateProductIdsWithCompletionBlock:^(bool success, EYError *error) {
            
            EYWishlistModel *wishlistModel = [EYWishlistModel sharedManager];
            wishlistModel.wishlistRequestState = wishlistRequestNeedToSend;
            [wishlistModel  getWishlistItemsWithCompletionBlock:nil];
            
            [self goToRequiredController];
        }];
    
    }];
    

}

- (void)goToRequiredController
{
    if (_isPresented) {
        if (_delegate && [_delegate respondsToSelector:@selector(userSignInSuccessfulWithAccountController:)]) {
            [_delegate userSignInSuccessfulWithAccountController:self];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(userSignUpSuccessful)]) {
            [_delegate userSignUpSuccessful];
        }
    }
}

- (void)getOrSyncCartWithCompletionBlock:(void(^)(bool success,EYError * error))completionBlock
{
    EYCartModel * cartManager = [EYCartModel sharedManager];
    cartManager.cartRequestState = cartRequestNeedToSend;
    
   // if (cartManager.cartModel.cartProducts.count > 0) {
        
        [EYUtility showHUDWithTitle:nil];
        [self syncCartWithCompletionBlock:^(bool success, EYError *error) {
            
            if (error) {
                [EYUtility hideHUD];
            }
            
            completionBlock(success,error);
            
        }];
}

- (void)updateProductIdsWithCompletionBlock:(void(^)(bool success,EYError * error))completionBlock
{
    [EYUtility showHUDWithTitle:nil];
    [[EYWishlistModel sharedManager] updateProductIdsOfWishlistWithCompletionBlock:^(id responseObject, EYError *error)
     {
         [EYUtility hideHUD];
         if(!error)
         {
             if(completionBlock)
                 completionBlock(YES,nil);
           }
         else
         {
             if(completionBlock)
                 completionBlock(NO,error);
         }
     }];
}

- (void)userSignUpSuccessful
{
    [EYUtility showHUDWithTitle:nil];
    [[EYWebServiceManager manager] setup];

    [[EYAllAPICallsManager sharedManager] getAllUserAddressesRequestWithParameters:nil withRequestPath:kGetAllUserAddressesRequestPath shouldCache:NO withCompletionBlock:^(id responseObject, EYError *error) {
        [EYUtility hideHUD];
        EYAllAddressMtlModel * addressModl = (EYAllAddressMtlModel *)responseObject;
        
        if (addressModl.allAdrresses.count > 0) {
            _cartModel.cartAddress = [addressModl.allAdrresses firstObject];
            EYReviewOrderVC *review = [[EYReviewOrderVC alloc] initWithNibName:nil bundle:nil];
            review.cartModel = _cartModel;
            [self.navigationController pushViewController:review animated:YES];
        }
        else
        {
            EYShippingDetailsViewController *shippingVC = [[EYShippingDetailsViewController alloc]initWithNibName:nil bundle:nil];
            shippingVC.cartModel = _cartModel;
            [self.navigationController pushViewController:shippingVC animated:YES];
        }
        
    }];
    
    [EYUtility showHUDWithTitle:nil];
    [[EYWishlistModel sharedManager] updateProductIdsOfWishlistWithCompletionBlock:^(id responseObject, EYError *error)
    {
        [EYUtility hideHUD];
        if(!error)
        {
            if (responseObject){
                NSLog(@"Recieved wishlist");
            }
            else{
                NSLog(@"No product in wishlist");
            }
        }
        else{
            NSLog(@"Did not got wishlist");
        }
    }];
}

- (void)syncCartWithCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;
{
    EYCartModel * localModel = [EYCartModel sharedManager];
    NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    
    NSString * userId = userIdStr?userIdStr:@"-1";
    NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
    NSString * cookie = [[EYUtility shared] getCookie];
    
    NSDictionary *payload = @{@"userId":userId,@"cartId": cartId,@"cookie":cookie};
    
    [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:@{@"eventId" : @(0)} withRequestPath:kSyncCartRequestPath cache:NO payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if (!error) {
            EYSyncCartMtlModel * model = (EYSyncCartMtlModel *)responseObject;
            if (model.cartProducts.count == localModel.cartModel.cartProducts.count) {
                if(completionBlock)
                    completionBlock(YES,nil);
            }
            else
            {
                if(completionBlock)
                    completionBlock(NO,nil);
            }
        }
        else
        {
            if(completionBlock)
               completionBlock(NO,error);
        }
    }];
}

- (void)openBtnAlert
{
   // [WPButtonsAlertView showErrorInWindow:[[EYUtility shared] getWindow] animated:YES productInfo:self.product];

}

@end
