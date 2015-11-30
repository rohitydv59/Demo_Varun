//
//  EYMyOrdersCell.m
//  Eyvee
//
//  Created by Disha Jain on 15/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYMyOrdersCell.h"
#import "UIImageView+AFNetworking.h"

@interface EYMyOrdersCell()
@property (strong, nonatomic) UIImageView *itemImage;
@property (strong, nonatomic) UILabel *productBrand;
@property (strong, nonatomic) UILabel *productName;
@property (strong, nonatomic) UILabel *productSize;
@property (strong, nonatomic) UILabel *deliveryDate;
@property (strong, nonatomic) UILabel *pickupDate;
@property (strong, nonatomic) UILabel *creationDate;
@property (strong, nonatomic) UIImageView *accessoryImageView;
@property (strong, nonatomic) UIView *separatorLine;
@property (strong, nonatomic) NSString *stringTime;
@end
@implementation EYMyOrdersCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.itemImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.itemImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.itemImage setClipsToBounds:YES];
    [self.itemImage setBackgroundColor:kLightGrayBgColor];
    [self.contentView addSubview:self.itemImage];
    
    self.productName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productName.numberOfLines = 0;
    self.productName.font = AN_REGULAR(14.0);
    self.productName.textColor = kRowLeftLabelColor;
    [self.contentView addSubview:self.productName];
    
    self.productBrand = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productBrand.numberOfLines = 1;
    self.productBrand.font = AN_MEDIUM(14.0);
    self.productBrand.textColor = kBlackTextColor;
//    self.productBrand.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.productBrand];
    
    self.productSize = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productSize.numberOfLines = 1;
    self.productSize.font = AN_MEDIUM(13.0);
//    self.productSize.textAlignment = NSTextAlignmentLeft;
    self.productSize.textColor = kBlackTextColor;
    [self.contentView addSubview:self.productSize];
    
    self.deliveryDate = [[UILabel alloc] initWithFrame:CGRectZero];
    self.deliveryDate.numberOfLines = 0;
    self.deliveryDate.textColor = kBlackTextColor;
    self.deliveryDate.font = AN_REGULAR(12.0);
//    self.deliveryDate.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.deliveryDate];
    
    self.pickupDate = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pickupDate.numberOfLines = 0;
    self.pickupDate.textColor = kBlackTextColor;
    self.pickupDate.font = AN_REGULAR(12.0);
//    self.pickupDate.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.pickupDate];
    
    self.creationDate = [[UILabel alloc] initWithFrame:CGRectZero];
    self.creationDate.numberOfLines = 0;
    [self.contentView addSubview:self.creationDate];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
    
    _accessoryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_next"]];
    [self.contentView addSubview:_accessoryImageView];

}

-(void)setCurrentProduct:(EYAllOrdersMtlModel *)order andOrderType:(EYMyOrderType)type
{
    self.orderType = type;
    self.productName.text = order.productName;
    self.productBrand.text = order.brandName;
    NSString *imageString = order.productThumbnailImage;
    NSURL *urlImage = [NSURL URLWithString:imageString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlImage];
    UIImage *img = [[UIImageView sharedImageCache] cachedImageForRequest:urlRequest];
    if (img)
    {
        [self.itemImage cancelImageRequestOperation];
        _itemImage.image = img;
        [self setNeedsLayout];
    }
    else
    {
        __weak __typeof(self)weakSelf = self;
        [self.itemImage setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakSelf processImage:image];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [weakSelf processImage:nil];
            
        }];
    }
   
    
    //Creation Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * dateFromString = [dateFormatter dateFromString:order.createdOn];
    NSString *dateString =[[EYUtility shared]getDateWithoutSuffix:dateFromString]; //date like 21 Oct
    [dateFormatter setDateFormat:@"KK:mma"];
    _stringTime = [[dateFormatter stringFromDate:dateFromString]lowercaseString ];
    self.creationDate.attributedText = [self getAttributedDateAndTimeString:dateString andTimeString:_stringTime];
    
    //Product Size
    if ([order.size isEqualToString:@"free size"])
    {
       _productSize.text = [NSString stringWithFormat:@"Size %@",@"Free"];
    }
    else
    {
        _productSize.text = [NSString stringWithFormat:@"Size %@",order.size];
    }
    //Delivery and pick  up dates
    if (type == EYOrderCurrent)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dd = [dateFormatter dateFromString:order.expectedDeliveryDate];
        NSString *ddString =[[EYUtility shared]getDateWithSuffixShortMonth:dd];
        NSDate *pd = [dateFormatter dateFromString:order.expectedPickUpDate];
        NSString *pdString =[[EYUtility shared]getDateWithSuffixShortMonth:pd];
        self.deliveryDate.attributedText = [self setProductDate:ddString forDateType:@"Expected Delivery "];
        self.pickupDate.attributedText = [self setProductDate:pdString forDateType:@"Pickup "];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dd = [dateFormatter dateFromString:order.deliveredOn];
        NSString *ddString =[[EYUtility shared]getDateWithSuffixShortMonth:dd];
        NSDate *pd = [dateFormatter dateFromString:order.pickedUpOn];
        NSString *pdString =[[EYUtility shared]getDateWithSuffixShortMonth:pd];
        self.deliveryDate.attributedText = [self setProductDate:ddString forDateType:@"Delivered "];
        self.pickupDate.attributedText = [self setProductDate:pdString forDateType:@"Pickup Done "];
    }
 }

