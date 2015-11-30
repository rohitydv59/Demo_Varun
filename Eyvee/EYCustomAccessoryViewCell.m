//
//  EYCustomAccessoryViewCell.m
//  Eyvee
//
//  Created by Disha Jain on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYCustomAccessoryViewCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYCustomAccessoryViewCell ()
{
    EYCustomAccessoryViewCellType _mode;
}
@property (strong,nonatomic) UILabel *leftLabel;
@property (strong,nonatomic) UIImageView *imgView;
@property (strong,nonatomic) NSString *rowText;
@property (nonatomic, strong) UIView * separatorLine, *buttonSep1, *buttonSep2;

@property (nonatomic, strong) UIButton *select, *edit, *remove;

@end

@implementation EYCustomAccessoryViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowText:(NSString*)text andAccessoryViewType:(accessoryType)type andMode:(EYCustomAccessoryViewCellType)mode
{
   self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _mode = mode;
        _rowText = text;
        self.accessoryViewType = type;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}

- (void)populateCellWithText:(NSString *)rowText andFont:(UIFont*)font andTextColor:(UIColor*)color
{
    _leftLabel.text= rowText;
    _leftLabel.font = font;
    _leftLabel.textColor = color;
}

-(void)populateCellWithAttributedText:(NSAttributedString *)rowText {
    _leftLabel.attributedText = rowText;
}

