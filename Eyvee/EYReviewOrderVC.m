//
//  EYReviewOrderVC.m
//  Eyvee
//
//  Created by Disha Jain on 18/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYReviewOrderVC.h"
#import "EYBottomButton.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYOrderDetailCell.h"
#import "EYCustomAccessoryViewCell.h"
#import "EYSyncCartMtlModel.h"
#import "EYPaymentOptionsController.h"
#import "EYThankyouViewController.h"
#import "EYAllAPICallsManager.h"
#import "EYAccountController.h"
#import "EYShippingDetailsViewController.h"
#import "EYAllAddressVC.h"
#import "EYPromoCodeViewController.h"
#import "EYCartModel.h"
#import "EYAttributedLabelsCell.h"
#import "EYError.h"
#import "EYAllAPICallsManager.h"
#import "EYUserDetailsVC.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"
#import "EYAccountManager.h"

@interface EYReviewOrderVC ()<UITableViewDataSource,UITableViewDelegate, EYPromoCodeViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) EYBottomButton *bottomView;
@property (nonatomic, strong) NSString *accessoryCellText;
@end

@implementation EYReviewOrderVC

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        self.title = @"Review Your Order";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[EYUtility shared] saveUserAddressWithModel:_cartModel.cartAddress];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kSectionBgColor;
    self.tableView.tableHeaderView = [self headerView];
    self.view.backgroundColor = kSectionBgColor;
    [self.view addSubview:_tableView];
    
    _bottomView = [[EYBottomButton alloc]initWithFrame:(CGRectZero) image:@"next_btn_large" ButtonText:@"PROCEED TO PAYMENT" andFont:AN_BOLD(13.0)];
    [self.view addSubview:_bottomView];
    
    [_bottomView addTarget:self action:@selector(proceedToPaymentTapped:) forControlEvents:UIControlEventTouchUpInside];
   
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //Table View
    CGSize size = self.view.bounds.size;
    
    _bottomView.frame = (CGRect){0,size.height - kBottomBarHeight,size.width,kBottomBarHeight};
    
    _tableView.frame = CGRectMake(0, 0, size.width, size.height - _bottomView.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableArray * controllerArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController * controller in controllerArr) {
        if ([controller isKindOfClass:[EYShippingDetailsViewController class]]) {
            [controllerArr removeObject:controller];
            break;
        }
    }
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

