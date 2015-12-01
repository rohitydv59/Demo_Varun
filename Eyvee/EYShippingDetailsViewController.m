//
//  EYShippingDetailsViewController.m
//  Eyvee
//
//  Created by Disha Jain on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYShippingDetailsViewController.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYTextFieldCell.h"
#import "EYBottomButton.h"
#import "EYCustomAccessoryViewCell.h"
//#import "EYShippingDataModel.h"
#import "EYReviewOrderVC.h"
#import "EYShippingAddressMtlModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYAddressTextField.h"
#import "EYAllAPICallsManager.h"
#import "EYAccountController.h"
#import "WPKeyboardAccessoryView.h"
#import "EDKeyboardAccessoryView.h"
#import "EYError.h"
#import "NSString+validation.h"
#import "EYUserDetailsVC.h"
#import "EYAccountController.h"
#import "EDLoaderView.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"

//For LOcal
#import "EYCartModel.h"

@interface EYShippingDetailsViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,WPKeyboardAccessoryViewDelegate,EDKeyboardAccessoryViewDelegate>
{
    float availableHeightForInnerTable;
    NSIndexPath *indexPathToMakeFirstResponder;
}
@property (nonatomic, strong) EDLoaderView *loader;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,assign)BOOL isSwitchON;
@property (nonatomic,assign) CGFloat sizeMax;
@property (nonatomic,strong) EYBottomButton *bottomView;
@property (nonatomic, strong) EDKeyboardAccessoryView *accView;
@property (nonatomic, assign) NSString *name;
@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *houseNumber;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *billingHouseNo;
@property (nonatomic, strong) NSString *billingAddressLine2;
@property (nonatomic, strong) NSString *billingCity;
@property (nonatomic, strong) NSString *billingPostalCode;
@property (nonatomic, strong) EYAddressTextField *currentlyEditingTf;

@end

@implementation EYShippingDetailsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        self.title = @"Shipping Address";
    }
    return self;
    
}
#pragma mark view 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //Table View
    CGSize size = self.view.bounds.size;
    
    _bottomView.frame = (CGRect){0, size.height - kBottomBarHeight, size.width, kBottomBarHeight};
    
    _tableView.frame = CGRectMake(0, 64, size.width, size.height - _bottomView.frame.size.height - 64);
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];

    if (!_addressModel)
    {
        _addressModel = [[EYShippingAddressMtlModel alloc] init];
        _addressModel .fullName = [EYAccountManager sharedManger].loggedInUser.fullName;
        _addressModel.contactNum = [EYAccountManager sharedManger].loggedInUser.phoneNumber;
        
    }
    
    if (_addressModel.billingAddress) {
        _isSwitchON = NO;
    }
    
    if (!_addressModel.billingAddress) {
        _addressModel.billingAddress = [[EYShippingAddressMtlModel alloc] init];
    }
    NSString * pincode = [[EYUtility shared] getPinCode];
    NSLog(@"pincode - %@",pincode);
//    if (pincode) {
//        _addressModel.pincode = pincode;
//        [self fetchShippingDetailsWithCompletionBlock:^(bool success, EYError *error) {
//            [self initializeBottomViewAndTableView];
//        }];
//    }
//    else
    {
        [self initializeBottomViewAndTableView];
    }
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)initializeBottomViewAndTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kSectionBgColor;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    
    [self.view addSubview:_tableView];
    
