//
//  EYGridSubcategoryController.m
//  Eyvee
//
//  Created by Neetika Mittal on 12/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYGridProductController.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYGridProductHeaderView.h"
#import "ProductDetailViewController.h"
#import "EYProductCell.h"
#import "EYGetAllProductsMTLModel.h"
#import "EYAllAPICallsManager.h"
#import "SortByRelevenceView.h"
#import "EYUIImageViewContentViewAnimation.h"
#import "UIImageView+AFNetworking.h"
#import "DetailPageContentViewController.h"
#import "EYFilterDataModel.h"
#import "EYUserWishlistMtlModel.h"
#import "EYWishlistModel.h"
#import "EYAccountController.h"
#import "EYError.h"
#import "EYBagSummaryViewController.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYBadgedBarButtonItem.h"
#import "WishlistSignupViewController.h"
#import "EDLoaderView.h"
#import "EYEmptyView.h"
#import "EYAccountManager.h"
#import "EYLogInBeforeWishlistViewController.h"

@interface EYGridProductController () <UICollectionViewDataSource, UICollectionViewDelegate, SortByRelevanceViewDelegate,UICollectionViewDelegateFlowLayout, EYWishListActionDelegate,EYAccountControllerDelegate, UIGestureRecognizerDelegate,EYLogInBeforeWishlistViewControllerDelegate>
{
    int overlayMode;
    CGFloat lastTabBarShownOffset,lastScrollOffset;
    NSInteger filterCount;
    NSInteger pageCount;
}

@property (nonatomic, strong) EYGetAllProductsMTLModel *allProductsWithFilterModel;
@property (nonatomic, strong) NSIndexPath *indexPathSelectedToSort;
@property (nonatomic, strong) EYGridProductHeaderView *headerView;
@property (nonatomic, strong) SortByRelevenceView *sortView;
@property (nonatomic, strong) ProductDetailViewController* detailVC;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic ,strong) EYFilterDataModel * appliedFilterModel;
@property (nonatomic ,strong) EYFilterDataModel *filterModel;
@property (nonatomic, strong) EYAllWishlistMtlModel * wishlistModel;
@property (nonatomic, strong) EYProductsInfo *selectedProductInfo;
@property (nonatomic, strong) EYBadgedBarButtonItem *rightButton;
@property (nonatomic, strong) WishlistSignupViewController * wishlistVC ;

@property (nonatomic, strong) EDLoaderView *loader;
@property (nonatomic, strong) NSMutableArray *productsInfoArray;
@property (nonatomic, strong) EYEmptyView *emptyView;
@property (nonatomic, strong) EYLogInBeforeWishlistViewController *wishlistLogInVC;

@end

@implementation EYGridProductController

static NSString * const reuseIdentifier = @"Cell";


#pragma mark - view life cycle -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = (_productCategory == GETProductsFromWishlist) ? @"Wishlist" : [_titleForNavigationBar capitalizedString];
    [self.navigationController setDelegate:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName :kBlackTextColor,
                                                                   NSFontAttributeName : AN_MEDIUM(16.0)};
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    UIImage *image =[ UIImage imageNamed:@"shopping_bag"];
    
    _rightButton = [[EYBadgedBarButtonItem alloc] initWithImage:image target:self action:@selector(actionCart:)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    filterCount = 0;
    _indexPathSelectedToSort = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self setup];
    
    lastTabBarShownOffset = -5.0f;
    lastScrollOffset = -5.0f;
    
    if (_productCategory == GETProductsFromWishlist)
    {
    }
    else {
        pageCount = 0;
        [self getDataWithSortIndex:_indexPathSelectedToSort.row];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.delegate = self;
    [self.navigationController setDelegate:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    if (!self.loader.hidden) {
        [self.loader setHidden:NO];
    }
    
    [self.collectionView reloadData];
    
    if (_productCategory == GETProductsFromWishlist)
    {
        if ([[EYAccountManager sharedManger] isUserLoggedIn] == NO)
        {
            if (!_wishlistVC) {
                self.wishlistVC = [EYUtility instantiateViewWithIdentifier:@"WishlistSignup"];
                [self.wishlistVC setDelegate:self];
                [self addChildViewController:self.wishlistVC];
                [self.view addSubview:self.wishlistVC.view];
                [self.wishlistVC didMoveToParentViewController:self];
            }
            return;
        }
        else
        {
            if (_wishlistVC)
            {
                [self.wishlistVC willMoveToParentViewController:nil];
                [self.wishlistVC.view removeFromSuperview];
                [self.wishlistVC removeFromParentViewController];
                self.wishlistVC = nil;
            }
            [self gettingWishlist];
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setDelegate:NULL];
    self.navigationController.interactivePopGestureRecognizer.delegate = NULL;
    
    self.collectionView.delegate = nil;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect rect = self.view.bounds;
    CGFloat topY = 64.0;
    
    if (self.wishlistVC)
    {
        [self.wishlistVC.view setFrame:CGRectMake(0, topY, rect.size.width, rect.size.height - topY)];
    }
    
    if (_productCategory != GETProductsFromWishlist)
    {
        self.headerView.frame = (CGRect) {0.0, topY , rect.size.width, kTabBarHeight};
        topY += kTabBarHeight;
    }
    
    self.collectionView.frame = (CGRect) {0.0, topY, rect.size.width, rect.size.height - topY};
    self.emptyView.frame = self.collectionView.frame;
    
    self.loader.frame = (CGRect) {0.0, topY, rect.size.width, self.loader.bounds.size.height};
}


#pragma mark - wishlist message -
- (void)gettingWishlist
{
    if (_productCategory != GETProductsFromWishlist)
    {
        return;
    }
    
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
    
    _productsInfoArray = nil;
    
    __weak typeof (self) weakself = self;

    EYWishlistModel * model = [EYWishlistModel sharedManager];
    
    if (model.wishlistRequestState == wishlistRequestInProcess || model.wishlistRequestState == wishlistRequestError || model.wishlistRequestState == wishlistRequestNeedToSend) {
        self.loader.hidden = NO;
        [weakself processWishListResponse:nil withError:nil];

//        [[EYWishlistModel sharedManager] getWishlistItemsWithCompletionBlock:^(id responseObject, EYError *error) {
//            self.loader.hidden = YES;
//            [weakself processWishListResponse:responseObject withError:error];
//        }];
    }
    else
    {
        self.loader.hidden = YES;
        [self processWishListResponse:model.allProductsInWishlist withError:nil];
    }
}

- (void)getDataWithSortIndex:(NSInteger)index
{
    _productsInfoArray = nil;
    [self.collectionView reloadData];
    
    self.loader.hidden = NO;

    [self.headerView setUserInteractionEnabled:NO];
    if (_productCategory == GetProductsFromSlider || _productCategory == GetProductsFromBanner)
    {
        NSDictionary *filters = @{};
        NSMutableArray * arrayOfAppliedFilters = [self creatingDictForFilters:self.appliedFilterModel];
        if (_sliderNameReceived && _sliderValueReceived && _subcategoryIdReceived) {
            
            NSString *sliderTypeStr = @"Category";
            switch ([_sliderType integerValue]) {
                case 1:
                    sliderTypeStr = @"Recently Viewed";
                    break;
                case 2:
                    sliderTypeStr = @"Trending Now";
                    break;
                case 3:
                    sliderTypeStr = @"Most Popular";
                    break;
                case 4:
                    sliderTypeStr = @"Tags";
                    break;
                case 5:
                    sliderTypeStr = @"Designer";
                    break;
                case 7:
                    sliderTypeStr = @"Occasion";
                    break;
                default:
                    sliderTypeStr = @"Category";
                    break;
            }
            
            NSDictionary *dict = @{@"filterType": sliderTypeStr,
                                   @"name": _sliderNameReceived,
                                   @"id": _sliderValueReceived,
                                   @"valueIds": _subcategoryIdReceived};

            [arrayOfAppliedFilters addObject:dict];
            filters = @{@"sortingType": @(index)};
        }
        else if (_bannerIdReceived) {
            filters = @{@"bannerId" : _bannerIdReceived,
                        @"sortingType": @(index)};
        }
        else {
            
        }
        __weak typeof (self)weakSelf = self;

        NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)pageCount];
        NSString *requestPath = kGetAllProductsRequestPath(pageStr);

        [[EYAllAPICallsManager sharedManager] getAllProductsWithCustomFilters:nil requestPath:_filePathForData shouldCache:NO payload:arrayOfAppliedFilters withCompletionBlock:^(id responseObject, EYError *error)
         {
             [weakSelf processAllProductsWithCustomFilterResponse:responseObject withError:error withArrayOfAppliedFilters:arrayOfAppliedFilters];
         }];
    }
    else if(_productCategory == GETProductsFromWishlist)                                                             //wishlist
    {
        
    }
}

