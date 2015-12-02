//
//  ProductDetailViewController.m
//  eyVee
//
//  Created by Disha Jain on 12/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDescriptionCell.h"
#import "ShippingNAssuranceCell.h"
#import "SaveNShareTableViewCell.h"
#import "EYConstant.h"
#import "EYGridProductController.h"
#import "ScrollButtonsTableViewCell.h"
#import "EYUIImageViewContentViewAnimation.h"
#import "EYProductCell.h"
#import "UIImageView+AFNetworking.h"
#import "EYUtility.h"
#import "EDImageViewerController.h"
#import "TableViewCellWithSeparator.h"
#import "EYButtonWithRightImage.h"
#import "EYBagSummaryViewController.h"
#import "EYAllAPICallsManager.h"
#import "EYError.h"
#import "EYWishlistModel.h"
#import "EYAccountController.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYBadgedBarButtonItem.h"
#import "EYAccountManager.h"
#import "EYShippingTextViewController.h"

#import "WPButtonsAlertView.h"

#define kProductNameRow @"ProductNameRow"
#define kSizesRow @"sizes"
#define kProductDescRow @"ProductDescRow"
#define kShippingRow @"ShippingRow"
#define kProductQualityRow @"ProductQualityRow"
#define kSaveAndShareRow @"SaveAndShareRow"
#define kSizeAndFit @"SizeAndFitRow"


@interface ProductDetailViewController ()< UITableViewDataSource, UITableViewDelegate, EYSelectSizeViewDelegate, EYAddToBagViewControllerDelegate,UIActivityItemSource>
{
    EYGridProductController * gridObj;
    UIView * separatorLine;
}

//bottom view objects

@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *retailPriceLabel;
@property (nonatomic,strong)EYButtonWithRightImage *buttonReserve;
@property (nonatomic, strong) EYBadgedBarButtonItem *rightButton;

@property (nonatomic,strong)NSArray *productSizeArray;
@property (nonatomic,strong)NSArray *productSizeIdArray;

@property (nonatomic,strong)NSString *selectedSize;
@property (assign,nonatomic)NSInteger selectedButtonSizeTag;

@end

@implementation ProductDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    
    //Navigation bar
    self.navigationItem.title = _productModelReceived.brandName;

    UIImage *image =[ UIImage imageNamed:@"shopping_bag"];
    _rightButton = [[EYBadgedBarButtonItem alloc] initWithImage:image target:self action:@selector(actionAddToBagTapped:)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    //Table View
    _tbView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    
    [self.view addSubview:_tbView];
    
    //Header View
    _header = [[ProductDetailHeadersViewController alloc] init];
    [_header setDelegate:self];
    _header.selectedSmallImageString = self.selectedSmallImagePath;
    _header.productResizeImagesModelReceived = self.productModelReceived.productResizeImages;
    self.tbView.tableFooterView = [[UIView alloc]init];
    
     //Product sizes from product detail model:
    _productSizeArray = [[NSArray alloc]init];
    _productSizeIdArray = [[NSArray alloc]init];

    NSArray *attributesArray = _productModelReceived.productAttributes;
    EYProductAttributes *productAttributeModel = attributesArray[0];
    _productSizeArray = productAttributeModel.attrValues;
    _productSizeIdArray = productAttributeModel.attrValueIds;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
}

- (void)actionAddToBagTapped:(id)sender
{
    //cart
    EYBagSummaryViewController *bagSummary = [[EYBagSummaryViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:bagSummary animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self creatingBottom];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)creatingBottom
{
    //Bottom View
    _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_bottomView];
    
    //Bottom View Objects
    
    if (!_priceLabel)
    {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _priceLabel.numberOfLines = 1;
        [self.bottomView addSubview:_priceLabel];
    }
    
    _priceLabel.attributedText = [self attributedStringForPrice:_productModelReceived.originalPrice.integerValue];

    
//    if (_rentalPeriod == 4)
//    {
//        _priceLabel.attributedText = [self attributedStringForPrice:_productModelReceived.fourDayRentalPrice.integerValue];
//    }
//    else
//    {
//        _priceLabel.attributedText = [self attributedStringForPrice:_productModelReceived.eightDayRentalPrice.integerValue];
//    }
//    _retailPriceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    _retailPriceLabel.numberOfLines = 1;
//    _retailPriceLabel.attributedText = [self attributedStringForRetailPrice:_productModelReceived.originalPrice.integerValue];
//    [self.bottomView addSubview:_retailPriceLabel];
    
    _buttonReserve = [EYButtonWithRightImage buttonWithType:UIButtonTypeSystem];
    _buttonReserve.backgroundColor = kAppGreenColor;
    _buttonReserve.titleLabel.font = AN_BOLD(13.0);
    [_buttonReserve setTitle:NSLocalizedString(@"reserve_now_btn_text", @"") forState:UIControlStateNormal];
    [_buttonReserve setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonReserve addTarget:self action:@selector(actionButtonReserve) forControlEvents:UIControlEventTouchUpInside];
    [_buttonReserve setImage:[UIImage imageNamed:@"next_btn_large"] forState:UIControlStateNormal];
    [_buttonReserve setTintColor:[UIColor whiteColor]];
    [self.bottomView addSubview:_buttonReserve];
    
    separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    separatorLine.backgroundColor = kSeparatorColor;
    [self.bottomView addSubview:separatorLine];
}

