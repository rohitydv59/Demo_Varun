//
//  EYAccountController.h
//  Eyvee
//
//  Created by Neetika Mittal on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EYProductInCartInfo;
@class EYSyncCartMtlModel;
@class EYAccountController;

typedef enum {
    kLoginMode,
    kSignupMode
} AccountMode;

@protocol EYAccountControllerDelegate <NSObject>

@optional

- (void)userSignUpSuccessful;
- (void)userSignInSuccessfulWithAccountController:(EYAccountController *)account;

@end

@interface EYAccountController : UIViewController

@property (nonatomic, weak) id <EYAccountControllerDelegate> delegate;
@property (nonatomic, strong) EYProductInCartInfo *product;
@property (nonatomic, strong) EYSyncCartMtlModel * cartModel;
@property (nonatomic) BOOL isPresented;
@property (nonatomic) AccountMode currentMode;

@end
