//
//  EYFAQCell.m
//  Eyvee
//
//  Created by Disha Jain on 20/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYFAQCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYFAQCell()
{
    
}
@property (strong,nonatomic)UILabel *topLabel;
@end


@implementation EYFAQCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    _topLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _topLabel.numberOfLines = 0;

    [self.contentView addSubview:_topLabel];
}

-(void)layoutSubviews
{
    CGSize size = self.contentView.bounds.size;
    
    CGFloat availableSpaceForLabel = size.width-2*kMainTextFieldHeight;
    CGSize sizeForLabel = [EYUtility sizeForAttributedString:_topLabel.attributedText width:availableSpaceForLabel];
    _topLabel.frame = (CGRect){kMainTextFieldHeight,KFAQTopPadding,sizeForLabel};
    
}

-(void)updateTopLabelText:(NSString*)topText bottomText:(NSString*)bottomText
{
   _topLabel.attributedText =  [self setTopText:topText andBottomText:bottomText];
}

-(NSAttributedString*)setTopText:(NSString *)topText andBottomText:(NSString *)bottomText
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacingBefore = 2.0;
    
    if (topText.length > 0)
    {
        attr = [[NSAttributedString alloc] initWithString:topText attributes:@{
                                                                                NSFontAttributeName: AN_MEDIUM(14.0),
                                                                                NSForegroundColorAttributeName : kBlackTextColor
                                                                                }];
        [mutAttr appendAttributedString:attr];
    }
    
    if (bottomText.length>0)
    {
        attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",bottomText] attributes:@{
                                                                                                                        NSFontAttributeName: AN_REGULAR(14.0),
                                                                                                                        NSForegroundColorAttributeName : kAnswerTextColor,
                                                                                                                        NSParagraphStyleAttributeName : style
                                                                                                                        }];
        [mutAttr appendAttributedString:attr];
    }
   
    return mutAttr;
 
}

@end
