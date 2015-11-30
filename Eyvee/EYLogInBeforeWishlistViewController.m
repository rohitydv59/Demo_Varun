//
//  EYLogInBeforeWishlistViewController.m
//  Eyvee
//
//  Created by Disha Jain on 05/11/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYLogInBeforeWishlistViewController.h"
#import "EYAccountController.h"
#import "EYUtility.h"
@interface EYLogInBeforeWishlistViewController ()<EYAccountControllerDelegate>
- (IBAction)actionWishlistSignUp:(id)sender;
- (IBAction)actionWishlistLogin:(id)sender;

@end

@implementation EYLogInBeforeWishlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionWishlistSignUp:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(buttonSignUpPressed)]) {
        [_delegate buttonSignUpPressed];
    }
    EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
    accCont.delegate = self;
    accCont.currentMode = kSignupMode;
    accCont.isPresented = YES;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:accCont];
    [self presentViewController:nav animated:YES completion:nil];
    
  

}

- (IBAction)actionWishlistLogin:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(buttonLoginPressed)]) {
        [_delegate buttonLoginPressed];
    }

    EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
    accCont.delegate = self;
    accCont.currentMode = kLoginMode;
    accCont.isPresented = YES;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:accCont];
    [self presentViewController:nav animated:YES completion:nil];
    

}


@end
