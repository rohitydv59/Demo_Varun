//
//  EYOrderDetailsViewController.m
//  Eyvee
//
//  Created by Disha Jain on 24/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYOrderDetailsViewController.h"
#import "EYAddToBagHeaderView.h"
#import "EYUtility.h"
#import "EYConstant.h"
#import "EYOrderDetailCell.h"
#import "EYAttributedLabelsCell.h"
#import "EYCustomAccessoryViewCell.h"
#import "EYOrderCell.h"

#define kOrderDatesSection @"OrderDatesSection"
#define kShippingToSection @"ShippingToSection"
#define kPaymentSummarySection @"PaymentSummary"
#define kOrderSummarySection @"OrderSummary"

@interface EYOrderDetailsViewController ()
{
    BOOL _isAddressSaved;
}
@property (strong, nonatomic) EYShippingAddressMtlModel *shippingModelObj;
@end

@implementation EYOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (EYShippingAddressMtlModel *shipModel in _allAddressesReceived.allAdrresses)
    {
        if ([_orderModelReceived.shippingAddressId isEqual:shipModel.addressId])
        {
            _isAddressSaved = YES;
            _shippingModelObj = shipModel;
        }
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;    
    self.view.backgroundColor = kSectionBgColor;
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.navigationItem.title = @"Order Details";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isAddressSaved)
    {
        return 4;
    }
    else
    {
        return 3.0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName=[self getStringForSection:section];
    
    if ([sectionName isEqualToString:kPaymentSummarySection])
    {
        return 2;
    }
    else
        return 1;
}

- (NSString *)getStringForSection:(NSInteger)section
{
    NSString *sectionName = @"";
    switch (section)
    {
        case 0:
            sectionName =kOrderDatesSection;
            break;
        case 1:
            if (_isAddressSaved)
            {
                sectionName = kShippingToSection;
            }
            else
                sectionName = kPaymentSummarySection;
            break;

        case 2:
            if (_isAddressSaved)
            {
                sectionName = kPaymentSummarySection;
            }
            else
            {
                sectionName = kOrderSummarySection;
            }
            break;

        case 3:
            sectionName = kOrderSummarySection;
            break;

        default:
            break;
    }
    return sectionName;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*sectionName = [self getStringForSection:indexPath.section];
    
    if ([sectionName isEqualToString:kOrderDatesSection])
    {
        NSString *cellIdentifier = @"orderSummary1";
        
        EYAttributedLabelsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[EYAttributedLabelsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setLeftLabelAttributedText:[self getAttributedStringForLeftTextWithMode:_orderTypeReceived]];
        [cell setRightLabelAttributedText:nil];
        
        return cell;
    }
    else if ([sectionName isEqualToString:kShippingToSection])
    {
        //shippping to cell
        
        NSString *cellIdentifier = @"shippingToAddressCell";
        
        EYCustomAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            
            cell = [[EYCustomAccessoryViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier rowText:@"shippingToAddressCell" andAccessoryViewType:imageView andMode:EYCustomAccessoryViewCellTypeDefault];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSAttributedString *str = [self getAttributedStringForShippingCell];
        [cell populateCellWithAttributedText:str];
        [cell setImageAsPerCellType:EYCustomAccessoryViewCellTypeDefault];
        return cell;

    }
    else if ([sectionName isEqualToString:kPaymentSummarySection])
    {
        //Payment Summary
      
        if (indexPath.row == 0)
        {
            NSString *cellIdentifier = @"subtotalCell";
            
            EYAttributedLabelsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[EYAttributedLabelsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setLeftLabelAttributedText:[self getAttributedStringForLeftTextPayment]];
            [cell setRightLabelAttributedText:[self getAttributedStringForRightTextPayment]];
            
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
            [cell updateCellDataWithLeftLabel:@"Paid" andRightLabel:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[_orderModelReceived.amountPaid floatValue]]] andMode:EYReviewOrderLabel];
            return cell;
        
        }
    }
    else
    {
       NSString *cellIdentifier = @"orderSummary2";
        EYOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[EYOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell updateOrderDetailCell:_orderModelReceived];
        return cell;
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString*sectionName = [self getStringForSection:section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0)];
    view.backgroundColor = kSectionBgColor;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,0, 0)];
    lbl.font = AN_BOLD(12.0);
    lbl.textColor = kBlackTextColor;
    [view addSubview:lbl];
    
    if ([sectionName isEqualToString:kOrderDatesSection])
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0);
        lbl.frame = CGRectMake(kProductDescriptionPadding, 0, self.view.frame.size.width-kProductDescriptionPadding, 44.0);
        lbl.text = @"ORDER SUMMARY";
    }
    else if ([sectionName isEqualToString:kShippingToSection])
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 51.0);
        lbl.text = @"SHIPPING TO";
        CGSize lblSize = lbl.intrinsicContentSize;
        lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height - 12.0),lblSize};
        
    }
    else if ([sectionName isEqualToString:kPaymentSummarySection])
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 51.0);
        lbl.text = @"PAYMENT SUMMARY";
        CGSize lblSize = lbl.intrinsicContentSize;
        lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height - 12.0),lblSize};
    }
    else if ([sectionName isEqualToString:kOrderSummarySection])
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 51.0);
        lbl.text = @"ORDER SUMMARY";
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
    NSString*sectionName = [self getStringForSection:section];

    if ([sectionName isEqualToString:kOrderDatesSection])
    {
        return 44.0;
    }
    else
        return 51.0 ;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString*sectionName = [self getStringForSection:section];
    
    if ([sectionName isEqualToString:kOrderSummarySection])
    {
        return 24.0;
    }
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString*sectionName = [self getStringForSection:section];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0)];
    view.backgroundColor = kSectionBgColor;
    if ([sectionName isEqualToString:kOrderSummarySection])
    {
        view.frame = (CGRect){0, 0, self.view.frame.size.width, 24.0};
    }
    else
    {
        view.frame = (CGRect){0, 0, self.view.frame.size.width, 1.0};
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*sectionName = [self getStringForSection:indexPath.section];

    if ([sectionName isEqualToString:kOrderDatesSection])
    {
        NSAttributedString *leftStr = [self getAttributedStringForLeftTextWithMode:_orderTypeReceived];
        return [EYAttributedLabelsCell requiredHeightForCellWithAttributedText:leftStr rightLabelText:nil andCellWidth:self.view.frame.size.width];

    }
    else if ([sectionName isEqualToString:kShippingToSection])
    {
        NSAttributedString *str = [self getAttributedStringForShippingCell];
        return [EYCustomAccessoryViewCell requiredHeightForCellWithAttributedText:str andCellWidth:self.view.frame.size.width andMode:EYCustomAccessoryViewCellTypeDefault];
    }
    
    else if ([sectionName isEqualToString:kPaymentSummarySection])
    {
        if (indexPath.row == 0)
        {
            NSAttributedString *leftStr = [self getAttributedStringForLeftTextPayment];
            NSAttributedString *rightStr = [self getAttributedStringForRightTextPayment];
            return [EYAttributedLabelsCell requiredHeightForCellWithAttributedText:leftStr rightLabelText:rightStr andCellWidth:self.view.frame.size.width];
   
        }
        else
        {
            return 56.0;
        }
    }
    else if([sectionName isEqualToString:kOrderSummarySection])
    {
        return [EYOrderCell getHeightForCellWithWidth:self.view.frame.size.width andProductModel:_orderModelReceived];
    }
    else
        return 450;
}

