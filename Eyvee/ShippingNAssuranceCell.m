//
//  ShippingNAssuranceCell.m
//  eyVee
//
//  Created by Disha Jain on 12/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import "ShippingNAssuranceCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface ShippingNAssuranceCell()
@property (nonatomic, strong) UIView * separatorLine;
@property (strong,nonatomic) UIImageView *imgView;
@end

@implementation ShippingNAssuranceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;

        [self setup];
    }
    return self;
}

-(void)setup{
    _titleForRow = [[UILabel alloc]initWithFrame:CGRectZero];
    _titleForRow.numberOfLines = 1;
    _titleForRow.textColor = kBlackTextColor;
    _titleForRow.font = AN_BOLD(11.0);
    [self.contentView addSubview:_titleForRow];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView.image = [UIImage imageNamed:@"arrow_next"];
    [self.contentView addSubview:_imgView];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

    CGRect rect = self.contentView.bounds;
    CGSize sizeOfText = self.titleForRow.intrinsicContentSize;
    self.titleForRow.frame = (CGRect){kProductDescriptionPadding,(rect.size.height-sizeOfText.height)/2,sizeOfText};
    
    CGSize sizeOfSideView = (CGSize){12,12};
    _imgView.frame = (CGRect){rect.size.width - kProductDescriptionPadding- sizeOfSideView.width,16.0,sizeOfSideView};
    
    CGFloat thickness = 1.0;
    _separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
}



@end
