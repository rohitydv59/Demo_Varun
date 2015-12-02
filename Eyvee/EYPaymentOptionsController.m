//
//  EYPaymentOptionsController.m
//  Eyvee
//
//  Created by Neetika Mittal on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYPaymentOptionsController.h"
#import "EYPaymentOptionCell.h"
#import "EYUtility.h"
#import "EYConstant.h"
#import "EYUserCardDetailsCell.h"
#import "WPKeyboardAccessoryView.h"
#import "WPPickerView.h"
#import "NSString+validation.h"
#import "EYPaymentHeaderView.h"
#import "EYSaveCardCell.h"
#import "PayUData.h"
#import "EYPayUResponseMtlModel.h"
#import "EYPaymentWebController.h"
#import "WPTickButton.h"
#import "EYSyncCartMtlModel.h"
#import "EYCustomAccessoryViewCell.h"
#import "TableViewCellWithSeparator.h"
#import "EYNetBankingListViewController.h"
#import "EDKeyboardAccessoryView.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"
#import "EYMonthYearPicker.h"
#import "EDLoaderView.h"
#import "PVToast.h"

typedef enum {
    PaymentOptionNone = 4,
    PaymentOptionCreditCard = 0,
    PaymentOptionDebitCard = 1,
    PaymentOptionNetbanking = 2,
    PaymentOptionCOD = 3,
    PaymentOptionStoredCards = 5
}PaymentOption;

@interface EYPaymentOptionsController () <EDKeyboardAccessoryViewDelegate, UITextFieldDelegate, WPPickerDelegate> {
    BOOL _shouldShowStoredCards,apiInProgress;
}

@property (nonatomic, assign) PaymentOption optionSelected;
//@property (nonatomic, strong) WPKeyboardAccessoryView *accView;
@property (nonatomic, strong) EDKeyboardAccessoryView *accView;
@property (nonatomic, strong) UITextField *currentlyEditingTf;
@property (nonatomic, strong) WPPickerView *picker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) EYPaymentHeaderView *headerView;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSDate *expiryDate;
@property (nonatomic, strong) NSString *cvv;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) EYPayUResponseMtlModel *allOptions;
@property (nonatomic, strong) PayUData *data;
@property (nonatomic, strong) NSArray *topFiveNetBanks;
@property (nonatomic, strong) EYMonthYearPicker *noDatepicker;
@end

@implementation EYPaymentOptionsController

static NSString *identifier = @"EYPaymentOptionCell";
static NSString *cardIdentifier = @"EYUserCardDetailsCell";
static NSString *saveCardIdentifier = @"EYSaveCardCell";
static NSString *netBankingCellIdentifier = @"NetbankingCell";

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Pay & Finish";
    self.optionSelected = PaymentOptionNone;
    
    [self.tableView registerClass:[EYPaymentOptionCell class] forCellReuseIdentifier:identifier];
    [self.tableView registerClass:[EYUserCardDetailsCell class] forCellReuseIdentifier:cardIdentifier];
    [self.tableView registerClass:[EYSaveCardCell class] forCellReuseIdentifier:saveCardIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:netBankingCellIdentifier];
    [self.tableView registerClass:[TableViewCellWithSeparator class] forCellReuseIdentifier:netBankingCellIdentifier];

    self.accView = [[EDKeyboardAccessoryView alloc]initWithFrame:(CGRect) {0.0, 0.0, 0.0, kKeyboardAccessoryHeight} andMode:EDDoneButtonOnly];
    self.accView.delegate = self;
    
//    self.picker = [[WPPickerView alloc] initWithFrame:(CGRect) {0.0, 0.0, 0.0, kPickerDefaultHeight} currentDate:[NSDate date] minDate:nil maxDate:nil];
//    self.picker.delegate = self;
    self.noDatepicker = [[EYMonthYearPicker alloc]initWithFrame:(CGRect) {0.0, 0.0, self.view.frame.size.width, kPickerDefaultHeight}];
    self.noDatepicker.datePickerMode = EYMonthYearPickerModeMonthAndYear;
    self.noDatepicker.minimumDate = [NSDate date];
    [self.noDatepicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.tableView.backgroundColor = kSectionBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[EDLoaderView alloc]init];
    //self.tableView.tableHeaderView = [self loader];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.view.backgroundColor = kSectionBgColor;
    [self makeApiCall];
}


