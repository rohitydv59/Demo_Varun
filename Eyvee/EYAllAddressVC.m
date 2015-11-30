//
//  EYAllAddressVC.m
//  Eyvee
//
//  Created by kartik shahzadpuri on 9/24/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAllAddressVC.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYOrderDetailCell.h"
#import "EYCustomAccessoryViewCell.h"
#import "EYAllAPICallsManager.h"
#import "EYShippingAddressMtlModel.h"
#import "EYShippingAddressMtlModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYReviewOrderVC.h"
#import "EYBottomButton.h"
#import "EYShippingDetailsViewController.h"
#import "EYCustomAccessoryViewCell.h"
#import "EYUtility.h"
#import "EYAccountController.h"
#import "EYUserDetailsVC.h"
#import "EYCartModel.h"
#import "EYEmptyView.h"
#import "EYError.h"
#import "EDLoaderView.h"

//check here
//#import "EYShippingAddressModel.h"
//#import "EYError.h";
@interface EYAllAddressVC ()<UITableViewDataSource,UITableViewDelegate,EYNewAddressAddedDelegate, EYCustomAccessoryViewCellDelegate>
{
    BOOL cartAddressDeleted;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EYBottomButton *bottomView;
@property (nonatomic, strong) EYEmptyView *emptyView;


@end

@implementation EYAllAddressVC

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableArray * controllerArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController * controller in controllerArr) {
        if ([controller isKindOfClass:[EYAccountController class]]) {
            [controllerArr removeObject:controller];
            break;
        }
    }
    for (UIViewController * controller in controllerArr) {
        if ([controller isKindOfClass:[EYUserDetailsVC class]]) {
            [controllerArr removeObject:controller];
            break;
        }
    }
    self.navigationController.viewControllers = [[NSArray alloc] initWithArray:controllerArr];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.comingFromMode == comingFromMeMode)
    {
        self.title = @"Shipping Address";
    }
    else
    {
        self.title = @"Select Shipping Address";
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[UIView new]];
    _tableView.backgroundColor = kSectionBgColor; //RGB(242.0, 246.0, 248.0);
    [self.view addSubview:_tableView];
    
    _bottomView = [[EYBottomButton alloc]initWithFrame:(CGRectZero) image:@"" ButtonText:@"ADD NEW ADDRESS +" andFont:AN_BOLD(13.0)];
    [self.view addSubview:_bottomView];
    _bottomView.hidden = YES;
    
    [self.bottomView addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view layoutIfNeeded];
    
    NSLog(@"_addressModl.allAdrresses count %lu ------ %@",(unsigned long)_addressModl.allAdrresses.count, _addressModl.allAdrresses);
    if (_addressModl.allAdrresses.count > 0) {
        [self.tableView reloadData];
    }
    else
        [self getAllAddressFromServer];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    //backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goBack
{
    if (cartAddressDeleted)   {
        [EYUtility showAlertView:@"Please Select or Add a New Address to go back to Review Order"];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)addNewAddress
{
    EYShippingDetailsViewController *shippingVC = [[EYShippingDetailsViewController alloc]initWithNibName:nil bundle:nil];
    shippingVC.delegate= self;
    shippingVC.comingFromReview = _comingFromReview;
    shippingVC.comingFromMode = _comingFromMode;
    shippingVC.cartModel = _currentCart;
    [self.navigationController pushViewController:shippingVC animated:YES];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
//    _bottomView.frame = (CGRect){0,size.height - kBottomBarHeight,size.width,kBottomBarHeight};
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    
//    _tableView.frame = CGRectMake(0, 0, size.width, size.height - _bottomView.frame.size.height);
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
}

- (void)getAllAddressFromServer
{
    [_tableView setTableHeaderView:[[EDLoaderView alloc] init]];

    [self performSelector:@selector(gettingAllAdressLocally) withObject:nil afterDelay:3];
//    __weak __typeof (self) weakSelf = self;
//    [[EYAllAPICallsManager sharedManager] getAllUserAddressesRequestWithParameters:nil withRequestPath:kGetAllUserAddressesRequestPath shouldCache:NO withCompletionBlock:^(id responseObject, EYError *error) {
//        [weakSelf processAllAddressWithResponseObj:responseObject andError:error];
//    }];
}

- (void)processAllAddressWithResponseObj:(id)responseObject andError:(EYError *)error
{
    if (error)
    {
        [_tableView setTableHeaderView:[self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:YES]];
    }
    else
    {
        _addressModl = (EYAllAddressMtlModel *)responseObject;
        [self checkingForAddress];
    }
    
     [_tableView reloadData];
}

-(void) gettingAllAdressLocally
{

    
    EYShippingAddressMtlModel* allAdd = [[EYUtility shared] getUserAddressModel];
    NSMutableArray * localArray = [[NSMutableArray alloc] init];
    [localArray addObject:allAdd];
    _addressModl = [[EYAllAddressMtlModel alloc] init];
    _addressModl.allAdrresses = [localArray mutableCopy];
    [self checkingForAddress];

    [_tableView reloadData];

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0)];
    view.backgroundColor = kSectionBgColor;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,0, 0)];
    lbl.font = AN_BOLD(12.0);
    lbl.textColor = kBlackTextColor;
    [view addSubview:lbl];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0);
    lbl.text = @"SAVED";
    CGSize lblSize = lbl.intrinsicContentSize;
    lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height)/2,lblSize};

    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_addressModl.allAdrresses.count > 0) ? 1 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  _addressModl.allAdrresses.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"savedAddressCell";
    
    EYCustomAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        
        cell = [[EYCustomAccessoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier rowText:@"shippingToAddressCell" andAccessoryViewType:imageView andMode:(_comingFromMode == comingFromMeMode) ? EYCustomAccessoryViewCellTypeFromMe : EYCustomAccessoryViewCellTypeAddressList];
    }
    
    cell.delegate = self;
    cell.tag = indexPath.row;
    EYShippingAddressMtlModel *model = _addressModl.allAdrresses[indexPath.row];
    NSLog(@"passed model is %@",model);
    NSAttributedString *str = [self getAttributedStringForShippingCellForAddressModel:model];
    [cell populateCellWithAttributedText:str];