- (void)setup
{
    if (!(_productCategory == GETProductsFromWishlist))
    {
        self.headerView = [[EYGridProductHeaderView alloc] initWithFrame:CGRectZero];
        [self.headerView setUserInteractionEnabled:NO];
        [self.headerView.leftBtn addTarget:self action:@selector(filterBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView.rightBtn addTarget:self action:@selector(sortBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_headerView];
    }
    else
    {
        self.headerView = nil;
        self.navigationItem.title = @"Wishlist";
    }
    
    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    aFlowLayout.minimumInteritemSpacing = kGutterSpace;
    aFlowLayout.minimumLineSpacing = kGutterSpace;
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:aFlowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    if (_productCategory == GETProductsFromWishlist) {
        [self.collectionView setContentInset:(UIEdgeInsets) {5.0, 0.0, kTabBarHeight + 5, 0.0}];
        [self.collectionView setScrollIndicatorInsets:(UIEdgeInsets) {0.0, 0.0, kTabBarHeight, 0.0}];
    }
    else {
        [self.collectionView setContentInset:(UIEdgeInsets) {5.0, 0.0, 5, 0.0}];
    }
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[EYProductCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.loader = [[EDLoaderView alloc] init];
    self.loader.hidden = YES;
    [self.view addSubview:_loader];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_productCategory == GETProductsFromWishlist) {
        return;
    }
    
    float currentOffset = scrollView.contentOffset.y;
    CGFloat maxOffset = scrollView.contentSize.height - (self.view.frame.size.height - 64.0 - kTabBarHeight);
    
    if (currentOffset < -5.0) {
        
    }
    else if (currentOffset > lastScrollOffset) {
        
        if (currentOffset > maxOffset) {
            
        }
        else if (currentOffset < lastTabBarShownOffset + 20.0) {
            
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
            self.collectionView.contentInset = UIEdgeInsetsMake(5.0, 0, 5.0, 0);
        }
    }
    else
    {
        if (currentOffset < maxOffset)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];
            lastTabBarShownOffset = currentOffset;
            self.collectionView.contentInset = UIEdgeInsetsMake(5.0, 0, 5.0+kTabBarHeight, 0);
        }
    }
    lastScrollOffset = currentOffset;
}

-(void) resettingPageCount
{
    pageCount = 0;
}

- (void)passingNewAppliedFilters:(EYFilterDataModel *)applyfilterModel
{
    if (self.emptyView)
    {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
    
    self.appliedFilterModel = applyfilterModel;
    [self getDataWithSortIndex:_indexPathSelectedToSort.row];
    if (filterCount > 0)
    {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%ld)",(long)filterCount] attributes:@{NSForegroundColorAttributeName : kBlackTextColor}];
        NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:@"Filter " attributes:@{NSForegroundColorAttributeName : kBlackTextColor}];
        [str1 appendAttributedString:str];
        [self.headerView updateLeftButtonTitle:str1 rightButtonTitle:@"Sort"];
    }
    else
    {
        NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:@"Filter" attributes:@{NSForegroundColorAttributeName : kBlackTextColor}];
        [self.headerView updateLeftButtonTitle:str1 rightButtonTitle:@"Sort"];
    }
}