- (void)makeApiCall
{
    apiInProgress = YES;
    PayUData *payment = [[PayUData alloc] init];
    payment.totalAmount = [_cartModel.totalAmountPayable floatValue];
    payment.productInfo = @"product";
    payment.firstName = [EYAccountManager sharedManger].loggedInUser.fullName;
    payment.email = [EYAccountManager sharedManger].loggedInUser.email;
    payment.phoneNumber = [EYAccountManager sharedManger].loggedInUser.phoneNumber;
    payment.sURL = @"http://52.88.31.116/webservices/convertCartToOrderPayu.json?res=200";
    payment.fURL = @"http://52.88.31.116/webservices/convertCartToOrderPayu.json?res=300";
    payment.cUrl = @"http://52.88.31.116/webservices/convertCartToOrderPayu.json?res=100";
    payment.command = @"get_merchant_ibibo_codes";
    
    
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]; //* 1000];
    payment.transactionId = [NSString stringWithFormat:@"%@--%@",_cartModel.cartId, timestamp];
    
//    payment.totalAmount = 1240.0;
//    payment.productInfo = @"RB-dress";
//    payment.firstName = @"niteesh";
//    payment.email = @"niteeshb@gmail.com";
//    payment.phoneNumber = @"";
//    payment.sURL = @"http://www.facebook.com/";
//    payment.fURL = @"http://www.facebook.com/";
//    payment.command = @"get_merchant_ibibo_codes";
//    payment.udf1 = @"test1";
//    payment.udf2 = @"test2";
//    payment.udf3 = @"test3";
//    payment.udf4 = @"test4";
//    payment.udf5 = @"test5";
    
    self.data = payment;
    
    [payment getAllPaymentsAvailableOptionDataWithCompletionBlock:^(id responseObject, NSError *error) {
        apiInProgress = NO;
        
        if (error)
        {
            NSLog(@"Error in payu response");
        }
        else {
            self.allOptions = responseObject;
            NSLog(@"response : %@",responseObject);
            //NSDictionary *responseDict = (NSDictionary *)responseObject;
            
            NSString* filter = @"%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@|| %K CONTAINS[cd] %@ || %K CONTAINS[cd] %@ || %K CONTAINS[cd] %@";
            NSArray* args = @[@"title", @"State Bank Of India", @"title", @"HDFC",@"title",@"ICICI",@"title",@"Citi",@"title",@"Axis"];
            NSPredicate* predicate = [NSPredicate predicateWithFormat:filter argumentArray:args];
            _topFiveNetBanks =[self.allOptions.allBanks filteredArrayUsingPredicate:predicate];
            [self.tableView reloadData];
        }
        self.tableView.tableHeaderView = [self headerView];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = back;
    [self.dateFormatter setDateFormat:@"MM/YY"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getTextForPaymentOption:(PaymentOption)option
{
    NSString *text;
    switch (option) {
        case PaymentOptionCOD:
            text = @"CASH ON DELIVERY";
            break;
            
        case PaymentOptionDebitCard:
            text = @"DEBIT CARD";
            break;
            
        case PaymentOptionCreditCard:
            text = @"CREDIT CARD";
            break;
            
        case PaymentOptionNetbanking:
            text = @"NETBANKING";
            break;
            
        case PaymentOptionStoredCards:
            text = @"PAY VIA SAVED CARD";
            break;
            
        default:
            text = @"";
            break;
    }
    return text;
}

- (NSInteger)getSectionForPaymentOption:(PaymentOption)option
{
    NSInteger index = -1;
    switch (option) {
//        case PaymentOptionCOD:
//            index = 6;
//            break;
            
        case PaymentOptionDebitCard:
            index = 4;
            break;
            
        case PaymentOptionCreditCard:
            index = 3;
            break;
            
        case PaymentOptionNetbanking:
            index = 5;
            break;
            
        case PaymentOptionStoredCards:
            index = 2;
            break;
            
        default:
            index = -1;
            break;
    }
    if (_shouldShowStoredCards == NO) {
        index -= 1;
    }
    return index;
}

- (PaymentOption)mapIndexToPaymentOption:(NSInteger)index
{
    PaymentOption option;
    if (_shouldShowStoredCards) {
        switch (index) {
            case 2:
                option = PaymentOptionStoredCards;
                break;
                
            case 3:
                option = PaymentOptionCreditCard;
                break;
                
            case 4:
                option = PaymentOptionDebitCard;
                break;
                
            case 5:
                option = PaymentOptionNetbanking;
                break;
                
//            case 6:
//                option = PaymentOptionCOD;
//                break;
                
            default:
                option = PaymentOptionNone;
                break;
        }
    }
    else {
        switch (index) {
            case 2:
                option = PaymentOptionCreditCard;
                break;
                
            case 3:
                option = PaymentOptionDebitCard;
                break;
                
            case 4:
                option = PaymentOptionNetbanking;
                break;
                
//            case 5:
//                option = PaymentOptionCOD;
//                break;
//                
            default:
                option = PaymentOptionNone;
                break;
        }
    }
    return option;
}

- (NSInteger)getNumberOfRowsForSelectedOption:(PaymentOption)option
{
    NSInteger count = 0;
    switch (option) {
//        case PaymentOptionCOD:
//            count = 0;
//            break;
            
        case PaymentOptionDebitCard:
            count = 5;
            break;
            
        case PaymentOptionCreditCard:
            count = 5;
            break;
            
        case PaymentOptionNetbanking:
//            count = self.allOptions.allBanks.count;
            count = [_topFiveNetBanks count] + 1;
            break;
            
        case PaymentOptionStoredCards:
            count = 0;
            break;
            
        default:
            count = 0;
            break;
    }
    return count;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
//    return (_shouldShowStoredCards) ? 7 : 6 ;
    if (apiInProgress) {
        return 0;
    }
    else
        return (_shouldShowStoredCards) ? 6 : 5 ;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    return 1 + (([self getSectionForPaymentOption:self.optionSelected] == section) ? [self getNumberOfRowsForSelectedOption:self.optionSelected] : 0);
    
    if (section == 0) {
        return 1 ;
    }
    else if (section == 1)
    {
        return 0 ;
    }
    else
    {
        return 1 + (([self getSectionForPaymentOption:self.optionSelected] == section) ? [self getNumberOfRowsForSelectedOption:self.optionSelected] : 0);
 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(indexPath.section == 0 || indexPath.section == 1))
    {
        if (indexPath.row == 0)
        {
            EYPaymentOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            PaymentOption option = [self mapIndexToPaymentOption:indexPath.section];
            [cell updateLabelText:[self getTextForPaymentOption:option]];
            cell.isCellSelected = (option == self.optionSelected);
            return cell;
        }
        else if (self.optionSelected == PaymentOptionDebitCard || self.optionSelected == PaymentOptionCreditCard)
        {
            if (indexPath.row == 5)
            {
                EYSaveCardCell *cell = [tableView dequeueReusableCellWithIdentifier:saveCardIdentifier forIndexPath:indexPath];
                [cell setAmount:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[_cartModel.totalAmountPayable floatValue]]]];
                [cell.payBtn addTarget:self action:@selector(payBtnForCardTapped:) forControlEvents:UIControlEventTouchUpInside];
            
                return cell;
            }
            else
            {
                EYUserCardDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cardIdentifier forIndexPath:indexPath];
                cell.tf.inputView = nil;
                if (indexPath.row == 1)
                {
                    cell.type = UserDetailTypeNameOnCard;
                    cell.tf.text = self.name;
                    cell.tf.returnKeyType = UIReturnKeyNext;

                }
                else if (indexPath.row == 2)
                {
                    cell.type =  UserDetailTypeCardNumber;
                    cell.tf.text = self.cardNumber;

                }
                else if (indexPath.row == 3)
                {
                    cell.type =  UserDetailTypeExpiryDate;
//                    cell.tf.inputView = self.picker;
                    cell.tf.inputView = self.noDatepicker;
                    cell.tf.text = [self.dateFormatter stringFromDate:self.expiryDate];

                }
                else if (indexPath.row == 4)
                {
                    cell.type = UserDetailTypeCVV;
                    cell.tf.text = self.cvv;
                }
                cell.tf.inputAccessoryView = self.accView;
                cell.tf.tag = indexPath.row;
                cell.tf.delegate = self;
                return cell;
            }
        }
        else if (self.optionSelected == PaymentOptionNetbanking)
        {

            if (indexPath.row == self.topFiveNetBanks.count+1)
            {
                TableViewCellWithSeparator *cell = [tableView dequeueReusableCellWithIdentifier:netBankingCellIdentifier forIndexPath:indexPath];
                [cell setIsFilterMode:NO];
                [cell.productDesc setTextColor:kRowLeftLabelColor];
                [cell updateTextOfLabel:@"More Banks"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell updateCellFont:AN_REGULAR(14.0)];
                [cell updateCellFontColor:kAppGreenColor];
                return cell;
            }
            else
            {
                TableViewCellWithSeparator *cell = [tableView dequeueReusableCellWithIdentifier:netBankingCellIdentifier forIndexPath:indexPath];
                [cell setIsFilterMode:NO];
                EYPayUResponseDetailsMtlModel *mdl = self.topFiveNetBanks[indexPath.row-1];
                [cell updateTextOfLabel:mdl.title];
                [cell updateCellFont:AN_REGULAR(14.0)];
                [cell.productDesc setTextColor:kRowLeftLabelColor];
                return cell;
            }
           
        }
    }
    else
    {
        //return order detail cell;
        NSString *cellIdentifier = @"orderCell";
        
        EYCustomAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[EYCustomAccessoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier rowText:@"" andAccessoryViewType:imageView andMode:EYCustomAccessoryViewCellTypeDefault];
        }
        [cell setImageAsPerCellType:EYCustomAccessoryViewCellTypeDefault];
        
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
        
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu Items, ",(unsigned long)_cartModel.cartProducts.count] attributes:dict1];
        [attr appendAttributedString:str];
        
        str = [[NSAttributedString alloc]initWithString: [[EYUtility shared]getCurrencyFormatFromNumber:[_cartModel.totalAmountPayable floatValue]] attributes:dict2];
        [attr appendAttributedString:str];
        
        [cell populateCellWithAttributedText:attr];
        
        return cell;

    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        return 48.0;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return 46.0;
        }
        else if (self.optionSelected == PaymentOptionCreditCard || self.optionSelected == PaymentOptionDebitCard)
        {
            if (indexPath.row == 5)
            {
                return [EYSaveCardCell requiredHeightForWidth:CGRectGetWidth(tableView.frame) andText:@"All transactions done securely.You will be redirected to bank's authentication page in next step"];
            }
            else
            {
                return 48.0;
            }
        }
        else
        {
            return 48.0;
        }

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
        return;
    }
    
    if (indexPath.row > 0 && self.optionSelected != PaymentOptionNetbanking) {
        return;
    }
    else if (self.optionSelected == PaymentOptionNetbanking && indexPath.row > 0 && indexPath.row<self.topFiveNetBanks.count+1)
    {
       // EYPayUResponseDetailsMtlModel *model = self.topFiveNetBanks[indexPath.row - 1];
       // [self openNetbankingController:model];
        [[PVToast shared]showToastMessage:@"Disabled For Demo Version"];

        return;
    }
    else if (self.optionSelected == PaymentOptionNetbanking && indexPath.row == self.topFiveNetBanks.count+1)
    {
        EYNetBankingListViewController *netBankingVC = [[EYNetBankingListViewController alloc]initWithNibName:nil bundle:nil];
        netBankingVC.allBanks = self.allOptions.allBanks;
        netBankingVC.dataReceived = self.data;
        [self.navigationController pushViewController:netBankingVC animated:YES];
        return;
    }
    
    PaymentOption option = [self mapIndexToPaymentOption:indexPath.section];
    [self resetData];
    self.optionSelected = (option == self.optionSelected) ? PaymentOptionNone : option;
    self.tableView.tableHeaderView = [self headerView];
    [self.tableView reloadData];
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
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 50.0);
        lbl.text = @"SELECT PAYMENT METHOD";
        CGSize lblSize = lbl.intrinsicContentSize;
        lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height - 12.0),lblSize};
        
    }
    
    else
    {

        if (_shouldShowStoredCards)
        {
            if ((self.optionSelected == PaymentOptionCreditCard && section == 4) || (section == 5 && self.optionSelected == PaymentOptionDebitCard))
            {
                view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 11);
                 view.backgroundColor = kSectionBgColor;
            }
            else
            {
                view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 1);
                view.backgroundColor = kSectionBgColor; //[UIColor whiteColor];
            }
        }
        else
        {
            if ((self.optionSelected == PaymentOptionCreditCard && section == 3) || (section == 4 && self.optionSelected == PaymentOptionDebitCard))
            {
                view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 11);
                view.backgroundColor = kSectionBgColor;
            }
            else
            {
                view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 1);
                view.backgroundColor = kSectionBgColor; // [UIColor whiteColor];
            }
        
        
        }
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
    {
        if (_shouldShowStoredCards) {
            if ((section == 4 && _optionSelected == PaymentOptionCreditCard) || (section == 5 && _optionSelected == PaymentOptionDebitCard))
            {
                return 11;
            }
            else {
                return 1;
            }
        }
        else {
            if ((section == 3 && _optionSelected == PaymentOptionCreditCard) || (section == 4 && _optionSelected == PaymentOptionDebitCard))
            {
                return 11;
            }
            else
            {
                return 1;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 1)];
   view.backgroundColor = kSectionBgColor;

    return view;
}