-(void)setUp
{
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _leftLabel.numberOfLines = 0;
    [self.contentView addSubview:_leftLabel];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
    
    if (self.accessoryViewType == switchView)
    {
        _switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
        self.accessoryView = _switchView;
        [_switchView setOnTintColor:kAppGreenColor];
    }
    else
    {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_imgView];
    }
    
    if (_mode == EYCustomAccessoryViewCellTypeAddressList) {
        _select = [UIButton buttonWithType:UIButtonTypeSystem];
        [_select setTitleColor:kAppGreenColor forState:UIControlStateNormal];
        [_select setTitle:@"SELECT" forState:UIControlStateNormal];
        [_select.titleLabel setFont:AN_BOLD(11.0)];
        [_select addTarget:self action:@selector(pressSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_select];
        
        _edit = [UIButton buttonWithType:UIButtonTypeSystem];
        [_edit setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        [_edit setTitle:@"EDIT" forState:UIControlStateNormal];
        [_edit.titleLabel setFont:AN_BOLD(11.0)];
        [_edit addTarget:self action:@selector(pressEdit:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_edit];
        
        _remove = [UIButton buttonWithType:UIButtonTypeSystem];
        [_remove setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        [_remove setTitle:@"REMOVE" forState:UIControlStateNormal];
        [_remove.titleLabel setFont:AN_BOLD(11.0)];
        [_remove addTarget:self action:@selector(pressRemove:) forControlEvents:UIControlEventTouchUpInside];
        //[self.contentView addSubview:_remove];
        
        _buttonSep1 = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonSep1.backgroundColor = kSeparatorColor;
        [self.contentView addSubview:_buttonSep1];
        
        _buttonSep2 = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonSep2.backgroundColor = kSeparatorColor;
        //[self.contentView addSubview:_buttonSep2];
    }
    else if (_mode == EYCustomAccessoryViewCellTypeFromMe) {
        _edit = [UIButton buttonWithType:UIButtonTypeSystem];
        [_edit setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        [_edit setTitle:@"EDIT" forState:UIControlStateNormal];
        [_edit.titleLabel setFont:AN_BOLD(11.0)];
        [_edit addTarget:self action:@selector(pressEdit:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_edit];
        
        _remove = [UIButton buttonWithType:UIButtonTypeSystem];
        [_remove setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        [_remove setTitle:@"REMOVE" forState:UIControlStateNormal];
        [_remove.titleLabel setFont:AN_BOLD(11.0)];
        [_remove addTarget:self action:@selector(pressRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_remove];
        
        _buttonSep2 = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonSep2.backgroundColor = kSeparatorColor;
        [self.contentView addSubview:_buttonSep2];
    }
}

-(void)setImageAsPerCellType:(EYCustomAccessoryViewCellType)type
{
    _mode = type;
    if (type == EYCustomAccessoryViewCellPromo)
    {
        _imgView.image = [UIImage imageNamed:@"plus_expand"];
        
    }
    else if (type == EYCustomAccessoryViewCellPromoApplied)
    {
        _imgView.image = [UIImage imageNamed:@"cross"];
        
    }
    else
    {
        _imgView.image = [UIImage imageNamed:@"arrow_next"];
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat availableWForLabel = size.width - 2*kProductDescriptionPadding - 12 - 15.0;
    
    CGSize sizeOfLabel = [EYUtility sizeForAttributedString:_leftLabel.attributedText width:availableWForLabel];
    
    if ([_rowText isEqualToString:@"shippingToAddressCell"])
    {
        _leftLabel.frame = (CGRect){kProductDescriptionPadding,14.0,sizeOfLabel};
    }
    else
    {
        _leftLabel.frame = (CGRect){kProductDescriptionPadding,(size.height-sizeOfLabel.height)/2,sizeOfLabel};
    }
  
    
    //Separator
    
    CGFloat thickness = 1.0;
    
    _separatorLine.frame = CGRectMake(0, size.height-thickness, size.width, thickness);
    _imgView.frame = (CGRect){size.width - kProductDescriptionPadding - 12.0,(size.height-_imgView.image.size.height)/2,12.0,12.0};
    
    
    if (_mode == EYCustomAccessoryViewCellTypeAddressList) {
        float y = 14.0 + sizeOfLabel.height + 16.0;
        float x = kProductDescriptionPadding - 6;
        CGSize sepSize = CGSizeMake(thickness, 20);
        CGSize size1 = CGSizeMake(62, 30);
        _select.frame = (CGRect){x, y, size1};
        
        x += 62;
        _buttonSep1.frame = (CGRect){x, y + 5, sepSize};
        
        x += thickness;
        _edit.frame = (CGRect){x, y, 48, 30};
        
        x += 48;
        _buttonSep2.frame = (CGRect) {x, y + 5, sepSize};
        
        x += thickness;
        _remove.frame = (CGRect) {x, y, 72, 30};
    }
    else if (_mode == EYCustomAccessoryViewCellTypeFromMe) {
        float y = 14.0 + sizeOfLabel.height + 16.0;
        float x = kProductDescriptionPadding - 9;
        CGSize sepSize = CGSizeMake(thickness, 20);
        _edit.frame = (CGRect){x, y, 48, 30};
        
        x += 48;
        _buttonSep2.frame = (CGRect) {x, y + 5, sepSize};
        
        x += thickness;
        _remove.frame = (CGRect) {x, y, 72, 30};
    }
}

+ (CGFloat)requiredHeightForCellWithText:(NSString*)text andFont:(UIFont*)font andCellWidth:(CGFloat)width
{
    CGSize sizeOfLabel = [EYUtility sizeForString:text font:font width:width-kcellPadding*2 - 40 ];
    return sizeOfLabel.height + kcellPadding;
}

+ (CGFloat)requiredHeightForCellWithAttributedText:(NSAttributedString *)text andCellWidth:(CGFloat)width andMode:(EYCustomAccessoryViewCellType)mode
{
    CGSize sizeOfAttributedStr = [EYUtility sizeForAttributedString:text width:width-2*kProductDescriptionPadding-12.0-15.0];
    CGFloat h = 0.0;
    h += 14.0 + sizeOfAttributedStr.height + 16.0;
    if (mode == EYCustomAccessoryViewCellTypeAddressList) {
        h += 30 + 16;
    }
    return h;
}

#pragma Button Actions

- (void)pressSelect:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectAddressAtIndex:)]) {
        [_delegate selectAddressAtIndex:self.tag];
    }
}

- (void)pressEdit:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editAddressAtIndex:)]) {
        [_delegate editAddressAtIndex:self.tag];
    }
}

- (void)pressRemove:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(removeAddressAtIndex:)]) {
        [_delegate removeAddressAtIndex:self.tag];
    }
}

@end