- (void)didSingleTapInProductDetail:(ProductDetailHeadersViewController *)controller withCurrentIndex:(NSUInteger)currentIndex withImageArray:(NSMutableArray *)imageArray withLargeImageArray:(NSMutableArray *)largeImageArray
{
    controller.innerController = [[EDImageViewerController alloc] initWithNibName:nil bundle:nil withCurrentIndex:currentIndex];
    controller.innerController.imageArray = imageArray;
    controller.innerController.largeImageArray = largeImageArray;
    controller.innerController.transitioningDelegate = self;
    controller.innerController.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:controller.innerController animated:YES completion:nil];
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;

    CGSize sizeOfBottomView = (CGSize){size.width,60};

    _tbView.frame = CGRectMake(0, 0, size.width, size.height - sizeOfBottomView.height);
    // - 150

    CGFloat headerHeight = (reverseAspectRatio * [UIScreen mainScreen].bounds.size.width) + kPageControlHeight;
    _header.view.frame = CGRectMake(0, 0, size.width, headerHeight);
    self.tbView.tableHeaderView = _header.view;

    _bottomView.frame = (CGRect){0,CGRectGetMaxY(self.tbView.frame),sizeOfBottomView};
    
    CGSize sizeOfbuttonReserve = [EYUtility sizeForString:_buttonReserve.titleLabel.text font:_buttonReserve.titleLabel.font];
    CGFloat w = sizeOfbuttonReserve.width + kProductDescriptionPadding*3 + 8.0;
    
    CGFloat buttonReserveWidth = (size.width - 2*kProductDescriptionPadding - 5.0)/2;
    CGSize buttonReserveSize = (CGSize){buttonReserveWidth,36};
    
    _buttonReserve.frame = (CGRect){size.width-kProductDescriptionPadding-w,(_bottomView.frame.size.height - buttonReserveSize.height)/2,w,36};

    CGSize sizeOfPriceLabel = _priceLabel.intrinsicContentSize;
//    CGSize sizeOfRetailLabel = _retailPriceLabel.intrinsicContentSize;
    
//    CGFloat h = sizeOfPriceLabel.height + sizeOfRetailLabel.height + 2.0;
   
//    _priceLabel.frame = (CGRect){kProductDescriptionPadding,(_bottomView.frame.size.height - h)/2,sizeOfPriceLabel};
    _priceLabel.frame = (CGRect){kProductDescriptionPadding,(_bottomView.frame.size.height - sizeOfPriceLabel.height)/2,sizeOfPriceLabel};

//    _retailPriceLabel.frame = (CGRect){kProductDescriptionPadding,CGRectGetMaxY(_priceLabel.frame)+2.0,sizeOfRetailLabel};
    
    CGFloat thickness = 1.0;
    separatorLine.frame = CGRectMake(0,0, _bottomView.frame.size.width, thickness);
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)getNumberOfSectionsCount
{
    NSInteger count = 7;
    if ([_productSizeArray containsObject:@"free size"] || _productSizeArray.count == 0) {
         count--;
    }
    if (_productModelReceived.productDetails.length == 0) {
        count--;
    }
    if (_productModelReceived.stylistNotes.length == 0) {
        count--;
    }
    return count;
}

