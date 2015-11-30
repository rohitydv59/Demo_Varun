//
//  rentalTableViewCell.m
//  eyVee
//
//  Created by Disha Jain on 11/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import "DeliveryDateTableViewCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface DeliveryDateTableViewCell() {
    UIView * separatorLine;
}

@property (nonatomic, strong) UILabel * labelDeliveryDate;


@end

@implementation DeliveryDateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMode:(deliveryAndSizeMode)mode
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.mode = mode;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _labelDeliveryDate = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDeliveryDate.numberOfLines = 1;
        _labelDeliveryDate.font = AN_REGULAR(14);
        [_labelDeliveryDate setTextColor:kRowLeftLabelColor];
    
        [self.contentView addSubview:_labelDeliveryDate];
        
        _middleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _middleLabel.numberOfLines = 1;
        _middleLabel.font = AN_REGULAR(15.0);
        [_middleLabel setTextColor:kPlaceholderColor];
        [self.contentView addSubview:_middleLabel];

        _calenderButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:_calenderButton];
        
        separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
        separatorLine.backgroundColor = kSeparatorColor;
        [self addSubview:separatorLine];
        [self updateMode:_mode];
        
    }
    return self;
}

- (void)updateMode:(deliveryAndSizeMode)mode
{
    self.mode = mode;
    if (mode == deliveryDateMode)
    {
        _labelDeliveryDate.text = @"Delivery Date";
        UIImage *image = [UIImage imageNamed:@"cal"];
        [_calenderButton setImage:image forState:UIControlStateNormal];
        [_calenderButton setTintColor:kBlackTextColor];
        
    }
    else if (mode == filterDeliveryDateMode)
    {
        _labelDeliveryDate.text = @"Delivery Date";
        UIImage *image = [UIImage imageNamed:@"cal"];
        [_calenderButton setImage:image forState:UIControlStateNormal];
        [_calenderButton setTintColor:kBlackTextColor];
    }
    else if (mode == pickUpMode)
    {
         _labelDeliveryDate.text = @"Pickup Date";
    }
    else
    {
        //Select Size Mode
        _labelDeliveryDate.text = @"Select Size" ;
        [_calenderButton setAttributedTitle:[self getAttributedStringForButtonWithText:[NSString stringWithFormat:@"%@%@",@"SIZE GUIDE ",kRightSymbol]] forState:UIControlStateNormal];
        
    }
    [self setNeedsLayout];
}

-(void)updateMiddleLabelFromDetailVC:(NSString*)sizeReceived
{
    if (sizeReceived.length > 0)
    {
        _middleLabel.text = sizeReceived;
        _middleLabel.textColor = kBlackTextColor;
  
    }
    else{
        _middleLabel.text = @"Select " ;
        [_middleLabel setTextColor:kPlaceholderColor];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    
    CGSize labelDeliveryDateSize = _labelDeliveryDate.intrinsicContentSize;
    
    CGSize middleLabelSize = [EYUtility sizeForString:self.middleLabel.text font:self.middleLabel.font width:rect.size.width * .5];
    
    if (self.mode == deliveryDateMode) //For FIlter date,For add to cart date delivery
    {
        CGSize buttonSize = CGSizeMake(24, 24);
        _calenderButton.frame = (CGRect){rect.size.width - (kTrailingPadding + buttonSize.width), kdefaultCellPadding, buttonSize};
        
        _labelDeliveryDate.frame = (CGRect){kProductDescriptionPadding ,(rect.size.height -labelDeliveryDateSize.height) / 2,rect.size.width * .5 - kProductDescriptionPadding, labelDeliveryDateSize.height};
        
        _middleLabel.frame = (CGRect){_labelDeliveryDate.frame.origin.x + _labelDeliveryDate.frame.size.width , (rect.size.height - middleLabelSize.height) / 2, rect.size.width * .5, middleLabelSize.height };
    }
   else if (self.mode == filterDeliveryDateMode) //For FIlter date,For add to cart date delivery
    {
       
        _labelDeliveryDate.frame = (CGRect){kTableViewLargePadding ,(rect.size.height -labelDeliveryDateSize.height) / 2,rect.size.width * .5 - kTableViewLargePadding, labelDeliveryDateSize.height};
        CGSize buttonSize = CGSizeMake(24, 24);
        _calenderButton.frame = (CGRect){rect.size.width - (kTrailingPadding + buttonSize.width), kdefaultCellPadding, buttonSize};
        _middleLabel.frame = (CGRect){_labelDeliveryDate.frame.origin.x + _labelDeliveryDate.frame.size.width , (rect.size.height - middleLabelSize.height) / 2, rect.size.width * .5, middleLabelSize.height };
    }
    else
    {
        CGSize sizeOfButtonCalender = [EYUtility sizeForString:_calenderButton.titleLabel.text font:_calenderButton.titleLabel.font];
        _calenderButton.frame = (CGRect){rect.size.width - (sizeOfButtonCalender.width)-kTableViewLargePadding,floorf((rect.size.height - sizeOfButtonCalender.height)/2.0),sizeOfButtonCalender};
        
         _labelDeliveryDate.frame = (CGRect){kProductDescriptionPadding ,(rect.size.height -labelDeliveryDateSize.height) / 2,rect.size.width * .5 - kProductDescriptionPadding, labelDeliveryDateSize.height};
        _middleLabel.frame = (CGRect){_labelDeliveryDate.frame.origin.x + _labelDeliveryDate.frame.size.width , (rect.size.height - middleLabelSize.height) / 2, rect.size.width * .5, middleLabelSize.height };
    }
    
    CGFloat thickness = 1.0;
    separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
}

-(NSAttributedString*)getAttributedStringForButtonWithText:(NSString*)text
{
       NSDictionary*dict = @{
                          NSForegroundColorAttributeName: kBlackTextColor,
                          NSFontAttributeName : AN_REGULAR(11.0)
                          };
    
    NSAttributedString *str = [[NSAttributedString alloc]initWithString:text attributes:dict];

    return str;
}

-(void)openSizeChart:(id)sender
{
    NSLog(@"Open Size CHart");
}

@end
