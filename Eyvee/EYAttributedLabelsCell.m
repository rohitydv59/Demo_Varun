//
//  EYAttributedLabelsCell.m
//  Eyvee
//
//  Created by Disha Jain on 30/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAttributedLabelsCell.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface EYAttributedLabelsCell ()

@property (strong, nonatomic) UIView *separatorLine;

@end

@implementation EYAttributedLabelsCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        
    if (self)
    {
            
    [self setUp];
            
    }
        
    return self;
}

-(void)setUp
{
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _leftLabel.numberOfLines = 0;
//    _leftLabel.backgroundColor = [UIColor greenColor];
    
    [self.contentView addSubview: _leftLabel];
    
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _rightLabel.numberOfLines = 0;
//    _rightLabel.backgroundColor = [UIColor blueColor];
    
    [self.contentView addSubview:_rightLabel];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
 
}

-(void)setLeftLabelAttributedText:(NSAttributedString*)str
{
    _leftLabel.attributedText = str;
}

-(void)setRightLabelAttributedText:(NSAttributedString*)str
{
    _rightLabel.attributedText = str;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sizeOfLeftLabel = [EYUtility sizeForAttributedString:_leftLabel.attributedText width:self.contentView.frame.size.width-2*kProductDescriptionPadding];
    CGSize sizeOfRightLabel = [EYUtility sizeForAttributedString:_rightLabel.attributedText width:self.contentView.frame.size.width -2*kProductDescriptionPadding - sizeOfLeftLabel.width];
    
   
    _leftLabel.frame = (CGRect){kProductDescriptionPadding,14.0,sizeOfLeftLabel};
    _rightLabel.frame = (CGRect){self.contentView.frame.size.width - kProductDescriptionPadding - sizeOfRightLabel.width,14.0,sizeOfRightLabel};
    
    _separatorLine.frame = (CGRect){0,self.frame.size.height - 1.0,self.frame.size.width,1.0};
}

+(CGFloat)requiredHeightForCellWithAttributedText:(NSAttributedString *)lefttext rightLabelText:(NSAttributedString*)rightText andCellWidth:(CGFloat)width
{
    CGFloat h = 0.0;
    
    CGSize sizeOfLeftLabel = [EYUtility sizeForAttributedString:lefttext width:width-2*kProductDescriptionPadding];
    CGSize sizeOfRightLabel = [EYUtility sizeForAttributedString:rightText width:width -2*kProductDescriptionPadding - sizeOfLeftLabel.width];
    
    h+= 14.0;
    
    CGFloat maxH = MAX(sizeOfLeftLabel.height, sizeOfRightLabel.height);
    
    h+=maxH + 16.0 +1.0;
    
    return h;
}

@end
