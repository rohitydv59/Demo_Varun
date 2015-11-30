//
//  EYAddToBagViewController.m
//  Eyvee
//
//  Created by Disha Jain on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAddToBagViewController.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "DeliveryDateTableViewCell.h"
#import "RentalTableViewCell.h"
#import "EYSelectSizeView.h"
#import "EYPaymentOptionsController.h"
#import "EYShippingDetailsViewController.h"
#import "EYAccountController.h"
#import "EYShippingDetailsViewController.h"
#import "EYBagSummaryViewController.h"
#import "EYProductInCartInfo.h"
#import "WPButtonsAlertView.h"
#import "EYGridProductController.h"
#import "EYBagSummaryViewController.h"
#import "EYAllAPICallsManager.h"
#import "EYCartModel.h"
#import "PickUpDateTextCell.h"
#import "EYSyncCartMtlModel.h"
#import "EYTextFieldCell.h"
#import "WPKeyboardAccessoryView.h"
#import "EYGetAllProductsMTLModel.h"
#import "EYError.h"
#import "EYBottomButton.h"
#import "EDKeyboardAccessoryView.h"
#import "EYShippingTextViewController.h"
#import "ASCalendarController.h"
#import "EDLoaderView.h"

#define KSizeRow @"sizeRow"
#define kRentalPerioRow @"rentalPeriod"
#define kDeliveryDateRow @"deliveryDate"
#define kPickUpDateRow @"pickUpDate"
#define kPickUpTextRow @"pickUpText"
#define kPinCodeRow @"pinCodeRow"

@interface EYAddToBagViewController ()< UITableViewDataSource, UITableViewDelegate,EYSelectSizeViewDelegate,UITextFieldDelegate,EDKeyboardAccessoryViewDelegate, ASCalendarControllerDelegate>
{
    NSArray *productSizeArray;
    NSArray *productSizeIdsArray;
    NSInteger rowCount;
}
@property (nonatomic, strong) UITableView * tbView;
//bottom view objects
@property (nonatomic,strong)UIButton *buttonAddToBag;

//FooterView
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) UIView *overlay;

@property (nonatomic, strong) NSString *thumbnailImage;
@property (nonatomic, strong) NSString *enteredPin;

@property (nonatomic,assign)BOOL stateOfBottomView, callInProgress;

@property (nonatomic,strong) EDKeyboardAccessoryView *accView;
@property (nonatomic, strong) EYBottomButton *bottomView;

//Select SIze View from bottom
@property (nonatomic, strong) EYSelectSizeView *bottomPopUpView;
@property (nonatomic, strong) ASCalendarController *calendar;
@property (nonatomic, strong) EYCartModel *cartModel;
@property (nonatomic, strong) EYAddressTextField *currentlyEditingTf;

@end

