//
//  PickUpDateTextCell.m
//  Eyvee
//
//  Created by Disha Jain on 07/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "PickUpDateTextCell.h"
#import "EYUtility.h"
#import "EYConstant.h"
@interface PickUpDateTextCell() {
    UIView * separatorLine;
}

@property (nonatomic, strong) UILabel * labelText;


@end

@implementation PickUpDateTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _labelText = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelText.numberOfLines = 0;
        _labelText.attributedText = [self setAttributedText];
        [self.contentView addSubview:_labelText];
        
        separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
        separatorLine.backgroundColor = kSeparatorColor;
        [self.contentView addSubview:separatorLine];
                
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    
    CGSize labelDeliveryDateSize = [EYUtility sizeForAttributedString:_labelText.attributedText width:rect.size.width - 2*kProductDescriptionPadding];
    
    _labelText.frame = (CGRect){kProductDescriptionPadding ,(rect.size.height -labelDeliveryDateSize.height) / 2,rect.size.width - 2*kProductDescriptionPadding, labelDeliveryDateSize.height};
    
    CGFloat thickness = 1.0;
    separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSAttributedString*)setAttributedText
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = 2.0;
    
    NSDictionary *dict2 = @{NSFontAttributeName : AN_MEDIUM(12.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style
                            };
    
    NSDictionary *dict1 = @{NSFontAttributeName : AN_REGULAR(12.0),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style
                            };
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"For pickup, we will call you to schedule a time slot." attributes:dict1];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc]initWithString:@"For any help we are always available at " attributes:dict1];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc]initWithString:@"support@demo.com" attributes:dict2];
    [attr appendAttributedString:str];
    
    return attr;

}

@end