//    [cell setImageAsPerCellType:(_comingFromMode == comingFromMeMode) ? EYCustomAccessoryViewCellTypeFromMe : EYCustomAccessoryViewCellTypeAddressList];
    return cell;
}

- (NSAttributedString*)getAttributedStringForShippingCellForAddressModel:(EYShippingAddressMtlModel *)currentAddress
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    style2.alignment = NSTextAlignmentLeft;
    style2.paragraphSpacingBefore = 4.0;
    
    
    NSDictionary *dict1 = @{NSFontAttributeName : AN_MEDIUM(15.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style
                            };
    
    NSDictionary *dict2 = @{NSFontAttributeName : AN_REGULAR(15.0),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style2
                            };
    
    NSDictionary *dict3 = @{NSFontAttributeName : AN_REGULAR(15.0),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style
                            };
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,",currentAddress.fullName] attributes:dict1];
    [attr appendAttributedString:str];
    
    if (currentAddress.contactNum.length > 0)
    {
        str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,",currentAddress.contactNum] attributes:dict3];
        [attr appendAttributedString:str];
        
    }
    str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@,%@\n%@-%@\n%@,%@",currentAddress.addressLine1,currentAddress.addressLine2,currentAddress.cityName,currentAddress.pincode,currentAddress.stateName,currentAddress.countryName] attributes:dict2];
    
    [attr appendAttributedString:str];
    return attr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     EYShippingAddressMtlModel * currentAddress = [_addressModl.allAdrresses objectAtIndex:indexPath.row];
    NSAttributedString *str = [self getAttributedStringForShippingCellForAddressModel:currentAddress];
    return [EYCustomAccessoryViewCell requiredHeightForCellWithAttributedText:str andCellWidth:self.view.frame.size.width andMode:EYCustomAccessoryViewCellTypeAddressList];
}

- (void)newAddressAddedDelegateWithAllAddressModel:(EYAllAddressMtlModel *)allAddresses
{
    NSMutableArray *newAddresses =[allAddresses.allAdrresses mutableCopy];
    
    //add all old addresses in newAddresses array to create new list;
    for (EYShippingAddressMtlModel *shipModel in _addressModl.allAdrresses)
    {
        [newAddresses addObject:shipModel];
    }
    _addressModl.allAdrresses = newAddresses;
    
    _addressModl = allAddresses;
    [self checkingForAddress];
    [_tableView reloadData];
}