- (void)openNetbankingController:(EYPayUResponseDetailsMtlModel *)detailModel
{
    NSURLRequest *request = [self.data getRequestForNetbanking:detailModel];
    EYPaymentWebController *webCont = [[EYPaymentWebController alloc] initWithNibName:nil bundle:nil];
    [webCont setRequest:request];
    [self.navigationController pushViewController:webCont animated:YES];
}

- (void)resetData
{
    self.cardNumber = @"";
    self.expiryDate = nil;
    self.cvv = @"";
    self.name = @"";
}


#pragma mark - WPKeyboardAccessoryView Delegate

- (void)didTapDoneButton
{
    [self.view endEditing:YES];
}

- (void)didTapNextButton
{
    if (self.currentlyEditingTf.tag - 1 == 3) {
        [self.view endEditing:YES];
    }
    else {
        NSInteger index = [self getSectionForPaymentOption:self.optionSelected];
        if (index == -1) {
            return;
        }
        __block EYUserCardDetailsCell *cell = (EYUserCardDetailsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag + 1) inSection:index]];
        if (!cell) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag + 1) inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            } completion:^(BOOL finished) {
                cell = (EYUserCardDetailsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag + 1) inSection:index]];
                [cell.tf becomeFirstResponder];
            }];
        }
        else {
            [cell.tf becomeFirstResponder];
        }
    }
}