#pragma mark - UItableview delegates and datasource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1)
    {
        return 1.0;
    }
    else if (section == 2)
    {
        return self.cartModel.promoCodes.count+1;
    }
    else
        return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *cellIdentifier = @"orderCell";
        
        EYCustomAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[EYCustomAccessoryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier rowText:@"" andAccessoryViewType:imageView andMode:EYCustomAccessoryViewCellTypeDefault];
        }
       
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentLeft;
        
        NSDictionary *dict1 = @{NSFontAttributeName : AN_MEDIUM(15.0),
                                NSForegroundColorAttributeName : kBlackTextColor,
                                NSParagraphStyleAttributeName : style
                                };
        
        NSDictionary *dict2 = @{NSFontAttributeName : AN_REGULAR(15.0),
                                NSForegroundColorAttributeName : kRowLeftLabelColor,
                                NSParagraphStyleAttributeName : style
                                };
        
        NSString * itemText;
        if (_cartModel.cartProducts.count == 1)
            itemText = @"Item";
        else
            itemText = @"Items";
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu %@, ",(unsigned long)_cartModel.cartProducts.count,itemText] attributes:dict1];
        [attr appendAttributedString:str];
        
       
        
        str = [[NSAttributedString alloc]initWithString: [[EYUtility shared]getCurrencyFormatFromNumber:[_cartModel.totalAmountPayable floatValue]] attributes:dict2];
        [attr appendAttributedString:str];
        
        [cell populateCellWithAttributedText:attr];
        [cell setImageAsPerCellType:EYCustomAccessoryViewCellTypeDefault];

        return cell;
    }
    else if (indexPath.section == 1)
    {
      
            NSString *cellIdentifier = @"shippingToAddressCell";
            
            EYCustomAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                
                cell = [[EYCustomAccessoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier rowText:@"shippingToAddressCell" andAccessoryViewType:imageView andMode:EYCustomAccessoryViewCellTypeDefault];
            }
            
           NSAttributedString *str = [self getAttributedStringForShippingCell];
            [cell populateCellWithAttributedText:str];
            [cell setImageAsPerCellType:EYCustomAccessoryViewCellTypeDefault];
            return cell;
    }
    else if (indexPath.section == 2)
    {
        NSString *identifier = @"offerCell";
        
       
        if (self.cartModel.promoCodes.count)
        {
            if (indexPath.row == self.cartModel.promoCodes.count)
            {
                EYCustomAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell)
                {
                    cell = [[EYCustomAccessoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier rowText:@"" andAccessoryViewType:imageView andMode:EYCustomAccessoryViewCellPromo];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSDictionary *dict = @{NSFontAttributeName : AN_MEDIUM(12.0),
                                       NSForegroundColorAttributeName : kBlackTextColor};
                
                NSAttributedString *attr;
                attr = [[NSAttributedString alloc]initWithString:@"ADD ANOTHER OFFER CODE" attributes:dict];
                [cell populateCellWithAttributedText:attr];
                [cell setImageAsPerCellType:EYCustomAccessoryViewCellPromo];
                return cell;
            }
            else
            {
                EYCustomAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell)
                {
                    cell = [[EYCustomAccessoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier rowText:@"" andAccessoryViewType:imageView andMode:EYCustomAccessoryViewCellPromoApplied];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSDictionary *dict = @{NSFontAttributeName : AN_MEDIUM(12.0),
                                       NSForegroundColorAttributeName : kBlackTextColor};
                
                NSAttributedString *attr;
                NSDictionary *promoCodeDict = self.cartModel.promoCodes[indexPath.row];
                NSString *promoCodeName=[promoCodeDict objectForKey:@"promoCodeName"];
//                NSCharacterSet *nonNumbericCharacterSet = [[NSMutableCharacterSet decimalDigitCharacterSet] invertedSet];
//                NSString *discountstr = [[promoCodeName componentsSeparatedByCharactersInSet:nonNumbericCharacterSet] componentsJoinedByString:@""];
                attr = [[NSAttributedString alloc]initWithString:promoCodeName attributes:dict];
                [cell populateCellWithAttributedText:attr];
                [cell setImageAsPerCellType:EYCustomAccessoryViewCellPromoApplied];
                return cell;
  
            }
        }
        
        else
        {
            EYCustomAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYCustomAccessoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier rowText:@"" andAccessoryViewType:imageView andMode:EYCustomAccessoryViewCellPromo];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSDictionary *dict = @{NSFontAttributeName : AN_MEDIUM(12.0),
                                   NSForegroundColorAttributeName : kBlackTextColor};
            
            NSAttributedString *attr;
            attr = [[NSAttributedString alloc]initWithString:@"HAVE AN OFFER/PROMO CODE?" attributes:dict];
            [cell populateCellWithAttributedText:attr];
            [cell setImageAsPerCellType:EYCustomAccessoryViewCellPromo];
            return cell;
        }
    }
    else if (indexPath.section ==3)
    {
            NSString *cellIdentifier = @"subtotalCell";
            
            EYAttributedLabelsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[EYAttributedLabelsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        
        [cell setLeftLabelAttributedText:[self getAttributedStringForLeftText]];
        [cell setRightLabelAttributedText:[self getAttributedStringForRightText]];
        
            return cell;

        }

    else
    {
        NSString *cellIdentifier = @"finalSubtotalCell";
        
        EYOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[EYOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withMode:EYReviewOrderLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
         [cell updateCellDataWithLeftLabel:@"Total" andRightLabel:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[_cartModel.totalAmountPayable floatValue]]] andMode:EYReviewOrderLabel];
        return cell;
    }
 
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0)];
        view.backgroundColor = kSectionBgColor;
    
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,0, 0)];
        lbl.font = AN_BOLD(12.0);
        lbl.textColor = kBlackTextColor;
        [view addSubview:lbl];
    
        if (section == 0)
        {
            view.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0);
            lbl.frame = CGRectMake(kProductDescriptionPadding, 0, self.view.frame.size.width-kProductDescriptionPadding, 44.0);
            lbl.text = @"ORDER";
        }
        else if (section == 1)
        {
            view.frame = CGRectMake(0, 0, self.view.frame.size.width, 51.0);
             lbl.text = @"SHIPPING TO";
            CGSize lblSize = lbl.intrinsicContentSize;
            lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height - 12.0),lblSize};
           
        }
        else
        {
             view.frame = CGRectMake(0, 0, self.view.frame.size.width, 11.0);
        }
        return view;
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0  )
    {
        return 44.0;
    }
    else if (section == 1)
    {
        return 51.0 ;
    }
    else
        return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        
        NSAttributedString *str = [self getAttributedStringForShippingCell];
        return [EYCustomAccessoryViewCell requiredHeightForCellWithAttributedText:str andCellWidth:self.view.frame.size.width andMode:EYCustomAccessoryViewCellTypeDefault];
    }
    else if (indexPath.section == 3)
    {
        NSAttributedString *leftStr = [self getAttributedStringForLeftText];
        NSAttributedString *rightStr = [self getAttributedStringForRightText];
        return [EYAttributedLabelsCell requiredHeightForCellWithAttributedText:leftStr rightLabelText:rightStr andCellWidth:self.view.frame.size.width];
    }
    else if (indexPath.section == 0 || indexPath.section == 2)
        return 48.0;
    else
    {
        return 56.0;
    }
}