- (void)editAddressAtIndex:(NSInteger)index
{
    NSLog(@"EYShippingDetailsViewController editAddressAtIndex");
    if (self.comingFromMode == comingFromBagMode || self.comingFromMode == comingFromReviewMode)
    {
        EYShippingDetailsViewController *shippingVC = [[EYShippingDetailsViewController alloc]initWithNibName:nil bundle:nil];
        _currentCart.cartAddress = _addressModl.allAdrresses[index];
        shippingVC.addressModel = _addressModl.allAdrresses[index];
        shippingVC.cartModel = _currentCart;
        shippingVC.delegate= self;
        shippingVC.updateAddress = YES;
        shippingVC.comingFromMode = self.comingFromMode;
        [self.navigationController pushViewController:shippingVC animated:YES];
    }
    else
    {
        EYShippingDetailsViewController *shippingVC = [[EYShippingDetailsViewController alloc]initWithNibName:nil bundle:nil];
        shippingVC.addressModel = _addressModl.allAdrresses[index];
        shippingVC.delegate= self;
        shippingVC.updateAddress = YES;
        shippingVC.comingFromMode = comingFromMeMode;
        [self.navigationController pushViewController:shippingVC animated:YES];
    }
  
}
- (void)removeAddressAtIndex:(NSInteger)index
{
    [EYUtility showHUDWithTitle:@"Loading"];
    NSDictionary * parameter = @{@"isDeleted":@"true"};
    EYShippingAddressMtlModel *model = _addressModl.allAdrresses[index];
    [[EYAllAPICallsManager sharedManager] updateAddressRequestWithParameters:parameter withRequestPath:@"updateUserAddress.json" payload:@[@{@"addressId":model.addressId}]  withCompletionBlock:^(id responseObject, EYError *error) {
        [EYUtility hideHUD];
        if (!error)
        {
            _addressModl = (EYAllAddressMtlModel *)responseObject;
            [self checkingForAddress];
            [_tableView reloadData];
            
            [[EYUtility shared] checkAndDeleteUserAddressModelForAddress:model];
            
            if (_currentCart) {
                if ([model.addressId isEqualToNumber:_currentCart.cartAddress.addressId]) {
                    cartAddressDeleted = YES;
                    _currentCart.cartAddress = nil;
                    [[EYUtility shared] deleteUserAddressModel];
                }
            }
            else
            {
                EYCartModel * cartModel = [EYCartModel sharedManager];
                if (cartModel.cartModel) {
                    
                    if (cartModel.cartModel.cartAddress) {
                        if ([model.addressId isEqualToNumber:cartModel.cartModel.cartAddress.addressId]) {
                            cartModel.cartModel.cartAddress = nil;
                            [[EYUtility shared] deleteUserAddressModel];
                        }
                    }
                }
            }
        }
        else
        {
            
        }
    }];
}
- (void)selectAddressAtIndex:(NSInteger)index
{
//    if (_comingFromReview) {
//        
//        _currentCart.cartAddress = address;
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        EYShippingAddressMtlModel * currentAddress = address;
//        _currentCart.cartAddress = currentAddress;
//        EYReviewOrderVC *review = [[EYReviewOrderVC alloc] initWithNibName:nil bundle:nil];
//        review.cartModel = _currentCart;
//        [self.navigationController pushViewController:review animated:YES];
//        
//    }
    
    if (_comingFromMode == comingFromReviewMode) {
        
        _currentCart.cartAddress = _addressModl.allAdrresses[index];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(_comingFromMode == comingFromBagMode)
    {
        EYShippingAddressMtlModel * currentAddress = _addressModl.allAdrresses[index];
        _currentCart.cartAddress = currentAddress;
        EYReviewOrderVC *review = [[EYReviewOrderVC alloc] initWithNibName:nil bundle:nil];
        review.cartModel = _currentCart;
        [self.navigationController pushViewController:review animated:YES];
    }
}

-(void) checkingForAddress
{
    if (self.emptyView)
    {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
    
    if (_addressModl.allAdrresses.count <= 0)
    {
        [_tableView setTableHeaderView:[self showEmptyViewWithMessage:NSLocalizedString(@"empty_addressList", @"") withImage:nil andRetryBtnHidden:YES]];
    }
    else
    {
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
    }
}



- (EYEmptyView *)showEmptyViewWithMessage:(NSString *)messageText withImage:(UIImage *)image andRetryBtnHidden:(BOOL)hidden
{
    if (!self.emptyView){
        self.emptyView = [[EYUtility shared] errorViewWithText:messageText withImage:image andRetryBtnHidden:hidden];
        self.emptyView.frame = CGRectZero;
    }
    return self.emptyView;
}

@end