- (NSString *)getStringForRow:(NSInteger)row
{
    NSString *rowName = @"";
    switch (row) {
        case 0:
            rowName = kProductNameRow;
            break;
            
        case 1:
            if (![_productSizeArray containsObject:@"free size"]&& _productSizeArray.count > 0) {
                rowName = kSizesRow;
            }
            else if (_productModelReceived.productDetails.length > 0) {
                rowName = kProductDescRow;
            }
            else if (_productModelReceived.stylistNotes.length>0){
                rowName = kSizeAndFit;
            }

            else {
                rowName = kShippingRow;
            }
            break;
            
        case 2:
            if (![_productSizeArray containsObject:@"free size"]&& _productSizeArray.count > 0 && _productModelReceived.productDetails.length > 0)
            {
                rowName = kProductDescRow;
            }
            else if (_productModelReceived.productDetails.length > 0 && ([_productSizeArray containsObject:@"free size"] && _productSizeArray.count > 0))
            {
                if (_productModelReceived.stylistNotes.length>0)
                {
                    rowName = kSizeAndFit;
                }
                else
                {
                    rowName = kShippingRow;
                }
            }
            else if (_productModelReceived.productDetails.length <= 0 && ([_productSizeArray containsObject:@"free size"] && _productSizeArray.count > 0))
            {
                if (_productModelReceived.stylistNotes.length>0) {
                    rowName = kShippingRow;
                }
                else
                {
                    rowName = kSaveAndShareRow;
                }
            }
            else if (![_productSizeArray containsObject:@"free size"]&& _productSizeArray.count > 0 && _productModelReceived.productDetails.length <= 0)
            {
                if (_productModelReceived.stylistNotes.length>0) {
                    rowName = kSizeAndFit;
                }
                else
                {
                    rowName = kShippingRow;
                }
            }
            break;
            
        case 3:
            if (![_productSizeArray containsObject:@"free size"]&& _productSizeArray.count > 0 && _productModelReceived.productDetails.length > 0)
            {
                if (_productModelReceived.stylistNotes.length>0) {
                    rowName = kSizeAndFit;
                }
                else
                {
                    rowName = kShippingRow;
                }
            }
            else if (_productModelReceived.productDetails.length > 0 && ([_productSizeArray containsObject:@"free size"] && _productSizeArray.count > 0))
            {
                if (_productModelReceived.stylistNotes.length>0)
                {
                    rowName = kShippingRow;
                }
                else
                {
                    rowName = kProductQualityRow;
                }
            }
            else if (_productModelReceived.productDetails.length <= 0 && ([_productSizeArray containsObject:@"free size"] && _productSizeArray.count > 0))
            {
                if (_productModelReceived.stylistNotes.length>0) {
                    rowName = kSaveAndShareRow;
                }
                else
                {
                    rowName = kSaveAndShareRow;
                }
            }
            else if (![_productSizeArray containsObject:@"free size"]&& _productSizeArray.count > 0 && _productModelReceived.productDetails.length <= 0)
            {
                if (_productModelReceived.stylistNotes.length>0) {
                    rowName = kShippingRow;
                }
                else
                {
                    rowName = kProductQualityRow;
                }
            }
            break;
            
        case 4:
            if (![_productSizeArray containsObject:@"free size"]&& _productSizeArray.count > 0 && _productModelReceived.productDetails.length > 0) {
                if (_productModelReceived.stylistNotes.length>0) {
                    rowName = kShippingRow;
                }
                else
                {
                    rowName = kProductQualityRow;
                }
            }
            
            else if (_productModelReceived.productDetails.length > 0 && ([_productSizeArray containsObject:@"free size"] && _productSizeArray.count > 0))
            {
                if (_productModelReceived.stylistNotes.length>0)
                {
                    rowName = kProductQualityRow;
                }
                else
                {
                    rowName = kSaveAndShareRow;
                }
            }
            else if (_productModelReceived.productDetails.length <= 0 && ([_productSizeArray containsObject:@"free size"] && _productSizeArray.count > 0))
            {
                if (_productModelReceived.stylistNotes.length>0)
                {
                    rowName = kSaveAndShareRow;
                }
              
            }
            else if (![_productSizeArray containsObject:@"free size"]&& _productSizeArray.count > 0 && _productModelReceived.productDetails.length <= 0)
            {
                if (_productModelReceived.stylistNotes.length>0) {
                    rowName = kProductQualityRow;
                }
                else
                {
                    rowName = kSaveAndShareRow;
                }
            }
            break;
        case 5:
          
            if (![_productSizeArray containsObject:@"free size"] && _productSizeArray.count > 0&& _productModelReceived.productDetails.length > 0)
            {
                if (_productModelReceived.stylistNotes.length>0)
                {
                    rowName = kProductQualityRow;
                }
                else
                {
                    rowName = kSaveAndShareRow;
                }
            }
            else
            {
                rowName = kSaveAndShareRow;
 
            }
           
            break;
            
        case 6:
            rowName = kSaveAndShareRow;
            break;
        
        default:
            break;
    }
    return rowName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getNumberOfSectionsCount];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier ;
    NSString *rowName = [self getStringForRow:indexPath.row];
    if ([rowName isEqualToString:kProductNameRow])
    {
        cellIdentifier = @"labelSeparator";
        TableViewCellWithSeparator* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TableViewCellWithSeparator alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setIsFilterMode:NO];

        [cell updateTextOfLabel:_productModelReceived.productName];
        return cell;
        
    }
    else if ([rowName isEqualToString:kSizesRow])
    {
        cellIdentifier = @"scrollButtons";
        ScrollButtonsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ScrollButtonsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier andMode:productSizesMode andArrayOfValues:_productSizeArray andArrayOfValueIds:_productSizeIdArray];
            //to update size from detail to bottom view in add to cart
            cell.sizeView.delegate = self;
        }
        return cell;
    }
    else if ([rowName isEqualToString:kProductDescRow])
    {
        cellIdentifier = @"productDescription";
        ProductDescriptionCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ProductDescriptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSString *trimmedString = [_productModelReceived.productDetails stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [cell updateProductDescLabelText:trimmedString];
        return cell;
    }
    else if ([rowName isEqualToString:kSizeAndFit])
    {
        cellIdentifier = @"sizeFit";
        ShippingNAssuranceCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ShippingNAssuranceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.titleForRow.text = @"STYLIST NOTES";
        return cell;
        
    }
    else if ([rowName isEqualToString:kShippingRow])
    {
        cellIdentifier = @"shippingRow";
        ShippingNAssuranceCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ShippingNAssuranceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.titleForRow.text = @"SHIPPING & RETURNS";
        return cell;

    }
    else if ([rowName isEqualToString:kProductQualityRow])
    {
        cellIdentifier = @"qualityRow";
        ShippingNAssuranceCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[ShippingNAssuranceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.titleForRow.text = @"QUALITY GUARANTEE";
        return cell;
        
    }
    else if ([rowName isEqualToString:kSaveAndShareRow])
    {
        cellIdentifier = @"saveNShare";
        SaveNShareTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[SaveNShareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }

        cell.buttonSave.isClicked = [self.selectedCell.favBtn isSelected];
        [cell.buttonSave addTarget:self action:@selector(actionButtonSave:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonShare addTarget:self action:@selector(actionButtonShare:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        cellIdentifier = @"myCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;

        cell.textLabel.text = @"We recommend selecting delivery date a day before the event.";
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        return cell;
    }
}

-(void) sizeGuideButtonClicked:(id) sender
{
    NSLog(@"sizeGuideButtonClicked product detail");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowName = [self getStringForRow:indexPath.row];
    if ([rowName isEqualToString:kProductNameRow])
    {
        return [TableViewCellWithSeparator requiredheightForRowWithWidth:self.view.frame.size.width andText:_productModelReceived.productName ];
    }
    else if ([rowName isEqualToString:kSizesRow])
    {
        return 116.0;
    }
    else if ([rowName isEqualToString:kProductDescRow])
    {
        NSString *trimmedString = [_productModelReceived.productDetails stringByTrimmingCharactersInSet:
                                                                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return [ProductDescriptionCell requiredHeightForRowWith:self.tbView.bounds.size.width forText:trimmedString];
    }
    else if ([rowName isEqualToString:kShippingRow])
    {
       
        return 44.0;
    }
    else if ([rowName isEqualToString:kSizeAndFit])
    {
        
        return 44.0;
    }

    else if ([rowName isEqualToString:kProductQualityRow])
    {
        return 44.0;
    }
    else
    {
        return 76.0;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *rowName = [self getStringForRow:indexPath.row];

    if ([rowName isEqualToString:kShippingRow])
    {
      //open  shipping and return information page
        EYShippingTextViewController *siteInfoVC = [EYUtility instantiateViewWithIdentifier:@"siteInfoVC"];
        siteInfoVC.siteInfoMode = SiteInfoShippingTextMode;
        [self.navigationController pushViewController:siteInfoVC animated:YES];
    }
    else if ([rowName isEqualToString:kProductQualityRow])
    {
        //open quality assurance page
        EYShippingTextViewController *siteInfoVC = [EYUtility instantiateViewWithIdentifier:@"siteInfoVC"];
        siteInfoVC.siteInfoMode = SiteInfoQualityTextMode;
        [self.navigationController pushViewController:siteInfoVC animated:YES];
    }
    else if ([rowName isEqualToString:kSizeAndFit])
    {
        //Open Stylist Notes
        EYShippingTextViewController *siteInfoVC = [EYUtility instantiateViewWithIdentifier:@"siteInfoVC"];
        siteInfoVC.siteInfoMode = SiteInfoDefault;
        siteInfoVC.textString = _productModelReceived.stylistNotes;
        siteInfoVC.headingString = @"Stylist Notes";
        [self.navigationController pushViewController:siteInfoVC animated:YES];
    }
}

//Buttons actions

-(void)actionButtonSave:(id) sender
{
    EYButtonWithRightImage * button = (EYButtonWithRightImage *) sender;
    if ([[EYAccountManager sharedManger] isUserLoggedIn] == NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"DEMO" message:@"Please Login to add this product in your Wishlist" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] show];
    }
    else
    {
        if (!button.isClicked)
        {
            [self addingIntoWishlist:button];
        }
        else
        {
            [self deletingFromWishlist:button];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
        accCont.delegate = self;
        accCont.isPresented = YES;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:accCont];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)addingIntoWishlist:(EYButtonWithRightImage *) button
{
    // for updating products Array
    EYGetAllProductsMTLModel *allProducts = [[EYWishlistModel sharedManager] getWishlistLocally];
    NSMutableArray *arrayForAddingProduct;
    if (allProducts)
    {
        if (allProducts.productsInfo.count)
        {
            arrayForAddingProduct = [allProducts.productsInfo mutableCopy];
        }
        else
        {
            arrayForAddingProduct = [[NSMutableArray alloc]init];
        
        }
    }
    else
    {
            allProducts = [[EYGetAllProductsMTLModel alloc]init];
            arrayForAddingProduct = [[NSMutableArray alloc]init];
        
    }
    [arrayForAddingProduct addObject:_productModelReceived];
    allProducts.productsInfo = arrayForAddingProduct;
    
    [[EYWishlistModel sharedManager]saveWishListLocally:allProducts];

    //For updating product ids array
    NSMutableArray *productIdsArray = [[[EYWishlistModel sharedManager]getWishlistProductIdsLocally] mutableCopy];
    
    if (productIdsArray.count)
    {
    }
    else
    {
        productIdsArray = [[NSMutableArray alloc]init];
    }

    [productIdsArray addObject:_productModelReceived.productId];
    [[EYWishlistModel sharedManager]saveWishListProductIdsLocally:productIdsArray];
    
        button.isClicked = YES;

    [[NSNotificationCenter defaultCenter]postNotificationName:kWishListUpdateNotification object:nil userInfo:@{@"count":@([[EYWishlistModel sharedManager]getWishlistLocally].productsInfo.count)}];

    
    
//    [EYUtility showHUDWithTitle:@"Adding"];
//    __weak typeof (self) weakSelf = self;
//
//    [[EYAllAPICallsManager sharedManager] addProductToWishlistRequestWithParameters:@{@"productId" : self.productModelReceived.productId} withRequestPath:kAddProductsToWishlistRequestPath cache:NO withCompletionBlock:^(id responseObject,EYError *error)
//     {
//         [weakSelf processAddProductToWishlist:responseObject withError:error withButton:button];
//     }];
    
}

- (void)processAddProductToWishlist:(id)responseObject withError:(EYError *)error withButton:(EYButtonWithRightImage *)button
{
    [EYUtility hideHUD];
    if (!error && responseObject)
    {
        button.isClicked = YES;
    }
    else {
        [EYUtility showAlertView:error.errorMessage];
    }
}


- (void)deletingFromWishlist:(EYButtonWithRightImage *) button
{
    EYGetAllProductsMTLModel *allProducts = [[EYWishlistModel sharedManager] getWishlistLocally];
    NSMutableArray *productsArray = [allProducts.productsInfo mutableCopy];
    
    if (productsArray.count)
    {
        if ([productsArray containsObject:_productModelReceived])
        {
            [productsArray removeObject:_productModelReceived];
        }
    }
    
    allProducts.productsInfo = productsArray;
    [[EYWishlistModel sharedManager]saveWishListLocally:allProducts];
    
    //update product ids array
    NSMutableArray *productIdsArray= [[[EYWishlistModel sharedManager]getWishlistProductIdsLocally]mutableCopy];
    if (productIdsArray.count)
    {
        if ([productIdsArray containsObject:_productModelReceived.productId])
        {
            [productIdsArray removeObject:_productModelReceived.productId];
        }
    }
    [[EYWishlistModel sharedManager]saveWishListProductIdsLocally:productIdsArray];
    [[NSNotificationCenter defaultCenter]postNotificationName:kWishListUpdateNotification object:nil userInfo:@{@"count":@([[EYWishlistModel sharedManager]getWishlistProductIdsLocally].count)}];

    button.isClicked = NO;

    
    
//    [EYUtility showHUDWithTitle:@"Deleting"];
//    __weak typeof (self) weakSelf = self;
//
//    [[EYAllAPICallsManager sharedManager] deleteProductsFromWishlistWithParameters:@{@"productId":self.productModelReceived.productId} withRequestPath:kRemoveSingleProductFromWishlistRequestPath cache:nil withCompletionBlock:^(BOOL responseSuccess, EYError *error)
//     {
//         [weakSelf processDeleteProductsFromWishlist:responseSuccess withError:error andButton:button];
//     }];
}

- (void)processDeleteProductsFromWishlist:(BOOL)responseSuccess withError:(EYError *)error andButton:(EYButtonWithRightImage *)button
{
    [EYUtility hideHUD];
    if (!error && responseSuccess)
    {
        button.isClicked = NO;
        if ([self.delegate respondsToSelector:@selector(deletionSuccessfull)]) {
            [self.delegate deletionSuccessfull];
        }
    }
    else
    {
        [EYUtility showAlertView:error.errorMessage];
    }
    
}

- (void)actionButtonShare:(id) sender
{
    [EYUtility shareApp:self];
}

- (void)actionButtonReserve
{    
//    EYAddToBagViewController *addToBagVC = [[EYAddToBagViewController alloc]initWithNibName:nil bundle:nil];
//    addToBagVC.productModelReceived = _productModelReceived;
//
//    addToBagVC.sizeReceived = _selectedSize;
//    addToBagVC.buttonSizeTagForBottomPopUpView = _selectedButtonSizeTag;
//    addToBagVC.rentalPeriod = self.rentalPeriod;
//    addToBagVC.startDate = self.startDate;
//    addToBagVC.delegate = self;
//    
//    [self.navigationController pushViewController:addToBagVC animated:YES];
    
    EYCartModel *localCartModel = [EYCartModel sharedManager];
    [localCartModel addProductIntoCartLocally:_productModelReceived withSize:_selectedSize];

}


-(NSAttributedString*)attributedStringForPrice:(NSInteger)price
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *firstLine = @{NSFontAttributeName : AN_BOLD(20.0),
                                NSForegroundColorAttributeName : [UIColor blackColor],
                                };
 
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[[EYUtility shared]getCurrencyFormatFromNumber:price] attributes:firstLine];
    [attr appendAttributedString:str];
    
    return attr;
}

-(NSAttributedString*)attributedStringForRetailPrice:(NSInteger)retailPrice
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    
    NSDictionary *dict = @{NSFontAttributeName : AN_REGULAR(11.0),
                                 NSForegroundColorAttributeName :kRetailLabelColor,
                                 };
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Retail :" attributes:dict];
    [attr appendAttributedString:str];
    str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[[EYUtility shared]getCurrencyFormatFromNumber:retailPrice]] attributes:dict];
    [attr appendAttributedString:str];
    return attr;

}