- (void)signUpSuccessfullFromWishlist
{
    EYWishlistModel * model = [EYWishlistModel sharedManager];
    model.wishlistRequestState = wishlistRequestNeedToSend;
    [self.wishlistVC.navigationController popToRootViewControllerAnimated:YES];
    [self.wishlistVC willMoveToParentViewController:nil];
    [self.wishlistVC.view removeFromSuperview];
    [self.wishlistVC removeFromParentViewController];
    self.wishlistVC = nil;
}

- (NSMutableArray *)creatingDictForFilters:(EYFilterDataModel *)applyfilterModel
{
    filterCount = 0;
    NSMutableArray * finalFilterArray = [[NSMutableArray alloc] init];
    NSMutableArray * sectionNameArray = [[NSMutableArray alloc] init];
    
    if (!applyfilterModel) {
        return finalFilterArray;
    }
    
    // for deliveryDate
    if (applyfilterModel.startDate)
    {
        NSString * startDate = [[EYUtility shared] getStringFromDate:applyfilterModel.startDate];
        NSDate *end = [[EYUtility shared] dateByAddingDays:applyfilterModel.rentalPeriod toDate:applyfilterModel.startDate];
        NSString * endDate = [[EYUtility shared]getStringFromDate:end];
        
        NSMutableDictionary * dict1 = [[NSMutableDictionary alloc] init];
        NSArray * dateArray = @[startDate , endDate];
        [dict1 setObject:@"rentaldates" forKey:@"filterType"];
        [dict1 setObject:@"rentaldates" forKey:@"name"];
        [dict1 setObject:@"-1" forKey:@"id"];
        [dict1 setObject:dateArray forKey:@"values"];
        [finalFilterArray addObject:dict1];
        filterCount++;
    }
    for (EYProductFilters * filter in self.allProductsWithFilterModel.productsFilters)
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        if (applyfilterModel.rentalPeriod == 4)
        {
            if ([filter.filterType isEqualToString:kFourDayType])
            {
                [dict setObject:filter.filterType forKey:@"filterType"];
                [dict setObject:filter.name forKey:@"name"];
                [dict setObject:filter.filterId forKey:@"id"];
                float minValueSelected = ((NSString *)[applyfilterModel.priceRange objectForKey:@"selectedMinValue"]).floatValue;
                float maxValueSelected = ((NSString *)[applyfilterModel.priceRange objectForKey:@"selectedMaxValue"]).floatValue;
                
                [dict setObject:[applyfilterModel.priceRange objectForKey:@"selectedMinValue"]forKey:@"minVal"];
                [dict setObject:[applyfilterModel.priceRange objectForKey:@"selectedMaxValue"] forKey:@"maxVal"];
                [finalFilterArray addObject:dict];
                
                if (minValueSelected != filter.minVal.floatValue || maxValueSelected != filter.maxVal.floatValue)
                {
                    filterCount++;
                }
            }
        }
        if (applyfilterModel.rentalPeriod == 8)
        {
            if ([filter.filterType isEqualToString:kEightDayType])
            {
                [dict setObject:filter.filterType forKey:@"filterType"];
                [dict setObject:filter.name forKey:@"name"];
                [dict setObject:filter.filterId forKey:@"id"];
                [dict setObject:[applyfilterModel.priceRange objectForKey:@"selectedMinValue"]forKey:@"minVal"];
                [dict setObject:[applyfilterModel.priceRange objectForKey:@"selectedMaxValue"] forKey:@"maxVal"];
                [finalFilterArray addObject:dict];
                filterCount++;
                float minValueSelected = ((NSString *)[applyfilterModel.priceRange objectForKey:@"selectedMinValue"]).floatValue;
                float maxValueSelected = ((NSString *)[applyfilterModel.priceRange objectForKey:@"selectedMaxValue"]).floatValue;
                
                if (minValueSelected != filter.minVal.floatValue || maxValueSelected != filter.maxVal.floatValue)
                {
                    filterCount++;
                }
            }
        }
        if ([filter.filterType isEqualToString:kOccasionType])
        {
            if (applyfilterModel.occasionsIdArray.count > 0)
            {
                [dict setObject:filter.filterType forKey:@"filterType"];
                [dict setObject:filter.name forKey:@"name"];
                [dict setObject:filter.filterId forKey:@"id"];
                [dict setObject:applyfilterModel.occasionsIdArray forKey:@"valueIds"];
                [finalFilterArray addObject:dict];
                filterCount++;
                
            }
        }
        if ([filter.filterType isEqualToString:kAttributeType])
        {
            if ([filter.name isEqualToString:@"Size"])
            {
                if (applyfilterModel.sizeIdArray.count > 0)
                {
                    [dict setObject:filter.filterType forKey:@"filterType"];
                    [dict setObject:filter.name forKey:@"name"];
                    [dict setObject:filter.filterId forKey:@"id"];
                    [dict setObject:applyfilterModel.sizeIdArray forKey:@"valueIds"];
                    [finalFilterArray addObject:dict];
                    filterCount++;
                }
            }
            else if ([filter.name isEqualToString:@"Color"])
            {
                if (applyfilterModel.colorIdArray.count > 0)
                {
                    [dict setObject:filter.filterType forKey:@"filterType"];
                    [dict setObject:filter.name forKey:@"name"];
                    [dict setObject:filter.filterId forKey:@"id"];
                    [dict setObject:applyfilterModel.colorIdArray forKey:@"valueIds"];
                    [finalFilterArray addObject:dict];
                    filterCount++;
                }
            }
            else
            {
                for (NSMutableDictionary * otherDict in applyfilterModel.otherFilters)
                {
                    NSString * sectionName = (NSString *)[otherDict objectForKey:@"sectionName"];
                    if ([sectionName isEqualToString:filter.name])
                    {
                        [dict setObject:filter.filterType forKey:@"filterType"];
                        [dict setObject:filter.name forKey:@"name"];
                        [dict setObject:filter.filterId forKey:@"id"];
                        [dict setObject:[otherDict objectForKey:@"valueIdArray"] forKey:@"valueIds"];
                        [finalFilterArray addObject:dict];
                        filterCount++;
                        
                    }
                }
                for (NSString * secName in sectionNameArray)
                {
                    if ([filter.name isEqualToString:secName])
                    {
                        
                    }
                }
            }
        }
        if ([filter.filterType isEqualToString:kDesignerType])
        {
            if (applyfilterModel.allDesignerIdArray.count > 0 || applyfilterModel.topDesignerIdArray.count > 0)
            {
                NSMutableArray * designerArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < applyfilterModel.allDesignerIdArray.count; i++)
                {
                    [designerArray addObject:[applyfilterModel.allDesignerIdArray objectAtIndex:i]];
                }
                for (int i = 0; i < applyfilterModel.topDesignerIdArray.count; i++)
                {
                    if (![designerArray containsObject:[applyfilterModel.topDesignerIdArray objectAtIndex:i]])
                    {
                        [designerArray addObject:[applyfilterModel.topDesignerIdArray objectAtIndex:i]];
                    }
                }
                [dict setObject:filter.filterType forKey:@"filterType"];
                [dict setObject:filter.name forKey:@"name"];
                [dict setObject:filter.filterId forKey:@"id"];
                [dict setObject:designerArray forKey:@"valueIds"];
                [finalFilterArray addObject:dict];
                filterCount++;
                
            }
        }
    }
    return finalFilterArray;
}

