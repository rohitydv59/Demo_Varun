//
//  EYAddToBagViewController.h
//  Eyvee
//
//  Created by Disha Jain on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYGetAllProductsMTLModel.h"

#import "EYAddToBagHeaderView.h"

@class EYAddToBagViewController;

@protocol EYAddToBagViewControllerDelegate <NSObject>

- (void)updateSizeReceivedFromBottomView:(NSString*)buttonValue andButtonTag:(NSInteger)buttonTag;
- (void)updateDateFromAddToBagInFilterVC:(NSDate *)startDate;
- (void)updateRentalPeriodFromAddtoBag:(NSInteger)rentalPeriod;

@end

@interface EYAddToBagViewController : UIViewController

@property (strong, nonatomic) EYAddToBagHeaderView *header;
@property (strong, nonatomic) EYProductsInfo *productModelReceived;

//for selected button size from product detail view controller

@property (strong, nonatomic) NSString *sizeReceived;
@property (nonatomic, assign) NSInteger buttonSizeTagForBottomPopUpView;
@property (nonatomic, strong) NSNumber *productID;
@property (nonatomic, strong) NSString *pinCode;

@property (nonatomic, assign) NSInteger rentalPeriod;
@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic) BOOL comingFromCart;
@property (nonatomic, strong) NSNumber *cartSKUId;

@property (weak,nonatomic)id <EYAddToBagViewControllerDelegate> delegate;

@end
