//
//  SaveNShareTableViewCell.m
//  eyVee
//
//  Created by Disha Jain on 12/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import "SaveNShareTableViewCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface SaveNShareTableViewCell()

@end

@implementation SaveNShareTableViewCell

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

-(void)setup
{
    _buttonSave = [EYButtonWithRightImage buttonWithType:UIButtonTypeSystem];
    _buttonSave.layer.borderWidth = 1.0;
    _buttonSave.layer.borderColor = [UIColor blackColor].CGColor;
    _buttonSave.titleLabel.font = AN_REGULAR(12);
    [_buttonSave setTitleColor:kBlackTextColor forState:UIControlStateNormal];
//    [_buttonSave setTitle:NSLocalizedString(@"save_btn_text", "") forState:UIControlStateNormal];
    [_buttonSave setImage:[[UIImage imageNamed:@"fav_add"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]forState:UIControlStateNormal];
    
    [self.contentView addSubview:_buttonSave];
    
    _buttonShare = [EYButtonWithRightImage buttonWithType:UIButtonTypeSystem];
    _buttonShare.layer.borderWidth = 1.0;
    _buttonShare.titleLabel.font = AN_REGULAR(12);
    [_buttonShare setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    _buttonShare.layer.borderColor = [UIColor blackColor].CGColor;
    [_buttonShare setImage:[[UIImage imageNamed:@"share"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [_buttonShare setTitle:NSLocalizedString(@"share_btn_text", "") forState:UIControlStateNormal];
    [self.contentView addSubview:_buttonShare];
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize rect  = self.contentView.bounds.size;
    
     CGFloat spacingBetweenButton = 5.0;
    
    CGFloat buttonW = (rect.width - 2* kProductDescriptionPadding - spacingBetweenButton)/2;
    
    CGSize sizeForButtons = (CGSize){buttonW,36};
   
    _buttonSave.frame = (CGRect){kProductDescriptionPadding,kProductDescriptionPadding,sizeForButtons};
    
    _buttonShare.frame = (CGRect){CGRectGetMaxX(_buttonSave.frame)+spacingBetweenButton,kProductDescriptionPadding,sizeForButtons};
   
    
}

+(CGFloat)requiredHeightForRow
{
    CGFloat h = 0.0;
    h+=kcellPadding*2 + 40 ; // 40 is the button height taken above;
    
    return h;
}


@end
