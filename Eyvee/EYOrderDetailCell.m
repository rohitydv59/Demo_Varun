//
//  EYOrderDetailCell.m
//  Eyvee
//
//  Created by Disha Jain on 24/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYOrderDetailCell.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface EYOrderDetailCell ()


@property (strong, nonatomic) UIView *separatorLine;

@end

@implementation EYOrderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMode:(EYLabelCellMode)mode
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
      
        [self setUpWithMode:mode];
        
    }
    
    return self;
}

-(void)setUpWithMode:(EYLabelCellMode)mode
{
    
    _cellMode = mode;
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _leftLabel.numberOfLines = 1;
    
    [self.contentView addSubview: _leftLabel];
    
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _rightLabel.numberOfLines = 1;
    
    [self.contentView addSubview:_rightLabel];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
    
    if (mode == EYBagSummaryLabel) //total cell in bag summary vc
    {
        _rightLabel.font = AN_MEDIUM(20.0);
        _leftLabel.font = AN_REGULAR(20.0);

    }
    else if (mode == EYReviewOrderLabel) //total cell in review order vc
    {
        _rightLabel.font = AN_BOLD(16.0);
        _leftLabel.font = AN_REGULAR(20.0);
    }
    else
    {
        _rightLabel.font = AN_BOLD(20.0);
        _rightLabel.textColor = kBlackTextColor;
        _leftLabel.font = AN_REGULAR(20.0);
        _leftLabel.textColor = kBlackTextColor;
    }
  
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    
    
    
    if (self.cellMode == EYBagSummaryLabel || self.cellMode == EYReviewOrderLabel)
    {
        CGSize sizeOfRightLabel = _rightLabel.intrinsicContentSize;
        
        _rightLabel.frame = (CGRect){rect.size.width - sizeOfRightLabel.width - kProductDescriptionPadding,(rect.size.height-sizeOfRightLabel.height)/2,sizeOfRightLabel};
        
        CGSize sizeOfLeftLabel = _leftLabel.intrinsicContentSize;
        
        _leftLabel.frame = (CGRect){kProductDescriptionPadding,(rect.size.height-sizeOfLeftLabel.height)/2,sizeOfLeftLabel};
        
        CGFloat thickness = 1.0;
        _separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
  
    }
    else
    {
        CGSize sizeOfRightLabel = _rightLabel.intrinsicContentSize;
        
        _rightLabel.frame = (CGRect){rect.size.width - sizeOfRightLabel.width - kcellPadding,(rect.size.height-sizeOfRightLabel.height)/2,sizeOfRightLabel};
        
        CGSize sizeOfLeftLabel = _leftLabel.intrinsicContentSize;
        
        _leftLabel.frame = (CGRect){kcellPadding,(rect.size.height-sizeOfLeftLabel.height)/2,sizeOfLeftLabel};
    }
    
    
    
}

-(void)updateCellDataWithLeftLabel:(NSString*)leftLabelText andRightLabel:(NSString*)rightLabelText andMode:(EYLabelCellMode)mode
{
    if (mode == EYOrderDetailLabel)
    {
        _leftLabel.attributedText = [self setAttributedTextForLeftLabelWithText:leftLabelText];
        _rightLabel.attributedText =  [self setAttributedTextForRightLabelWithText:rightLabelText];
    }
    else
    {
        _leftLabel.text = leftLabelText;
        _rightLabel.text = rightLabelText;
    }
    
}

-(NSAttributedString*)setAttributedTextForLeftLabelWithText:(NSString*)leftLabelText
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    if (leftLabelText.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:leftLabelText attributes:@{
                                                                             NSFontAttributeName: REGULAR(15.0),
                                                                             NSForegroundColorAttributeName : [UIColor darkGrayColor],
                                                                             NSParagraphStyleAttributeName : style
                                                                             }];
        [mutAttr appendAttributedString:attr];
    }
    
    return mutAttr;
    

}

-(NSAttributedString*)setAttributedTextForRightLabelWithText:(NSString*)rightLabelText
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    if (rightLabelText.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:rightLabelText attributes:@{
                                                                                     NSFontAttributeName: REGULAR(15.0),
                                                                                     NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                     NSParagraphStyleAttributeName : style
                                                                                     }];
        [mutAttr appendAttributedString:attr];
    }
    
    return mutAttr;
}

+(CGFloat)getHeightForCellWithLeftLabel:(NSString*)leftText leftLabelFont:(UIFont*)leftfont rightLabelText:(NSString*)rightText rightLabelFont:(UIFont*)rightFont
{
    CGFloat h = 0.0;
    
    CGSize sizeOfLeftLabel = [EYUtility sizeForString:leftText font:leftfont];
    CGSize sizeOfRightLabel = [EYUtility sizeForString:rightText font:rightFont];
    
    CGFloat maxH = MAX(sizeOfLeftLabel.height, sizeOfRightLabel.height);
    
    h+=kcellPadding*2 + maxH;
    
    return h;
}

@end
