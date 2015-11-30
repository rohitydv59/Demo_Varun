//
//  EYGridSubcategoryController.h
//  Eyvee
//
//  Created by Neetika Mittal on 12/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVUtilities.h>
#import "EYConstant.h"
#import "ContainerViewController.h"
#import "WishlistSignupViewController.h"
#import "ProductDetailViewController.h"

@class EYProductFilters;
@class EYGridProductController;

typedef enum overlayMode {
    enum_sort,
    enum_wishlist
} overlayMode_Type;

@interface EYGridProductController : UIViewController <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning, ContainerViewControllerDelegate, WishlistSignUpDelegate, ProductDetailViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@property (nonatomic, assign) EYProductCategory productCategory;
@property (nonatomic, strong) NSString* sliderNameReceived;
@property (nonatomic, strong) NSString *sliderValueReceived;
@property (nonatomic, strong) NSArray *subcategoryIdReceived;
@property (nonatomic, strong) NSNumber *sliderType;
@property (nonatomic, strong) NSNumber *bannerIdReceived;
@property (nonatomic, strong) NSNumber *userWishlistId;
@property (nonatomic, strong) NSString *titleForNavigationBar;

//Json

@property (nonatomic, strong) NSString *filePathForData;
@end