//    _bottomView = [[EYBottomButton alloc]initWithFrame:(CGRectZero) image:@"next_small" ButtonText:@"SAVE SHIPPING ADDRESS" andFont:AN_BOLD(13.0)];
    _bottomView = [[EYBottomButton alloc]initWithFrame:(CGRectZero) image:@"arrow_next" ButtonText:@"SAVE SHIPPING ADDRESS" andFont:AN_BOLD(13.0)];

    [self.view addSubview:_bottomView];
    
    [_bottomView addTarget:self action:@selector(saveShippingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _accView = [[EDKeyboardAccessoryView alloc]initWithFrame:(CGRect){0.0,0.0,0.0,kKeyboardAccessoryHeight} andMode:EDDoneButtonOnly];
    
    _accView.delegate = self;
}

#pragma mark Table view data source and delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSwitchON == NO) {
        return 4;
    }
    else
    {
     return 3;
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
   if (_isSwitchON == NO)
    {
        if (section == 3) {
            return 6;
        }
    }
    if (section == 0) {
        return 3;
    }
    else if (section == 1)
    {
        return 6;
    }
    else if (section == 2)
    {
        return 1;
    }
    
    else return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44.0;
    }
    else if (section == 1 || section == 3)
    {
        return 51.0;
    }
    else
        return 15.0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = kSectionBgColor;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectZero];
    lbl.font = AN_BOLD(12.0);
    [view addSubview:lbl];
    
    if (section == 0)
        
     {
         view.frame = CGRectMake(0, 0, self.view.frame.size.width-kProductDescriptionPadding, 44.0);
         lbl.text = @"CONTACT DETAILS";
         lbl.textColor = kBlackTextColor;
         CGSize lblSize = lbl.intrinsicContentSize;
         lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height)/2,lblSize};
         
     }
    else if (section == 1 )
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width-kProductDescriptionPadding, 51.0);
        view.backgroundColor = kSectionBgColor;
        lbl.text = @"SHIPPING ADDRESS";
        lbl.textColor = kBlackTextColor;
        CGSize lblSize = lbl.intrinsicContentSize;
        lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height - 12.0),lblSize};
        
    }
    else if (section == 3 )
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width-kProductDescriptionPadding, 51.0);
        view.backgroundColor = kSectionBgColor;
        lbl.text = @"BILLING ADDRESS";
        lbl.textColor = kBlackTextColor;
        CGSize lblSize = lbl.intrinsicContentSize;
        lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height - 12.0),lblSize};
        
    }
    else if (section == 3)
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width-kProductDescriptionPadding, 15.0);
    }

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSString *identifier = @"staticIdentifier1";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textfield.textFieldName = @"fullName";
            cell.textfield.text = _addressModel.fullName;
            cell.textfield.delegate = self;
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.inputAccessoryView = self.accView;
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            [cell setLabelText:@"Full Name" andPlaceholderText:@"Required"];
            return cell;
        }
        else if (indexPath.row ==1)
        {
            NSString *identifier = @"staticIdentifier2";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            cell.textfield.textFieldName = @"mobileNumber";
            cell.textfield.text = _addressModel.contactNum;

            if (cell.textfield.text.length == 0) {
                cell.textfield.text = @"+91";
            }
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.delegate = self;
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.inputAccessoryView = self.accView;
            
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            [cell setLabelText:@"Mobile Number" andPlaceholderText:@"Required"];
            return cell;
        }
        else
        {
            NSString *identifier = @"staticIdentifier3";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            
            cell.textLabel.text = @"Contact number is only used to update you about order";
            cell.textLabel.font = AN_REGULAR(11.0);
            cell.textLabel.textColor = kRowLeftLabelColor;
            return cell;
        }
    }
    else if(indexPath.section == 1) // section shipping details
    {
        
        if (indexPath.row == 0)
        {
            NSString *identifier = @"staticIdentifier4";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"houseNumber";
            NSString *str = [NSString stringWithFormat:@"%lu%lu",indexPath.section+1,indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.delegate = self;
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.inputAccessoryView = _accView;
            cell.textfield.text = _addressModel.addressLine1;

            [cell setLabelText:@"House/Apt No." andPlaceholderText:@"Required"];
            return cell;
        }
        else if (indexPath.row == 1)
        {
            NSString *identifier = @"staticIdentifier5";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
             cell.textfield.textFieldName = @"addressLine";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.delegate = self;
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.inputAccessoryView = _accView;
            cell.textfield.text = _addressModel.addressLine2;

            [cell setLabelText:@"Address line 2" andPlaceholderText:@"Area,Landmark etc."];
            
            return cell;
 
        }
        /*
        else if (indexPath.row == 2)
        {
            NSString *identifier = @"staticIdentifier6";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
             cell.textfield.textFieldName = @"city";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.text = _addressModel.addressLine2;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;

            [cell setLabelText:@"City" andPlaceholderText:@"Required"];
            
            return cell;
        }
        */
        else if (indexPath.row == 2)
        {
            NSString *identifier = @"staticIdentifier7";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
             cell.textfield.textFieldName = @"postalCode";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.text = _addressModel.pincode;
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;

            [cell setLabelText:@"Pin Code" andPlaceholderText:@"Required"];
            
            return cell;
        }
        else if (indexPath.row == 3)
        {
            NSString *identifier = @"staticIdentifier8";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"shippingCity";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.text = _addressModel.cityName;
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;
            cell.textfield.enabled = YES;
            [cell setLabelText:@"City" andPlaceholderText:@""];
            
            return cell;
        }
        else if (indexPath.row == 4)
        {
            NSString *identifier = @"staticIdentifier9";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"shippingState";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.text = _addressModel.stateName;
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;
            cell.textfield.enabled = YES;
            [cell setLabelText:@"State" andPlaceholderText:@""];
            
            return cell;
        }
        else if (indexPath.row == 5)
        {
            NSString *identifier = @"staticIdentifier10";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"shippingCountry";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.text = _addressModel.countryName;
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;
            cell.textfield.enabled = YES;
            [cell setLabelText:@"Country" andPlaceholderText:@""];
            
            return cell;
        }
        else
        {
            NSString *identifier = @"staticIdentifierBilling7";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"billingCountry";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;
            cell.textfield.enabled = NO;
            [cell setLabelText:@"Country" andPlaceholderText:@""];
            
            return cell;
        }

    }
    else if (indexPath.section == 2)
    {
        NSString *identifier = @"switchViewCell";
        EYCustomAccessoryViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
            cell = [[EYCustomAccessoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier rowText:@"" andAccessoryViewType:switchView andMode:EYCustomAccessoryViewCellTypeDefault];

        NSDictionary *dict = @{NSFontAttributeName : AN_REGULAR(13.0),
                               NSForegroundColorAttributeName : kRowLeftLabelColor};
        
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"Also use as Billing Address" attributes:dict];
        [cell populateCellWithAttributedText:attr];
        [cell.switchView addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventValueChanged];
        cell.switchView.on = _isSwitchON;
        return cell;
    }
    else if (indexPath.section == 3)
    {
        
        if (indexPath.row == 0)
        {
            NSString *identifier = @"staticIdentifierBilling1";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.text = _addressModel.billingAddress.addressLine1;
             cell.textfield.textFieldName = @"houseNumberBilling";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.delegate = self;
            cell.textfield.inputAccessoryView = self.accView;
           
            [cell setLabelText:@"House No/Street" andPlaceholderText:@"Required"];
            return cell;
        }
        else if (indexPath.row == 1)
        {
            NSString *identifier = @"staticIdentifierBilling2";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
             cell.textfield.textFieldName = @"addressLineBilling";
            cell.textfield.text = _addressModel.billingAddress.addressLine2;
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.delegate = self;
            cell.textfield.inputAccessoryView = self.accView;

            [cell setLabelText:@"Address line 2" andPlaceholderText:@"Area,Landmark etc."];
            
            return cell;
            
        }
        /*
        else if (indexPath.row == 2)
        {
            NSString *identifier = @"staticIdentifierBilling3";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
             cell.textfield.textFieldName = @"cityBilling";
            cell.textfield.text = _addressModel.billingAddress.cityName;

            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.delegate = self;
            cell.textfield.inputAccessoryView = self.accView;

            [cell setLabelText:@"City" andPlaceholderText:@"Delhi"];
            
            return cell;
        }
        */
        else if (indexPath.row == 2)
        {
            NSString *identifier = @"staticIdentifierBilling4";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
             cell.textfield.textFieldName = @"postalCodeBilling";
            cell.textfield.text = _addressModel.billingAddress.pincode;

            NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.delegate = self;
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;

            [cell setLabelText:@"Pin Code" andPlaceholderText:@"Required"];
            
            return cell;
        }
        else if (indexPath.row == 3)
        {
            NSString *identifier = @"staticIdentifierBilling5";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"billingCity";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.text = _addressModel.billingAddress.cityName;

            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;
            cell.textfield.enabled = NO;
            [cell setLabelText:@"City" andPlaceholderText:@""];
            
            return cell;
        }
        else if (indexPath.row == 4)
        {
            NSString *identifier = @"staticIdentifierBilling6";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"billingState";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.text = _addressModel.billingAddress.stateName;

            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;
            cell.textfield.enabled = NO;
            [cell setLabelText:@"State" andPlaceholderText:@""];
            
            return cell;
        }
        else if (indexPath.row == 5)
        {
            NSString *identifier = @"staticIdentifierBilling7";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"billingCountry";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.text = _addressModel.billingAddress.countryName;

            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;
            cell.textfield.enabled = NO;
            [cell setLabelText:@"Country" andPlaceholderText:@""];
            
            return cell;
        }
        else
        {
            NSString *identifier = @"staticIdentifierBilling8";
            EYTextFieldCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.textfield.textFieldName = @"billingCountry";
            NSString *str = [NSString stringWithFormat:@"%ld%ld",indexPath.section+1,(long)indexPath.row];
            cell.textfield.tag = [str integerValue];
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
            cell.textfield.inputAccessoryView = self.accView;
            cell.textfield.delegate = self;
            cell.textfield.enabled = NO;
            [cell setLabelText:@"Country" andPlaceholderText:@""];
            
            return cell;
        }
        

    }
 else
     return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 2) {
            return 44.0;
        }
        else
            return 48.0;
    }
    else
    
        return 48.0 ;
}

