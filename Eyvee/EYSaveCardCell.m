//
//  EYSaveCardCell.m
//  Eyvee
//
//  Created by Neetika Mittal on 03/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYSaveCardCell.h"
#import "WPTickButton.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYSaveCardCell ()

@property (nonatomic, strong) UIImageView *lockImgView;
@property (nonatomic, strong) UILabel *bottomLbl;

@end

@implementation EYSaveCardCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.tickBtn = [WPTickButton buttonWithType:UIButtonTypeCustom];
    [self.tickBtn setAttributedTitleForTickButton:@"Save this card securely for faster checkout next time" secondString:@""];
    [self.tickBtn addTarget:self action:@selector(tickBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_tickBtn];
    
    self.payBtn = [[EYBottomButton alloc]initWithFrame:(CGRectZero) image:@"next_btn_large" ButtonText:@"" andFont:AN_BOLD(16.0)];
    [self.contentView addSubview:_payBtn];
    
    self.bottomLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    self.bottomLbl.font = LIGHT(14.0);
    self.bottomLbl.numberOfLines = 0;
    self.bottomLbl.attributedText = [self setAttributedStringForSaveCell:@"All transactions done securely.You will be redirected to bank's authentication page in next step"];
    [self.contentView addSubview:_bottomLbl];
}

- (void)setAmount:(NSString *)amount
{
    _amount = amount;
//    [self.payBtn setTitle:[NSString stringWithFormat:@"PAY %@",_amount] forState:UIControlStateNormal];
    self.payBtn.buttonString = [NSString stringWithFormat:@"PAY %@",_amount];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    
    CGFloat padding = kProductDescriptionPadding;
    
//    CGSize tickSize = [self.tickBtn requiredSizeForWidth:rect.size.width - 2*padding];
    self.tickBtn.frame = (CGRect) {padding, 0, rect.size.width - 2*padding,60};
    
    self.payBtn.frame = (CGRect) {padding, CGRectGetMaxY(self.tickBtn.frame), rect.size.width - 2 * padding, kPaymentButtonHeight};
    
//    CGSize imgSize = self.lockImgView.image.size;
//    CGFloat y = CGRectGetMaxY(self.payBtn.frame) + padding;
//    self.lockImgView.frame = (CGRect) {padding, y, imgSize};
    
    CGSize lblSize = [EYUtility sizeForAttributedString:_bottomLbl.attributedText width:rect.size.width-2*kProductDescriptionPadding];
    self.bottomLbl.frame = (CGRect) {kProductDescriptionPadding, 14.0+CGRectGetMaxY(self.payBtn.frame), lblSize};
}

+ (CGFloat)requiredHeightForWidth:(CGFloat)width andText:(NSString *)text
{
//    CGFloat padding = kTableViewSidePadding;
//    CGSize lockImgSize = [UIImage imageNamed:@"lock"].size;
//    
//    CGSize imgSize = [UIImage imageNamed:@"tick_on"].size;
//    CGSize lblSize = [EYUtility sizeForString:@"Save this card securely for faster checkout next time" font:kTickButtonFont width:width - 2.5 * padding - imgSize.width];
//    CGFloat h = MAX(imgSize.height, lblSize.height) + 4 * padding + kHeaderButtonHeight + MAX(lockImgSize.height, LIGHT(14.0).lineHeight);
    
//    h = 60.0+kPaymentButtonHeight +  MAX(lockImgSize.height, LIGHT(14.0).lineHeight) + 14.0 + 20.0;
    
    CGFloat h = 0.0;
    
    NSMutableAttributedString *attrRight = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dict = @{NSFontAttributeName : AN_REGULAR(11.0),
                           NSForegroundColorAttributeName : KSecurePaymentText,
                           NSParagraphStyleAttributeName : style
                           };
    
    
    
    NSAttributedString *strRight = [[NSAttributedString alloc] initWithString:text attributes:dict];
    [attrRight appendAttributedString:strRight];
    
    CGSize lblSize = [EYUtility sizeForAttributedString:attrRight width:width - 2*kProductDescriptionPadding];
    
    h+=60.0+kPaymentButtonHeight + 14.0+ 20.0 + lblSize.height ;
    
    return h;
}

- (void)tickBtnTapped:(WPTickButton *)sender
{
    sender.on = !sender.on;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSAttributedString*)setAttributedStringForSaveCell:(NSString*)text
{
    NSMutableAttributedString *attrRight = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dict = @{NSFontAttributeName : AN_REGULAR(11.0),
                            NSForegroundColorAttributeName : KSecurePaymentText,
                            NSParagraphStyleAttributeName : style
                            };
    
    
    
    NSAttributedString *strRight = [[NSAttributedString alloc] initWithString:text attributes:dict];
    [attrRight appendAttributedString:strRight];
    
    
    return attrRight;
}

@end
