//
//  FavoriteTableViewCell.m
//  Eyvee
//
//  Created by Varun Kapoor on 20/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "FavoriteTableViewCell.h"
#import "EYConstant.h"

@interface FavoriteTableViewCell()
@property (nonatomic, weak) IBOutlet UILabel * label;
@property (nonatomic, weak) IBOutlet UIImageView * imageView;

@end

@implementation FavoriteTableViewCell
@synthesize imageView;

- (void)awakeFromNib
{
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)updateCellWithTopText:(NSString*)topText withMiddleText:(NSString *)middleText withBottomText:(NSString *)bottomText
{
    _label.attributedText = [self setAttributedTextForTopText:topText withMiddleText:middleText withBottomText:bottomText];
}

-(NSAttributedString*)setAttributedTextForTopText:(NSString *)topText withMiddleText:(NSString *)middleText withBottomText:(NSString *)bottomText
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentLeft;
    style1.lineSpacing = 6;

    
    if (topText.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:topText attributes:@{
                                                                                     NSFontAttributeName: AN_MEDIUM(16),
                                                                                     NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                     NSParagraphStyleAttributeName : style
                                                                                     }];
        [mutAttr appendAttributedString:attr];
    }
    
    if (middleText.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", middleText]  attributes:@{
                                                                               NSFontAttributeName: AN_REGULAR(14),
                                                                               NSForegroundColorAttributeName : [UIColor blueColor],
                                                                               NSParagraphStyleAttributeName : style1
                                                                               }];
        [mutAttr appendAttributedString:attr];
    }
    
    if (bottomText.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", bottomText]  attributes:@{
                                                                               NSFontAttributeName: AN_REGULAR(14),
                                                                               NSForegroundColorAttributeName : [UIColor greenColor],
                                                                               NSParagraphStyleAttributeName : style1
                                                                               }];
        [mutAttr appendAttributedString:attr];
    }
    
    return mutAttr;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