-(void)switchPressed:(id)sender
{
    if ([sender isOn])
    {
        _isSwitchON = YES;
        [self syncShippingAndBillingAddress];
//        _addressModel.billingAddress.addressLine1 = _addressModel.addressLine1;
//        _addressModel.billingAddress.addressLine2 = _addressModel.addressLine2;
//        _addressModel.billingAddress.pincode = _addressModel.pincode;
//        _addressModel.billingAddress.addressId = [NSNumber numberWithInt:0];
//        _addressModel.billingAddress.shippingAddressId = _addressModel.addressId;
//        _addressModel.billingAddress.city = _addressModel.city;
//        _addressModel.billingAddress.state = _addressModel.state;
//        _addressModel.billingAddress.country = _addressModel.country;
//        _addressModel.billingAddress.cityName = _addressModel.cityName;
//        _addressModel.billingAddress.stateName = _addressModel.stateName;
//        _addressModel.billingAddress.countryName = _addressModel.countryName;
        [_tableView reloadData];
        [self.view setNeedsLayout];
    }
    
    else
    {
        _isSwitchON = NO;
        _addressModel.billingAddress.addressId = [NSNumber numberWithInt:0];
        _addressModel.billingAddress.shippingAddressId = _addressModel.addressId;

        [_tableView reloadData];
        [self.view setNeedsLayout];
        
    }
}

