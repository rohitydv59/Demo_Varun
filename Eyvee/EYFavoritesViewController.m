//
//  EYFavoritesViewController.m
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYFavoritesViewController.h"
#import "FavoriteTableViewCell.h"
#import "EYConstant.h"
#import "FavoriteHeaderView.h"
#import "EYWishlistModel.h"
#import "EYUserWishlistMtlModel.h"
#import "EYAllAPICallsManager.h"
#import "EYGridProductController.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYBadgedBarButtonItem.h"

@interface EYFavoritesViewController()
{
    
}
@property (nonatomic, strong) FavoriteHeaderView *headerView;
@property (nonatomic, strong) EYAllWishlistMtlModel * allWishListModel;
@property (nonatomic, strong) EYBadgedBarButtonItem *rightButton;
@end
@implementation EYFavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Wishlist";

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    UIImage *image =[ UIImage imageNamed:@"shopping_bag"];
    _rightButton = [[EYBadgedBarButtonItem alloc] initWithImage:image target:self action:@selector(actionCart:)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    EYGridProductController *productCont = [[EYGridProductController alloc] initWithNibName:nil bundle:nil];
    productCont.productCategory = GETProductsFromWishlist;
    [self.navigationController pushViewController:productCont animated:YES];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)cartBtnTapped:(id) sender
{
    
}

- (void)actionCart:(id)sender
{
    
}

@end
