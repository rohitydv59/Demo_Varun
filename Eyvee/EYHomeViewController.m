    //
//  EYHomeViewController.m
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYHomeViewController.h"
#import "EYConstant.h"
#import "EYHomeCategoryCell.h"
#import "EYGridProductController.h"
#import "EYUtility.h"
#import "EYAllAPICallsManager.h"
#import "EYBannersMtlModel.h"
#import "EYError.h"
#import "EYCartModel.h"
#import "EYBagSummaryViewController.h"
#import "EYStaticViewController.h"
#import "EYBadgedBarButtonItem.h"
#import "EYWishlistModel.h"
#import "EDLoaderView.h"
#import "EYEmptyView.h"


@interface EYHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, assign) CGSize mainSize;
@property (nonatomic, strong) EYBadgedBarButtonItem *rightButton;
@property (nonatomic, strong) EYEmptyView *emptyView;

@end

@implementation EYHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainSize = [UIScreen mainScreen].bounds.size;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage* logoImage = [UIImage imageNamed:@"logo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName : kBlackTextColor,
                                                                   NSFontAttributeName : AN_MEDIUM(16.0)};
    
    [self.tableView setContentInset:UIEdgeInsetsMake(64.0, 0, kTabBarHeight, 0)];
    self.tableView.scrollIndicatorInsets = (UIEdgeInsets) {64.0, 0.0, kTabBarHeight, 0.0};
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    UIImage *image =[ UIImage imageNamed:@"shopping_bag"];
    
    _rightButton = [[EYBadgedBarButtonItem alloc] initWithImage:image target:self action:@selector(actionCart:)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
#warning NAMAN move these to manager
    
    NSInteger cardId = [[[EYUtility shared] getCartId] integerValue];

    if (cardId > 0) {
        [[EYCartModel sharedManager] getCartItemsWithCompletionBlock:^(id responseObject, EYError *error) {
        }];
    }
    
    EYWishlistModel * wishListModel = [EYWishlistModel sharedManager];
    wishListModel.wishlistRequestState = wishlistRequestNeedToSend;

    [wishListModel getWishlistItemsWithCompletionBlock:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTblView) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.tableHeaderView = [[EDLoaderView alloc] init];
    [self performSelector:@selector(getBannersData) withObject:nil afterDelay:5.0];
    //[self getBannersData];
}

- (void)getBannersData
{
    if (!self.refreshControl.isRefreshing) {
   //     self.tableView.tableHeaderView = [[EDLoaderView alloc] init];
    }
    __weak __typeof(self) weakSelf = self;
    
    [[EYAllAPICallsManager sharedManager]getAllBannersRequestWithParameters:nil withRequestPath:kBannersFilePath shouldCache:YES isPullToRefresh:self.refreshControl.isRefreshing  withCompletionBlock:^(id responseObject, EYError *error)
    {
        [weakSelf processBannersList:responseObject error:error];
    }];
    
    //new code
//    _banners=[[EYAllAPICallsManager sharedManager]getAllBannersJsonWithPath:kBannersFilePath];
//    if (_banners.count > 0)
//        [self.tableView reloadData];


}

- (void)processBannersList:(id)bannersList error:(EYError *)error
{
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    if (bannersList)
    {
        _banners = bannersList;
        self.tableView.tableHeaderView = nil;
    }
    else
    {
        if (_banners.count > 0)
            return;
        self.tableView.tableHeaderView = [self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:YES];
    }
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];
}

#pragma mark - uitableview datasource and delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _banners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"category";
    EYHomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EYHomeCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setcategoryImage:nil];
    
    EYBannersMtlModel *bannerModel = [_banners objectAtIndex:indexPath.row];
    NSString *bannerMainText;

    if ([bannerModel.bannerName rangeOfString:@"AD" options:NSDiacriticInsensitiveSearch].location != NSNotFound) {
        bannerMainText = nil;
    }
    else
        bannerMainText = bannerModel.bannerName;
    
    NSString *bannerSubText = bannerModel.headerText;
    NSString *bannerMiddleText = bannerModel.middleText;
    NSString *bannerBottomText = bannerModel.bottomText;
    NSInteger bannerHeaderFont = [bannerModel.headerFont integerValue ];
    NSInteger bannerMiddleFont = [bannerModel.middleFont integerValue ];
    NSInteger bannerBottomFont = [bannerModel.bottomFont integerValue];
    
    [cell setHeaderTextFont:bannerHeaderFont middleTextFont:bannerMiddleFont bottomTextFont:bannerBottomFont];
    [cell setlabelmainText:bannerMainText headerText:bannerSubText middleText:bannerMiddleText bottomText:bannerBottomText WithVCMode:bannerVC];
    
    NSString *imagePath = nil;

    for (EYProductResizeImages *images in bannerModel.resizedImages)
    {
        if ([EYUtility isDeviceGreaterThanSix])
        {
            if ([images.imageSize isEqualToString:@"medium"])
            {
                imagePath = images.image;
            }
            else
            {
                if ([images.imageSize isEqualToString:@"small"])
                {
                    imagePath = images.image;
                }
            }
        }
        else
        {
            if ([images.imageSize isEqualToString:@"small"])
            {
                imagePath = images.image;
            }
        }
    }
    
    if (!imagePath) {
        imagePath = bannerModel.imageName;
    }
    
    if (!imagePath) {
        [cell setBannerImage:nil];
    }
    else
    {
        NSURL *sliderImageUrl = [NSURL URLWithString:imagePath];
        [cell setBannerImage:sliderImageUrl];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYBannersMtlModel *bannerModel = [_banners objectAtIndex:indexPath.row];
    if ([bannerModel.bannerName rangeOfString:@"AD" options:NSDiacriticInsensitiveSearch].location != NSNotFound)
    {
        return ceil((1*self.view.bounds.size.width)/6);
    }
    return ceil((7*self.view.bounds.size.width)/9);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYBannersMtlModel *banner = [_banners objectAtIndex:indexPath.row];
    if (banner.link.length > 0) {
        EYStaticViewController *vc = [[EYStaticViewController alloc] initWithNibName:nil bundle:nil];
        vc.link = banner.link;
        vc.titleText = banner.bannerName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([banner.bannerName rangeOfString:@"AD" options:NSDiacriticInsensitiveSearch].location == NSNotFound)
    {
        NSNumber *bannerId = banner.bannerId;
        EYGridProductController *productCont = [[EYGridProductController alloc] initWithNibName:nil bundle:nil];
        productCont.productCategory = GetProductsFromBanner;
        productCont.bannerIdReceived = bannerId;
        productCont.filePathForData = banner.bannerProductsFile;
        productCont.titleForNavigationBar = banner.bannerName;
        [self.navigationController pushViewController:productCont animated:YES];
    }
}

- (void)actionCart:(id)sender
{
    EYBagSummaryViewController *bagSummary = [[EYBagSummaryViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:bagSummary animated:YES];
}

- (void)refreshTblView
{
    [self getBannersData];
}


#pragma mark - show empty/error view

- (EYEmptyView *)showEmptyViewWithMessage:(NSString *)messageText withImage:(UIImage *)image andRetryBtnHidden:(BOOL)hidden
{
    if (!self.emptyView){
        self.emptyView = [[EYUtility shared] errorViewWithText:messageText withImage:image andRetryBtnHidden:hidden];
        self.emptyView.frame = CGRectZero;
    }
    return self.emptyView;
}

@end
