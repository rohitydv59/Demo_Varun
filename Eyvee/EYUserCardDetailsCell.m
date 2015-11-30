//
//  EYUserCardDetailsCell.m
//  Eyvee
//
//  Created by Neetika Mittal on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYUserCardDetailsCell.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "WPPickerView.h"

@interface EYUserCardDetailsCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation EYUserCardDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.leftLabel.font = AN_REGULAR(13.0);
    self.leftLabel.textColor = kRowLeftLabelColor;
    [self.contentView addSubview:_leftLabel];

    self.tf = [[UITextField alloc] initWithFrame:CGRectZero];
    self.tf.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.contentView addSubview:_tf];

    self.rightImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.rightImgView.hidden = YES;
    self.rightImgView.contentMode = UIViewContentModeCenter;
    self.rightImgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_rightImgView];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize rect = self.contentView.bounds.size;
    
    CGFloat padding = kProductDescriptionPadding;
    
    CGFloat leftSideLength = 140.0;
    
    CGSize leftLabelSize = self.leftLabel.intrinsicContentSize;
    
    self.leftLabel.frame = (CGRect){kProductDescriptionPadding,(rect.height-leftLabelSize.height)/2,leftSideLength-kProductDescriptionPadding,leftLabelSize.height};
    
     CGSize size = (self.rightImgView.hidden == NO) ? [self.rightImgView.image size] : CGSizeZero;

    
    CGFloat thickness = 1;
    self.tf.frame = (CGRect){CGRectGetMaxX(self.leftLabel.frame), 0, rect.width-leftSideLength-kProductDescriptionPadding - size.width - 8.0,rect.height -thickness};
    
    self.rightImgView.frame = (CGRect) {rect.width - size.width - padding, floorf((rect.height - size.height)/2.0), size};
    _separatorLine.frame = CGRectMake(0,rect.height - thickness, rect.width, thickness);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(UserDetailType)type
{
    _type = type;
    self.leftLabel.text = [self getTextForCellType:type];
    self.tf.placeholder = [self getPlaceholderForCellType:type];
    self.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.tf.placeholder attributes:@{NSForegroundColorAttributeName: kPlaceholderColor , NSFontAttributeName : AN_REGULAR(15.0)}];
    
    self.tf.keyboardType = UIKeyboardTypeDefault ; //UIKeyboardTypeNumberPad;
    if (type == UserDetailTypeCVV) {
        self.rightImgView.hidden = NO;
        self.rightImgView.image = [UIImage imageNamed:@"cvv_icon"];
        self.tf.secureTextEntry = YES;
        //added
        self.tf.keyboardType = UIKeyboardTypeNumberPad ;
    }
    else {
        if (type == UserDetailTypeCardNumber) {
            self.tf.keyboardType = UIKeyboardTypeNumberPad;
        }
        self.tf.secureTextEntry = NO;
        self.rightImgView.hidden = YES;
    }
    [self setNeedsLayout];
}

- (NSString *)getTextForCellType:(UserDetailType)type
{
    NSString *text = @"";
    switch (type) {
        case UserDetailTypeCardNumber:
            text = @"Card No.";
            break;
            
        case UserDetailTypeCVV:
            text = @"CVV";
            break;
            
        case UserDetailTypeExpiryDate:
            text = @"Date Of Expiry";
            break;
            
        case UserDetailTypeNameOnCard:
            text = @"Name On Card";
            break;
            
        default:
            break;
    }
    return text;
}

- (NSString *)getPlaceholderForCellType:(UserDetailType)type
{
    NSString *text = @"";
    switch (type) {
        case UserDetailTypeCardNumber:
            text = @"1234-5678-9012-3456";
            break;
            
        case UserDetailTypeCVV:
            text = @"3-digit number";
            break;
            
        case UserDetailTypeExpiryDate:
            text = @"mm / yyyy";
            break;
            
        case UserDetailTypeNameOnCard:
            text = @"Enter Name";
            break;
            
        default:
            break;
    }
    return text;
}

@end