@implementation EYAddToBagViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
   self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
         self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = (self.comingFromCart) ? @"Update Item" : @"Add to Bag";
    
    self.title = title;

    //Table View
    _tbView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.backgroundColor = kSectionBgColor;
    [self.view addSubview:_tbView];
    
    NSString *pinEnteredLast=[[NSUserDefaults standardUserDefaults] stringForKey:kPinCodeKey];
    _enteredPin = pinEnteredLast;
    
    if(_enteredPin.length == 0)
    {
        EYShippingAddressMtlModel * localAddress = [[EYUtility shared] getUserAddressModel];
        _enteredPin = localAddress.pincode;
    }
    
    
    //Bottom View
    if (self.comingFromCart)
    {
        _bottomView = [[EYBottomButton alloc] initWithFrame:(CGRectZero) image:@"next_btn_large" ButtonText:@"UPDATE ITEM" andFont:AN_BOLD(13.0)];
    }
    else
    {
        _bottomView = [[EYBottomButton alloc] initWithFrame:(CGRectZero) image:@"next_btn_large" ButtonText:@"ADD TO BAG" andFont:AN_BOLD(13.0)];

    }
    [self.bottomView addTarget:self action:@selector(actionButtonAddToBag) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_bottomView];
    
    self.view.backgroundColor = kSectionBgColor;
    
    //Header View		
    _header = [[EYAddToBagHeaderView alloc]initWithFrame:CGRectZero];
    _header.backgroundColor = [UIColor whiteColor];
    
    for (EYProductResizeImages * productResizeImage in self.productModelReceived.productResizeImages)
    {
        if ([productResizeImage.imageTag isEqual:@"front"] )
        {
            if ([productResizeImage.imageSize isEqual:@"thumbnail"])
            {
                _thumbnailImage = productResizeImage.image;
            }
        }
    }
    [_header setHeaderDetails:self.productModelReceived withReceivedRentalPeriod:_rentalPeriod];

    //Table Footer View
    _footerView = [[UIView alloc]initWithFrame:CGRectZero];
    _footerView.backgroundColor = kSectionBgColor;
    
    _footerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _footerLabel.numberOfLines = 0;
    _footerLabel.textColor = kAppLightGrayColor;
    _footerLabel.attributedText = [EYAddToBagViewController getAttrStr:@"Currently we only deliver in Delhi\nFor delivery,we recommend selecting date\na day before the event"];
   
    [_footerView addSubview:_footerLabel];
    
    _cartModel = [EYCartModel sharedManager];
    
    _accView = [[EDKeyboardAccessoryView alloc]initWithFrame:(CGRect){0.0,0.0,0.0,kKeyboardAccessoryHeight} andMode:EDDoneButtonOnly];
    _accView.delegate = self;
    
    //Product sizes from product detail model:
    
    if (!_comingFromCart) {
        NSArray *productSizes = [[NSArray alloc]init];
        NSArray *attributesArray = _productModelReceived.productAttributes;
        EYProductAttributes *productAttributeModel = attributesArray[0];
        productSizes = productAttributeModel.attrValues;
        productSizeArray = productAttributeModel.attrValues;
        productSizeIdsArray = productAttributeModel.attrValueIds;
        self.sizeReceived = [productSizeArray containsObject:@"free size"] ? @"free size" : _sizeReceived;
        [self setTableHeaderWtihLoader:NO];
    }
    else
    {
        self.callInProgress = YES;
        [self setTableHeaderWtihLoader:YES];
        [self getProductModelFromServer:self.productID];
    }
    
    if (_rentalPeriod == 4 || !_rentalPeriod) {
        [self performSelector:@selector(fourDayRentalTapped:) withObject:nil];
    }
    else{}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tbView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopMoreTapped:) name:kShopMoreButtonTappedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewCartTapped:) name:kViewCartButtonTappedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    _bottomView.frame = (CGRect){0,size.height - kBottomBarHeight,size.width,kBottomBarHeight};
    _tbView.frame = CGRectMake(0, 0, size.width, size.height - _bottomView.frame.size.height);
    
   
    
    
}

- (void)getProductModelFromServer:(NSNumber *)productId
{
    __weak typeof(self) weakSelf = self;
    [[EYAllAPICallsManager sharedManager] getSpecificProductWithParameters:@{@"productId":productId} withRequestPath:@"getProductByProductId.json?" cache:NO withCompletionBlock:^(id responseObject, EYError *error) {
        [weakSelf processSpecificProductApiWithResponseObj:responseObject andError:error];
    }];
}

- (void)processSpecificProductApiWithResponseObj:(id)responseObject andError:(EYError *)error{
    self.callInProgress = NO;
    _productModelReceived = (EYProductsInfo *)responseObject;
    NSArray *attributesArray = _productModelReceived.productAttributes;
    if (attributesArray.count > 0) {
        EYProductAttributes *productAttributeModel = attributesArray[0];
        productSizeArray = productAttributeModel.attrValues;
        productSizeIdsArray = productAttributeModel.attrValueIds;
    }
    [_header setHeaderDetails:self.productModelReceived withReceivedRentalPeriod:self.rentalPeriod];
    [self setTableHeaderWtihLoader:NO];
    [self.tbView reloadData];
}