#pragma mark - productDetailView controllerDelegate

-(void) deletionSuccessfull
{
    if (_productCategory == GETProductsFromWishlist)
    {
        if (self.detailVC)
        {
            [self.detailVC.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _productsInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EYProductsInfo *productModel = [_productsInfoArray objectAtIndex:indexPath.row];
    
    EYProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.product = productModel;
    cell.productImgView.image = nil;
    
    [cell.favBtn setTag:indexPath.row];
    EYGetAllProductsMTLModel *allProducts = [[EYWishlistModel sharedManager] getWishlistLocally];
    NSMutableArray *temparr = [[NSMutableArray alloc] init];
    for (EYProductsInfo * info in allProducts.productsInfo)
    {
        [temparr addObject:info.productId];
    }
    NSArray * selectedFavCellIdsArray = [[EYWishlistModel sharedManager] getWishlistProductIdsLocally];
    //[EYWishlistModel sharedManager].productIdsArray;
    if ([selectedFavCellIdsArray containsObject:productModel.productId])
    {
        [cell.favBtn setSelected:true];
    }
    else
        [cell.favBtn setSelected:false];
    
    
    for (EYProductResizeImages * productResizeImage in productModel.productResizeImages)
    {
        if ([EYUtility isDeviceGreaterThanSix])                               // for 6+
        {
            if ([productResizeImage.imageTag isEqual:@"front"] && [productResizeImage.imageSize isEqual:@"medium"])
            {
                NSString *imagePath = productResizeImage.image;
                [cell setProductImage:imagePath];
            }
        }
        else
        {
            if ([productResizeImage.imageTag isEqual:@"front"] && [productResizeImage.imageSize isEqual:@"small"])
            {
                NSString *imagePath = productResizeImage.image;
                [cell setProductImage:imagePath];
            }
        }
    }
    
    NSString *brandName = productModel.brandName;
    NSNumber *originalPrice = productModel.originalPrice;
    NSNumber *FourdayPrice = productModel.fourDayRentalPrice ;
    
    [cell setProductPrices:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[FourdayPrice floatValue ]]] retailPrice:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[originalPrice floatValue]]]];
    cell.productName.text = brandName;
    
    BOOL cellPosition;
    if (indexPath.row%2 == 0)
    {
        cellPosition = YES;
        cell.cellPositionR=cellPosition;
    }
    else
    {
        cellPosition = NO;
        cell.cellPositionR = cellPosition;
    }
    
    return cell;
}

- (void)addingIntoWishlist:(EYProductsInfo *)product
{
    NSMutableArray *allProductsArray ;
    EYGetAllProductsMTLModel *allProducts = [[EYWishlistModel sharedManager] getWishlistLocally];
    if (allProducts) 
    {
        NSArray * productIdArr = [[EYWishlistModel sharedManager] getWishlistProductIdsLocally];
        NSMutableArray * newProductInfoArray = [[NSMutableArray alloc] init];
        
        {
            for (EYProductsInfo * info in allProducts.productsInfo)
            {
                if ([productIdArr containsObject:info.productId])
                {
                    [newProductInfoArray addObject:info];
                }
            }
            
        }
        
        allProducts.productsInfo = newProductInfoArray;
        allProductsArray = [allProducts.productsInfo mutableCopy];
    }
    else
    {
        allProducts = [[EYGetAllProductsMTLModel alloc]init];
        allProductsArray = [[NSMutableArray alloc] init];
    }
    
    [allProductsArray addObject:product];
    allProducts.productsInfo = [allProductsArray mutableCopy];
    [[EYWishlistModel sharedManager] saveWishListLocally:allProducts];
    
    NSMutableArray * tempArr = [[[EYWishlistModel sharedManager] getWishlistProductIdsLocally] mutableCopy];
    if (tempArr.count <= 0)
    {
        tempArr = [[NSMutableArray alloc] init];
    }
    for (EYProductsInfo * info in allProducts.productsInfo)
    {
        [tempArr addObject:info.productId];
    }
    if (tempArr.count > 0)
    {
        [EYWishlistModel sharedManager].productIdsArray = tempArr;
    }
    [[EYWishlistModel sharedManager] saveWishListProductIdsLocally:tempArr];
    
    [_collectionView reloadData];
}