#pragma mark TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(EYAddressTextField *)textField
{
    
//    [textField resignFirstResponder];
//    return YES;
    
        if (self.currentlyEditingTf.tag == 10)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        else if (self.currentlyEditingTf.tag == 11)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:0 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 20)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 21)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:2 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 22)
        {
            [textField resignFirstResponder];
        }
        else if (self.currentlyEditingTf.tag == 40)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:3];
        }
        else if (self.currentlyEditingTf.tag == 41)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:2 inSection:3];
        }
        else if (self.currentlyEditingTf.tag == 42)
        {
            [textField resignFirstResponder];
        }
    
    EYTextFieldCell *cell = (EYTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPathToMakeFirstResponder];
    if (cell)
    {
        [cell.textfield becomeFirstResponder];
        indexPathToMakeFirstResponder = nil;
    }
    else
    {
        [self.tableView scrollToRowAtIndexPath:indexPathToMakeFirstResponder atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return YES;
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    EYAddressTextField *addressTextField =  (EYAddressTextField*)textField;
    NSString *text = [addressTextField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if ([addressTextField.textFieldName isEqualToString:@"fullName"])
    {
        _addressModel.fullName = text;
    }
    else if ([addressTextField.textFieldName isEqualToString:@"mobileNumber"])
    {
        if (newLength > [textField.text length])
        {
            if ([textField.text length] < 3 && ![textField.text isAllDigits])
            {
                return NO;
            }
        }
        else
        {
            if ([textField.text length] == 3)
            {
                return NO;
            }
        }
        if (text.length>13)
        {
            return NO;
        }
        _addressModel.contactNum = text;

    }

    else if ([addressTextField.textFieldName isEqualToString:@"houseNumber"])
    {
        _addressModel.addressLine1 = text;
    }
    else if ([addressTextField.textFieldName isEqualToString:@"addressLine"])
    {
        _addressModel.addressLine2 = text;
    }
    else if ([addressTextField.textFieldName isEqualToString:@"city"])
    {
        _addressModel.cityName = text;
    }
    else if ([addressTextField.textFieldName isEqualToString:@"postalCode"])
    {
        _addressModel.pincode = text;
        if (text.length == 6) {
//            [textField resignFirstResponder];
//            [self fetchShippingDetailsWithCompletionBlock:nil];
        }
        else if (text.length > 6)
            return NO;
    }
    else if ([addressTextField.textFieldName isEqualToString:@"houseNumberBilling"])
    {
        _addressModel.billingAddress.addressLine1 = text;
    }
    else if ([addressTextField.textFieldName isEqualToString:@"addressLineBilling"])
    {
        _addressModel.billingAddress.addressLine2 = text;
    }
    else if ([addressTextField.textFieldName isEqualToString:@"cityBilling"])
    {
         _addressModel.billingAddress.cityName = text;
    }
    else if ([addressTextField.textFieldName isEqualToString:@"postalCodeBilling"])
    {
         _addressModel.billingAddress.pincode = text;
        if (text.length == 6) {
            [textField resignFirstResponder];
//            [self fetchBillingDetails];
        }
        else if (text.length > 6)
            return NO;
    }

    return YES;
}


- (void)fetchShippingDetailsWithCompletionBlock:(void(^)(bool success, EYError *error))completionBlock
{
    
    [EYUtility showHUDWithTitle:@"Fetching Shipping Details"];
    NSDictionary * shippingParameters = @{@"pincode":_addressModel.pincode};
    
    [[EYAllAPICallsManager sharedManager] checkShippingPincodeAvailabilityWithParameters:shippingParameters withRequestPath:@"checkPinCode.json" payload:nil withCompletionBlock:^(id responseObject, EYError *error) {
        [EYUtility hideHUD];
        
        if (!error) {
            [self setAddressModel:_addressModel WithDictionary:(NSDictionary *)responseObject];
            [self.tableView reloadData];
            if (completionBlock)
                completionBlock(YES,nil);
            }
        else
        {
            [self setAddressModel:_addressModel WithDictionary:(NSDictionary *)responseObject];
            [self.tableView reloadData];
            [EYUtility showAlertView:error.errorMessage];
            if (completionBlock)
            {
                completionBlock(NO,error);
                
            }
        }
    }];
}
//92384301 passwordii

- (void)fetchBillingDetails
{
    [EYUtility showHUDWithTitle:@"Fetching Billing Details"];

    NSDictionary * billingParameters = @{@"pincode":_addressModel.billingAddress.pincode};
    
    [[EYAllAPICallsManager sharedManager] checkBillingPincodeAvailabilityWithParameters:billingParameters withRequestPath:@"checkPinCode.json" payload:nil withCompletionBlock:^(id responseObject, EYError *error) {
        [EYUtility hideHUD];
        if (!error) {
            [self setAddressModel:_addressModel.billingAddress WithDictionary:(NSDictionary *)responseObject];
            [self.tableView reloadData];
        }
        else
        {
            [self setAddressModel:_addressModel WithDictionary:(NSDictionary *)responseObject];
            [self.tableView reloadData];
            [EYUtility showAlertView:error.errorMessage];
        }
    }];

}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentlyEditingTf = (EYAddressTextField*)textField;
    if ([self.currentlyEditingTf.textFieldName isEqualToString:@"fullName"]) {
        [self.accView disablePrevious];
    }
    else if ([self.currentlyEditingTf.textFieldName isEqualToString:@"postalCode"])
    {
        if (_isSwitchON)
        {
           [self.accView disableNext];
        }
       else
       {
            [self.accView enableAll];
       }
    }
    else if ([self.currentlyEditingTf.textFieldName isEqualToString:@"postalCodeBilling"])
    {
         [self.accView disableNext];
    }
    else {
        [self.accView enableAll];
    }
    return YES;

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor = kTextFieldTypingColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
   
    //Append +91 for mobile number
//    for (EYTextFieldCell *cell in self.tableView.visibleCells) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        if (indexPath.row == 1 && indexPath.section == 0 && [cell.textfield.text length] < 3) {
//            cell.textfield.text = @"+91";
//        }
//    }
    cell.backgroundColor = kRowColorWhileTyping;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor =kBlackTextColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = [UIColor whiteColor];
}

-(void)saveShippingButtonTapped:(id)sender
{
    [self updateUserAddress];
}

- (void)updateUserAddress
{
    _addressModel.countryName = @"India";
    _addressModel.stateName = @"Haryana";
    if (_addressModel.addressLine2.length == 0) {
        _addressModel.addressLine2 = @"";
    }
   
    if (![self checkMobileNumber])
    {
        [[[UIAlertView alloc] initWithTitle:@"Mobile Number incorrect" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;

    }
    
    if (![self checkIfValid]) {
        [[[UIAlertView alloc] initWithTitle:@"All fields are mandatory" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    if (_updateAddress) {
        [self updateAddressWithData:_addressModel];
    }
    else
        [self addNewAddressWithData:_addressModel];
    NSLog(@"Hi There");
    
}

- (void)setAddressModel:(EYShippingAddressMtlModel *)model WithDictionary:(NSDictionary *)data
{
    NSDictionary * response = [data objectForKey:@"data"];
    model.pincode = [response objectForKey:@"pincode"];
    model.cityName = [response objectForKey:@"city"];
    model.stateName = [response objectForKey:@"state"];
    model.countryName = [response objectForKey:@"country"];
    model.city = [response objectForKey:@"cityId"];
    model.state = [response objectForKey:@"stateId"];
    model.country = [response objectForKey:@"countryId"];
}

- (void)addNewAddressWithData:(EYShippingAddressMtlModel *)address
{
    if (self.isSwitchON) {
        [self syncShippingAndBillingAddress];
    }
    
//    NSArray * payload = @[@{@"addressType":@"1",@"fullName":_addressModel.fullName,@"city":address.city,@"state":address.state,@"country":address.country,@"addressLine1":_addressModel.addressLine1,@"addressLine2":_addressModel.addressLine2,@"pincode":_addressModel.pincode,@"shippingAddressId":@"0",@"cityName":_addressModel.cityName,@"stateName":_addressModel.stateName,@"countryName":_addressModel.countryName,@"contactNum":_addressModel.contactNum},
//                          
//                          @{@"addressType":@"2",@"fullName":_addressModel.fullName,@"city":address.city,@"state":address.state,@"country":address.country,@"addressLine1":_addressModel.billingAddress.addressLine1,@"addressLine2":_addressModel.billingAddress.addressLine2,@"pincode":_addressModel.billingAddress.pincode,@"shippingAddressId":@"0",@"cityName":_addressModel.billingAddress.cityName,@"stateName":_addressModel.stateName,@"countryName":_addressModel.countryName,@"contactNum":_addressModel.contactNum}];
    
//    [EYUtility showHUDWithTitle:@"Loading"];
    _cartModel.cartAddress = _addressModel;
    [[EYUtility shared]saveUserAddressWithModel:_addressModel];
    //save cart
    [[EYCartModel sharedManager]saveCartLocally:_cartModel];

    [self moveToRequiredViewWithAllAddresses];
}

- (void)updateAddressWithData:(EYShippingAddressMtlModel *)address
{
//    NSArray * payload = @[@{@"addressId":address.addressId, @"addressType":@"1",@"fullName":_addressModel.fullName,@"city":address.city,@"state":address.state,@"country":address.country,@"addressLine1":_addressModel.addressLine1,@"addressLine2":_addressModel.addressLine2,@"pincode":_addressModel.pincode,@"shippingAddressId":_addressModel.shippingAddressId,@"cityName":_addressModel.cityName,@"stateName":_addressModel.stateName,@"countryName":_addressModel.countryName,@"contactNum":_addressModel.contactNum},
//  @{@"addressId":_addressModel.billingAddress.addressId,@"addressType":@"2",@"fullName":_addressModel.fullName,@"city":_addressModel.billingAddress.city,@"state":_addressModel.billingAddress.state,@"country":_addressModel.billingAddress.country,@"addressLine1":_addressModel.billingAddress.addressLine1,@"addressLine2":_addressModel.billingAddress.addressLine2,@"pincode":_addressModel.billingAddress.pincode,@"shippingAddressId":_addressModel.addressId,@"cityName":_addressModel.billingAddress.cityName,@"stateName":_addressModel.billingAddress.stateName,@"countryName":_addressModel.billingAddress.countryName,@"contactNum":_addressModel.billingAddress.contactNum}];
//    
//    [EYUtility showHUDWithTitle:@"Updating"];
//    
//    NSDictionary * parameter = @{@"isDeleted":@"false"};
//    
//    [[EYAllAPICallsManager sharedManager] updateAddressRequestWithParameters:parameter withRequestPath:@"updateUserAddress.json" payload:payload  withCompletionBlock:^(id responseObject, EYError *error) {
//        [EYUtility hideHUD];
//        if (!error) {
//            EYAllAddressMtlModel * allAdrresses = (EYAllAddressMtlModel *)responseObject;
//            if (_cartModel)
//            {
//                _cartModel.cartAddress = _addressModel;
//
//            }
//            [self moveToRequiredViewWithAllAddresses:allAdrresses];
//        }
//    }];
    
    [[EYUtility shared]saveUserAddressWithModel:address];
    _addressModel = address;
    _cartModel.cartAddress = address;
    //save cart with updated address;
    [[EYCartModel sharedManager]saveCartLocally:_cartModel];
     [self moveToRequiredViewWithAllAddresses];
    
}

- (void)moveToRequiredViewWithAllAddresses
{
      if (self.comingFromMode == comingFromReviewMode) {
        EYReviewOrderVC * reviewController;
        for (UIViewController * controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[EYReviewOrderVC class]]) {
                reviewController = (EYReviewOrderVC *)controller;
                break;
            }
        }
        [self.navigationController popToViewController:reviewController animated:YES];
    }
    else if(self.comingFromMode == comingFromBagMode)
    {
        EYReviewOrderVC *review = [[EYReviewOrderVC alloc] initWithNibName:nil bundle:nil];
        review.cartModel = _cartModel;
        [self.navigationController pushViewController:review animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//used previously
- (void)moveToRequiredViewWithAllAddresses:(EYAllAddressMtlModel *)allAddresses
{
    if (_delegate && [_delegate respondsToSelector:@selector(newAddressAddedDelegateWithAllAddressModel:)]) {
        [_delegate newAddressAddedDelegateWithAllAddressModel:allAddresses];
    }
    
    if (self.comingFromMode == comingFromReviewMode) {
        EYReviewOrderVC * reviewController;
        for (UIViewController * controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[EYReviewOrderVC class]]) {
                reviewController = (EYReviewOrderVC *)controller;
                break;
            }
        }
        [self.navigationController popToViewController:reviewController animated:YES];
    }
    else if(self.comingFromMode == comingFromBagMode)
    {
        EYReviewOrderVC *review = [[EYReviewOrderVC alloc] initWithNibName:nil bundle:nil];
        review.cartModel = _cartModel;
        [self.navigationController pushViewController:review animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(BOOL)checkMobileNumber
{
    if (_addressModel.contactNum.length!=13)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkIfValid
{
    BOOL isValid = YES;
    
    if (_addressModel.fullName.length == 0 || _addressModel.addressLine1.length == 0 || _addressModel.pincode.length == 0 || _addressModel.stateName.length == 0 || _addressModel.countryName.length == 0 || _addressModel.contactNum.length == 0) {
        isValid = NO;
    }

    else
    {
        if (!_isSwitchON)
        {
            
            if (_addressModel.billingAddress.addressLine1.length == 0 || _addressModel.billingAddress.pincode.length == 0)
            {
                isValid = NO;
            }
        }
        else
            isValid = YES;
    }
    return isValid;
}



- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.bottom = keyboardSize.height;
        self.tableView.contentInset = inset;
        self.tableView.scrollIndicatorInsets = inset;
    }];
    
}
-(void)keyboardWillHide:(NSNotification*)notification
{
    CGFloat animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.bottom = 48.0;
        self.tableView.contentInset = inset;
        self.tableView.scrollIndicatorInsets = inset;
    }];
}

#pragma mark - WPKeyboardAccessoryView Delegate

- (void)didTapDoneButton
{
    [self.view endEditing:YES];
}

-(void)didTapCancelButton
{
    [self.view endEditing:YES];
}

-(void)didTapNextButton
{

    if ((self.currentlyEditingTf.tag == 33) || ((self.currentlyEditingTf.tag == 23)&&_isSwitchON))
    {
       [self.view endEditing:YES];
    }
    else
    {
        if (self.currentlyEditingTf.tag == 10)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        else if (self.currentlyEditingTf.tag == 11)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:0 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 20)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 21)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:2 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 22)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:3 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 23 && !(_isSwitchON))
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:0 inSection:3];
        }
        else if (self.currentlyEditingTf.tag == 40)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:3];
        }
        else if (self.currentlyEditingTf.tag == 41)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:2 inSection:3];
        }
        else if (self.currentlyEditingTf.tag == 42)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:3 inSection:3];
        }

    }
    
    EYTextFieldCell *cell = (EYTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPathToMakeFirstResponder];
        if (cell)
        {
            [cell.textfield becomeFirstResponder];
            indexPathToMakeFirstResponder = nil;
        }
        else
        {
            [self.tableView scrollToRowAtIndexPath:indexPathToMakeFirstResponder atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    
}

-(void)didTapPreviousButton
{
    if (self.currentlyEditingTf.tag == 10)
    {
        [self.view endEditing:YES];
    }
    else
    {
        if (self.currentlyEditingTf.tag == 11)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        else if (self.currentlyEditingTf.tag == 20)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        else if (self.currentlyEditingTf.tag == 21)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:0 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 22)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 23)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:2 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 40)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:3 inSection:1];
        }
        else if (self.currentlyEditingTf.tag == 41)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:0 inSection:3];
        }
        else if (self.currentlyEditingTf.tag == 42)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:1 inSection:3];
        }
        else if (self.currentlyEditingTf.tag == 43)
        {
            indexPathToMakeFirstResponder = [NSIndexPath indexPathForRow:2 inSection:3];
        }
        
    }
    
    EYTextFieldCell *cell = (EYTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPathToMakeFirstResponder];
    if (cell)
    {
        [cell.textfield becomeFirstResponder];
        indexPathToMakeFirstResponder = nil;
    }
    else
    {
        [self.tableView scrollToRowAtIndexPath:indexPathToMakeFirstResponder atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void)syncShippingAndBillingAddress{
    _addressModel.billingAddress.addressLine1 = _addressModel.addressLine1;
    _addressModel.billingAddress.addressLine2 = _addressModel.addressLine2;
    _addressModel.billingAddress.pincode = _addressModel.pincode;
    _addressModel.billingAddress.addressId = [NSNumber numberWithInt:0];
    _addressModel.billingAddress.shippingAddressId = _addressModel.addressId;
    _addressModel.billingAddress.city = _addressModel.city;
    _addressModel.billingAddress.state = _addressModel.state;
    _addressModel.billingAddress.country = _addressModel.country;
    _addressModel.billingAddress.cityName = _addressModel.cityName;
    _addressModel.billingAddress.stateName = _addressModel.stateName;
    _addressModel.billingAddress.countryName = _addressModel.countryName;
}


@end