-(void)keyboardWillShow:(NSNotification*)notif
{
    CGSize keyboardSize =[[[notif userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    CGFloat animationDuration=[[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        UIEdgeInsets inset = self.tbView.contentInset;
        inset.bottom = keyboardSize.height;
        self.tbView.contentInset = inset;
        
    }];
}

-(void)keyboardWillHide:(NSNotification*)notif
{
    CGFloat animationDuration=[[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
   
    [UIView animateWithDuration:animationDuration animations:^{
        UIEdgeInsets inset = self.tbView.contentInset;
        inset.bottom = 48.0;
        self.tbView.contentInset = inset;
        
    }];

}


- (void)backBtnTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Bottom View Button Action
- (void)actionButtonAddToBag
{
    if (![self checkIfValid]) {
        return;
    }
    EYProductInCartInfo *selectedProduct = [[EYProductInCartInfo alloc] init];
    selectedProduct.productAllInfo = self.productModelReceived;
    selectedProduct.size = self.sizeReceived;
//    selectedProduct.rentalPeriod = self.rentalPeriod;
//    selectedProduct.startDate = self.startDate;
    selectedProduct.price = [self.productModelReceived.originalPrice floatValue];
//    selectedProduct.price = (self.rentalPeriod == 8) ? [self.productModelReceived.eightDayRentalPrice floatValue] : [[self.productModelReceived fourDayRentalPrice] floatValue];

    

    NSString *rentalStrtDate = [[EYUtility shared] getStringFromDate:self.startDate];
    NSDate *end = [[EYUtility shared] dateByAddingDays:self.rentalPeriod toDate:self.startDate];
    NSString *rentalEndDate = [[EYUtility shared] getStringFromDate:end];
    NSString *rentalType = (self.rentalPeriod == 4) ? @"1" : @"2";
    
    NSString *pinCode = [[EYUtility shared]getPinCode];
    
    if (_enteredPin.length < 6) {
        [EYUtility showAlertView:@"Pincode" message:@"Enter a valid pincode"];
        return;
    }
    
    if (_enteredPin.length)
    {
        pinCode = _enteredPin;
    }
    
    NSNumber *sizeId = @(0);
    for (EYProductAttributes *attr in self.productModelReceived.productAttributes) {
        for (NSString *attrName in attr.attrValues) {
            if ([attrName isEqualToString:self.sizeReceived]) {
                NSInteger index = [attr.attrValues indexOfObject:attrName];
                sizeId = [attr.attrValueIds objectAtIndex:index];
                break;
            }
        }
    }
    NSNumber *entityId = @(0);
    for (EYProductSKUs *skus in self.productModelReceived.productSKUs) {
        if ([skus.sizeValueId integerValue] == [sizeId integerValue]) {
            entityId = skus.entityId;
            break;
        }
    }
    NSDictionary *parameters;
    if (self.comingFromCart) {
        parameters = @{@"eventId" : @(2), @"rentalStartDate" : rentalStrtDate, @"rentalEndDate" : rentalEndDate, @"rentalType" : rentalType, @"skuId" : entityId, @"cartSkuId" : self.cartSKUId,@"pincode" : pinCode};
    }
    else {
        parameters = @{@"eventId" : @(1), @"rentalStartDate" : rentalStrtDate, @"rentalEndDate" : rentalEndDate, @"rentalType" : rentalType, @"skuId" : entityId ,@"pincode" : pinCode};
    }
    
    [EYUtility showHUDWithTitle:@"Loading"];
    __weak typeof(self) weakSelf = self;

    [[EYCartModel sharedManager] operationsOnCart:parameters requestPath:kSyncCartRequestPath withCompletionBlock:^(id responseObject, EYError *error) {
        [weakSelf processSynchingCart:responseObject withError:error withPincode:pinCode withCartInfo:selectedProduct];
    }];
    
}

- (void)processSynchingCart:(id)responseObject withError:(EYError *)error withPincode:(NSString *)pinCode withCartInfo:(EYProductInCartInfo *)selectedProduct
{
    [EYUtility hideHUD];
    
    if (!error && responseObject)
    {
        [[NSUserDefaults standardUserDefaults] setObject:pinCode forKey:kPinCodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (self.comingFromCart)
            [self.navigationController popViewControllerAnimated:YES];
        else
        {
            EYCartModel * cartManager = [EYCartModel sharedManager];
            cartManager.cartRequestState = cartRequestNeedToSend;
            [WPButtonsAlertView showErrorInWindow:[[EYUtility shared] getWindow] animated:YES productInfo:selectedProduct];
            
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:error.errorMessage message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


- (BOOL)checkIfValid
{
    BOOL isValid = YES;
    NSString * message;
    
    if (self.enteredPin.length < 6) {
        isValid = NO;
        message = @"Enter a valid pincode";
    }
    else if (self.sizeReceived.length == 0)
    {
        isValid = NO;
        message = @"Please Select Size";
    }
//    else if (self.startDate == nil)
//    {
//        message = @"Please Select Delivery Dates";
//        isValid = NO;
//    }
    
    if (!isValid) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    return isValid;
}

- (NSString *)getStringForRow:(NSInteger)row
{
    NSString *rowName = @"";
        switch (row)
        {
            case 0:
                rowName = kPinCodeRow;
                break;
            
            case 1:
                if (productSizeArray.count>0 && ![productSizeArray containsObject:@"free size"]){
                    rowName = KSizeRow ;
                }
                else{
                    rowName = kRentalPerioRow;
                }
                break;
                
//            case 2:
//                if (productSizeArray.count>0 && ![productSizeArray containsObject:@"free size"]){
//                     rowName = kRentalPerioRow;
//                 }
//                else{
//                    rowName = kDeliveryDateRow;
//                }
//                break;
//            case 3:
//                if (productSizeArray.count>0 && ![productSizeArray containsObject:@"free size"]){
//                    rowName = kDeliveryDateRow;
//                }
//                else if (self.startDate){
//                    rowName = kPickUpDateRow;
//                }
//                break;
//            case 4:
//                if (productSizeArray.count>0 && ![productSizeArray containsObject:@"free size"]){
//                    rowName = kPickUpDateRow;
//                }
//                else{
//                  rowName = kPickUpTextRow;
//                }
//                break;
//            case 5:
//                    rowName = kPickUpTextRow;
//                break;
            default:
                break;
        }
       return rowName;
}

#pragma mark Table View Data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.callInProgress) {
        return 0;
    }
//    int x = ((![productSizeArray containsObject:@"free size"]) ? 3 : 2) + ((self.startDate) ? 2 : 0) + 1 ;
    int x = ((![productSizeArray containsObject:@"free size"]) ? 2 : 1);
    rowCount = x;
    return x;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rowName = [self getStringForRow:indexPath.row];
    
    if ([rowName isEqualToString:KSizeRow])
    {
        DeliveryDateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"sizeCell"];
        if (!cell)
        {
            cell = [[DeliveryDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sizeCell" andMode:selectSizeMode];
        }
        [cell updateMiddleLabelFromDetailVC:_sizeReceived];//to update middle label text from detailVC
        [cell.calenderButton addTarget:self action:@selector(sizeChartTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell updateMode:selectSizeMode];
        return cell;
    }
//    else if ([rowName isEqualToString:kRentalPerioRow])
//    {
//        RentalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rentalCell"];
//        if (!cell)
//        {
//            cell = [[RentalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rentalCell"];
//        }
//        [cell.buttonDay1 addTarget:self action:@selector(fourDayRentalTapped:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.buttonDay2 addTarget:self action:@selector(eightDayRentalTapped:) forControlEvents:UIControlEventTouchUpInside];
//        [cell updateMode:rentalCellAddToBag];
//        [_header updateHeaderPriceAsPerRentSelected:self.rentalPeriod];
//        [cell updateCellWithAppliedFilters:self.rentalPeriod];
//        return cell;
//    }
//    else if ([rowName isEqualToString:kDeliveryDateRow]) // calender cell
//    {
//        DeliveryDateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"deliveryCell"];
//        if (!cell)
//        {
//            cell = [[DeliveryDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deliveryCell" andMode:deliveryDateMode];
//        }
//        
//        [cell updateMiddleLabelFromDetailVC:[[EYUtility shared] getDateWithSuffix:self.startDate]];
//        [cell.calenderButton addTarget:self action:@selector(openCalenderController) forControlEvents:UIControlEventTouchUpInside];
//        [cell updateMode:deliveryDateMode];
//         [_header updateHeaderPriceAsPerRentSelected:self.rentalPeriod];
//        return cell;
//    }
//    
//    else if ([rowName isEqualToString:kPickUpDateRow]) // pickUpCell
//    {
//        DeliveryDateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"pickUpCell"];
//        if (!cell)
//        {
//            cell = [[DeliveryDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickUpCell" andMode:pickUpMode];
//        }
//        
//        NSDate *end = [[EYUtility shared] dateByAddingDays:self.rentalPeriod toDate:self.startDate];
//        [cell updateMiddleLabelFromDetailVC:[[EYUtility shared] getDateWithSuffix:end]];
//        [cell.calenderButton addTarget:self action:@selector(openCalenderController) forControlEvents:UIControlEventTouchUpInside];
//        
//        return cell;
//    }
//    
//    else if ([rowName isEqualToString:kPickUpTextRow]) // pickUpCell
//    {
//        PickUpDateTextCell* cell = [tableView dequeueReusableCellWithIdentifier:@"pickUpTextCell"];
//        if (!cell)
//        {
//            cell = [[PickUpDateTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickUpTextCell"];
//            
//        }
//        _footerLabel.attributedText = nil;
//        return cell;
//    }
    
    else if ([rowName isEqualToString:kPinCodeRow])
    {
        EYTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pinCodeCell"];
        if (!cell)
        {
            cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pinCodeCell"];
        }
        
        [cell setLabelText:@"Pin Code" andPlaceholderText:@"Required"];
        cell.textfield.text = _enteredPin;
        if ([[NSUserDefaults standardUserDefaults] stringForKey:kPinCodeKey]) {
            cell.textfield.enabled = NO;
        }
        [cell.rightButton addTarget:self action:@selector(buttonWhyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.textfield.delegate = self;
        cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
        cell.textfield.inputAccessoryView = self.accView;
        [cell updateTextFieldMode:addToCartVC];
        return cell;
    }
    else
    {
        NSString *cellIdentifier = @"myCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowName = [self getStringForRow:indexPath.row];
    
    [_tbView deselectRowAtIndexPath:indexPath animated:NO];
    if ([rowName isEqualToString:KSizeRow])
    {
     //open Select size view and disable other visible view
        
        [self.view endEditing:YES];

        CGRect rect = [UIScreen mainScreen].bounds;
        self.overlay = [[UIView alloc] initWithFrame:rect];
        [self.view.window addSubview:_overlay];
        
        CGRect frame = (CGRect) {0, rect.size.height, rect.size.width, 140};
        
        _bottomPopUpView = [[EYSelectSizeView alloc] initWithFrame:frame andMode:EYSelectSizeForAddToCart andArrayOfValues:productSizeArray andArrayOfValues:productSizeIdsArray];
        [_bottomPopUpView updateTagReceivedToShowSelectedSize:_buttonSizeTagForBottomPopUpView];
        _bottomPopUpView.delegate = self;
        [self.view.window addSubview:_bottomPopUpView];
        _bottomPopUpView.backgroundColor = [UIColor whiteColor];
        
        self.overlay.userInteractionEnabled = YES;
        self.overlay.alpha = 0.0;
        self.overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
      
        UITapGestureRecognizer *tapOnOverlay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnOverlaySize:)];
        [self.overlay addGestureRecognizer:tapOnOverlay];
        UIPanGestureRecognizer *panOnOverlay = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnOverlaySize:)];
        [self.overlay addGestureRecognizer:panOnOverlay];
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.overlay.alpha = 1.0;
            _bottomPopUpView.frame = (CGRect) {0.0, rect.size.height - frame.size.height, frame.size};
        } completion:^(BOOL finished)
         {
            
        }];
        
        
    }
//    else if ([rowName isEqualToString:kDeliveryDateRow])
//    {
//        [self openCalenderController];
//        [self.view endEditing:YES];
//    }
//    else if([rowName isEqualToString:kRentalPerioRow])
//    {
//        [self.view endEditing:YES];
//    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *rowName = [self getStringForRow:indexPath.row];
    
//    if ([rowName isEqualToString:kPickUpTextRow])
//    {
//        return 68;
//    }
//    else
        return 48.0;
}

#pragma mark - calender

- (void)openCalenderController
{
    if (self.calendar) {
        return;
    }
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.overlay = [[UIView alloc] initWithFrame:rect];
    [self.navigationController.view addSubview:_overlay];
    self.overlay.userInteractionEnabled = YES;
    self.overlay.alpha = 0.0;
    self.overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    
    UITapGestureRecognizer *tapOnOverlay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnOverlay:)];
    [self.overlay addGestureRecognizer:tapOnOverlay];
    UIPanGestureRecognizer *panOnOverlay = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnOverlay:)];
    [self.overlay addGestureRecognizer:panOnOverlay];
    
    self.calendar = [[ASCalendarController alloc] initWithNibName:nil bundle:nil];
    self.calendar.delegate = self;
    [self.calendar setStartDate:self.startDate numberOfDays:self.rentalPeriod];
    
    CGFloat h = kHeaderButtonHeight * 9;
    CGRect frame = (CGRect) {0.0, rect.size.height + 0, rect.size.width, h};
    self.calendar.view.frame = frame;
    
    [self.navigationController addChildViewController:self.calendar];
    [self.navigationController.view addSubview:self.calendar.view];
    
    frame.origin.y = rect.size.height - h;
    [UIView animateWithDuration:0.3 animations:^{
        self.overlay.alpha = 1.0;
        self.calendar.view.frame = frame;
    } completion:^(BOOL finished) {
        [self.calendar didMoveToParentViewController:self.navigationController];
    }];
}

- (void)tapOnOverlay:(id)sender
{
    [self dismissCalendar];
}

- (void)panOnOverlay:(id)sender
{
    [self dismissCalendar];
}

- (void)tapOnOverlaySize:(id)sender
{
    [self dismissSizeSelector];
}

- (void)panOnOverlaySize:(id)sender
{
    [self dismissSizeSelector];
}

- (void)dismissSizeSelector
{
    CGRect rect = self.bottomPopUpView.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _bottomPopUpView.frame = rect;
        _overlay.alpha = 0.0;
        
    } completion:^(BOOL finished)
     {
         [self.overlay removeFromSuperview];
         self.overlay = nil;
         
         [self.bottomPopUpView removeFromSuperview];
         self.bottomPopUpView = nil;
     }];
}