- (void)deletingFromWishlist:(EYProductsInfo *)product
{
    [EYUtility showHUDWithTitle:@"Deleting"];
    
    __weak typeof (self) weakSelf = self;
//    [[EYAllAPICallsManager sharedManager] deleteProductsFromWishlistWithParameters:@{@"productId":product.productId} withRequestPath:kRemoveSingleProductFromWishlistRequestPath cache:NO withCompletionBlock:^(BOOL responseSuccess, EYError *error)
     {
         [weakSelf processDeleteProductsFromWishlist:nil withError:nil andProduct:product];
     };
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailVC = [[ProductDetailViewController alloc]initWithNibName:nil bundle:nil];
    
    EYProductsInfo *productModel = [_productsInfoArray objectAtIndex:indexPath.row];
    self.detailVC.productModelReceived = productModel;
    self.selectedIndexPath = indexPath;
    self.detailVC.rentalPeriod = self.appliedFilterModel.rentalPeriod;
    self.detailVC.startDate = self.appliedFilterModel.startDate;
    [self.detailVC setDelegate:self];
    
    self.detailVC.selectedCell = (EYProductCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    for (EYProductResizeImages * productResizeImage in productModel.productResizeImages)
    {
        if ([EYUtility isDeviceGreaterThanSix])                          // for 6+
        {
            if ([productResizeImage.imageTag isEqual:@"front"] && [productResizeImage.imageSize isEqual:@"medium"])
            {
                self.detailVC.selectedSmallImagePath = productResizeImage.image;
            }
        }
        else
        {
            if ([productResizeImage.imageTag isEqual:@"front"] && [productResizeImage.imageSize isEqual:@"small"])
            {
                self.detailVC.selectedSmallImagePath = productResizeImage.image;
            }
        }
    }
    
    [self.navigationController pushViewController:_detailVC animated:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        if ([toVC isKindOfClass:[ProductDetailViewController class]] && [fromVC isKindOfClass:[EYGridProductController class]] )
        {
            return self.detailVC;
        }
        return nil;
    }
    if (operation == UINavigationControllerOperationPop)
    {
        if ([toVC isKindOfClass:[EYGridProductController class]])
        {
            return self;
        }
        return nil;
    }
    return nil;
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (_productCategory != GETProductsFromWishlist ) {
//        if (indexPath.row  == _productsInfoArray.count-1)
//        {
//            [self getNextDataWithSortIndex:_indexPathSelectedToSort.row];
//        }
//    }
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES ;
}

#pragma mark uiviewAnimationDelegate

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ProductDetailViewController *fromViewController = (ProductDetailViewController *) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EYGridProductController *toViewController = (EYGridProductController *) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [containerView setBackgroundColor:[UIColor whiteColor]];
    UIPageViewController * pageViewController = fromViewController.header.pageViewController;
    NSArray * arrr = [pageViewController viewControllers];
    
    DetailPageContentViewController * dtObj = [arrr objectAtIndex:0];
    UIImageView *imageView = dtObj.headerImageView;
    CGRect headerRectFrame = imageView .frame;
    
    CGRect headerRectInSuperView = [fromViewController.tbView convertRect:headerRectFrame toView:[fromViewController.tbView superview]];
    EYUIImageViewContentViewAnimation *cellImageSnapshot = [[EYUIImageViewContentViewAnimation alloc] initWithFrame:headerRectInSuperView withImageViewFrame:headerRectFrame];
    
    [cellImageSnapshot setBackgroundColor:[UIColor whiteColor]];
    cellImageSnapshot.image = imageView.image;
    imageView.hidden = YES;
    [containerView addSubview:cellImageSnapshot];
    
    CGRect selectedCellFrameInSuperview = [self.collectionView convertRect:fromViewController.selectedCell.frame toView:[self.collectionView superview]];       //getting cell frame wrt superview
    
    CGRect selectedCellImageviewInSuperview = CGRectMake(selectedCellFrameInSuperview.origin.x + fromViewController.selectedCell.productImgView.frame.origin.x, selectedCellFrameInSuperview.origin.y + fromViewController.selectedCell.productImgView.frame.origin.y, fromViewController.selectedCell.productImgView.frame.size.width, fromViewController.selectedCell.productImgView.frame.size.height);
    
    UIImageView *tempImgView;
    tempImgView = [[UIImageView alloc] initWithFrame:selectedCellImageviewInSuperview];
    
    [tempImgView setBackgroundColor:[UIColor whiteColor]];
    [toViewController.view addSubview:tempImgView];
    [containerView addSubview:cellImageSnapshot];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromViewController.view.alpha = 0.0;
        cellImageSnapshot.frame = selectedCellImageviewInSuperview;
    } completion:^(BOOL finished)
     {
         [tempImgView removeFromSuperview];
         [cellImageSnapshot removeFromSuperview];
         imageView.hidden = NO;
         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
         
     }];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.view.frame.size.width/2-kGutterSpace/2;
    CGFloat h = [EYProductCell heightForWidth:w];
    return CGSizeMake(w, h);
}

#pragma mark - user actions