//add to cart view controller delegate
-(void)updateSizeReceivedFromBottomView:(NSString *)buttonValue andButtonTag:(NSInteger)buttonTag
{
    _selectedSize = buttonValue;
    _selectedButtonSizeTag = buttonTag;
}

-(void)updateSizeButtonValue:(NSString *)buttonValue andButtonTag:(NSInteger)buttonTag
{
    _selectedSize = buttonValue;
    _selectedButtonSizeTag = buttonTag;
}

- (void)updateRentalPeriodFromAddtoBag:(NSInteger)rentalPeriod
{
    self.rentalPeriod = rentalPeriod;
}

-(void)updateDateFromAddToBagInFilterVC:(NSDate *)date
{
    self.startDate = date;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.header.innerController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return nil;
//    return self.header.innerController;
}

#pragma mark viewControllerAnimationDelegate

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView * containerView = [transitionContext containerView];
    
    if([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[EYGridProductController class]])
    {
        if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[ProductDetailViewController class]])
        {
            EYGridProductController * fromViewController = (EYGridProductController *) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            gridObj = fromViewController;
            
            ProductDetailViewController *toViewController = (ProductDetailViewController *) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            {
                NSTimeInterval duration = [self transitionDuration:transitionContext];
                UICollectionView *collectionView = fromViewController.collectionView;
                
                UICollectionViewLayoutAttributes * theAttributes = [collectionView layoutAttributesForItemAtIndexPath:fromViewController.selectedIndexPath];
                CGRect cellFrameInSuperview = [collectionView convertRect:theAttributes.frame toView:[collectionView superview]];               //getting cell frame with respect to superview
                
                CGRect cellImageViewFrameInSuperview = CGRectMake(cellFrameInSuperview.origin.x + toViewController.selectedCell.productImgView.frame.origin.x , cellFrameInSuperview.origin.y + toViewController.selectedCell.productImgView.frame.origin.y, toViewController.selectedCell.productImgView.frame.size.width, toViewController.selectedCell.productImgView.frame.size.height);              //getting cell imageview frame with respect to superview
                
                CGRect cellFrameWithImageViewHeight = CGRectMake(cellFrameInSuperview.origin.x, cellFrameInSuperview.origin.y, cellFrameInSuperview.size.width, cellImageViewFrameInSuperview.size.height + toViewController.selectedCell.productImgView.frame.origin.y);              //getting cell frame with imageview height
                
                EYUIImageViewContentViewAnimation * cellImageViewSnapshot = [[EYUIImageViewContentViewAnimation alloc] initWithFrame:cellFrameWithImageViewHeight withImageViewFrame:toViewController.selectedCell.productImgView.frame]; //cell height is equal to image view height
                
                cellImageViewSnapshot.backgroundColor = [UIColor whiteColor];
                [cellImageViewSnapshot setImage:toViewController.selectedCell.productImgView.image];
                
                UIImageView *tempImgView;
                {
                    tempImgView = [[UIImageView alloc] initWithFrame:cellImageViewFrameInSuperview];
                }
                
                [tempImgView setBackgroundColor:[UIColor whiteColor]];
                [containerView addSubview:tempImgView];
                
                [self.view addSubview:cellImageViewSnapshot];
                
                toViewController.view.alpha = 0;
                
                [containerView setBackgroundColor:[UIColor whiteColor]];
                toViewController.tbView.hidden = YES;
                [containerView addSubview:toViewController.view];
                [containerView addSubview:cellImageViewSnapshot];
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    CGRect rect;{
                        //getting header height
                        CGFloat headerHeight = [self.header getHeight:containerView.frame.size];
                        rect = CGRectMake(0, 64, containerView.frame.size.width, headerHeight); // 37 is bydefault height of page control
                    }
                    cellImageViewSnapshot.frame = rect;
                } completion:^(BOOL finished)
                 {
                     toViewController.view.alpha = 1;
                     toViewController.tbView.hidden = NO;
                     [tempImgView removeFromSuperview];
                     [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     [cellImageViewSnapshot removeFromSuperview];
                     [self.navigationController setDelegate:self];
                 }];
            }
        }
    }
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        if ([toVC isKindOfClass:[EDImageViewerController class]]) {
            return self.header.innerController;
        }
        else {
            return nil;
        }
    }
    if (operation == UINavigationControllerOperationPop)
    {
        if ([fromVC isKindOfClass:[ProductDetailViewController class]] && [toVC isKindOfClass:[EYGridProductController class]])
        {
            EYGridProductController * gridVc = (EYGridProductController *) toVC;
            return gridVc;
        }
        else
        {
            return nil;
        }
    }
    return nil;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma UiActivity delegates

-(NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType
{
    return @"test";
}
-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return @"";
}
-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}

@end
