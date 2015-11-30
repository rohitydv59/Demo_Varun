//
//  ScrollButtonsTableViewCell.m
//  Eyvee
//
//  Created by Disha Jain on 17/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "ScrollButtonsTableViewCell.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface ScrollButtonsTableViewCell()<EYSelectSizeViewDelegate>

@end

@implementation ScrollButtonsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMode:(sizeMode)mode andArrayOfValues:(NSArray*)array andArrayOfValueIds:(NSArray *)valueIds
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _sizesArray = array;
        _sizesIdsArray = valueIds;

        self.modeReceived = mode;
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone ;

    self.sizeView = [[EYSelectSizeView alloc]initWithFrame:CGRectZero andMode:(_modeReceived == filterMode) ? EYSelectSizeForFilter : EYSelectSizeForProductDetail  andArrayOfValues:_sizesArray andArrayOfValues:_sizesIdsArray];
    self.sizeView.delegate = self;
    [self.contentView addSubview:_sizeView];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.sizeView.frame = self.contentView.bounds;
}

+(CGFloat)requiredHeightForRowWithFont:(UIFont*)font andText:(NSString*)text
{
    CGFloat h = 0.0;
    
    CGFloat padding = kcellPadding;
    CGSize sizeOfLabel = [EYUtility sizeForString:text font:font];
    
    h+=padding+sizeOfLabel.height+padding+55.0; //btn height taken is 55.0
    CGFloat thickness = 1.0/[UIScreen mainScreen].scale;
    h+=thickness + padding;
    
    return h;
}




@end