- (void)actionCart:(id)sender
{
    EYBagSummaryViewController *bagSummary = [[EYBagSummaryViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:bagSummary animated:YES];
}

- (void)filterBtnTapped:(id)sender
{
    ContainerViewController *container = [EYUtility instantiateViewWithIdentifier:@"ContainerViewController"];
    container.appliedFilterModel = self.appliedFilterModel;
    container.allProductsWithFilterModel = self.allProductsWithFilterModel;
    
    [container setDelegate:self];
    
    UINavigationController *navCont = [[UINavigationController alloc]initWithRootViewController:container];
    [self presentViewController:navCont animated:YES completion:nil];
}

- (void)sortBtnTapped:(id)sender
{
    if (self.sortView || self.overlay)
    {
        [self.sortView removeFromSuperview];
        self.sortView = nil;
        [self.overlay removeFromSuperview];
        self.overlay = nil;
        self.headerView.leftBtn.userInteractionEnabled = YES;
        self.headerView.boldSeparatorLine.hidden = YES;
    }
    else
    {
        self.headerView.leftBtn.userInteractionEnabled = NO;
        overlayMode = enum_sort;
        [self creatingOverlay:CGRectMake(0, 64+49.0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        CGFloat lineW = 1.0;
        CGFloat w = self.view.bounds.size.width/2;
        
        _sortView = [[SortByRelevenceView alloc]initWithFrame:CGRectMake(w+lineW, CGRectGetMaxY(self.headerView.frame), w-lineW, 44*3.0)];
        [self.view addSubview:_sortView];
        
        _sortView.indexPathSelected = _indexPathSelectedToSort;
        _sortView.delegate = self;
        self.headerView.boldSeparatorLine.hidden = NO;
    }
}

- (void)creatingOverlay:(CGRect)rect
{
    self.overlay = [[UIView alloc] initWithFrame:rect];
    self.overlay.backgroundColor = [UIColor grayColor];
    self.overlay.userInteractionEnabled = YES;
    
    if (overlayMode == enum_sort)                                              //sortBtn
    {
        [self.view addSubview:_overlay];
        self.overlay.alpha = 1.0;
        self.overlay.backgroundColor = [UIColor clearColor];
    }
    
    UITapGestureRecognizer *tapOnOverlay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnOverlay:)];
    [self.overlay addGestureRecognizer:tapOnOverlay];
    
    UIPanGestureRecognizer *panOnOverlay = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnOverlay:)];
    [self.overlay addGestureRecognizer:panOnOverlay];
}

- (void)panOnOverlay:(id)sender
{
    if (self.overlay)
    {
        [self.overlay removeFromSuperview];
        self.overlay = nil;
    }
    if (overlayMode == enum_sort)
    {
        if (self.sortView)
        {
            [_sortView removeFromSuperview];
            self.sortView = nil;
        }
        self.headerView.leftBtn.userInteractionEnabled = YES;
        self.headerView.boldSeparatorLine.hidden = YES;
    }
}

- (void)tapOnOverlay:(id)sender
{
    if (self.overlay)
    {
        [self.overlay removeFromSuperview];
        self.overlay = nil;
    }
    if (overlayMode == enum_sort)
    {
        if (self.sortView)
        {
            [_sortView removeFromSuperview];
            self.sortView = nil;
        }
        self.headerView.leftBtn.userInteractionEnabled = YES;
        self.headerView.boldSeparatorLine.hidden = YES;
    }
}

- (void)doneBtnTapped:(id)sender
{
    
}

#pragma mark Sort By Relevance view Delegate methods

- (void)tableRowSelectedWithIndex:(NSInteger)index andValue:(NSString *)value
{
    self.indexPathSelectedToSort = [NSIndexPath indexPathForRow:index inSection:0];
    pageCount = 0;
    [self getDataWithSortIndex:index];
    [self sortBtnTapped:nil];
}

- (void)wishListButtonTappedWithProduct:(EYProductsInfo *)product withCell:(EYProductCell *)cell
{
    if ([[EYAccountManager sharedManger] isUserLoggedIn] == NO)
    {
        [self openSignUpBeforeWishlist];
    }
    else
    {
        if (![cell.favBtn isSelected])
        {
            [self addingIntoWishlist:product];
        }
        else
        {
            [self deletingFromWishlist:product];
        }
    }
}

#pragma mark - calender

- (void)openSignUpBeforeWishlist
{
    if (self.wishlistLogInVC) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];

    CGRect rect = [UIScreen mainScreen].bounds;
    self.overlay = [[UIView alloc] initWithFrame:rect];
    [self.navigationController.view addSubview:_overlay];
    self.overlay.userInteractionEnabled = YES;
    self.overlay.alpha = 0.0;
    self.overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    
    UITapGestureRecognizer *tapOnOverlayForWishlist = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnOverlayWishlist:)];
    [self.overlay addGestureRecognizer:tapOnOverlayForWishlist];
    UIPanGestureRecognizer *panOnOverlayForWishlist = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnOverlayWishlist:)];
    [self.overlay addGestureRecognizer:panOnOverlayForWishlist];
    
    self.wishlistLogInVC = [EYUtility instantiateViewWithIdentifier:@"wishlistLogIn"];
    self.wishlistLogInVC.delegate = self;
   
    
    CGFloat h = 200;
    CGRect frame = (CGRect) {0.0, rect.size.height + 0, rect.size.width, h};
    self.wishlistLogInVC.view.frame = frame;
    
    [self.navigationController addChildViewController:self.wishlistLogInVC];
    [self.navigationController.view addSubview:self.wishlistLogInVC.view];
    
    frame.origin.y = rect.size.height - h;
    [UIView animateWithDuration:0.3 animations:^{
        self.overlay.alpha = 1.0;
        self.wishlistLogInVC.view.frame = frame;
    } completion:^(BOOL finished) {
        [self.wishlistLogInVC didMoveToParentViewController:self.navigationController];
    }];
}

-(void)buttonLoginPressed
{
    [self dismissWishlistVC];
}

-(void)buttonSignUpPressed
{
    [self dismissWishlistVC];
}

- (void)tapOnOverlayWishlist:(id)sender
{
    [self dismissWishlistVC];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];
}

