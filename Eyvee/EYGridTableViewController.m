//
//  EYGridTableViewController.m
//  Eyvee
//
//  Created by Disha Jain on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYGridTableViewController.h"
#import "EYHomeCategoryCell.h"
#import "EYSlidersMtlModel.h"
#import "EYAllAPICallsManager.h"
#import "EYConstant.h"
#import "EYSubcategoryTableViewCell.h"
#import "EYGridProductController.h"
#import "EYError.h"
#import "EYMoreItemsViewController.h"
#import "EYBagSummaryViewController.h"
#import "EYBadgedBarButtonItem.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"
#import "EDLoaderView.h"
#import "EYEmptyView.h"

@interface EYGridTableViewController ()<UITableViewDataSource,UITableViewDelegate, EYSubcategoryTableViewCellDelegate>

@property (nonatomic, strong) NSArray *slidersArray;
@property (nonatomic, strong) NSArray *subcategoryArray;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger previousIndex;
@property (nonatomic) NSInteger indexForSubcategory;
@property (nonatomic) NSNumber *sliderId;

@property (nonatomic, strong) EYBadgedBarButtonItem *rightButton;
@property (nonatomic, strong) EYEmptyView *emptyView;

@end

@implementation EYGridTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName : kBlackTextColor,
                                                                   NSFontAttributeName : AN_MEDIUM(16.0)};
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    UIImage *image =[ UIImage imageNamed:@"shopping_bag"];
    _rightButton = [[EYBadgedBarButtonItem alloc] initWithImage:image target:self action:@selector(actionAddToBagTapped:)];
    self.navigationItem.rightBarButtonItem = _rightButton;
    self.navigationItem.title = @"Explore";
    
    _selectedIndex = -1;
    _indexForSubcategory = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(64.0, 0, kTabBarHeight, 0)];
    self.tableView.scrollIndicatorInsets = (UIEdgeInsets) {64.0, 0.0, kTabBarHeight, 0.0};
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTblView) forControlEvents:UIControlEventValueChanged];
    
    [self getSlidersData];
}

- (void)actionAddToBagTapped:(id)sender
{
    //cart
    EYBagSummaryViewController *bagSummary = [[EYBagSummaryViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:bagSummary animated:YES];
}

- (void)getSlidersData
{
    if (!self.refreshControl.isRefreshing) {
        self.tableView.tableHeaderView = [[EDLoaderView alloc] init];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    [[EYAllAPICallsManager sharedManager] getAllSlidersRequestWithParameters:nil withRequestPath:kSlidersFilePath shouldCache:NO isPullToRefresh:self.refreshControl.isRefreshing withCompletionBlock:^(id responseObject, EYError *error)
    {
        [weakSelf processSlidersData:responseObject error:error];
    }];
}

- (void)processSlidersData:(id)responseData error:(EYError *)error
{
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    if (responseData) {
        _slidersArray = responseData;
        self.tableView.tableHeaderView = nil;
    }
    else{
        if (_slidersArray.count > 0) {
            return;
        }
        self.tableView.tableHeaderView = [self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:YES];
    }
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];
}

#pragma mark - table view delegates and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _slidersArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _selectedIndex)
    {
        EYSlidersMtlModel *slider = [_slidersArray objectAtIndex:_selectedIndex];
        if (slider.children.count > 7) {
            return 4+1;
        }
        else {
            return (slider.children.count/2 + slider.children.count%2)+1;
        }
    }
    else
    {
       return 1;  
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *identifier = @"category";
        EYHomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EYHomeCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        EYSlidersMtlModel *sliderModel = [_slidersArray objectAtIndex:indexPath.section];
        
        NSString *imagePath = nil;

        for (EYProductResizeImages *images in sliderModel.resizedImages) {

            if ([EYUtility isDeviceGreaterThanSix])
            {
                if ([images.imageSize isEqualToString:@"medium"])
                {
                    imagePath = images.image;
                    break;
                }
            }
            else
            {
                if ([images.imageSize isEqualToString:@"small"])
                {
                    imagePath = images.image;
                    break;
                }
            }
        }
        
        if (!imagePath) {
            imagePath = sliderModel.imageName;
        }
        
        if (!imagePath) {
            [cell setBannerImage:nil];
        }
        else {
            NSURL *sliderImageUrl = [NSURL URLWithString:imagePath];
            [cell setBannerImage:sliderImageUrl];
        }
        
        NSString *sliderMainText = sliderModel.headerText;
        NSString *sliderMiddleText = sliderModel.middleText;
        NSString *sliderBottomText = sliderModel.bottomText;
        
        NSInteger sliderHeaderFont = [sliderModel.headerFontSize integerValue ];
        NSInteger sliderMiddleFont = [sliderModel.middleFontSize integerValue ];
        NSInteger sliderBottomFont = [sliderModel.bottomFontSize integerValue];
        
        [cell setHeaderTextFont:sliderHeaderFont middleTextFont:sliderMiddleFont bottomTextFont:sliderBottomFont];
        [cell setlabelmainText:nil headerText:sliderMainText middleText:sliderMiddleText bottomText:sliderBottomText WithVCMode:sliderVC];
        return cell;
    }
    else {
        static NSString *identifier = @"subcategory";
        EYSubcategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EYSubcategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        EYSlidersMtlModel *sliderModel = [_slidersArray objectAtIndex:indexPath.section];
        NSArray *subcategoryArr = sliderModel.children;
        cell.sliderModelReceived = sliderModel;
        
        if (subcategoryArr.count>7)
        {
            NSInteger initialIndex = (indexPath.row - 1) * 2;
            [cell setLeftItem:subcategoryArr[initialIndex] setRightItem:(6 > initialIndex + 1) ? subcategoryArr[initialIndex + 1] : @"-100:More:xyz"];
        }
        else
        {
            NSInteger initialIndex = (indexPath.row - 1) * 2;
            [cell setLeftItem:subcategoryArr[initialIndex] setRightItem:(subcategoryArr.count > initialIndex + 1) ? subcategoryArr[initialIndex + 1] : nil];
        }
      

        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return (1*self.view.bounds.size.width)/2;
    }
    else
    {
        return 48;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0)
    {
        _previousIndex = _selectedIndex;
        if (indexPath.section == _selectedIndex)
        {
            _selectedIndex = -1;
        }
        else
        {
            _selectedIndex = indexPath.section;
        }
        [self updateSections];
    }
    else
    {
        
    }
}


