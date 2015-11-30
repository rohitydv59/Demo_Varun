//
//  SortByTableViewCell.m
//  Eyvee
//
//  Created by Disha Jain on 18/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "SortByTableViewCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface SortByTableViewCell()
@property (strong,nonatomic)UIView *separatorLine;
@end

@implementation SortByTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    _sortByLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _sortByLabel.numberOfLines = 1;
    _sortByLabel.font = AN_MEDIUM(14.0);
    _sortByLabel.textColor =kBlackTextColor;
    [self.contentView addSubview:_sortByLabel];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
    self.backgroundColor = [UIColor whiteColor];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGSize labelSize = _sortByLabel.intrinsicContentSize;
    _sortByLabel.frame = (CGRect){(size.width - labelSize.width)/2,(size.height - labelSize.height)/2,labelSize};
    
    CGFloat thickness = 1.0;
    _separatorLine.frame = CGRectMake(0, size.height - thickness, size.width, thickness);

}



@end
