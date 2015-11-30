//
//  PriceTableViewCell.m
//  EyveeFilterView
//
//  Created by Varun Kapoor on 12/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import "PriceTableViewCell.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface PriceTableViewCell ()

@end

@implementation PriceTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [self.rangeSlider setDelegate:self];
}

-(void) updateCell
{
    NSString * minV = [[EYUtility shared]getCurrencyFormatFromNumber:self.rangeSlider.selectedMinimumValue] ;
    NSString * maxV = [NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:self.rangeSlider.selectedMaximumValue]] ;

    [self.fromPriceLabel setAttributedText:[self getPriceRange:@"From " withEndString:minV]];
    [self.toPriceLabel setAttributedText:[self getPriceRange:@"to " withEndString:maxV]];
}

- (NSAttributedString *)getPriceRange:(NSString *) startingString withEndString:(NSString *) endingString
{
    NSMutableAttributedString *startingLabelAttributes = [[NSMutableAttributedString alloc] initWithString:startingString];
    [startingLabelAttributes addAttribute:NSFontAttributeName value:AN_REGULAR(12) range:NSMakeRange(0, startingString.length)];
    [startingLabelAttributes addAttribute:NSForegroundColorAttributeName value:kRowLeftLabelColor range:NSMakeRange(0, startingString.length)];
    
    NSMutableAttributedString * endingLabelAttributes = [[NSMutableAttributedString alloc] initWithString:endingString];
    [endingLabelAttributes addAttribute:NSFontAttributeName value:AN_MEDIUM(12) range:NSMakeRange(0, endingString.length)];
    [endingLabelAttributes addAttribute:NSForegroundColorAttributeName value:kAppGreenColor range:NSMakeRange(0, endingString.length)];
    
    [startingLabelAttributes appendAttributedString:endingLabelAttributes];
    return startingLabelAttributes;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
