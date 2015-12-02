//
//  EYBagSummaryViewController.m
//  Eyvee
//
//  Created by Disha Jain on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYBagSummaryViewController.h"
#import "EYBagSummaryCell.h"
#import "EYBottomButton.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYOrderDetailCell.h"
#import "EYCustomAccessoryViewCell.h"
#import "EYGetAllProductsMTLModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYReviewOrderVC.h"
#import "EYErrorCartViewController.h"
#import "EYAllAPICallsManager.h"
#import "EYSyncCartMtlModel.h"
#import "EYCartModel.h"
#import "EYAddToBagViewController.h"
#import "EYAllAddressVC.h"
#import "EYShippingDetailsViewController.h"
#import "EYAccountController.h"
#import "EYError.h"
#import "EYUserWishlistMtlModel.h"
#import "EYWishlistModel.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"
#import "EYEmptyView.h"
#import "EDLoaderView.h"
#import "PVToast.h"

@interface EYBagSummaryViewController ()<UITableViewDataSource,UITableViewDelegate,EditBagItemDelegate,EYAccountControllerDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EYBottomButton *bottomView;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) EYSyncCartMtlModel * currentModel;

//added for locally updating the bag

@end

@implementation EYBagSummaryViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        self.title = @"Bag Summary";
        
    }
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _bottomView.hidden = YES;
    
    //viewing the products in cart locally
    
    EYSyncCartMtlModel *cartSaved =[[EYCartModel sharedManager] getCartLocally];
    if(cartSaved)
    {
        _currentModel = cartSaved;
        _bottomView.hidden = NO;

        if(_currentModel.cartProducts.count <= 0)
        {
            //no products in cart
            EYEmptyView *emptyView = [[EYUtility shared]errorViewWithText:NSLocalizedString(@"empty_cart", @"") withImage:[UIImage imageNamed:@"cart_empty_large"] andRetryBtnHidden:YES];
            [self.tableView setTableHeaderView:emptyView];
            [self.tableView setTableFooterView:nil];
            [self.tableView reloadData];
            _bottomView.hidden = YES;
        }


    }
    else
    {
        //no products in cart
        EYEmptyView *emptyView = [[EYUtility shared]errorViewWithText:NSLocalizedString(@"empty_cart", @"") withImage:[UIImage imageNamed:@"cart_empty_large"] andRetryBtnHidden:YES];
        [self.tableView setTableHeaderView:emptyView];
        [self.tableView setTableFooterView:nil];
        [self.tableView reloadData];
         _bottomView.hidden = YES;
    }

//    NSInteger cardId = [[[EYUtility shared] getCartId] integerValue];
//    if (cardId > 0) {
//        [self getCartItems];
//    }
//    else
//    {
//        EYEmptyView *emptyView = [[EYUtility shared]errorViewWithText:NSLocalizedString(@"empty_cart", @"") withImage:[UIImage imageNamed:@"cart_empty_large"] andRetryBtnHidden:YES];
//        [self.tableView setTableHeaderView:emptyView];
//        [self.tableView setTableFooterView:nil];
//        [self.tableView reloadData];
//
//    }
    [self.view setBackgroundColor:kSectionBgColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeTableView];
}

- (void)initializeTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kSectionBgColor;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    [self.view addSubview:_tableView];
    
    _bottomView = [[EYBottomButton alloc]initWithFrame:(CGRectZero) image:@"next_btn_large" ButtonText:@"CONTINUE CHECKOUT" andFont:AN_BOLD(13.0)];
    [self.view addSubview:_bottomView];
    
    [self.bottomView addTarget:self action:@selector(continueCheckoutTapped:) forControlEvents:UIControlEventTouchUpInside];

    _footerView = [[UIView alloc]initWithFrame:CGRectZero];
    _footerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _footerLabel.attributedText = [self getAttributedTextForFooterLabel];
    [self.footerView addSubview:_footerLabel];
    _footerView.backgroundColor = kSectionBgColor;
    _footerLabel.textColor = kAppLightGrayColor;
    self.view.backgroundColor = kSectionBgColor;
    
    [self.view layoutIfNeeded];
}

- (void)updateRequestStateChanged
{
    [self setUpUIAsPerUpdateRequestState];
}

