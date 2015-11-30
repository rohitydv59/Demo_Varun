//
//  EYPaymentOptionCell.m
//  Eyvee
//
//  Created by Neetika Mittal on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYPaymentOptionCell.h"
#import "EYConstant.h"

@interface EYPaymentOptionCell ()

@property (nonatomic, strong) UIImageView *checkBox;
@property (nonatomic, strong) UILabel *label;
@property (strong, nonatomic) UIView *separatorLine;

@end

@implementation EYPaymentOptionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.font = AN_MEDIUM(14.0);
    self.label.textColor = kBlackTextColor;
    [self.contentView addSubview:_label];
    
    self.checkBox = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.checkBox.contentMode = UIViewContentModeCenter;
    self.checkBox.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_checkBox];

    self.isCellSelected = NO;
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];

}

- (void)setIsCellSelected:(BOOL)isCellSelected
{
    _isCellSelected = isCellSelected;
    if (isCellSelected)
    {

        self.checkBox.image = [UIImage imageNamed:@"checked"];
    }
    else
    {
        self.checkBox.image = [UIImage imageNamed:@"unchecked"];
    }
    [self setNeedsLayout];
}

- (void)updateLabelText:(NSString *)text
{
    self.label.text = text;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    
    CGFloat padding = kProductDescriptionPadding;
    
    CGSize imgSize = self.checkBox.image.size;
    self.checkBox.frame = (CGRect) {rect.size.width - kProductDescriptionPadding - imgSize.width, floorf((rect.size.height - imgSize.height)/2.0), imgSize};
    
    CGSize lblSize = self.label.intrinsicContentSize;
    self.label.frame = (CGRect) {padding , floorf((rect.size.height - lblSize.height)/2.0), lblSize};
    
    CGFloat thickness = 1.0;
     _separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
}

+ (CGFloat)requiredHeight
{
    CGFloat padding = kTableViewSidePadding;
    CGSize imgSize = [UIImage imageNamed:@"tick_on"].size;
    CGFloat h = MAX(imgSize.height, MEDIUM(16.0).lineHeight);
    h += 2 * padding;
    return h;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