#pragma mark - string methods -

- (NSAttributedString*)getAttributedStringForShippingCell
{
    EYShippingAddressMtlModel * currentAddress = _cartModel.cartAddress;
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

-(NSAttributedString*)getAttributedStringForLeftText
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentLeft;
    
    NSDictionary *dict1 = @{NSFontAttributeName : AN_REGULAR(15.0),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style1
                            };
    
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    style2.paragraphSpacingBefore = 4.0;
    
    NSDictionary *dict2 = @{NSFontAttributeName : AN_REGULAR(15.0),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style2
                            };
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Subtotal\n" attributes:dict1];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc]initWithString:@"Shipping\n" attributes:dict2];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc]initWithString:@"Tax\n" attributes:dict2];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc]initWithString:@"Discount" attributes:dict2];
    [attr appendAttributedString:str];
    
    return attr;

}
-(NSAttributedString*)getAttributedStringForRightText
{
    NSMutableAttributedString *attrRight = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style3 = [[NSMutableParagraphStyle alloc] init];
    style3.alignment = NSTextAlignmentRight;
    
    NSDictionary *dict3 = @{NSFontAttributeName : AN_REGULAR(15.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style3
                            };
    
    NSMutableParagraphStyle *style4 = [[NSMutableParagraphStyle alloc] init];
    style4.paragraphSpacingBefore = 4.0;
    style4.alignment = NSTextAlignmentRight;
    
    NSDictionary *dict4 = @{NSFontAttributeName : AN_REGULAR(15.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style4
                            };
    
    NSAttributedString *strRight = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[[EYUtility shared]getCurrencyFormatFromNumber:[_cartModel.totalAmountPayable floatValue] ]] attributes:dict3];
    [attrRight appendAttributedString:strRight];
    
    strRight = [[NSAttributedString alloc]initWithString:@"Free\n" attributes:dict4];
    [attrRight appendAttributedString:strRight];
    
    strRight = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n",[[EYUtility shared]getCurrencyFormatFromNumber:[_cartModel.totalTax floatValue]]] attributes:dict4];
    [attrRight appendAttributedString:strRight];

    strRight = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[_cartModel.totalDiscountViaPromoCode floatValue]]] attributes:dict4];
    [attrRight appendAttributedString:strRight];
    
    
    NSLog(@"totap amount payable excluding tax : %@",_cartModel.totalAmountPayableTaxExcl);
    NSLog(@"total tax : %@",_cartModel.totalTax);
    NSLog(@"total discount via promocode : %@",_cartModel.totalDiscountViaPromoCode);
    NSLog(@"total rental price : %@",_cartModel.totalRentalPrice);
    
    
    return attrRight;
}