-(void)processImage:(UIImage*)image
{
    [self.itemImage setImage:image];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    //Item Image
    CGSize sizeOfImageView = (CGSize){cellProductImageW,cellProductImageH};
    _itemImage.frame = (CGRect){kProductDescriptionPadding,kProductDescriptionPadding,sizeOfImageView};
    
    //ProductBrand
    CGSize sizeOfBrandName = [EYUtility sizeForString:self.productBrand.text font:AN_MEDIUM(14.0)];
    _productBrand.frame = (CGRect){CGRectGetMaxX(self.itemImage.frame)+kProductDescriptionPadding,kProductDescriptionPadding,sizeOfBrandName};
   
    //Creation Date
    CGSize sizeOfCreationDate = [EYUtility sizeForAttributedString:self.creationDate.attributedText width:size.width];
    _creationDate.frame = (CGRect){size.width - kProductDescriptionPadding - sizeOfCreationDate.width,kProductDescriptionPadding,sizeOfCreationDate};
   
    //Product Name
    CGFloat availableWForProductName = size.width - (kProductDescriptionPadding*3 + sizeOfCreationDate.width + kProductDescriptionPadding + sizeOfImageView.width);
    CGSize sizeOfProductName = [EYUtility sizeForString:_productName.text font:AN_REGULAR(14.0) width:availableWForProductName];
    _productName.frame = (CGRect){_productBrand.frame.origin.x,CGRectGetMaxY(_productBrand.frame)+ 3.0,sizeOfProductName.width,sizeOfProductName.height};
    
    //Product Size
    CGSize sizeOfProductSize = [EYUtility sizeForString:_productSize.text font:AN_MEDIUM(13.0) width:availableWForProductName];
    _productSize.frame = (CGRect){_productBrand.frame.origin.x,CGRectGetMaxY(_productName.frame)+3.0,sizeOfProductSize};
    
    //Separator
    CGFloat thickness = 1.0 ;
    _separatorLine.frame = CGRectMake(_productBrand.frame.origin.x, kLineAndTextSpacing+CGRectGetMaxY(self.productSize.frame), size.width - kProductDescriptionPadding*3 - sizeOfImageView.width, thickness);
    //right accessory view
    _accessoryImageView.frame = (CGRect){size.width - 16.0 - kProductDescriptionPadding,kProductDescriptionPadding + CGRectGetMaxY(self.separatorLine.frame),16.0,16.0};
    
    //Delivery Date
    CGFloat availableWForDate = size.width - (kProductDescriptionPadding*4 + sizeOfImageView.width + 16.0);
    CGSize sizeOfDeliveryDate = [EYUtility sizeForAttributedString:_deliveryDate.attributedText width:availableWForDate];
    _deliveryDate.frame = (CGRect){_productBrand.frame.origin.x,CGRectGetMaxY(_separatorLine.frame) + kLineAndTextSpacing,sizeOfDeliveryDate};
    
    //Pick Up Date
    CGSize sizeOfPickUpDate = [EYUtility sizeForAttributedString:_pickupDate.attributedText width:availableWForDate];
    _pickupDate.frame = (CGRect){_productBrand.frame.origin.x,CGRectGetMaxY(_deliveryDate.frame) + 3.0,sizeOfPickUpDate};
    
}
//For Date and Time Label on Right Side
-(NSAttributedString*)getAttributedDateAndTimeString:(NSString*)dateString andTimeString:(NSString*)timeString
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentRight;
   
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    style2.alignment = NSTextAlignmentRight;
    style2.lineSpacing = 2.0;
    
    if (dateString.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:dateString attributes:@{
                                                                                NSFontAttributeName: AN_REGULAR(14.0),
                                                                                NSForegroundColorAttributeName : kAppLightGrayColor,
                                                                                NSParagraphStyleAttributeName : style1
                                                                                }];
        [mutAttr appendAttributedString:attr];
    }
    
    if (timeString.length >0)
    {
        attr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",timeString] attributes:@{
                                                                                NSFontAttributeName: AN_REGULAR(14.0),
                                                                                NSForegroundColorAttributeName : kAppLightGrayColor,
                                                                                NSParagraphStyleAttributeName : style2
                                                                                }];
        [mutAttr appendAttributedString:attr];

    }
            return mutAttr;
}