- (void)didTapPreviousButton
{
    if (self.currentlyEditingTf.tag == 0) {
        [self.view endEditing:YES];
    }
    else {
        NSInteger index = [self getSectionForPaymentOption:self.optionSelected];
        if (index == -1) {
            return;
        }
        __block EYUserCardDetailsCell *cell = (EYUserCardDetailsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag - 1) inSection:index]];
        if (!cell) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag - 1) inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            } completion:^(BOOL finished) {
                cell = (EYUserCardDetailsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag - 1) inSection:index]];
                [cell.tf becomeFirstResponder];
            }];
        }
        else {
            [cell.tf becomeFirstResponder];
        }
    }
}

#pragma mark - UITextfieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    NSInteger index = [self getSectionForPaymentOption:self.optionSelected];
    if (index == -1) {
        return YES;
    }
    __block EYUserCardDetailsCell *cell = (EYUserCardDetailsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag + 1) inSection:index]];
    if (!cell) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag + 1) inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } completion:^(BOOL finished) {
            cell = (EYUserCardDetailsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentlyEditingTf.tag + 1) inSection:index]];
            [cell.tf becomeFirstResponder];
        }];
    }
    else {
        [cell.tf becomeFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textField: %@", textField.text);
    textField.font = AN_REGULAR(15.0);
    textField.textColor = kTextFieldTypingColor;
    EYUserCardDetailsCell *cell = (EYUserCardDetailsCell*)textField.superview;
    cell.backgroundColor = kRowColorWhileTyping;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor =kBlackTextColor;
    EYUserCardDetailsCell *cell = (EYUserCardDetailsCell*)textField.superview;
    cell.backgroundColor = [UIColor whiteColor];
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[EYUserCardDetailsCell class]]) {
            EYUserCardDetailsCell *cardCell = (EYUserCardDetailsCell *) cell;
            if (cardCell.tf == textField && cardCell.type == UserDetailTypeCVV) {
                self.cvv = textField.text;
            }
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentlyEditingTf = textField;
    if (self.currentlyEditingTf.tag - 1 == 0) {
        [self.accView disablePrevious];
    }
    else if (self.currentlyEditingTf.tag - 1 == 3) {
        [self.accView disableNext];
    }
    else {
        [self.accView enableAll];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger tag = textField.tag;
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (tag == 2) {
        if (![text isAllDigitsWithHypens]) {
            return NO;
        }
        else {
            if (text.length > 19) {
                return NO;
            }
            if (string.length == 0) {
                [self deletingCharactersForTextFieldCardNumber:textField range:range];
            }
            else {
                [self addingCharactersInTextFieldCardNumber:textField range:range string:string];
            }
            self.cardNumber = textField.text;
            return NO; // why return no?
        }
    }
    else if (tag == 4) {
        if (text.length >= 4) {
            return NO;
        }
        return YES;
    }
    else if (tag == 1) {
        self.name = text;
        return YES;
    }
    return NO;
}

- (void)addingCharactersInTextFieldCardNumber:(UITextField *)textField range:(NSRange)range string:(NSString *)string
{
    if (range.location == 4 || range.location == 9 || range.location == 14) {
        textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@"-%@",string]];
    }
    else {
        textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@"%@",string]];
    }
}