- (void)panOnOverlayWishlist:(id)sender
{
    [self dismissWishlistVC];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];
}

- (void)dismissWishlistVC
{
    [self.wishlistLogInVC willMoveToParentViewController:nil];
    
    CGRect frame = self.wishlistLogInVC.view.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.wishlistLogInVC.view.frame = frame;
        self.overlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.wishlistLogInVC.view removeFromSuperview];
        [self.wishlistLogInVC removeFromParentViewController];
        self.wishlistLogInVC = nil;
        [self.overlay removeFromSuperview];
        self.overlay = nil;
    }];
 
}



- (void)userSignInSuccessfulWithAccountController:(EYAccountController *)account
{
    [self.collectionView reloadData];
}

- (void)userSignUpSuccessful
{
    [self.collectionView reloadData];
}

#pragma mark - processing responses -

- (void)processWishListResponse:(id)responseObject withError:(EYError *)error
{
    if (!error) {
        EYGetAllProductsMTLModel *allProductsModel = [[EYWishlistModel sharedManager] getWishlistLocally];
        _productsInfoArray = [NSMutableArray arrayWithArray:allProductsModel.productsInfo];
        if (_productsInfoArray.count == 0)
        {
            [self showEmptyViewWithMessage:NSLocalizedString(@"empty_wishlist", @"") withImage:nil andRetryBtnHidden:YES];
        }
        else
        {
            if (self.emptyView)
            {
                [self.emptyView removeFromSuperview];
                self.emptyView = nil;
            }
            
            NSArray * productIdArr = [[EYWishlistModel sharedManager] getWishlistProductIdsLocally];
            NSMutableArray * newProductInfoArray = [[NSMutableArray alloc] init];

            for (EYProductsInfo * info in _productsInfoArray)
            {
                if ([productIdArr containsObject:info.productId])
                {
                    [newProductInfoArray addObject:info];
                }
            }
            
            allProductsModel.productsInfo = newProductInfoArray;
            _productsInfoArray = newProductInfoArray;
            [[EYWishlistModel sharedManager] saveWishListLocally:allProductsModel];
            
            if (_productsInfoArray.count == 0)
            {
                [self showEmptyViewWithMessage:NSLocalizedString(@"empty_wishlist", @"") withImage:nil andRetryBtnHidden:YES];
            }

            [self.collectionView reloadData];

        }
    }
    else
    {
        [self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:YES];
    }
}

- (void)processAllProductsWithCustomFilterResponse : (id)responseObject withError:(EYError *)error withArrayOfAppliedFilters:(NSMutableArray *)arrayOfAppliedFilters
{
    self.loader.hidden = YES;
    if (!error)
    {
        EYGetAllProductsMTLModel *allProductsModel = responseObject;
        self.productsInfoArray = [NSMutableArray arrayWithArray:allProductsModel.productsInfo];
        
        if (self.productsInfoArray.count > 0)
        {
            if (!_appliedFilterModel)
            {
                self.allProductsWithFilterModel = responseObject;
                for (EYProductFilters * filter in self.allProductsWithFilterModel.productsFilters)
                {
                    if ([filter.filterType isEqualToString:kFourDayString])
                    {
                        self.appliedFilterModel = [[EYFilterDataModel alloc] initWithFourDayRentalFilter:filter];
                    }
                }
                if (!_appliedFilterModel)
                {
                    self.appliedFilterModel = [[EYFilterDataModel alloc] initWithFourDayRentalFilter:nil];
                }
            }
            
            if (self.emptyView)
            {
                [self.emptyView removeFromSuperview];
                self.emptyView = nil;
            }
            [self.headerView setUserInteractionEnabled:YES];
            [self.collectionView reloadData];
        }
        else
        {
            [self showEmptyViewWithMessage:NSLocalizedString(@"no_products", @"") withImage:nil andRetryBtnHidden:YES];
            if (_sliderNameReceived && _sliderValueReceived && _subcategoryIdReceived)
            {
                if (arrayOfAppliedFilters.count > 1)
                {
                    [self.headerView setUserInteractionEnabled:YES];
                }
                else
                {
                    [self.headerView setUserInteractionEnabled:NO];
                }
            }
            else if (_bannerIdReceived)
            {
                if (arrayOfAppliedFilters.count > 0)
                {
                    [self.headerView setUserInteractionEnabled:YES];
                }
                else
                {
                    [self.headerView setUserInteractionEnabled:NO];
                }
            }
            
        }
    }
    else {
#warning errormessage to be changed
        [self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:YES];
    }
}

- (void)processAddProductToWishlist:(id)responseObject withError:(EYError *)error
{
    [EYUtility hideHUD];
    if (!error && responseObject) {
        [self.collectionView reloadData];
    }
    else {
        [EYUtility showAlertView:error.errorMessage];
    }
}