//For Delivery and pIck up Dates
-(NSAttributedString *)setProductDate:(NSString*)dateObtained forDateType:(NSString*)dateType
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    if (dateObtained.length > 0)
    {
        attr = [[NSAttributedString alloc] initWithString:dateType attributes:@{
                                                                                NSFontAttributeName: AN_MEDIUM(13.0),
                                                                                NSForegroundColorAttributeName : kBlackTextColor
                                                                                }];
        [mutAttr appendAttributedString:attr];
        
        attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"- %@",dateObtained] attributes:@{
                                                                                                                        NSFontAttributeName: AN_REGULAR(13.0),
                                                                                                                        NSForegroundColorAttributeName : kAppLightGrayColor
                                                                                                                        }];
        [mutAttr appendAttributedString:attr];
    }
    return mutAttr;
}

+(CGFloat)getHeightForCellWithWidth:(CGFloat)width cellData:(EYAllOrdersMtlModel *)order andOrderType:(EYMyOrderType)myorderType
{
    //compute dynamic height
    CGFloat h = 0.0;
    
    CGSize sizeOfImageView = (CGSize){64,96};
    
    CGSize sizeOfBrandName = [EYUtility sizeForString:order.brandName font:AN_MEDIUM(14.0)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSDate * dateFromString = [dateFormatter dateFromString:order.createdOn];
    NSString *dateStringObtained =[[EYUtility shared]getDateWithoutSuffix:dateFromString];
    
    [dateFormatter setDateFormat:@"KK:mma"];
    NSString *timeStringObtained = [dateFormatter stringFromDate:dateFromString];
    
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentRight;
    
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    style2.alignment = NSTextAlignmentRight;
    style2.lineSpacing = 2.0;
    
    if (dateStringObtained.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:dateStringObtained attributes:@{
                                                                                  NSFontAttributeName: AN_REGULAR(14.0),
                                                                                  NSForegroundColorAttributeName : kAppLightGrayColor,
                                                                                  NSParagraphStyleAttributeName : style1
                                                                                  }];
        [mutAttr appendAttributedString:attr];
    }
    
    if (timeStringObtained.length >0)
    {
        attr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",timeStringObtained] attributes:@{
                                                                                 NSFontAttributeName: AN_REGULAR(14.0),
                                                                                 NSForegroundColorAttributeName : kAppLightGrayColor,
                                                                                 NSParagraphStyleAttributeName : style2
                                                                                 }];
        [mutAttr appendAttributedString:attr];
        
    }
    CGSize sizeOfCreationDate = [EYUtility sizeForAttributedString:mutAttr width:width];

    CGFloat availableWForProductName = width - (kProductDescriptionPadding*3 + sizeOfCreationDate.width + kProductDescriptionPadding + sizeOfImageView.width);
    CGSize sizeOfProductName = [EYUtility sizeForString:order.productName font:AN_REGULAR(14.0) width:availableWForProductName];
    
    NSString *dummySize;
    if ([order.size isEqualToString:@"free size"]) {
        dummySize = [NSString stringWithFormat:@"Size %@",@"Free"];
    }
    else
    {
        dummySize = [NSString stringWithFormat:@"Size %@",order.size];
    }
    CGSize sizeOfProductSize= [EYUtility sizeForString:dummySize font:AN_MEDIUM(13.0)];
    
    CGFloat sum = sizeOfBrandName.height + 3.0+ sizeOfProductName.height+3.0 +sizeOfProductSize.height + 1.0+kLineAndTextSpacing  ;
    
    h= sum + kLineAndTextSpacing;
    
    CGFloat availableWForDate = width - (kProductDescriptionPadding*4 + sizeOfImageView.width + 16.0);
    
    if (myorderType == EYOrderCurrent)
    {
        NSMutableAttributedString *mutAttr1 = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *mutAttr2 = [[NSMutableAttributedString alloc] init];
        NSAttributedString *attr;
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dd = [dateFormatter dateFromString:order.expectedDeliveryDate];
        NSString *ddString =[[EYUtility shared]getDateWithSuffixShortMonth:dd];
        NSDate *pd = [dateFormatter dateFromString:order.expectedPickUpDate];
        NSString *pdString =[[EYUtility shared]getDateWithSuffixShortMonth:pd];
        
        if (ddString.length > 0) //For Expected delivery date
        {
            attr = [[NSAttributedString alloc] initWithString:@"Expected Delivery " attributes:@{
                                                                                      NSFontAttributeName: AN_MEDIUM(13.0),
                                                                                      NSForegroundColorAttributeName : kBlackTextColor,
                                                                                      }];
            [mutAttr1 appendAttributedString:attr];
            attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"- %@",ddString] attributes:@{
                                                                                                                        NSFontAttributeName: AN_REGULAR(13.0),
                                                                                                                        NSForegroundColorAttributeName : kAppLightGrayColor
                                                                                                                        }];
            [mutAttr1 appendAttributedString:attr];
            CGSize sizeOfExpectedDeliveryLabel = [EYUtility sizeForAttributedString:mutAttr1 width:availableWForDate];
            h+=sizeOfExpectedDeliveryLabel.height + 3.0;
        }
        
       
        
        if (pdString.length > 0) //For Expected pick up date
        {
            attr = [[NSAttributedString alloc] initWithString:@"Pickup " attributes:@{
                                                                                                NSFontAttributeName: AN_MEDIUM(13.0),
                                                                                                 NSForegroundColorAttributeName : kBlackTextColor,
                                                                                                 }];
            [mutAttr2 appendAttributedString:attr];
            attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"- %@",pdString] attributes:@{
                                                                                                                        NSFontAttributeName: AN_REGULAR(13.0),
                                                                                                                        NSForegroundColorAttributeName : kAppLightGrayColor
                                                                                                                                  }];
            
            [mutAttr2 appendAttributedString:attr];
            CGSize sizeOfExpectedPickupLabel = [EYUtility sizeForAttributedString:mutAttr2 width:availableWForDate];
            h+=sizeOfExpectedPickupLabel.height;

        }
        
    }
    else //order type is past
    {
        NSMutableAttributedString *mutAttr1 = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *mutAttr2 = [[NSMutableAttributedString alloc] init];
        NSAttributedString *attr;
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dd = [dateFormatter dateFromString:order.deliveredOn];
        NSString *ddString =[[EYUtility shared]getDateWithSuffixShortMonth:dd];
        NSDate *pd = [dateFormatter dateFromString:order.pickedUpOn];
        NSString *pdString =[[EYUtility shared]getDateWithSuffixShortMonth:pd];
        if (ddString.length > 0) //For pastdelivery date
        {
            attr = [[NSAttributedString alloc] initWithString:@"Delivered " attributes:@{
                                                                                                 NSFontAttributeName: AN_MEDIUM(13.0),
                                                                                                 NSForegroundColorAttributeName : kBlackTextColor,
                                                                                                 }];
            [mutAttr1 appendAttributedString:attr];
            attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"- %@",ddString] attributes:@{
                                                                                                                                  NSFontAttributeName: AN_REGULAR(13.0),
                                                                                                                                  NSForegroundColorAttributeName : kAppLightGrayColor
                                                                                                                                  }];
            [mutAttr1 appendAttributedString:attr];
            CGSize sizeOfDeliveryLabel = [EYUtility sizeForAttributedString:mutAttr1 width:availableWForDate];
            h+=sizeOfDeliveryLabel.height + 3.0;

        }
        
        
        if (pdString.length > 0) //For past pick up date
        {
            attr = [[NSAttributedString alloc] initWithString:@"Pickup Done " attributes:@{
                                                                                      NSFontAttributeName: AN_MEDIUM(13.0),
                                                                                      NSForegroundColorAttributeName : kBlackTextColor,
                                                                                      }];
            [mutAttr2 appendAttributedString:attr];
            attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"- %@",pdString] attributes:@{
                                                                                                                                  NSFontAttributeName: AN_REGULAR(13.0),
                                                                                                                                  NSForegroundColorAttributeName : kAppLightGrayColor
                                                                                                                                  }];
            
            [mutAttr2 appendAttributedString:attr];
            CGSize sizeOfpickedupLabel = [EYUtility sizeForAttributedString:mutAttr2 width:availableWForDate];
            h+=sizeOfpickedupLabel.height;
        }
        
        

    }
    h+=topPaddingInCell;
    h+=kProductDescriptionPadding ;
    return h;

}
@end