- (void)dismissCalendar
{
    [self.calendar willMoveToParentViewController:nil];
    
    CGRect frame = self.calendar.view.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.view.frame = frame;
        self.overlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.calendar.view removeFromSuperview];
        [self.calendar removeFromParentViewController];
        self.calendar = nil;
        [self.overlay removeFromSuperview];
        self.overlay = nil;
    }];
}

- (void)calendar:(ASCalendarController *)cont didSelectDate:(NSDate *)date
{
    self.startDate = date;
    
    if ([_delegate respondsToSelector:@selector(updateDateFromAddToBagInFilterVC:)]) {
        [_delegate updateDateFromAddToBagInFilterVC:self.startDate];
    }
    
    [self dismissCalendar];
    [self.tbView reloadData];
}

- (void)viewTouched:(EYSelectSizeView *)view andButtonValue:(NSString*)buttonValue andTag:(NSInteger)buttonTag
{
    //Update Cell Middle label with selected Size:
    DeliveryDateTableViewCell *cell = (DeliveryDateTableViewCell*)[self.tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (!(buttonValue.length))
    {
        cell.middleLabel.text = @"Select";
        cell.middleLabel.textColor = kAppLightGrayColor;
    }
    else
    {
        cell.middleLabel.text = buttonValue ;
        cell.middleLabel.textColor = kBlackTextColor;
 
    }
    self.sizeReceived = buttonValue;
    self.buttonSizeTagForBottomPopUpView = buttonTag;
    [cell setNeedsLayout];
   
    [self dismissSizeSelector];
    
    if ([_delegate respondsToSelector:@selector(updateSizeReceivedFromBottomView:andButtonTag:)]) {
        [_delegate updateSizeReceivedFromBottomView:buttonValue andButtonTag:buttonTag];
    }
}

+ (NSAttributedString *)getAttrStr:(NSString *)mainText
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.paragraphSpacingBefore = 1.0;
    
    if (mainText.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:mainText attributes:@{
                                                                                NSFontAttributeName: AN_REGULAR(12.0),
                                                                                NSForegroundColorAttributeName : kAppLightGrayColor,
                                                                                NSParagraphStyleAttributeName : style
                                                                                }];
        [mutAttr appendAttributedString:attr];
    }

    return mutAttr;
}