- (void)deletingCharactersForTextFieldCardNumber:(UITextField *)textField range:(NSRange)range
{
    if (range.location == 5 || range.location == 10 || range.location == 15) {
        textField.text = [textField.text substringToIndex:[textField.text length]-2];
    }
    else {
        textField.text = [textField.text substringToIndex:[textField.text length]-1];
    }
}

#pragma mark - user actions
- (void)payBtnForCardTapped:(id)sender
{
    [self.view endEditing:YES];
    NSLog(@"CVV----%@",self.cvv);
    if (self.cardNumber.length == 0 || self.cvv.length == 0 || !self.expiryDate || self.name.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Please Enter all card details" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
       
        return;
    }
    if (self.cvv.length !=3 )
    {
        [[[UIAlertView alloc] initWithTitle:@"CVV number incorrect" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    NSString *cardNo = [self.cardNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self.dateFormatter setDateFormat:@"MM/YYYY"];
    NSString *expDateStr = [self.dateFormatter stringFromDate:self.expiryDate];
    NSArray *components = [expDateStr componentsSeparatedByString:@"/"];
    NSString *month, *year;
    if (components.count == 2) {
        month = components[0];
        year = components[1];
    }
    
    EYSaveCardCell *cell = (EYSaveCardCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self getNumberOfRowsForSelectedOption:self.optionSelected] inSection:[self getSectionForPaymentOption:self.optionSelected]]];
    NSURLRequest *request = [self.data getRequestForCardWithCardNumber:cardNo expiryMonth:month expiryYear:year name:self.name cvv:self.cvv saveCard:cell.tickBtn.on];
    EYPaymentWebController *webCont = [[EYPaymentWebController alloc] initWithNibName:nil bundle:nil];
    [webCont setTransactionId:self.data.transactionId];
    [webCont setRequest:request];
    
    [[PVToast shared]showToastMessage:@"Disabled For Demo Version"];

    
   // [self.navigationController pushViewController:webCont animated:YES];
}

#pragma mark - Picker Delegate

//- (void)pickerView:(WPPickerView *)aView didSelectDate:(NSDate *)date
//{
//    self.expiryDate = date;
//    [self updateDataInCellForRow:3];
//}

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    self.expiryDate = datePicker.date;
    [self updateDataInCellForRow:3];
}

- (void)updateDataInCellForRow:(NSInteger)rowNo
{
    NSInteger index = [self getSectionForPaymentOption:self.optionSelected];
    EYUserCardDetailsCell *cell = (EYUserCardDetailsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNo inSection:index]];
    if (rowNo == 1) {
        cell.tf.text = self.name;
    }
    else if (rowNo == 3) {
        cell.tf.text = [self.dateFormatter stringFromDate:self.expiryDate];
    }
    else if (rowNo == 4) {
        cell.tf.text = self.cvv;
    }
    else if (rowNo == 2) {
        cell.tf.text = self.cardNumber;
    }
}

#pragma mark - loader view
//- (UIView *)loader
//{
//    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EYLoaderView" owner:self options:nil];
//    UIView *loaderView = [nibObjects objectAtIndex:0];
//    return loaderView;
//}

- (UIView *)headerView
{
    CGRect rect = (CGRect){0,0, self.view.bounds.size.width,1};
    UIView *header = [[UIView alloc]initWithFrame:rect];
    header.backgroundColor = kSectionBgColor;
    return header;
}

@end