#pragma mark - -
-(void)proceedToPaymentTapped:(id)sender
{
    
    //locally
    
    EYPaymentOptionsController *payment = [[EYPaymentOptionsController alloc] initWithStyle:UITableViewStyleGrouped];
    payment.cartModel = _cartModel;
    [self.navigationController pushViewController:payment animated:YES];

    
    
    //_cartModel.cartAddress.addressId = nil;
//    if (!_cartModel.cartAddress.addressId || !_cartModel.cartAddress.billingAddress.addressId) {
//        [EYUtility showAlertView:@"Some mismatch happened between your shipping and billing address.Please select any other address"];
//        return;
//    }
    
//    [self updateAddressInCartWithCompletionBlock:^(bool success, EYError *error) {
//        if (!error) {
//            
//            [self validateCartWithCompletionBlock:^(bool success, EYError *error) {
//                if (!error) {
//                    
//                    EYPaymentOptionsController *payment = [[EYPaymentOptionsController alloc] initWithStyle:UITableViewStyleGrouped];
//                    payment.cartModel = _cartModel;
//                    [self.navigationController pushViewController:payment animated:YES];
//
//                    NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
//                    NSDictionary * payload = @{
//                                               @"userId": userIdStr,
//                                               @"cartId": [[EYUtility shared] getCartId],
//                                               @"paymentMode": @"Payu",
//                                               @"paymentMethod": @"COD",
//                                               @"tranactionId" : @"654321"
//                                               };
//                    [[EYAllAPICallsManager sharedManager] convertCartToOrderRequestWithParameters:nil withRequestPath:kConvertCartToOrderRequestPath payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
//                        if (error) {
//                            NSLog(@"error %@",error.errorMessage);
//                            [EYUtility showAlertView:error.errorMessage];
//                        }
//                        NSLog(@"%@",responseObject);
//                        EYThankyouViewController *tyCont = [[EYThankyouViewController alloc] initWithNibName:nil bundle:nil];
//                        [self.navigationController pushViewController:tyCont animated:YES];
//                    }];

                    
                    
//                }
//                else
//                    [EYUtility showAlertView:error.errorMessage];
//     
//            }];
//        }
//        else
//            [EYUtility showAlertView:error.errorMessage];
//        
//    }];
//
}

- (void)updateAddressInCartWithCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;
{
    
     NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    NSString * userId = userIdStr?userIdStr:@"-1";
    NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
    NSString * cookie = [[EYUtility shared] getCookie];
    

    NSDictionary *payload = @{@"userId":userId,@"cartId": cartId,@"cookie":cookie,@"shippingAddressId":_cartModel.cartAddress.addressId,@"billingAddressId":_cartModel.cartAddress.billingAddress.addressId};
    
    [EYUtility showHUDWithTitle:@"Updating Address"];
    
    [[EYCartModel sharedManager] operationsOnCart:@{@"eventId":[NSNumber numberWithInt:0]} requestPath:@"updateCart.json" payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        [EYUtility hideHUD];
        if (!error) {
            completionBlock(YES,nil);
        }
        else
            completionBlock(NO,error);
    }];
}