- (void)fourDayRentalTapped:(id)sender
{
    self.rentalPeriod = 4;

    if ([_delegate respondsToSelector:@selector(updateRentalPeriodFromAddtoBag:)]) {
        [_delegate updateRentalPeriodFromAddtoBag:self.rentalPeriod];
    }
    [self.tbView reloadData];
}

- (void)eightDayRentalTapped:(id)sender
{
    self.rentalPeriod = 8;

    if ([_delegate respondsToSelector:@selector(updateRentalPeriodFromAddtoBag:)]) {
        [_delegate updateRentalPeriodFromAddtoBag:self.rentalPeriod];
    }
    [self.tbView reloadData];
}

#pragma mark - textfield delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentlyEditingTf = (EYAddressTextField*)textField;
    [self.accView disableAll];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor = kTextFieldTypingColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = kRowColorWhileTyping;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor =kBlackTextColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = [UIColor whiteColor];
}

-(BOOL)textFieldShouldReturn:(EYAddressTextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _enteredPin = text;
    
    return YES;
}

#pragma mark Accessory view delegates

- (void)didTapDoneButton
{
    [self.view endEditing:YES];
}

-(void)didTapCancelButton
{
    NSString *pinEnteredLast=[[NSUserDefaults standardUserDefaults] stringForKey:kPinCodeKey];
    _currentlyEditingTf.text = pinEnteredLast;
    [self.view endEditing:YES];
}

