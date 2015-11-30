//
//  ProductDetailViewController.h
//  eyVee
//
//  Created by Disha Jain on 12/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYAddToBagViewController.h"
#import "EYGetAllProductsMTLModel.h"
#import "ProductDetailHeadersViewController.h"
#import "EYAccountController.h"

@class EYProductCell;
@class ProductDetailViewController;

@protocol ProductDetailViewControllerDelegate <NSObject>
- (void)deletionSuccessfull;
@end

@interface ProductDetailViewController : UIViewController <UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate, ProductDetailHeaderViewControllerDelegate, UIViewControllerTransitioningDelegate, EYAccountControllerDelegate>

@property (strong,nonatomic) ProductDetailHeadersViewController *header;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView * tbView;
@property (strong, nonatomic) EYProductsInfo *productModelReceived;
@property (nonatomic, strong) EYProductCell *selectedCell; // this is for animation
@property (nonatomic, strong) NSString * selectedSmallImagePath;

@property (nonatomic, assign) NSInteger rentalPeriod;
@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, weak) id <ProductDetailViewControllerDelegate> delegate;

@end