-(void)updateSections
{
    NSMutableArray *indexArrToAdd = [[NSMutableArray alloc] init];
    NSMutableArray *indexArrToDelete = [[NSMutableArray alloc] init];
    
    // For Deleting rows from Previous or unselected section
    if (_previousIndex != -1) {
        EYSlidersMtlModel *slider = [_slidersArray objectAtIndex:_previousIndex];
        NSArray *subArr = slider.children;
        
        if (subArr.count>7)
        {
            for (int i = 1; i <= 4; i++) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:_previousIndex];
                [indexArrToDelete addObject:indexpath];
            }
        }
        else
        {
            for (int i = 1; i <= (subArr.count/2+subArr.count%2); i++) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:_previousIndex];
                [indexArrToDelete addObject:indexpath];
            }
        }

        
    }
    
    // for adding rows in selected Section
    
    if (_selectedIndex != -1) {
        EYSlidersMtlModel *slider = [_slidersArray objectAtIndex:_selectedIndex];
        NSArray *subArr = slider.children;
        
        if (subArr.count>7)
        {
            for (int i = 1; i <= 4; i++) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:_selectedIndex];
                [indexArrToAdd addObject:indexpath];
            }
        }
        else
        {
            for (int i = 1; i <= (subArr.count/2+subArr.count%2); i++) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:_selectedIndex];
                [indexArrToAdd addObject:indexpath];
            }
        }
    }
    
    [self.tableView beginUpdates];

    [self.tableView deleteRowsAtIndexPaths:indexArrToDelete withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView insertRowsAtIndexPaths:indexArrToAdd withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    if (_selectedIndex != -1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectedIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - eysubcattablecell delegate

- (void)leftBtnTapped:(id)sender withId:(NSArray*)subCatId andSliderModel:(EYSlidersMtlModel *)sliderModel andSubCategoryName:(NSString*)subCategoryName andFilePath:(NSString *)dataFile
{
    
    if ([subCatId containsObject:@(-100)])
    {
        EYMoreItemsViewController *moreItemsVc = [[EYMoreItemsViewController alloc]initWithNibName:nil bundle:nil];
        moreItemsVc.itemsReceived = sliderModel.children;
        moreItemsVc.sliderId = [sliderModel.sliderId stringValue];
        moreItemsVc.sliderName = sliderModel.itemName;
        moreItemsVc.sliderType = sliderModel.sliderType;
        moreItemsVc.dataFilePath = dataFile;
        [self.navigationController pushViewController:moreItemsVc animated:YES];
    }
    else
    {
        EYGridProductController *productCont = [[EYGridProductController alloc] initWithNibName:nil bundle:nil];
        productCont.productCategory = GetProductsFromSlider;
        productCont.sliderNameReceived = sliderModel.itemName;
        productCont.sliderValueReceived = [sliderModel.sliderId stringValue];
        productCont.subcategoryIdReceived = subCatId;
        productCont.sliderType = sliderModel.sliderType;
        productCont.titleForNavigationBar = subCategoryName;
        productCont.filePathForData = dataFile;
        [self.navigationController pushViewController:productCont animated:YES];
        
    }
    
}


- (void)rightBtnTapped:(id)sender withId:(NSArray*)subCatId andSliderModel:(EYSlidersMtlModel *)sliderModel andSubCategoryName:(NSString*)subCategoryName andFilePath:(NSString *)dataFile
{
    
    
    if ([subCatId containsObject:@(-100)])
    {
        EYMoreItemsViewController *moreItemsVc = [[EYMoreItemsViewController alloc]initWithNibName:nil bundle:nil];
        moreItemsVc.itemsReceived = sliderModel.children;
        moreItemsVc.sliderType = sliderModel.sliderType;
        moreItemsVc.sliderId = [sliderModel.sliderId stringValue];
        moreItemsVc.sliderName = sliderModel.itemName;
        moreItemsVc.dataFilePath = dataFile;
        [self.navigationController pushViewController:moreItemsVc animated:YES];
    }
    else
    {
        EYGridProductController *productCont = [[EYGridProductController alloc] initWithNibName:nil bundle:nil];
        productCont.productCategory = GetProductsFromSlider;
        productCont.sliderNameReceived = sliderModel.itemName;
        productCont.sliderValueReceived = [sliderModel.sliderId stringValue];
        productCont.subcategoryIdReceived = subCatId;
        productCont.sliderType = sliderModel.sliderType;
        productCont.titleForNavigationBar = subCategoryName;
        productCont.filePathForData = dataFile;
        [self.navigationController pushViewController:productCont animated:YES];
        
    }
}

- (void)refreshTblView
{
    [self getSlidersData];
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