#pragma mark - notifications

- (void)shopMoreTapped:(NSNotification *)notif
{
    UIViewController *cont;
    for (UIViewController *pushedCont in self.navigationController.viewControllers) {
        if ([pushedCont isKindOfClass:[EYGridProductController class]]) {
            cont = pushedCont;
            break;
        }
    }
    if (!cont) {
        cont = self.navigationController.viewControllers[0];
    }
    [self.navigationController popToViewController:cont animated:YES];
}

- (void)viewCartTapped:(NSNotification *)notif
{
    NSArray * controllerArr = self.navigationController.viewControllers;
    NSMutableArray * controllerMutableArr = [[NSMutableArray alloc] initWithObjects:[controllerArr firstObject], nil];
    EYBagSummaryViewController *bag = [[EYBagSummaryViewController alloc] initWithNibName:nil bundle:nil];
    [controllerMutableArr addObject:bag];
    [self.navigationController setViewControllers:[[NSArray alloc] initWithArray:controllerMutableArr] animated:YES];
}

-(void)buttonWhyAction:(id)sender
{
    EYShippingTextViewController *siteInfoVc = [EYUtility instantiateViewWithIdentifier:@"siteInfoVC"];
    siteInfoVc.siteInfoMode = SiteInfoWhyMode;
    siteInfoVc.textString = [self getStringForRightButton];
    [self.navigationController pushViewController:siteInfoVc animated:YES];
}