- (void)getCartItemsFromServer
{
    self.tableView.tableHeaderView = [[EDLoaderView alloc] init];
    //[self.tableView setTableHeaderView:[self loader]];
    [self.tableView setTableFooterView:nil];
    _currentModel = nil;
    [self.tableView reloadData];
    
    NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    
    NSString * userId = userIdStr?userIdStr:@"-1";
    NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
    NSString * cookie = [[EYUtility shared] getCookie];    
    NSDictionary *payload = @{@"userId":userId,@"cartId": cartId,@"cookie":cookie};
    
    [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:@{@"eventId" : @(0)} withRequestPath:kSyncCartRequestPath cache:NO payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if (error) {
            
            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
            [self.tableView setTableFooterView:nil];
            _currentModel = nil;
            [self.tableView reloadData];
        }
        else
        {
            EYCartModel * cart = [EYCartModel sharedManager];
            _currentModel = (EYSyncCartMtlModel *)responseObject;
            cart.cartModel = (EYSyncCartMtlModel *)responseObject;
            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
            [self.tableView setTableFooterView:_footerView];
            [self.tableView reloadData];
        }
    }];
}

- (void)processCartResponse:(id)response error:(EYError *)error
{
    if (error) {
        [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
        [self.tableView setTableFooterView:nil];
        _currentModel = nil;
        [self.tableView reloadData];
    }
    else
    {
        _currentModel = [EYCartModel sharedManager].cartModel;
        [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
        [self.tableView setTableFooterView:_footerView];
        [self.tableView reloadData];
        
        if (_currentModel.cartProducts.count > 0) {
            _bottomView.hidden = NO;
        }
        else{
            EYEmptyView *emptyView = [[EYUtility shared]errorViewWithText:NSLocalizedString(@"empty_cart", @"") withImage:[UIImage imageNamed:@"cart_empty_large"] andRetryBtnHidden:YES];
            [self.tableView setTableHeaderView:emptyView];
        }

    }
}

- (void)getCartItems
{
    self.tableView.tableHeaderView = [[EDLoaderView alloc] init];
    //[self.tableView setTableHeaderView:[self loader]];
    [self.tableView setTableFooterView:nil];
    _currentModel = nil;
    [self.tableView reloadData];
    
    __weak __typeof(self)weakSelf = self;
    
    [[EYCartModel sharedManager] getCartItemsWithCompletionBlock:^(id responseObject, EYError *error) {
        [weakSelf processCartResponse:responseObject error:error];
    }];
}

-(void)setUpUIAsPerUpdateRequestState
{
    EYCartModel * mngr = [EYCartModel sharedManager];
    switch (mngr.cartRequestState) {
        case cartRequestInProcess:
        {
            self.tableView.tableHeaderView = [[EDLoaderView alloc] init];
            //[self.tableView setTableHeaderView:[self loader]];
            [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
            _currentModel = nil;
            [self.tableView reloadData];
            
        }
            break;
        case cartRequestReceieved:
        {
            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
            [self.tableView setTableFooterView:_footerView];
            
            EYCartModel * cart = [EYCartModel sharedManager];
            _currentModel = cart.cartModel;
            [self.tableView reloadData];
            
        }
            break;
        case cartRequestError:
        {
            //self.tableView.tableHeaderView = [self errorViewWithText:NSLocalizedString(@"defaultError_msg", @"")];
            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
            [self.tableView setTableFooterView:nil];
            _currentModel = nil;
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
    
}

//- (UIView *)loader
//{
//    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EYLoaderView" owner:self options:nil];
//    UIView *loaderView = [nibObjects objectAtIndex:0];
//    return loaderView;
//}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //Table View
    CGSize size = self.view.bounds.size;
    
    _bottomView.frame = (CGRect){0,size.height - kBottomBarHeight,size.width,kBottomBarHeight};
    
    _tableView.frame = CGRectMake(0, 0, size.width, size.height - _bottomView.frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    
    _tableView.tableHeaderView = view;

    NSAttributedString *attr = [self getAttributedTextForFooterLabel];
    
    CGSize sizeOfFooterLabel = [EYUtility sizeForAttributedString:attr width:size.width-2*kProductDescriptionPadding];
    
    _footerView.frame = (CGRect){0,0,size.width,12.0+sizeOfFooterLabel.height+kProductDescriptionPadding};

    _tableView.tableFooterView = _footerView;
    
    _footerLabel.frame = (CGRect){kProductDescriptionPadding,12.0,sizeOfFooterLabel};
    _footerLabel.numberOfLines = 0;
   
    
}

#pragma mark - UItableViewe Datasource and Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return number of products in bag +1;
    if (_currentModel)
        return (_currentModel.cartProducts.count > 0) ? _currentModel.cartProducts.count + 1 : 0;
    else
        return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentModel)
    {
        if (section == _currentModel.cartProducts.count)
        {
            return 1;
        }
        else
            return 1;
    }
    else
        return  0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _currentModel.cartProducts.count)
    {
            NSString *cellIdentifier = @"orderDetailsCell";
            
            EYOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[EYOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withMode:EYBagSummaryLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
               
            }
             [cell updateCellDataWithLeftLabel:@"Subtotal" andRightLabel:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[_currentModel.totalAmountPayable floatValue]]] andMode:EYBagSummaryLabel];
            return cell;
        
    }
    else
    {
        NSString *identifier = @"bagCell";
        EYBagSummaryCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        EYSyncCartProductDetails * product = [_currentModel.cartProducts objectAtIndex:indexPath.section];
        if (!cell)
        {
            cell = [[EYBagSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setCurrentProduct:product];

        return cell;

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentModel) {
        
        if (indexPath.section != _currentModel.cartProducts.count)
        {
            EYSyncCartProductDetails * product = [_currentModel.cartProducts objectAtIndex:indexPath.section];
            return [EYBagSummaryCell requiredHeightForRowWithCartObject:product andTotalWidth:self.view.frame.size.width];
        }
        else
        {
//            if (indexPath.row == 0) //have a promo code cell
//            {
//                return 44.0;
//            }
//            else
//            {
//                CGFloat h = [EYOrderDetailCell getHeightForCellWithLeftLabel:@"Subtotal" leftLabelFont:AN_REGULAR(20.0) rightLabelText:@"Rs 1360" rightLabelFont:AN_MEDIUM(20.0)];
                return 56.0;
            //}
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_currentModel) {
        
        if (section != _currentModel.cartProducts.count)
        {
            return 1;
        }
        else
            return 11;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    return view;
    
   /* view.backgroundColor = kSectionBgColor;
    
    if (section != _currentModel.cartProducts.count )
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0);
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectZero];
        [view addSubview:lbl];
        
        NSDictionary *dict1 = @{NSFontAttributeName : AN_BOLD(12.0),
                                NSForegroundColorAttributeName : kBlackTextColor,
                                };
        NSDictionary *dict2 = @{NSFontAttributeName : AN_REGULAR(12.0),
                                NSForegroundColorAttributeName : kBlackTextColor,
                                };
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        
        NSAttributedString *str;
        
        EYSyncCartProductDetails * product = [_currentModel.cartProducts objectAtIndex:section];
        
        if ([product.rentalType isEqualToNumber:[NSNumber numberWithInt:1]]) {
            str = [[NSAttributedString alloc] initWithString:@"RENTAL 4 DAYS / " attributes:dict1];
        }
        else
            str = [[NSAttributedString alloc] initWithString:@"RENTAL 8 DAYS / " attributes:dict1];
        [attr appendAttributedString:str];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        NSDate *startdate = [dateFormatter dateFromString:product.rentalStartDate];
        NSDate *endDate = [dateFormatter dateFromString:product.rentalEndDate];
        
        [dateFormatter setDateFormat:@"dd MMM"];
        NSString *endDateStr = [dateFormatter stringFromDate:endDate];
        NSString *startDateStr = [dateFormatter stringFromDate:startdate];
        NSString *finalDateStr = [NSString stringWithFormat:@"%@ to %@", startDateStr, endDateStr];

        str = [[NSAttributedString alloc] initWithString:finalDateStr attributes:dict2];
        [attr appendAttributedString:str];
        lbl.attributedText = attr;
        CGSize lblSize = lbl.intrinsicContentSize;
        lbl.frame = (CGRect){kProductDescriptionPadding,(44-lblSize.height)/2,lblSize};
        
        return view;
    }
    
    else
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 12.0);
        return view;
    }
    */
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(NSAttributedString*)getAttributedTextForFooterLabel
{
     NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *dict1 = @{NSFontAttributeName : AN_MEDIUM(11.0),
                            NSForegroundColorAttributeName : kAppLightGrayColor,
                            NSParagraphStyleAttributeName : style
                            };

    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Shipping is free and will be confirmed in next step.\nCurrently we only deliver in Delhi,NCR" attributes:dict1];
    [attr appendAttributedString:str];
    
    return attr;
}

- (void)editBagItemWitProductDetails:(EYSyncCartProductDetails *)product
{
//    EYAddToBagViewController *addToBagVC = [[EYAddToBagViewController alloc]initWithNibName:nil bundle:nil];
//    addToBagVC.comingFromCart = YES;
//    
//    addToBagVC.sizeReceived = product.size;
//    addToBagVC.buttonSizeTagForBottomPopUpView = [product.sizeId integerValue];
//    addToBagVC.productID = product.productId;
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDate *startDate = [dateFormatter dateFromString:product.rentalStartDate];
//    NSDate *endDate = [dateFormatter dateFromString:product.rentalEndDate];
//    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
//                                                        fromDate:startDate
//                                                          toDate:endDate
//                                                         options:NSCalendarWrapComponents];
//    addToBagVC.rentalPeriod = components.day+1;
//    addToBagVC.cartSKUId = product.cartSkuId;
//    addToBagVC.startDate = startDate;
    
    [[PVToast shared]showToastMessage:@"Disabled For Demo Version"];
    
   // [self.navigationController pushViewController:addToBagVC animated:YES];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

}
- (void)removeBagItemWitProductDetails:(EYSyncCartProductDetails *)product
{
    if ([_currentModel.cartProducts containsObject:product])
    {
        NSLog(@"Product Found in array-------@");
        NSMutableArray *copyOfProductsInBagVC = [_currentModel.cartProducts mutableCopy];
        [copyOfProductsInBagVC removeObject:product];
        _currentModel.cartProducts = copyOfProductsInBagVC;
        
        //uopdating total amount
        [[EYCartModel sharedManager] saveCartLocally:_currentModel];
        _currentModel.totalAmountPayable = [[EYCartModel sharedManager] gettingTotalAmountPayableWithCartModel:_currentModel];

        NSLog(@"_currentModel.totalAmountPayable %@",_currentModel.totalAmountPayable);
        [[EYCartModel sharedManager] saveCartLocally:_currentModel];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCartUpdatedNotification object:nil userInfo:@{@"count" : @(_currentModel.cartProducts.count)}];

        
        [self.tableView reloadData];
        
        if (_currentModel.cartProducts.count == 0)
        {
            EYEmptyView *emptyView = [self showEmptyViewWithMessage:NSLocalizedString(@"empty_cart", @"") withImage:[UIImage imageNamed:@"cart_empty_large"] andRetryBtnHidden:YES];
            [self.tableView setTableHeaderView:emptyView];
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
            [self.tableView reloadData];
            self.bottomView.hidden = YES;
 
        }
    }
//    
//    [EYUtility showHUDWithTitle:@"Removing"];
//    
//    [[EYCartModel sharedManager] operationsOnCart:@{@"eventId":@"3",@"cartSkuId":product.cartSkuId} requestPath:@"updateCart.json?" withCompletionBlock:^(id responseObject, EYError *error) {
//        
//        [EYUtility hideHUD];
//        if (!error) {
//            _currentModel = (EYSyncCartMtlModel *)responseObject;
//            EYCartModel * cartModel = [EYCartModel sharedManager];
//            cartModel.cartModel = (EYSyncCartMtlModel *)responseObject;
//            [self.tableView reloadData];
//            if (cartModel.cartModel.cartProducts.count == 0) {
//                [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:kCartIdKey];
//                [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:kPinCodeKey];
//
//                EYEmptyView *emptyView = [self showEmptyViewWithMessage:NSLocalizedString(@"empty_cart", @"") withImage:[UIImage imageNamed:@"cart_empty_large"] andRetryBtnHidden:YES];
//                [self.tableView setTableHeaderView:emptyView];
//                    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
//                    [self.tableView reloadData];
//                    self.bottomView.hidden = YES;
//                }
//            }
//        else
//            [EYUtility showAlertView:error.errorMessage];            
//    }];
}


#pragma mark Continue Checkout -
-(void)continueCheckoutTapped:(id)sender
{
    if (_currentModel.cartProducts == 0) {
        return;
    }
    if ([[EYAccountManager sharedManger] isUserLoggedIn] == NO)
    {
        
        EYAccountController *accCont = [EYUtility instantiateViewWithIdentifier:@"EYAccountController"];
        accCont.currentMode = kSignupMode;
        accCont.cartModel = _currentModel;
        accCont.delegate = self;
        [self.navigationController pushViewController:accCont animated:YES];
    }
    else
    {
        
        EYShippingAddressMtlModel * localAddress = [[EYUtility shared] getUserAddressModel];
        
        if (localAddress) {
            EYReviewOrderVC *review = [[EYReviewOrderVC alloc] initWithNibName:nil bundle:nil];
            _currentModel.cartAddress = localAddress;
            review.cartModel = _currentModel;
            [self.navigationController pushViewController:review animated:YES];
        }
        else
        {
            EYShippingDetailsViewController *shippingVC = [[EYShippingDetailsViewController alloc]initWithNibName:nil bundle:nil];
            shippingVC.cartModel = _currentModel;
            shippingVC.comingFromMode = comingFromBagMode;
            [self.navigationController pushViewController:shippingVC animated:YES];
        }
    }
}


#pragma mark EYAccountControllerDelegate

- (void)userSignUpSuccessful
{
    [self.navigationController popViewControllerAnimated:YES];

//    [self fetchUserAddressesAndPushRequiredController];
}

- (void)fetchUserAddressesAndPushRequiredController
{
    [EYUtility showHUDWithTitle:@"Fetching Addresses"];
    
    [[EYAllAPICallsManager sharedManager] getAllUserAddressesRequestWithParameters:nil withRequestPath:kGetAllUserAddressesRequestPath shouldCache:NO withCompletionBlock:^(id responseObject, EYError *error) {
        [EYUtility hideHUD];
        if (!error)
        {
            EYAllAddressMtlModel * addressModl = (EYAllAddressMtlModel *)responseObject;
            if (addressModl.allAdrresses.count > 0)
            {
                _currentModel.cartAddress = [addressModl.allAdrresses firstObject];
                EYReviewOrderVC *review = [[EYReviewOrderVC alloc] initWithNibName:nil bundle:nil];
                review.cartModel = _currentModel;
                [self.navigationController pushViewController:review animated:YES];
            }
            else
            {
                                    NSLog(@"EYShippingDetailsViewController fetchuser");
                EYShippingDetailsViewController *shippingVC = [[EYShippingDetailsViewController alloc]initWithNibName:nil bundle:nil];
                shippingVC.cartModel = _currentModel;
                [self.navigationController pushViewController:shippingVC animated:YES];
            }
        }
        else
        {
            [EYUtility showAlertView:error.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)syncCartWithCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;
{
    EYCartModel * localModel = [EYCartModel sharedManager];
    
    NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    
    NSString * userId = userIdStr?userIdStr:@"-1";
    NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
    NSString * cookie = [[EYUtility shared] getCookie];
    
    NSDictionary *payload = @{@"userId":userId,@"cartId": cartId,@"cookie":cookie};
    
    [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:@{@"eventId" : @(0)} withRequestPath:kSyncCartRequestPath cache:NO payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        if (!error) {
            EYSyncCartMtlModel * model = (EYSyncCartMtlModel *)responseObject;
            if (model.cartProducts.count == localModel.cartModel.cartProducts.count) {
                completionBlock(YES,nil);
            }
            else
            {
                completionBlock(NO,nil);
            }
        }
        else
        {
            completionBlock(NO,error);
            
        }
    }];
}

- (EYEmptyView *)showEmptyViewWithMessage:(NSString *)messageText withImage:(UIImage *)image andRetryBtnHidden:(BOOL)hidden
{
    CGSize size = self.view.bounds.size;
    EYEmptyView *emptyView = [[EYUtility shared] errorViewWithText:messageText withImage:image andRetryBtnHidden:hidden];
    emptyView.frame = (CGRect){0.0,64.0,size.width, size.height-kTabBarHeight};
    return emptyView;
}


@end