-(NSAttributedString*)getAttributedStringForLeftTextWithMode:(EYMyOrderType)orderTypeR
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentLeft;
    style1.lineSpacing = 4.0;
    
    NSDictionary *dict1 = @{NSFontAttributeName : AN_REGULAR(14.0),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style1
                            };
    
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    style2.lineSpacing = 4.0;
    
    NSDictionary *dict2 = @{NSFontAttributeName : AN_REGULAR(14.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style2
                            };
    
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Placed on" attributes:dict1];
    [attr appendAttributedString:str];
    
    NSString *creationDate = [self getDate:_orderModelReceived.createdOn];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * dateFromString = [dateFormatter dateFromString:_orderModelReceived.createdOn];
    [dateFormatter setDateFormat:@"KK:mma"];
    NSString *creationTime = [[dateFormatter stringFromDate:dateFromString]lowercaseString ];
   
    str = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@, %@\n",creationDate,creationTime] attributes:dict2];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc]initWithString:@"Delivery on" attributes:dict1];
    [attr appendAttributedString:str];
    
    int rentDur = [_orderModelReceived.rentalType intValue];
    if(rentDur == 1)
    {
        rentDur = 4;
    }
    else
    {
        rentDur = 8;
    }
    NSString *deliveryDate;
    NSString *pickupDate;
    if (orderTypeR == EYOrderCurrent)
    {
       deliveryDate = [self getDate:_orderModelReceived.expectedDeliveryDate];
        pickupDate =  [self getDate:_orderModelReceived.expectedPickUpDate];
    }
    else
    {
        deliveryDate = [self getDate:_orderModelReceived.deliveredOn];
        pickupDate = [self getDate:_orderModelReceived.pickedUpOn];
    }

    
    str = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@, %d day Rental\n",deliveryDate,rentDur] attributes:dict2];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc]initWithString:@"Pickup on" attributes:dict1];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",pickupDate] attributes:dict2];
    [attr appendAttributedString:str];

    return attr;
    
}

- (NSAttributedString*)getAttributedStringForShippingCell
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
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,",_shippingModelObj.fullName] attributes:dict1];
    [attr appendAttributedString:str];
    
    if (_shippingModelObj.contactNum.length > 0)
    {
        str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,",_shippingModelObj.contactNum] attributes:dict3];
        [attr appendAttributedString:str];
        
    }
    
    str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@,%@\n%@-%@\n%@,%@",_shippingModelObj.addressLine1,_shippingModelObj.addressLine2,_shippingModelObj.cityName,_shippingModelObj.pincode,_shippingModelObj.stateName,_shippingModelObj.countryName] attributes:dict2];
    
    [attr appendAttributedString:str];
    return attr;
}

-(NSAttributedString*)getAttributedStringForLeftTextPayment
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
-(NSAttributedString*)getAttributedStringForRightTextPayment
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
    
    NSAttributedString *strRight = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[[EYUtility shared]getCurrencyFormatFromNumber:[_orderModelReceived.amountPaidExclTax floatValue] ]] attributes:dict3];
    [attrRight appendAttributedString:strRight];
    
    strRight = [[NSAttributedString alloc]initWithString:@"Free\n" attributes:dict4];
    [attrRight appendAttributedString:strRight];
    
    strRight = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n",[[EYUtility shared]getCurrencyFormatFromNumber:[_orderModelReceived.tax floatValue]]] attributes:dict4];
    [attrRight appendAttributedString:strRight];
    
    strRight = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[_orderModelReceived.promoCodesDiscount floatValue]]] attributes:dict4];
    [attrRight appendAttributedString:strRight];
    return attrRight;
}
    
-(NSString*)getDate:(NSString*)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dd = [dateFormatter dateFromString:dateStr];
    NSString *ddString =[[EYUtility shared]getDateWithSuffix:dd];
    return ddString;
}

@end