- (void)validateCartWithCompletionBlock:(void(^)(bool success, EYError *error))completionBlock;
{
     NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    NSString * userId = userIdStr?userIdStr:@"-1";
    NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
    NSString * cookie = [[EYUtility shared] getCookie];
    
    NSDictionary *payload = @{@"userId":userId,@"cartId": cartId,@"cookie":cookie,@"shippingAddressId":_cartModel.cartAddress.addressId,@"billingAddressId":_cartModel.cartAddress.billingAddress.addressId};
    
    [EYUtility showHUDWithTitle:@"Validating Cart"];
    NSString * pincode =  _cartModel.cartAddress.pincode;
    if (!pincode) {
//        pincode = @"122002";
        [EYUtility showAlertView:NSLocalizedString(@"empty_pincode", @"")];
    }
    [[EYCartModel sharedManager] operationsOnCart:@{@"pincode":pincode} requestPath:@"validateCart.json" payload:payload withCompletionBlock:^(id responseObject, EYError *error) {
        [EYUtility hideHUD];
        if (!error) {
            
            completionBlock(YES,nil);

            }
        else
        {
            completionBlock(NO,error);
        }
        
    }];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (indexPath.section == 1) {
        
        EYAllAddressVC * addressVc = [[EYAllAddressVC alloc] initWithNibName:nil bundle:nil];
        NSLog(@"_cart address in revieworder---- %@",_cartModel.cartAddress);
        addressVc.currentCart = _cartModel;
        addressVc.comingFromMode = comingFromReviewMode;
        [self.navigationController pushViewController:addressVc animated:YES];
    }
    
    if (indexPath.section == 2)
    {
        if (indexPath.row == self.cartModel.promoCodes.count)
        {
            EYPromoCodeViewController *promoVC = [[EYPromoCodeViewController alloc]initWithNibName:nil bundle:nil];
            promoVC.cartModelReceived = self.cartModel;
            promoVC.delegate = self;
            [self.navigationController pushViewController:promoVC animated:YES];
        }
        else
        {
            //Delete the promo Code
            NSDictionary *promoCodeDict=self.cartModel.promoCodes[indexPath.row];
            NSString *promoCodeStr= [promoCodeDict objectForKey:@"promoCodeName"];
            [self deletePromoCode:promoCodeStr];
        }
    }
}

-(void)deletePromoCode:(NSString*)promoCodeStr
{
    NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    NSString * userId = userIdStr ?userIdStr:@"-1";
    NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
    
    NSDictionary * payload = @{@"userId":userId,@"cartId":cartId};
    [EYUtility showHUDWithTitle:@"Please wait"];
    [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:@{@"eventId" : @(3),@"promoCode" : promoCodeStr} withRequestPath:kSyncCartRequestPath cache:NO payload:payload withCompletionBlock:^(id responseObject, EYError *error)
     {
         [EYUtility hideHUD];
         if (error)
         {
             [EYUtility showAlertView:error.errorMessage];
         }
         else
         {
             [EYUtility showAlertView:[NSString stringWithFormat:@"%@ deleted", promoCodeStr]];
             EYSyncCartMtlModel *cartModelResponse = (EYSyncCartMtlModel*)responseObject;
             self.cartModel.totalAmountPayable = cartModelResponse.totalAmountPayable;
             self.cartModel.totalDiscountViaPromoCode = cartModelResponse.totalDiscountViaPromoCode;
             self.cartModel.promoCodes = cartModelResponse.promoCodes;
             self.cartModel.totalAmountPayableTaxExcl = cartModelResponse.totalAmountPayableTaxExcl;
             self.cartModel.totalDiscount = cartModelResponse.totalDiscount;
             self.cartModel.totalTax = cartModelResponse.totalTax;
             [self.tableView reloadData];
         }
     }];
  
}

#pragma mark - EYPromoCodeViewControllerDelegate

- (void)promoCodeAppliedAndFinalCartObject:(EYSyncCartMtlModel *)finalModel
{
    self.cartModel.totalAmountPayable = finalModel.totalAmountPayable;
    self.cartModel.totalDiscountViaPromoCode = finalModel.totalDiscountViaPromoCode;
    self.cartModel.promoCodes = finalModel.promoCodes;
    self.cartModel.totalTax = finalModel.totalTax;
    self.cartModel.totalAmountPayableTaxExcl = finalModel.totalAmountPayableTaxExcl;
    self.cartModel.totalDiscount = finalModel.totalDiscount;
    [self.tableView reloadData];
}

#pragma mark - header view -
- (UIView *)headerView
{
    CGRect rect = (CGRect){0,0, self.view.bounds.size.width,1};
    UIView *header = [[UIView alloc]initWithFrame:rect];
    header.backgroundColor = kSectionBgColor;
    return header;
}


@end
