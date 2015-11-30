//
//  deliveryDateTableViewCell.m
//  eyVee
//
//  Created by Disha Jain on 11/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import "RentalTableViewCell.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface RentalTableViewCell()
{
    UIImageView *buttonSeparator;
    UIView *separatorLine;
}
@property (strong,nonatomic)UILabel *labelRentalPeriod;
@end

@implementation RentalTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setup];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    return self;
}

-(void)setup
{
    _labelRentalPeriod = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelRentalPeriod.numberOfLines = 1;
    _labelRentalPeriod.text = @"Rental Period";
    _labelRentalPeriod.font = AN_REGULAR(15);
    [_labelRentalPeriod setTextColor:kRowLeftLabelColor];
    [self.contentView addSubview:_labelRentalPeriod];
    
    _buttonDay1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_buttonDay1 setTitle:@"4 day" forState:UIControlStateNormal];
    _buttonDay1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _buttonDay1.titleLabel.font = AN_REGULAR(15);
    [_buttonDay1 setTintColor:kTextFieldTypingColor];
    [_buttonDay1 setTag:4];
    [self.contentView addSubview:_buttonDay1];
    
    _buttonDay2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contentView addSubview:_buttonDay2];
    [_buttonDay2 setTitle:@"8 day" forState:UIControlStateNormal];
    [_buttonDay2 setTag:8];
    _buttonDay2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    _buttonDay2.titleLabel.font = AN_REGULAR(15);
    [_buttonDay2 setTintColor:kAppLightGrayColor];

    buttonSeparator = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:buttonSeparator];
    [buttonSeparator setBackgroundColor:kSeparatorColor];

    separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    separatorLine.backgroundColor = kSeparatorColor;
    [self addSubview:separatorLine];
}

-(void)updateMode:(rentalCellMode)rentalCellModeSelected
{
    self.rentalCellType = rentalCellModeSelected;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    CGFloat remainingW ;
    
    CGSize labelRentalSize = [EYUtility sizeForString:_labelRentalPeriod.text font:_labelRentalPeriod.font width:rect.size.width * .5];

    if (self.rentalCellType == rentalCellFilter)
    {
        _labelRentalPeriod.frame = (CGRect){kTableViewLargePadding, (rect.size.height - labelRentalSize.height) / 2, (rect.size.width * .5) - kTableViewLargePadding, labelRentalSize.height};
       remainingW = rect.size.width - (self.labelRentalPeriod.frame.size.width + kTableViewLargePadding);

    }
    else
    {
        _labelRentalPeriod.frame = (CGRect){kProductDescriptionPadding, (rect.size.height - labelRentalSize.height) / 2, (rect.size.width * .5) - kProductDescriptionPadding, labelRentalSize.height};
        remainingW = rect.size.width - (self.labelRentalPeriod.frame.size.width + kProductDescriptionPadding);

 
    }
   

    float offsetX = 16;
    CGFloat btnW = remainingW / 2;
    self.buttonDay1.frame = (CGRect) {_labelRentalPeriod.frame.origin.x + _labelRentalPeriod.frame.size.width, 0.0, btnW - offsetX, rect.size.height};
    self.buttonDay2.frame = (CGRect) {self.buttonDay1.frame.origin.x + self.buttonDay1.frame.size.width + 0 , 0.0, btnW + offsetX, rect.size.height};
    [self.buttonDay2 setTitleEdgeInsets:UIEdgeInsetsMake(0, offsetX, 0, 0)];
    float thickness = 1.0;

    buttonSeparator.frame = (CGRect) {self.buttonDay2.frame.origin.x, 0.0, thickness, rect.size.height};
    
    separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
}


- (void)updateCellWithFourRentDict:(NSMutableDictionary *)fourRentDict withEightRentDict:(NSMutableDictionary *)eightRentDict
{
    if (fourRentDict)
    {
        [_buttonDay1 setTintColor:kTextFieldTypingColor];
        [_buttonDay2 setTintColor:kAppLightGrayColor];

    }
    else if(eightRentDict)
    {
        [_buttonDay1 setTintColor:kAppLightGrayColor];
       [_buttonDay2 setTintColor:kTextFieldTypingColor];
    }
}


-(void)updateCellWithAppliedFilters:(NSInteger) value
{
    if (value == 4)
    {
        [_buttonDay1 setTintColor:kTextFieldTypingColor];
        [_buttonDay2 setTintColor:kAppLightGrayColor];
        
    }
    else
    {
        [_buttonDay1 setTintColor:kAppLightGrayColor];
        [_buttonDay2 setTintColor:kTextFieldTypingColor];
    }
}


@end
