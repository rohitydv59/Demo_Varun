//
//  EYMeTableViewCell.m
//  Eyvee
//
//  Created by Disha Jain on 14/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYMeTableViewCell.h"
#import "EYConstant.h"
#import "EYUtility.h"
@interface EYMeTableViewCell()
{
    UIView * separatorLine;
  
}
@property (nonatomic, strong) UIImageView * accessoryImageView;

@end

@implementation EYMeTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _rowLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _rowLabel.font = AN_MEDIUM(14.0);
    _rowLabel.textColor = kBlackTextColor;
    [self.contentView addSubview:_rowLabel];
    
    _leftImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _leftImage.contentMode = UIViewContentModeScaleAspectFill;
    _leftImage.clipsToBounds = YES;
    [self.contentView addSubview:_leftImage];
    
    _accessoryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_next"]];
    [self.contentView addSubview:_accessoryImageView];
    
    separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    separatorLine.backgroundColor = kSeparatorColor;
    [self addSubview:separatorLine];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize available = self.contentView.bounds.size;
    
    float x_pos = 0.0;
    float y_pos = 0.0;
    
    CGSize leftImageSize = (CGSize){KMeSectionImageW,KMeSectionImageW};
    _leftImage.frame =  (CGRect) {kdefaultCellPadding, (available.height -leftImageSize.height)/2 , leftImageSize};
    
    float availableWidth = available.width - _leftImage.frame.size.width - kImageTextPadding-kdefaultCellPadding*2-kProductDescriptionPadding;
    CGSize textSize = [EYUtility sizeForString:_rowLabel.text font:_rowLabel.font width:availableWidth];
    x_pos = _leftImage.frame.origin.x + _leftImage.frame.size.width + kImageTextPadding;
    y_pos = (available.height - textSize.height)/2;
    _rowLabel.frame = (CGRect) {x_pos, y_pos,textSize};
    
    _accessoryImageView.frame = (CGRect){available.width - kdefaultCellPadding - kProductDescriptionPadding,(available.height-kdefaultCellPadding)/2,kdefaultCellPadding,kdefaultCellPadding};
    
    CGFloat thickness = 1.0;
    separatorLine.frame = CGRectMake(0, available.height - thickness, available.width, thickness);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