-(NSString*)getStringForRightButton
{
    return NSLocalizedString(@"pincode_str", @"");
    /*return @"1. PINCODE helps us quickly determine the availability of the items for your shipping location\n\n2. We use PINCODE to figure out if certain locations are not supported for delivery or other locations have a faster or express shipment available.\n\n3. In case you want to change the PINCODE to check for another location, please checkout the existing items in your Bag, or clear the bag by removing the items";*/
}

#pragma mark did select row button actions

- (void)sizeChartTapped:(id)sender
{
    //Open Size Chart
}

#pragma mark - settable header -
- (void)setTableHeaderWtihLoader:(BOOL)loader
{
    if (loader) {
        [self.tbView setTableHeaderView:[[EDLoaderView alloc]init]];
    }
    else
    {
        // moved this out of view will layout because this was overriding the loader header view and footer view when we fecth details from server
        
        CGSize size = self.view.bounds.size;
        CGFloat headerHeight = [_header getHeight:size.width];
        _header.frame = CGRectMake(0, 0, size.width, headerHeight);
        self.tbView.tableHeaderView = _header;
        
        
        CGFloat availableWForFooterLabel = size.width - kProductDescriptionPadding*2;
        
        CGSize sizeOfFooterLabel = [EYUtility sizeForAttributedString:_footerLabel.attributedText width:availableWForFooterLabel];
        _footerView.frame = (CGRect){0,0,size.width,sizeOfFooterLabel.height + 80.0};
        _tbView.tableFooterView = _footerView;
        _footerLabel.frame = (CGRect){(size.width-sizeOfFooterLabel.width)/2,(_footerView.frame.size.height - sizeOfFooterLabel.height)/2,sizeOfFooterLabel};
    }
}

@end
