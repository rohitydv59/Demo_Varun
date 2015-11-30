//
//  productDescriptionCell.m
//  eyVee
//
//  Created by Disha Jain on 12/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import "ProductDescriptionCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface ProductDescriptionCell()

@property(strong,nonatomic)UILabel *productDesc;
@property (nonatomic, strong) UIView * separatorLine;

@end

@implementation ProductDescriptionCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
    _productDesc.font = AN_REGULAR(15);
    _productDesc.textColor = kAnswerTextColor;
    [self.contentView addSubview:_productDesc];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
}

- (void)updateProductDescLabelText:(NSString *)text
{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _productDesc.attributedText = [ProductDescriptionCell getDescription:text];
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGRect rect = self.contentView.bounds;
    CGFloat availableW = rect.size.width - kProductDescriptionPadding*2;
    CGSize stringSize = [EYUtility sizeForAttributedString:_productDesc.attributedText width:availableW];
    
    _productDesc.frame = (CGRect){kProductDescriptionPadding,14.0,stringSize};
    
    CGFloat thickness = 1.0;
    
     _separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
    
}

+ (CGFloat)requiredHeightForRowWith:(CGFloat)width forText:(NSString *)text
{
    CGFloat h = 0.0;
    
    h+=14.0;
    
    
    NSAttributedString *str = [ProductDescriptionCell getDescription:text];
    CGFloat availableWidth = width - 2*kProductDescriptionPadding;
    CGSize strSize = [EYUtility sizeForAttributedString:str width:availableWidth];
    CGFloat thickness = 1.0;
    h+=strSize.height + 24.0-8.0 + thickness;
    
    return h;
}

+ (NSAttributedString *)getDescription:(NSString *)text
{
    if (!text) {
        text = @"";
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *firstLine = @{NSFontAttributeName : AN_REGULAR(15.0),
                                NSForegroundColorAttributeName : kAnswerTextColor,
                                NSParagraphStyleAttributeName:style
                                
                                };
    
    NSAttributedString *titleStr = [[NSAttributedString alloc] initWithString:text attributes:firstLine];
    [attr appendAttributedString:titleStr];
    
    return attr;
}

@end