- (void)processDeleteProductsFromWishlist:(BOOL)responseSuccess withError:(EYError *)error andProduct:(EYProductsInfo *)product
{
    [EYUtility hideHUD];
//    if (!error && responseSuccess)
    {
        if (_productCategory == GETProductsFromWishlist)                                                             //for fourth tab
        {
            EYGetAllProductsMTLModel * allProducts = [[EYWishlistModel sharedManager] getWishlistLocally];
            NSMutableArray * array = [allProducts.productsInfo mutableCopy];
            if ([array containsObject:product])
            {
                [array removeObject:product];
                allProducts.productsInfo = array ;
                [[EYWishlistModel sharedManager] saveWishListLocally:allProducts];
            }
            
            _productsInfoArray = [allProducts.productsInfo mutableCopy];
            if (_productsInfoArray.count <=0)
            {
                [self showEmptyViewWithMessage:NSLocalizedString(@"no_products", @"") withImage:nil andRetryBtnHidden:YES];
            }
            
            NSMutableArray * productarray = [[[EYWishlistModel sharedManager] getWishlistProductIdsLocally] mutableCopy];
            NSMutableArray * newProductarray = [[NSMutableArray alloc] init];

            for (EYProductsInfo * info in _productsInfoArray)
            {
                [newProductarray addObject:info.productId];
            }
            
            productarray = newProductarray;
            [[EYWishlistModel sharedManager] saveWishListProductIdsLocally:productarray];
        }
        else
        {
//            EYGetAllProductsMTLModel * allProducts = [[EYWishlistModel sharedManager] getWishlistLocally];
            NSMutableArray * array = [[[EYWishlistModel sharedManager] getWishlistProductIdsLocally] mutableCopy];
            if ([array containsObject:product.productId])
            {
                [array removeObject:product.productId];
                [EYWishlistModel sharedManager].productIdsArray = array;
                [[EYWishlistModel sharedManager] saveWishListProductIdsLocally:array];
            }
        }
        [self.collectionView reloadData];
    }
    
//    else
//    {
//        [EYUtility showAlertView:error.errorMessage];
//    }
}

- (void)processUpdateWishlist:(id)responseObject withError :(EYError *)error
{
    [EYUtility hideHUD];
    if (!error)
    {
        if (responseObject)
        {
            NSLog(@"Recieved wishlist");
            if (self.emptyView)
            {
                [self.emptyView removeFromSuperview];
                self.emptyView = nil;
            }
            [self.collectionView reloadData];
        }
        else
        {
            [self showEmptyViewWithMessage:NSLocalizedString(@"empty_wishlist", @"") withImage:nil andRetryBtnHidden:YES];
            NSLog(@"No product in wishlist");
        }
    }
    else
    {
        NSLog(@"Did not got wishlist");
        [self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:NO];
    }
}

#pragma mark - show empty/error view

- (void)showEmptyViewWithMessage:(NSString *)messageText withImage:(UIImage *)image andRetryBtnHidden:(BOOL)hidden
{
    if (!self.emptyView){
        self.emptyView = [[EYUtility shared] errorViewWithText:messageText withImage:image andRetryBtnHidden:hidden];
        self.emptyView.frame = CGRectZero;
        [self.view addSubview:self.emptyView];
    }
}

#pragma mark - call api with paging
- (void)getNextDataWithSortIndex :(NSInteger)index
{
    if (_productCategory == GetProductsFromSlider || _productCategory == GetProductsFromBanner)
    {
        NSDictionary *filters = @{};
        NSMutableArray * arrayOfAppliedFilters = [self creatingDictForFilters:self.appliedFilterModel];
        if (_sliderNameReceived && _sliderValueReceived && _subcategoryIdReceived) {
            
            NSString *sliderTypeStr = @"Category";
            switch ([_sliderType integerValue]) {
                case 1:
                    sliderTypeStr = @"Recently Viewed";
                    break;
                case 2:
                    sliderTypeStr = @"Trending Now";
                    break;
                case 3:
                    sliderTypeStr = @"Most Popular";
                    break;
                case 4:
                    sliderTypeStr = @"Tags";
                    break;
                case 5:
                    sliderTypeStr = @"Designer";
                    break;
                case 7:
                    sliderTypeStr = @"Occasion";
                    break;
                default:
                    sliderTypeStr = @"Category";
                    break;
            }
            
            
            NSDictionary *dict = @{@"filterType": sliderTypeStr,
                                   @"name": _sliderNameReceived,
                                   @"id": _sliderValueReceived,
                                   @"valueIds": _subcategoryIdReceived};
            
            [arrayOfAppliedFilters addObject:dict];
            filters = @{@"sortingType": @(index)};
        }
        else if (_bannerIdReceived) {
            filters = @{@"bannerId" : _bannerIdReceived,
                        @"sortingType": @(index)};
        }
        else {
            
        }
        __weak typeof (self)weakSelf = self;
        
        NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)pageCount + 1];
        NSString *requestPath = kGetAllProductsRequestPath(pageStr);
        [[EYAllAPICallsManager sharedManager] getAllProductsWithCustomFilters:filters requestPath:requestPath shouldCache:NO payload:arrayOfAppliedFilters withCompletionBlock:^(id responseObject, EYError *error)
         {
             [weakSelf processPagingApiWithCustomFilterResponse:responseObject withError:error];
         }];
    }
    else if(_productCategory == GETProductsFromWishlist)                                                             //wishlist
    {
        
    }
}

- (void)processPagingApiWithCustomFilterResponse : (id)responseObject withError:(EYError *)error
{
    if (!error)
    {
        pageCount ++;
        EYGetAllProductsMTLModel *allProductsModel = responseObject;
        if (allProductsModel.productsInfo.count > 0)
        {
            [self.productsInfoArray addObjectsFromArray:allProductsModel.productsInfo];
            [self.headerView setUserInteractionEnabled:YES];
            [self.collectionView reloadData];
        }
        else{
            // [self showEmptyViewWithMessage:NSLocalizedString(@"no_products", @"") withImage:nil andRetryBtnHidden:YES];
            [self.headerView setUserInteractionEnabled:YES];
        }
    }
    else {
        //[self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:YES];
    }

    
//    if (!error)
//    {
//        pageCount ++;
//        EYGetAllProductsMTLModel *allProductsModel = responseObject;
//        [self.productsInfoArray addObjectsFromArray:allProductsModel.productsInfo];
//        if (self.productsInfoArray.count > 0)
//        {
//            [self.headerView setUserInteractionEnabled:YES];
//            [self.collectionView reloadData];
//        }
//        else{
//           // [self showEmptyViewWithMessage:NSLocalizedString(@"no_products", @"") withImage:nil andRetryBtnHidden:YES];
//            [self.headerView setUserInteractionEnabled:YES];
//        }
//    }
//    else {
//        //[self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:YES];
//    }
}

@end


