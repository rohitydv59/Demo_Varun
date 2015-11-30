//
//  EYTextFieldCell.m
//  Eyvee
//
//  Created by Disha Jain on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYTextFieldCell.h"
#import "EYConstant.h"

@interface EYTextFieldCell ()<UITextFieldDelegate>
@property (nonatomic) float tfWidth;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UIView * separatorLine;
@property (nonatomic, strong) UILabel *leftLabel;
@end

@implementation EYTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return  self;
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textfield = [[EYAddressTextField alloc] initWithFrame:CGRectZero];
    self.textfield.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.textfield];
    self.textfield.delegate = self;
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
    
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.leftLabel.font = AN_REGULAR(13.0);
    self.leftLabel.textColor = kRowLeftLabelColor;
    [self.contentView addSubview:self.leftLabel];

    self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.rightButton setTitle:@"WHY?" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = AN_REGULAR(13.0);
    self.rightButton.hidden = YES;
    [self.contentView addSubview:self.rightButton];

}

-(void)updateTextFieldMode:(textFieldMode)mode
{
    self.mode = mode;
    [self setNeedsLayout];
}

-(void)setLabelText:(NSString *)textValue andPlaceholderText:(NSString *)placeholder
{
     _textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: kPlaceholderColor , NSFontAttributeName : AN_REGULAR(15.0)}];
    if (textValue.length>0)
    {
        _leftLabel.text = textValue;
  
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGFloat leftAreaLength = 160 ;
    
    CGFloat thickness = 1.0;
    
    CGSize leftLabelSize = self.leftLabel.intrinsicContentSize;
    
    self.leftLabel.frame = (CGRect){kProductDescriptionPadding,(size.height-leftLabelSize.height)/2,leftAreaLength-kProductDescriptionPadding,leftLabelSize.height};
    
    self.textfield.frame = (CGRect){CGRectGetMaxX(self.leftLabel.frame), 0, size.width-leftAreaLength-kProductDescriptionPadding,self.bounds.size.height -thickness};
    
    _separatorLine.frame = CGRectMake(0, self.bounds.size.height - thickness, self.bounds.size.width, thickness);
    
    if (self.mode == addToCartVC)
    {
        CGFloat kRightLblPadding = 15.0;
        self.leftLabel.frame = (CGRect){kTableViewLargePadding,(size.height-leftLabelSize.height)/2,leftLabelSize.width,leftLabelSize.height};
        
        self.rightButton.hidden = NO;
        CGSize sizeOfRightBtn = {44,44};
        _rightButton.frame = (CGRect){size.width-sizeOfRightBtn.width-kProductDescriptionPadding,(size.height-sizeOfRightBtn.height)/2,sizeOfRightBtn};
        
        CGRect textfieldRect = (CGRect){size.width*0.5, 0, ((size.width/2)-sizeOfRightBtn.width-kRightLblPadding),self.bounds.size.height -thickness};
        self.textfield.frame = textfieldRect;
    }
    
    else if (self.mode == addPromoCode)
    {
        self.leftLabel.hidden = YES;
        self.textfield.frame = (CGRect){kProductDescriptionPadding,0,size.width-2*kProductDescriptionPadding,self.bounds.size.height - thickness};
    }
}

+ (CGFloat)requiredHeightForCell:(NSString *)titletext width:(float)width
{
    float height = 0.0;
   
    
    return height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)configUserDetailsCellForIndexPath:(NSIndexPath *)indexPath
{
    self.textfield.returnKeyType = UIReturnKeyNext;
    self.textfield.tag = indexPath.row;
    
    if (indexPath.row == 0) {
        [self setLabelText:@"Full Name" andPlaceholderText:@"Required"];
    }
    else if (indexPath.row == 1){
        [self setLabelText:@"Email" andPlaceholderText:@"Required"];
    }
    else if (indexPath.row == 2){
        [self setLabelText:@"Mobile" andPlaceholderText:@"Required"];
        self.textfield.keyboardType = UIKeyboardTypePhonePad;
    }
}

- (void)setTextInTextfield:(NSString *)text ForIndexPath :(NSIndexPath *)indexpath
{
    self.textfield.returnKeyType = UIReturnKeyNext;
    self.textfield.tag = indexpath.row;
    if (text) {
        [self.textfield setText:text];
    }
    else
        [self.textfield setPlaceholder:@"Required"];
    
}


@end
