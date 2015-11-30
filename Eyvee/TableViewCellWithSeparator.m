//
//  TableViewCellWithSeparator.m
//  Eyvee
//
//  Created by Varun Kapoor on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "TableViewCellWithSeparator.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface TableViewCellWithSeparator()

@property (nonatomic, strong) UIView * separatorLine;
@property (nonatomic, strong) NSString *labelText;
@end

@implementation TableViewCellWithSeparator

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setup];

    }
    return self;
}


-(void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    _productDesc = [[UILabel alloc]initWithFrame:CGRectZero];
    _productDesc.numberOfLines = 0;
    [_productDesc setFont:AN_REGULAR(24)];
    _productDesc.textColor = kBlackTextColor;
    [self.contentView addSubview:_productDesc];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor =  kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.imgView setContentMode:UIViewContentModeRight];
    [self.imgView setImage:[UIImage imageNamed:@"arrow_right"]];
    [self.contentView addSubview:self.imgView];
}

- (void)updateTextOfLabel:(NSString *) text
{
    [_productDesc setText:text];
    [self setNeedsLayout];

}

-(void)updateCellFont:(UIFont *)font
{
    [_productDesc setFont:font];
}

-(void)updateCellFontColor:(UIColor *)color
{
    _productDesc.textColor = color;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    CGFloat thickness = 1.0;

    float remainingWidth = rect.size.width - (2 * kProductDescriptionPadding);
    CGSize labelSize = [EYUtility sizeForString:self.productDesc.text font:self.productDesc.font width:remainingWidth];
    
    _productDesc.frame = (CGRect){kProductDescriptionPadding,  (rect.size.height - labelSize.height) / 2, labelSize.width , labelSize.height};
    _separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
    
    self.imgView.frame = CGRectMake(rect.size.width - kProductDescriptionPadding - kdefaultCellPadding, (kFilterCellHeight - kdefaultCellPadding) / 2, kdefaultCellPadding, kdefaultCellPadding);
    
    if (self.isFilterMode)
    {

        float remainingWidth = rect.size.width - (2 * kTableViewLargePadding);
        CGSize labelSize = [EYUtility sizeForString:self.productDesc.text font:self.productDesc.font width:remainingWidth];
        _productDesc.frame = (CGRect){kTableViewLargePadding,  (rect.size.height - (labelSize.height + kcellPadding - 3)), labelSize.width , labelSize.height};
        _separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
        self.imgView.frame = CGRectMake(rect.size.width - kTableViewLargePadding - rect.size.height, 0.0, rect.size.height, rect.size.height);
    }
}

+(CGFloat)requiredheightForRowWithWidth:(CGFloat)width andText:(NSString*)text
{
    CGFloat h = 0.0;
    h+= 12.0;
    CGSize sizeOfLabel = [EYUtility sizeForString:text font:AN_REGULAR(24.0) width:width-2*kProductDescriptionPadding];
    h+=sizeOfLabel.height+kProductDescriptionPadding;
    return h;
}

-(void) setIsFilterMode:(BOOL)isFilterMode
{
    _isFilterMode = isFilterMode;
    if (isFilterMode)
    {
        [self.imgView setHidden:NO];
    }
    else
    {
        [self.imgView setHidden:YES];
    }
}


@end
